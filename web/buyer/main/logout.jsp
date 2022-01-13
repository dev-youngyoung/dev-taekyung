<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
	auth.delAuthInfo();
	u.jsReplace("/web/buyer/main/index.jsp");
	if(session != null)	{
		session.invalidate();
	}

%>