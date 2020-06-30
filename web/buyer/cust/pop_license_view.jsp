<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%
String client_no = u.request("client_no");
if(client_no.equals("")){
	u.jsError("정상적인 경로로 접근해 주세요.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet client = memberDao.find("member_no = '"+client_no+"' ");
if(client.next()){
}

String where = "member_no = '"+_member_no+"' and client_no = '"+client_no+"' ";

DataObject dao = null;
DataSet ds = null;

dao = new DataObject("tcb_client_tech a");
ds = dao.find(
		where
		, "a.*                                              "
		 +",(select code_nm                                 "
		 +"    from tcb_user_code                           "
		 +"  where member_no = '"+_member_no+"'         "
		 +"    and depth = '4'                              "
		 +"    and code = a.tech_cd ) code_nm                  "
		, " seq asc"
		);

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_license_view");
p.setVar("popup_title","보유면허 상세");
p.setVar("client", client);
p.setLoop("list", ds);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);

%>