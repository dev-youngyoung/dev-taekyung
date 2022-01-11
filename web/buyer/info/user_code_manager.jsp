<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

if(u.isPost()&& f.validate()){
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.user_code_manager");
p.setVar("menu_cd","000112");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000112", "btn_auth").equals("10"));
p.setVar("form_script", f.getScript());
p.display(out);
%>