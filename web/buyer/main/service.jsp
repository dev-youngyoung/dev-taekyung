<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%



p.setLayout("blank");
p.setDebug(out);
p.setBody("main.service");
p.setVar("popup_title","서비스 이용안내");
p.setVar("form_script",f.getScript());
p.display(out);
%>