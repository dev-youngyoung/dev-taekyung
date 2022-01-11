<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String tab_id = u.request("tab_id");



p.setLayout("default");
p.setDebug(out);
p.setBody("guide.service_intro");
p.setVar("menu_cd","000130");
p.setVar("tab_id", u.inArray(tab_id, new String[]{"0","1","2","3","4","5"})?tab_id:"");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script", f.getScript());
p.display(out);
%>