<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
String email_random = u.request("email_random");
String sign_dn = u.request("sign_dn");
String sign_data = u.request("sign_data");
if(cont_no.equals("")||cont_chasu.equals("")||email_random.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

String _member_no = "";
String _sign_seq = "";
String _member_name = "";
boolean sign_able = false;

String file_path = "";

DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.query(
		 "select a.status "
		+"     , a.cont_html "
		+"     , a.cont_no "
		+"     , a.cont_chasu "
		+"     , a.cont_name "
		+"     , a.template_cd"
		+"     , b.template_name "
		+"     , c.boss_name "
		+"     , c.member_name "
		+"     , c.user_name "
		+"     , c.tel_num"
		+"     , c.address, c.email "
		+"     , c.hp1, c.hp2, c.hp3 "
		+"     , c.tel_num "
		+"     , c.sign_date " 
		+"  from tcb_contmaster a, tcb_cont_template b, tcb_cust c "
		+ "where a.template_cd=b.template_cd "
		+ "  and a.cont_no=c.cont_no "
		+ "  and a.cont_chasu=c.cont_chasu "
		+ "  and a.member_no=c.member_no "
		+ "  and b.send_type='20' "
		+ "  and a.cont_no='"+cont_no+"' and a.cont_chasu='"+cont_chasu+"' ");
if(cont.size() < 1){
	u.jsAlert("계약정보가 없습니다.");
	return;
}

while(cont.next()){
	cont.put("cont_no_view", cont.getString("cont_no"));
	cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
	if(cont.getString("sign_date").equals(""))
		cont.put("sign_date", "미서명");
	else
		cont.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("sign_date")));

}

//추가 계약서 조회
DataObject contSubDao = new DataObject("tcb_cont_sub");
DataSet contSub = contSubDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and (gubun <> '40' or (gubun = '40' and option_yn in ('A','Y')))");
while(contSub.next()){
	contSub.put("hidden", u.inArray(contSub.getString("gubun"), new String[]{"20","30"}));
	contSub.put("template_name", contSub.getString("cont_sub_name"));
	contSub.put("template_cd", cont.getString("template_cd"));
	contSub.put("chk", contSub.getString("chk_yn").equals("Y")?"checked":"");
}

//서식정보 조회
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" status > 0 and template_cd ='"+cont.getString("template_cd")+"'");
if(template.next()){
	template.put("recv_write", template.getString("writer_type").trim().equals("Y"));
	template.put("need_attach_yn", template.getString("need_attach_yn").trim().equals("Y"));
}


// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust a, tcb_member b");
DataSet cust = custDao.find(
		" a.member_no=b.member_no(+) and cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and email_random = '"+email_random+"'  "
		,"a.*, b.member_gubun, (select cust_type from tcb_cont_sign where cont_no = a.cont_no and cont_chasu=a.cont_chasu and sign_seq = a.sign_seq) cust_type"
		,"a.display_seq asc"
);
if(cust.size()<1){
	u.jsError("계약업체 정보가 존재 하지 않습니다.");
	return;
}

while(cust.next()){
	cust.put("person_yn", cust.getString("member_gubun").equals("04")||cust.getString("member_gubun").equals(""));
	
	
	if(cust.getString("email_random").equals(email_random)){
		_member_no = cust.getString("member_no");
		_sign_seq = cust.getString("sign_seq");
		_member_name = cust.getString("member_name");
        if(cont.getString("status").equals("20") && cust.getString("sign_dn").equals("")){
            sign_able = true;
        }
        
        String isBoss = cust.getString("boss_name");
		if((cust.getString("member_gubun").equals("04")||cust.getString("member_gubun").equals(""))){
			isBoss = null;
		}
		p.setVar("isboss_name", isBoss);
	}
	if(cust.getString("sign_date").equals("")){
		cust.put("sign_date", "미서명");
	}else{
		cust.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust.getString("sign_date")));
	}
}

