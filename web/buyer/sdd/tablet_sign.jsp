<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="../contract/include_cont_func.jsp" %>
<%


p.setLayout("email_msign_contract");
p.setBody("sdd.tablet_sign");
p.setVar("query", u.getQueryString());
p.setVar("form_script", f.getScript());
p.display(out);
%>