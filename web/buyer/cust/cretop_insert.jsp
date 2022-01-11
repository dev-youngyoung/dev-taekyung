<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

DataObject doTM = new DataObject("tcb_member");
DataSet dsTM = doTM.find("member_no = '"+_member_no+"'", "member_no");
if(!dsTM.next()){
	u.jsError("올바른 접근이 아닙니다.");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.cretop_insert");
p.setVar("menu_cd","000084");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000084", "btn_auth").equals("10"));
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script", f.getScript());
p.display(out);
%>