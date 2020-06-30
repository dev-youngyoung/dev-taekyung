<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

CodeDao code = new CodeDao("tcb_comcode");
String[] code_member_gubun = code.getCodeArray("M001");
String[] code_client_type = code.getCodeArray("M210");  // 전문분야
String[] code_client_reg_cd = {"1=>정식등록","0=>가등록"};

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
				+"       , b.client_type					 "
				+"       , b.client_reg_cd					 "
				+"       , c.*					 "
				+"   from tcb_member a inner join tcb_client b on a.member_no = b.client_no left join tcb_member_add c on a.member_no=c.member_no"
				+"  where           "
				+"        b.member_no = '"+_member_no+"'     "
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
if(member.getString("post_code").trim().length() == 6){
	String post_code1 = member.getString("post_code").substring(0,3);
	String post_code2 = member.getString("post_code").substring(3);
	member.put("post_code", post_code1+" - "+ post_code2);
}else{
	member.put("post_code", member.getString("post_code").trim());
}

member.put("reason_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", member.getString("reason_date")));


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

f.addElement("client_reg_cd", member.getString("client_reg_cd"), "hname:'업체등록상태', required:'Y'");
f.addElement("client_type", member.getString("client_type"), "hname:'업체분류'");
f.addElement("debt_rate", member.getString("debt_rate"), "hname:'부채비율'");
f.addElement("liquid_rate", member.getString("liquid_rate"), "hname:'유동비율'");
f.addElement("client_status", member.getString("client_status"), "hname:'거래정지'");
f.addElement("temp_yn", member.getString("temp_yn"), "hname:'일회성업체'");

if(u.isPost()&& f.validate()){

	DB db = new DB();

	DataObject clientDao = new DataObject("tcb_client");
	//clientDao.setDebug(out);
	clientDao.item("status", f.get("client_status").equals("90")?"90":"10");
	clientDao.item("reason", f.get("reason"));
	clientDao.item("reason_date", f.get("reason").equals("")?"":u.getTimeString());
	clientDao.item("reason_id",  f.get("reason").equals("")?"":auth.getString("_USER_ID"));
	clientDao.item("temp_yn", f.get("temp_yn").equals("Y")?"Y":"");
	clientDao.item("client_type", f.get("client_type"));
	clientDao.item("client_reg_cd", f.get("client_reg_cd"));
	db.setCommand(clientDao.getUpdateQuery("member_no = '"+_member_no+"' and client_no = '"+member_no+"'"), clientDao.record);

	DataObject memberAddDao = new DataObject("tcb_member_add");

	int cnt = memberAddDao.getOneInt("select count(*) from tcb_member_add where member_no = '"+member_no+"'");
	memberAddDao.item("debt_rate", f.get("debt_rate"));
	memberAddDao.item("liquid_rate", f.get("liquid_rate"));
	if(cnt>0) {
		db.setCommand(memberAddDao.getUpdateQuery("member_no = '"+member_no+"'"), memberAddDao.record);
	} else {
		memberAddDao.item("member_no", member_no);
		db.setCommand(memberAddDao.getInsertQuery(), memberAddDao.record);
	}

	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장 하였습니다.", "./nh_cust_view.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.nh_cust_view");
p.setVar("menu_cd","000083");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000083", "btn_auth").equals("10"));
p.setVar("member",member);
p.setLoop("person", person);
p.setVar("src_view", src_view);
p.setLoop("src", src);
p.setLoop("code_client_type", u.arr2loop(code_client_type));
p.setLoop("code_client_reg_cd", u.arr2loop(code_client_reg_cd));
p.setVar("sys_date", u.getTimeString());
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.display(out);
%>