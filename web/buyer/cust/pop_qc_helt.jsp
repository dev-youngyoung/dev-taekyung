<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_qc_helt");
p.setVar("popup_title","평가기준참조");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>