if(sign_able && (sign_dn.equals("") || sign_data.equals(""))) {
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

//계약서류 조회
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and (auto_type is null or auto_type <> '3') "); // 작성업체만 보는 계약 파일 제외
while(cfile.next()){
	cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	//if(cfile.getString("cfile_seq").equals("1")&&cfile.getString("auto_yn").equals("Y")){
	if(cfile.getString("cfile_seq").equals("1")){  // 자유서식에서 구비서류 저장시 오류나서 auto_yn 삭제
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
		cfile.put("auto_str", "<a href=\"javascript:contPdfViewerp('"+u.request("cont_no")+"','"+cont_chasu+"','"+cfile.getString("cfile_seq")+"');\">"+ cfile.getString("auto_str") +"</a>");
	}else{
		cfile.put("btn_name", "다운로드");
		cfile.put("down_script","filedown('file.path.bcont_pdf','"+cfile.getString("file_path")+cfile.getString("file_name")+"','"+cfile.getString("doc_name")+"."+cfile.getString("file_ext")+"')");
	}
}



// 업체별 구비 서류 조회
DataObject rfileDao = new DataObject("tcb_rfile");
DataSet rfile = new DataSet();
if(u.inArray(cont.getString("template_cd"), new String[]{"2019183","2019211","2019227","2019230","2020179","2020196"})){ 
	rfile = rfileDao.query(
			 "  select a.attch_yn, a.doc_name, a.rfile_seq, a.allow_ext, b.file_path, b.file_name, b.file_ext, b.file_size, b.member_no "
			+"    from tcb_rfile a  "
			+"    left outer join  tcb_rfile_cust b "
			+"      on a.cont_no = b.cont_no  "
			+"     and a.rfile_seq = b.rfile_seq  "
			+"     and a.cont_chasu = b. cont_chasu "
			+"     and b.member_no = '"+_member_no+"' "
			+"   where  a.cont_no = '"+cont_no+"'  "
			+"     and a.cont_chasu = '"+cont_chasu+"' "
			+"   order by a.rfile_seq asc "
	);
}
while(rfile.next()){
	rfile.put("cont_no", u.aseEnc(rfile.getString("cont_no")));
	rfile.put("attch", rfile.getString("attch_yn").equals("Y"));
	rfile.put("attch_str", rfile.getString("attch_yn").equals("Y")?"<span class='caution-text'>(필수)</span> ":"");
	rfile.put("upload_yn", rfile.getString("file_name").equals("")?"":"Y");
	rfile.put("file_size", u.getFileSize(rfile.getLong("file_size")));
	rfile.put("doc_name", ""+rfile.getString("doc_name"));
	rfile.put("display_down", rfile.getString("file_name").equals("")?"none":"");
	rfile.put("display_del", rfile.getString("file_name").equals("")||rfile.getString("attch_yn").equals("Y")||!u.inArray(cont.getString("status"), new String[]{"20","21","30","40","41"})?"none":"");
	rfile.put("display_upload", u.inArray(cont.getString("status"), new String[]{"20","21","30","40","41"})?"":"none");
	rfile.put("upload_btn_nm", rfile.getString("file_name").equals("")?"첨부":"수정첨부");
}

/* 계약로그 START*/
if(sign_able) {
	ContBLogDao logDao = new ContBLogDao();
	int view_cnt= logDao.findCount(
			 "     cont_no = '"+cont_no+"' "
			+" and cont_chasu = '"+cont_chasu+"' " 
			+" and member_no = '"+_member_no+"' "
			+" and log_seq > (select max(log_seq) from tcb_cont_log where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"' and cont_status = '20' )"
			);
	if(view_cnt < 1){//전송이후로 내가 로그 정보에 없으면
		logDao = new ContBLogDao();
		logDao.setInsert(cont_no, String.valueOf(cont_chasu), _member_no, "1", cust.getString("user_name"), request.getRemoteAddr(), "전자문서 조회", "", cont.getString("status"),"20");
	}
}
/* 계약로그 END*/

p.setLayout("email_msign_contract");
p.setDebug(out);
p.setBody("sdd.email_contract_msign_recvview");
p.setVar("_member_no", _member_no);
p.setVar("_member_name", _member_name);
p.setVar("_sign_seq", _sign_seq);
p.setVar("sign_able", sign_able);
p.setVar("cont", cont);
p.setVar("template", template);
p.setLoop("contSub", contSub);
p.setLoop("cust", cust);
p.setLoop("rfile", rfile);
p.setVar("file_path", file_path);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>