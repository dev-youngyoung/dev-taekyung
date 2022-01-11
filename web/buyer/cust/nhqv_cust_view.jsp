<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] code_client_reg_cd = {"0=>가등록","1=>정식등록"};

String client_type = u.request("client_type");
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

CodeDao code = new CodeDao("tcb_comcode");
String[] code_member_gubun = code.getCodeArray("M001");

DataObject memberDao = new DataObject("tcb_member");
//mdao.setDebug(out);
DataSet member = memberDao.query(
		" select a.*								 "
				+"       , b.client_seq						 "
				+"       , b.client_reg_cd					 "
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
	String member_slno1= member.getString("member_slno").substring(0,6);
	String member_slno2= member.getString("member_slno").substring(6);
	member.put("member_slno", member_slno1+" - "+member_slno2);
}

DataObject personDao = new DataObject("tcb_person");
DataSet person = personDao.find(" member_no = '"+member_no+"' and status > 0 ", "*"," person_seq asc ");

f.addElement("client_reg_cd", member.getString("client_reg_cd"), "hname:'등록상태', required:'Y'");

if(u.isPost()&& f.validate()){

	DB db = new DB();

	DataObject clientDao = new DataObject("tcb_client");
	//clientDao.setDebug(out);
	clientDao.item("client_reg_cd", f.get("client_reg_cd"));
	db.setCommand(clientDao.getUpdateQuery("member_no = '"+_member_no+"' and client_no = '"+member_no+"'"), clientDao.record);


	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}

	u.jsAlertReplace("저장하였습니다.", "./nhqv_cust_view.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.nhqv_cust_view");
if(client_type.equals("1")){// 1:등록업체 2:협력업체
	p.setVar("menu_cd","000091");
	p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000091", "btn_auth").equals("10"));
}else{
	p.setVar("menu_cd","000092");
	p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000092", "btn_auth").equals("10"));
}
p.setLoop("code_client_reg_cd", u.arr2loop(code_client_reg_cd));
p.setVar("member",member);
p.setLoop("person", person);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.display(out);
%>