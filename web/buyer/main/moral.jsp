<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%



p.setLayout("popup");
p.setDebug(out);
p.setBody("main.moral");
p.setVar("popup_title","(��)���̽���غ� ��������");
p.setVar("form_script",f.getScript());
p.display(out);
%>