<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

f.addElement("s_sendEmail", null, "hname:'이메일주소', required:'Y'");

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_sendEmailSet");
p.setVar("form_script", f.getScript());
p.setVar("popup_title","결과전송 이메일 입력");
p.display(out);
%>