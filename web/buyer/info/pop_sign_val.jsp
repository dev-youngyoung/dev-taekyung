<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%
p.setLayout("blank");
//p.setDebug(out);
if(u.request("full").equals("Y"))
	p.setBody("info.pop_sign_val2");
else
	p.setBody("info.pop_sign_val");
p.display(out);
%>