<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
	auth.delAuthInfo();
	u.jsReplace("/web/admin/main/index.jsp");
	session.invalidate();
%>