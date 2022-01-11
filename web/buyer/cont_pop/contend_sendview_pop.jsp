<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%@ page import="nicednb.Client" %>
<%
String vcd = u.request("vcd");
String key = u.request("key");
String cert = u.request("cert");
System.out.println("vcd : " + vcd);
System.out.println("key : " + key);
System.out.println("cert : " + cert);
if(vcd.length()!=10){
	out.print("No Permission!!");
	return;
}

String contstr = u.aseDec(key);  // 디코딩
if(contstr.length() != 12){
	out.print("No Permission!!");
	return;
}

String sClientKey = "";

String member_no = "";

Client cs = new Client();
if(vcd.equals("1168150973")){  // 아이디지털홈쇼핑
	sClientKey = cs.getClientKey("www.idigitalhomeshopping.com");
	member_no = "20150600110";
}else if(vcd.equals("1208755227")){  // 위메프
	sClientKey = cs.getClientKey("www.wemakeprice.com");
	member_no = "20130500619";
}else if(vcd.equals("2118819183")){  // 더블유컨셉코리아
	sClientKey = cs.getClientKey("www.wconcept.co.kr");
	member_no = "20140100706"; 
}else if(vcd.equals("4928700855")){  // 에스케이브로드밴드
	sClientKey = cs.getClientKey("www.skbroadband.com");
	member_no = "20171101813"; 
}else if(vcd.equals("1068123810")){  // 소니코리아
	sClientKey = cs.getClientKey("www.sonykorea.com");
	member_no = "20160900378"; 
	//out.print(sClientKey);
}else if(vcd.equals("1168115020")){  // 나이스평가정보
	sClientKey = cs.getClientKey("www.niceinfo.co.kr");
	member_no = "20120300010";
	//out.print(sClientKey);
}else if(vcd.equals("2208708311")){  // 더블유쇼핑
	sClientKey = cs.getClientKey("w-shopping.co.kr");
	member_no = "20150500312";
} else if(vcd.equals("1078176324")){  // 아워홈
	System.out.println("아워홈");
	sClientKey = cs.getClientKey("www.ourhome.co.kr");
	member_no = "20170501348";
} else if(vcd.equals("4438700566")){  // 카카오메이커스
	sClientKey = cs.getClientKey("makers.kakao.com");
	member_no = "20181101476";
}else if(vcd.equals("1348106363")){  // 대덕전자
	sClientKey = cs.getClientKey("www.daeduck.com");
	member_no = "20150500269";
}else if(vcd.equals("1078767865")){	// 메리츠캐피탈 주식회사
	sClientKey = cs.getClientKey("www.meritzcapital.com");
	member_no = "20190802206";	
}else{
	out.print("No Permission!!");
	return;
}

System.out.println("cert : "+cert);
System.out.println("sClientKey : "+sClientKey);

if(!cert.equals(sClientKey))
{
	out.print("Certfication Key Error!!");
	return;
}


String cont_no = contstr.substring(0,11);
String cont_chasu = contstr.substring(11);

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

String file_path = "";
boolean gap_yn = false;// 로그인한 업체가갑인지 여부 cust_type == "01" 이면 갑이다.

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_change_gubun = codeDao.getCodeArray("M010");
String[] code_auto_type = {"=>자동생성","1=>자동첨부","2=>필수첨부","3=>내부용"};

