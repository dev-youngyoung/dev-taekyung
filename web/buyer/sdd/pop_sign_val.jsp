<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%
p.setLayout("popup_email_contract");
//p.setDebug(out);
p.setVar("popup_title","나이스다큐 본인확인 인증창");
p.setBody("sdd.pop_sign_val");
p.display(out);
%>