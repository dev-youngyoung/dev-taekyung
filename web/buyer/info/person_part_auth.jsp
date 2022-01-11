<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
p.setLayout("default");
//p.setDebug(out);
p.setBody("info.person_part_auth");
p.setVar("menu_cd", "000122");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000122", "btn_auth").equals("10"));
p.setVar("form_script",f.getScript());
p.display(out);
%>