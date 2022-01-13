<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
	auth.delAuthInfo();
	u.jsReplace("/web/buyer/main/index.jsp");
	if(session != null)	{
		session.invalidate();
	}

%>