<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%



p.setLayout("default");
p.setDebug(out);
p.setBody("main.charge");
p.setVar("popup_title","���񽺿�� �ȳ�");
p.setVar("form_script",f.getScript());
p.display(out);
%>