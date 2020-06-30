<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
	auth.delAuthInfo();
	u.jsReplace("/web/buyer/m/index.jsp?" + u.getQueryString());
	if(session != null)	{
		session.invalidate();
	}
%>