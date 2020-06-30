<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%



p.setLayout("default");
p.setDebug(out);
p.setBody("main.charge");
p.setVar("popup_title","서비스요금 안내");
p.setVar("form_script",f.getScript());
p.display(out);
%>