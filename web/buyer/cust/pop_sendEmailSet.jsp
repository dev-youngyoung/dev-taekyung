<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

f.addElement("s_sendEmail", null, "hname:'�̸����ּ�', required:'Y'");

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_sendEmailSet");
p.setVar("form_script", f.getScript());
p.setVar("popup_title","������� �̸��� �Է�");
p.display(out);
%>