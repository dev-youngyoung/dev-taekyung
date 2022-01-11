<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
p.setLayout("popup");
//p.setDebug(out);
p.setBody("info.pop_crosscert");
p.setVar("popup_title", "인증서 확인하기");
p.display(out);
%>