boolean bIsKakao = u.inArray(member_no, new String[]{"20130900194"});
DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsError("사용자 정보가 존재하지 않습니다.");
	return;
}

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",
"tcb_contmaster.*"
+" ,(select user_name from tcb_person where user_id = tcb_contmaster.reg_id ) writer_name "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is not null ) sign_cnt "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null ) unsign_cnt "
+" ,(select member_name from tcb_member where member_no = tcb_contmaster.mod_req_member_no ) mod_req_name "
);
if(!cont.next()){
	u.jsError("계약정보가 존재 하지 않습니다.");
	return;
}
cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
cont.put("cont_date",u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
cont.put("status_name", u.getItem(cont.getString("status"),code_status));
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
cont.put("reg_date", u.getTimeString("yyyy-MM-dd HH:mm", cont.getString("reg_date")));
cont.put("change_gubun_str", u.getItem(cont.getString("change_gubun"), code_change_gubun)+ (member_no.equals("20150500217") ? "" : "("+cont_chasu+"차)"));
cont.put("isCopyAble", cont.getString("cont_chasu").equals("0"));
if(bIsKakao) {
	if(cont.getString("cont_etc2").equals("on"))
		cont.put("cont_etc2", "▣ 양도 및 종료 계약");
	else
		cont.put("cont_etc2", "□ 양도 및 종료 계약 아님");

	cont.put("cont_etc3", u.nl2br(cont.getString("cont_etc3")));
}

// 추가 계약서 조회
DataObject contSubDao = new DataObject("tcb_cont_sub");
DataSet contSub = contSubDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and (gubun <> '40' or (gubun = '40' and option_yn in ('A','Y')))");
while(contSub.next()){
    contSub.put("cont_no", u.aseEnc(contSub.getString("cont_no")));
	contSub.put("hidden", u.inArray(contSub.getString("gubun"), new String[]{"20","30"}));
}

// 서식정보 조회
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" template_cd ='"+cont.getString("template_cd")+"'");
if(!template.next()){
}

// 내부 결재정보 조회
DataObject agreeTemplateDao = new DataObject("tcb_cont_agree");
DataSet agreeTemplate= agreeTemplateDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", "agree_seq");
while(agreeTemplate.next()){
    agreeTemplate.put("cont_no", u.aseEnc(agreeTemplate.getString("cont_no")));
    agreeTemplate.put("is_cust", agreeTemplate.getString("agree_cd").equals("0"));
    agreeTemplate.put("ag_md_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", agreeTemplate.getString("ag_md_date")));
    
    if(!agreeTemplate.getString("r_agree_person_id").equals("")){
    	agreeTemplate.put("agree_status_nm", agreeTemplate.getString("mod_reason").equals("")?"완료":"반려");
    	agreeTemplate.put("css", "is-active");
    	agreeTemplate.put("agree_person_name", agreeTemplate.getString("r_agree_person_name"));
    }else{
    	agreeTemplate.put("agree_status_nm", "");
    	agreeTemplate.put("css", "");
    }
}

DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");

// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust a");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq <= 10","a.*, (select cust_type from tcb_cont_sign where cont_no = a.cont_no and cont_chasu=a.cont_chasu and sign_seq = a.sign_seq ) cust_type");
if(cust.size()<1){
	u.jsError("계약업체 정보가 존재 하지 않습니다.");
	return;
}else{
	while(cust.next()){
        cust.put("cont_no", u.aseEnc(cust.getString("cont_no")));
		if(cust.getString("member_no").equals(member_no)&&cust.getString("cust_type").equals("01"))gap_yn = true;
		cust.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust.getString("sign_date")));
	}
}

// 연대보증 업체
DataSet cust_chain = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq > 10","a.*");
while(cust_chain.next()){
	cust_chain.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust_chain.getString("sign_date")));
}


//계약서류 조회
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	if(cfile.getString("cfile_seq").equals("1")&&cfile.getString("auto_yn").equals("Y")){
		file_path = cfile.getString("file_path");
	}
	if(cfile.getString("auto_yn").equals("Y")){
		cfile.put("auto_str", u.getItem(cfile.getString("auto_type"), code_auto_type));
		if(cfile.getString("auto_type").equals("")){
			cfile.put("auto_type","0");
		}
	}else{
		cfile.put("auto_str", "직접첨부");
	}
	cfile.put("auto_class", cfile.getString("auto_yn").equals("Y")?"caution-text":"");
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	if(cfile.getString("file_ext").toLowerCase().equals("pdf")){
		cfile.put("btn_name", "조회(인쇄)");
		cfile.put("down_script","contPdfViewer2('"+u.aseEnc(cont_no)+"','"+cont_chasu+"','"+cfile.getString("cfile_seq")+"')");
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
}


f.uploadDir = Startup.conf.getString("file.path.bcont_pdf") + file_path;

