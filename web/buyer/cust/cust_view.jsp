<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
boolean isDetailCode = u.inArray(_member_no, new String[]{"20150500312","20160401012","20171100802"});//(주)더블유쇼핑, 엘지히타치워터솔루션 주식회사, NICE정보통신

String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

CodeDao code = new CodeDao("tcb_comcode");
String[] code_member_gubun = code.getCodeArray("M001");

boolean src_view = false;

String member_slno1= "";
String member_slno2= "";

DataObject mdao = new DataObject("tcb_member");
//mdao.setDebug(out);
DataSet member = mdao.query(
	 " select a.*								 "
	+"       , b.status client_status            "
	+"       , b.reason                          "
	+"       , b.reason_date                     "
	+"       , b.reason_id                       "
	+"       , (select user_name                 "
	+"            from tcb_person                "
	+"           where member_no = b.member_no   "
	+"             and user_id = b.reason_id     "
	+"          ) reason_name                    "
	+"       , b.temp_yn						 "
	+"       , b.client_seq						 "
	+(isDetailCode?",( select cust_detail_code from tcb_client_detail where member_no = b.member_no and client_seq = b.client_seq) cust_detail_code ":"")
	+"   from tcb_member a, tcb_client b         "
	+"  where a.member_no = b.client_no          "
	+"    and b.member_no = '"+_member_no+"'     "
	+"    and b.client_no = '"+member_no+"'      "
);
if(!member.next()){
	u.jsError("회원정보가 없습니다.");
	return;
}
member.put("vendcd", u.getBizNo(member.getString("vendcd")));
member.put("member_gubun_name", u.getItem(member.getString("member_gubun"),code_member_gubun));
if(member.getString("member_slno").length()==13){
	member_slno1= member.getString("member_slno").substring(0,6);
	member_slno2= member.getString("member_slno").substring(6);
	member.put("member_slno", member_slno1+" - "+member_slno2);
}

member.put("post_code", member.getString("post_code").trim());
member.put("reason_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", member.getString("reason_date")));

DataObject rfileDao = new DataObject();
String rfileQuery = "  select a.attch_yn, a.doc_name, a.rfile_seq, a.allow_ext, b.file_path, b.file_name, b.file_ext, b.file_size, b.member_no "
		+"    from tcb_client_rfile_template a  "
		+"    left outer join  tcb_client_rfile b "
		+"      on a.member_no = b.member_no  "
		+"     and a.rfile_seq = b.rfile_seq  "
		+"     and b.client_no = '"+member_no+"'"
		+"   where a.member_no = '"+_member_no+"'";

//rfileDao.setDebug(out);
DataSet rfile = rfileDao.query(rfileQuery);
while(rfile.next()){
	rfile.put("file_size", u.getFileSize(rfile.getLong("file_size")));
}


DataObject personDao = new DataObject("tcb_person");
DataSet person = personDao.find(" member_no = '"+member_no+"' and status > 0  ", "*"," person_seq asc ");

DataSet src = new DataSet();
if( u.inArray(auth.getString("_MEMBER_TYPE"), new String[]{"01","03"})){
	DataSet login_member = mdao.find(" member_no = '"+_member_no+"' ");
	if(!login_member.next()){
	}
	if(!login_member.getString("src_depth").equals("")){
		src_view = true;
		src = mdao.query(
		 "  select                                                                                                                        "
		+"         (select src_nm from tcb_src_adm where member_no = a.member_no and src_cd = substr(a.src_cd ,0,3)||'000000') l_src_nm   "
		+"       , (select src_nm from tcb_src_adm where member_no = a.member_no and src_cd = substr(a.src_cd ,0,6)||'000') m_src_nm      "
		+"       , (select src_nm from tcb_src_adm where member_no = a.member_no and src_cd = a.src_cd ) s_src_nm                         "
		+"  from tcb_src_member a                                                                                                         "
		+" where member_no = '"+_member_no+"'                                                                                             "
		+"   and src_member_no = '"+member_no+"'                                                                                          "
		);
	}
	while(src.next()){
		if(login_member.getString("src_depth").equals("01")){
			src.put("src_nm", src.getString("l_src_nm"));
		}
		if(login_member.getString("src_depth").equals("02")){
			src.put("src_nm", src.getString("l_src_nm")+">"+src.getString("m_src_nm"));
		}
		if(login_member.getString("src_depth").equals("03")){
			src.put("src_nm", src.getString("l_src_nm")+" > "+src.getString("m_src_nm")+" > "+src.getString("s_src_nm"));
		}
	}
}


f.addElement("client_status", member.getString("client_status"), "hname:'거래정지'");
f.addElement("temp_yn", member.getString("temp_yn"), "hname:'일회성업체'");
if(isDetailCode){
	f.addElement("cust_detail_code", member.getString("cust_detail_code"), "hname:'거래처코드'");
}

if(u.isPost()&& f.validate()){

	DB db = new DB();
	
	DataObject clientDao = new DataObject("tcb_client");
	//clientDao.setDebug(out);
	clientDao.item("status", f.get("client_status").equals("90")?"90":"10");
	clientDao.item("reason", f.get("reason"));
	clientDao.item("reason_date", f.get("reason").equals("")?"":u.getTimeString());
	clientDao.item("reason_id",  f.get("reason").equals("")?"":auth.getString("_USER_ID"));
	clientDao.item("temp_yn", f.get("temp_yn").equals("Y")?"Y":"");
	db.setCommand(clientDao.getUpdateQuery("member_no = '"+_member_no+"' and client_no = '"+member_no+"'"), clientDao.record);
	
	if(isDetailCode){

		DataObject detailDao = new DataObject("tcb_client_detail");
		detailDao.item("member_no", _member_no);
		detailDao.item("person_seq", "1");
		detailDao.item("client_seq", member.getString("client_seq"));
		detailDao.item("client_detail_seq", "1");
		detailDao.item("cust_detail_code", f.get("cust_detail_code"));
		if(detailDao.findCount(" person_seq = '1' and member_no = '"+_member_no+"' and client_seq = '"+member.getString("client_seq")+"' ")>0){
			db.setCommand(detailDao.getUpdateQuery("person_seq = '1' and member_no = '"+_member_no+"' and client_seq = '"+member.getString("client_seq")+"'"), detailDao.record);
		}else{
			db.setCommand(detailDao.getInsertQuery(),detailDao.record);
		}
		if(!f.get("cust_detail_code").equals("")){
			String kthSql = " update tcb_cust                                           "
					       +"    set cust_detail_code='"+f.get("cust_detail_code")+"'   "
					       +"  where cont_no in (select cont_no                         "
					       +" 	              from tcb_contmaster                       "
					       +" 	             where member_no = '"+_member_no+"')        "
			               +"    and member_no = '"+member.getString("member_no")+"'    ";
			db.setCommand(kthSql, null);
		}
	}
	
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	
	u.jsAlertReplace("저장하였습니다.", "./cust_view.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.cust_view");
p.setVar("menu_cd","000082");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000082", "btn_auth").equals("10"));
p.setVar("member",member);
p.setLoop("rfile", rfile);
p.setLoop("person", person);
p.setVar("src_view", src_view);
p.setLoop("src", src);
p.setVar("sys_date", u.getTimeString());
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.setVar("isDetailCode", isDetailCode);
p.display(out);
%>