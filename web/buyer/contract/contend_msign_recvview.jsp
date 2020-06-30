<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}


boolean sign_able = false;
String cust_type = "";// 받는 사람이 갑인 경우 01 을인 경우 02
boolean gap_yn = false;// 로그인한 업체가갑인지 여부 cust_type == "01" 이면 갑이다.
String file_path = "";

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_status = codeDao.getCodeArray("M008");
String[] code_change_gubun = codeDao.getCodeArray("M010");
String[] code_sign_type = codeDao.getCodeArray("M042");

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'  and status in ('50','91') ",
"tcb_contmaster.*"
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is not null ) sign_cnt "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null ) unsign_cnt "
+" ,(select member_name from tcb_member where member_no = tcb_contmaster.mod_req_member_no ) mod_req_name "
+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,3) = substr(tcb_contmaster.src_cd,0,3) and depth='1') l_src_nm "
+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,6) = substr(tcb_contmaster.src_cd,0,6) and depth='2') m_src_nm "
+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and src_cd = tcb_contmaster.src_cd and depth='3') s_src_nm "
);
if(!cont.next()){
	u.jsError("계약정보가 존재 하지 않습니다.");
	return;
}
cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
cont.put("cont_date",u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
cont.put("status_name", u.getItem(cont.getString("status"), code_status));
cont.put("change_gubun_str", u.getItem(cont.getString("change_gubun"), code_change_gubun)+"("+cont_chasu+"차)");
if(!cont.getString("src_cd").equals(""))
cont.put("src_nm", cont.getString("l_src_nm")+" > "+cont.getString("m_src_nm")+" > "+cont.getString("s_src_nm"));

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+cont.getString("member_no")+"' ");
if(!member.next()){
	u.jsError("작성업체 정보가 존재 하지 않습니다.");
	return;
}

// 서식정보 조회
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" status > 0 and template_cd ='"+cont.getString("template_cd")+"'");
while(template.next()){
	if(template.getString("recv_write_yn").equals("Y"))  // 수신업체 작성 가능 여부
		template.put("recv_write", true);
	else
		template.put("recv_write", false);
}


DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","*","sign_seq asc");

// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust a");
DataSet cust = custDao.find(
		" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq <= 10"
		,"a.*, (select cust_type from tcb_cont_sign where cont_no = a.cont_no and cont_chasu=a.cont_chasu and sign_seq = a.sign_seq ) cust_type"
		,"a.display_seq asc"
		);
if(cust.size()<1){
	u.jsError("계약업체 정보가 존재 하지 않습니다.");
	return;
}
while(cust.next()){
       cust.put("cont_no", u.aseEnc(cust.getString("cont_no")));
	if(cust.getString("member_no").equals(_member_no)&&cust.getString("cust_type").equals("01"))gap_yn = true;
	cust.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust.getString("sign_date")));
	cust.put("sign_type_nm",  u.getItem(cust.getString("sign_type"), code_sign_type));
	if(cust.getString("member_no").equals(_member_no)){
		cust_type = cust.getString("cust_type");
		if(cust.getString("sign_dn").equals("")){
			sign_able = true;
		}
	}
}

// 연대보증 업체
DataSet cust_chain = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq > 10","a.*");
while(cust_chain.next()){
	cust_chain.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust_chain.getString("sign_date")));
}

//계약서류 조회
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and (auto_type is null or auto_type <> '3')"); // 작성업체만 보는 계약 파일 제외
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	if(cfile.getString("cfile_seq").equals("1")&&cfile.getString("auto_yn").equals("Y")){
		file_path = cfile.getString("file_path");
	}
	if(cfile.getString("auto_yn").equals("Y")){
		if(cfile.getString("auto_type").equals("1")){
			cfile.put("auto_str","자동첨부");
		}
		if(cfile.getString("auto_type").equals("2")){
			cfile.put("auto_str","필수첨부");
		}
		if(cfile.getString("auto_type").equals("")){
			cfile.put("auto_str","자동생성");
			cfile.put("auto_type","0");
		}
	}else{
		cfile.put("auto_str", "직접첨부");
	}
	cfile.put("auto_class", cfile.getString("auto_yn").equals("Y")?"caution-text":"");
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	if(cfile.getString("file_ext").toLowerCase().equals("pdf")){
		cfile.put("btn_name", "조회(인쇄)");
		cfile.put("down_script","contPdfViewer('"+u.request("cont_no")+"','"+cont_chasu+"','"+cfile.getString("cfile_seq")+"')");
	}else{
		cfile.put("btn_name", "다운로드");
		cfile.put("down_script","filedown('file.path.bcont_pdf','"+cfile.getString("file_path")+cfile.getString("file_name")+"','"+cfile.getString("doc_name")+"."+cfile.getString("file_ext")+"')");
	}
}

