<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.client_license_list");
p.setVar("menu_cd","000097");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000097", "btn_auth").equals("10"));
p.setVar("sys_date", u.getTimeString());
p.setVar("form_script", f.getScript());
p.display(out);
%>