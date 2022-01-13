<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
if(auth.getString("_MEMBER_NO")==null||auth.getString("_MEMBER_NO").equals("")){
	u.redirect("index.jsp");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("main.index_dash");
p.setVar("member_no", auth.getString("_MEMBER_NO"));
p.display(out);
%>