<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
	auth.delAuthInfo();
	u.jsReplace("/web/admin/main/index.jsp");
	session.invalidate();
%>