<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
p.setLayout("default");
p.setVar("menu_cd","000127");
//p.setDebug(out);
p.setBody("member.join_agree");
p.display(out);
%>