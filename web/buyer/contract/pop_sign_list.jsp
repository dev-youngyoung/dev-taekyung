<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu", "0");

if (cont_no.equals("") || cont_chasu.equals("")) {
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

DataObject custDao = new DataObject("tcb_cust a");
DataSet cust = custDao.find(
		" cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' and sign_seq <= 10"
		, "*"
		, "a.display_seq asc"
		);
if (cust.size() < 1) {
	u.jsError("서명 정보가 존재 하지 않습니다.");
	return;
}

while (cust.next()) {
	cust.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust.getString("sign_date")));
}

p.setLayout("popup");
// p.setDebug(out);
p.setBody("contract.pop_sign_list");
p.setVar("popup_title", "서명정보");
p.setLoop("cust", cust);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>