// 업체별 구비 서류 조회
DataObject rfileDao = new DataObject("tcb_rfile");

//custDao.setDebug(out);
DataSet rfile_cust = custDao.query(
 " select a.*  "
+"   from tcb_cust a, tcb_cont_sign b "
+"  where a.cont_no= b.cont_no  "
+"    and a.cont_chasu = b.cont_chasu "
+"    and a.sign_seq = b.sign_seq  "
+"    and a.cont_no = '"+cont_no+"' "
+"    and a.cont_chasu = '"+cont_chasu+"' "
+"    and b.cust_type <> '01' "
+"  order by a.cont_no asc, a.cont_chasu asc, a.sign_seq asc"
);
while(rfile_cust.next()){
	rfile_cust.put("cont_no", u.aseEnc(rfile_cust.getString("cont_no")));
	rfile_cust.put("attch_area", rfile_cust.getString("member_no").equals(member_no));

	String rfile_query = "";
	if(rfile_cust.getString("sign_seq").equals("2")){
		rfile_query =	 "  select a.attch_yn, a.doc_name, a.rfile_seq,a.allow_ext,b.file_path, b.file_name, b.file_ext, b.file_size,  b.member_no, b.reg_gubun"
						+"    from tcb_rfile a  "
						+"    left outer join  tcb_rfile_cust b "
						+"      on a.cont_no = b.cont_no  "
						+"     and a.cont_chasu = b.cont_chasu "
						+"     and a.rfile_seq = b.rfile_seq "
						+"     and b.member_no in ('"+rfile_cust.getString("member_no")+"', '"+cont.getString("member_no")+"'  )"
						+"   where  a.cont_no = '"+cont_no+"'  "
						+"     and a.cont_chasu = '"+cont_chasu+"' " ;
	}else{
		rfile_query =	 "  select a.attch_yn, a.doc_name, a.rfile_seq,a.allow_ext,b.file_path, b.file_name, b.file_ext, b.file_size,  b.member_no, b.reg_gubun"
						+"    from tcb_rfile a  "
						+"    left outer join  tcb_rfile_cust b "
						+"      on a.cont_no = b.cont_no  "
						+"     and a.cont_chasu = b.cont_chasu "
						+"     and a.rfile_seq = b.rfile_seq "
						+"     and b.member_no = '"+rfile_cust.getString("member_no")+"' "
						+"   where  a.cont_no = '"+cont_no+"'  "
						+"     and a.cont_chasu = '"+cont_chasu+"' " ;
	}

	//rfileDao.setDebug(out);
	DataSet rfile = rfileDao.query(rfile_query);
	while(rfile.next()){
		rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
		rfile.put("file_size", u.getFileSize(rfile.getLong("file_size")));
		rfile.put("gap", cont.getString("member_no").equals(rfile.getString("member_no"))&&rfile_cust.getString("sign_seq").equals("2"));
		rfile.put("isAttchAble", !rfile.getString("reg_gubun").equals("20"));//10:작업업체 첨부 20:협력사 첨부
	}
	rfile_cust.put(".rfile",rfile);
}


//내부 관리 서류 조회
String[] code_reg_type = {"10=><span class='caution-text'>필수첨부</span>","20=>선택첨부","30=>추가첨부"};
DataObject efileDao = new DataObject("tcb_efile");
DataSet efile = new DataSet();
if(cont.getString("efile_yn").equals("Y")){
	efile = efileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
	while(efile.next()){
		efile.put("str_reg_type", u.getItem(efile.getString("reg_type"), code_reg_type));
		efile.put("required", u.inArray(efile.getString("reg_type"), new String[]{"10","30"})?"required='Y'":"");
		//efile.put("doc_name_readonly", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"readonly":"");
		//efile.put("doc_name_class", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"in_readonly":"label");
		efile.put("doc_name_readonly", "readonly");
		efile.put("doc_name_class", "in_readonly");
		efile.put("del_yn", efile.getString("reg_type").equals("30"));
		efile.put("del_yn2", efile.getString("reg_type").equals("20")&&!efile.getString("file_name").equals(""));
		efile.put("file_size_str", u.getFileSize(efile.getInt("file_size")));
		efile.put("down_script","filedown('file.path.bcont_pdf','"+efile.getString("file_path")+efile.getString("file_name")+"','"+efile.getString("doc_name")+"."+efile.getString("file_ext")+"')");
	}
}

