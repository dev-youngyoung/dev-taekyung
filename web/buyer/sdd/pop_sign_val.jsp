<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
p.setLayout("popup_email_contract");
//p.setDebug(out);
p.setVar("popup_title","���̽���ť ����Ȯ�� ����â");
p.setBody("sdd.pop_sign_val");
p.display(out);
%>