//인지세 정보조회
DataObject stampDao = new DataObject("tcb_stamp ts left join tcb_member tm on ts.member_no=tm.member_no");
DataSet stamp = stampDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "ts.*, tm.member_name, tm.vendcd");
while(stamp.next()){
	stamp.put("cont_no", u.aseEnc(stamp.getString("cont_no")));
	stamp.put("stamp_money", u.numberFormat(stamp.getDouble("stamp_money"), 0));
	stamp.put("issue_date", u.getTimeString("yyyy-MM-dd", stamp.getString("issue_date")));
	stamp.put("vendcd", u.getBizNo(stamp.getString("vendcd")));
}

//보증정보조회
DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(warr.next()){
    warr.put("cont_no", u.aseEnc(warr.getString("cont_no")));
	warr.put("haja", warr.getString("warr_type").equals("20"));
	warr.put("warr_type", u.getItem(warr.getString("warr_type"),code_warr));
	warr.put("warr_date", u.getTimeString("yyyy-MM-dd", warr.getString("warr_date")));
	warr.put("warr_sdate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_sdate")));
	warr.put("warr_edate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_edate")));
	warr.put("warr_amt", u.numberFormat(warr.getDouble("warr_amt"),0));

	warr.put("warr_status", u.getItem(warr.getString("status"),code_warr_status));
	warr.put("end", warr.getString("status").equals("30")||warr.getString("status").equals(""));
}

// 업체별 구비 서류 조회
DataObject rfileDao = new DataObject("tcb_rfile");


String rfile_query =
" select a.*  "
+"   from tcb_cust a, tcb_cont_sign b "
+"  where a.cont_no= b.cont_no  "
+"    and a.cont_chasu = b.cont_chasu "
+"    and a.sign_seq = b.sign_seq  "
+"    and a.cont_no = '"+cont_no+"' "
+"    and a.cont_chasu = '"+cont_chasu+"' "
+"    and b.cust_type <> '01' ";
if(!cust_type.equals("01")) rfile_query += " and a.member_no ='"+_member_no+"'";
rfile_query += " order by a.cont_no asc, a.cont_chasu asc, a.sign_seq asc ";

//custDao.setDebug(out);
DataSet rfile_cust = custDao.query(rfile_query);
while(rfile_cust.next()){
    rfile_cust.put("cont_no", u.aseEnc(rfile_cust.getString("cont_no")));
	rfile_cust.put("attch_area", rfile_cust.getString("member_no").equals(_member_no));

	String rfileQuery ="";
	if(rfile_cust.getString("sign_seq").equals("2")){
		rfileQuery = "  select a.attch_yn, a.doc_name, a.rfile_seq, b.file_path, b.file_name, b.file_ext, b.file_size, b.member_no "
				+"    from tcb_rfile a  "
				+"    left outer join  tcb_rfile_cust b "
				+"      on a.cont_no = b.cont_no  "
				+"     and a.rfile_seq = b.rfile_seq  "
				+"     and a.cont_chasu = b. cont_chasu "
				+"     and b.member_no in ('"+rfile_cust.getString("member_no")+"' ,"+cont.getString("member_no")+")"
				+"   where  a.cont_no = '"+cont_no+"'  "
				+"     and a.cont_chasu = '"+cont_chasu+"' " ;
	}else{
		rfileQuery = "  select a.attch_yn, a.doc_name, a.rfile_seq, b.file_path, b.file_name, b.file_ext, b.file_size, b.member_no "
				+"    from tcb_rfile a  "
				+"    left outer join  tcb_rfile_cust b "
				+"      on a.cont_no = b.cont_no  "
				+"     and a.rfile_seq = b.rfile_seq  "
				+"     and a.cont_chasu = b. cont_chasu "
				+"     and b.member_no = '"+rfile_cust.getString("member_no")+"' "
				+"   where  a.cont_no = '"+cont_no+"'  "
				+"     and a.cont_chasu = '"+cont_chasu+"' " ;
	}


	//rfileDao.setDebug(out);
	DataSet rfile = rfileDao.query(rfileQuery);

	while(rfile.next()){
		rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
		rfile.put("file_size", u.getFileSize(rfile.getLong("file_size")));
		rfile.put("gap", cont.getString("member_no").equals(rfile.getString("member_no"))&&rfile_cust.getString("sign_seq").equals("2"));
	}
	rfile_cust.put(".rfile",rfile);
}

if(u.isPost()&&f.validate()){
	// 완료 페이지 로직 없음
}
p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contend_msign_recvview");
p.setVar("menu_cd","000065");
p.setVar("change_cont", Integer.parseInt(cont_chasu)>0);
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("gap_yn", gap_yn);
p.setVar("cont", cont);
p.setVar("sign_able", sign_able);
p.setVar("template", template);
p.setLoop("sign_template", signTemplate);
p.setLoop("cust", cust);
if(cust_chain.size()>0) p.setLoop("cust_chain", cust_chain);
p.setLoop("cfile", cfile);
p.setLoop("stamp", stamp);
p.setLoop("warr", warr);
p.setLoop("rfile_cust", rfile_cust);
p.setVar("file_path", file_path);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>