if(u.isPost()&&f.validate()){
	//구비서류 저장
	DataObject rfileCustDao = new DataObject("tcb_rfile_cust");
	DataSet rfileCust = rfileCustDao.find("cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"'");

	DB db = new DB();

	String[] rfile_member_no = f.getArr("rfile_member_no");
	String[] rfile_seq = f.getArr("rfile_seq");
	int rfile_cnt = rfile_seq==null?0:rfile_seq.length;
	for(int i=0; i < rfile_cnt ; i ++){
		rfileCustDao = new DataObject("tcb_rfile_cust");
		rfileCustDao.item("cont_no", cont_no);
		rfileCustDao.item("cont_chasu", cont_chasu);
		rfileCustDao.item("rfile_seq", rfile_seq[i]);
		rfileCustDao.item("member_no", rfile_member_no[i]);
		File file = f.saveFileTime("rfile_"+rfile_member_no[i]+"_"+rfile_seq[i]);
		if(file == null){
			rfileCustDao.item("file_path", "");
			rfileCustDao.item("file_name", "");
			rfileCustDao.item("file_ext", "");
			rfileCustDao.item("file_size", "");
			rfileCustDao.item("reg_gubun","");
		}else{
			rfileCustDao.item("file_path", file_path);
			rfileCustDao.item("file_name", file.getName());
			rfileCustDao.item("file_ext", u.getFileExt(file.getName()));
			rfileCustDao.item("file_size", file.length());
			rfileCustDao.item("reg_gubun","10");
		}

		rfileCust.first();
		boolean insert_yn = true;
		while(rfileCust.next()){
			if(rfileCust.getString("member_no").equals(rfile_member_no[i])&&rfileCust.getString("rfile_seq").equals(rfile_seq[i])){
				insert_yn = false;
			}
		}

		if(insert_yn){
			db.setCommand(rfileCustDao.getInsertQuery() ,rfileCustDao.record);
		}else{
			db.setCommand(
					rfileCustDao.getUpdateQuery(" cont_no='"+cont_no+"' "
					                           +" and cont_chasu = '"+cont_chasu+"' "
					                           +" and member_no = '"+rfile_member_no[i]+"' "
					                           +" and rfile_seq = '"+rfile_seq[i]+"'")
					,rfileCustDao.record);
		}
	}
	if(!db.executeArray()){
		u.jsError("저장에 실패하였습니다.");
		return;
	}
	u.jsAlertReplace("저장하였습니다.", "./contend_sendview.jsp?"+u.getQueryString());
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("cont_pop.contend_sendview_pop");
p.setVar("menu_cd","000063");
p.setVar("popup_title","완료(보낸계약)");
p.setVar("change_cont", Integer.parseInt(cont_chasu)>0);
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("gap_yn", gap_yn);
p.setVar("cont", cont);
p.setLoop("contSub", contSub);
p.setVar("file_path", file_path);
p.setVar("template", template);
p.setLoop("sign_template", signTemplate);
p.setLoop("agreeTemplate", agreeTemplate);
if(cust_chain.size()>0) p.setLoop("cust_chain", cust_chain);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("stamp", stamp);
p.setLoop("warr", warr);
p.setLoop("rfile_cust", rfile_cust);
p.setLoop("efile", efile);
p.setVar("query", u.getQueryString());
p.setVar("kakao", bIsKakao);
	p.setVar("btn_disuse", u.inArray(cont.getString("member_no"), new String[]{"20130500619","20150500312","20171101813","20170501348"})&&cont.getString("status").equals("50"));//위메프, 더블유쇼핑, 에스케이스토아, 아워홈, 만 계약폐기 기능 사용 한다.
p.setVar("form_script", f.getScript());
p.display(out);
%>
