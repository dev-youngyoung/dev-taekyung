<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%

String template = "";  
template = u.aseDec(u.request("c")); // ���̽����̸���, ���̽�������� �и��� ���ؼ� template_cd�� �޾Ƽ� �и� (html�ܿ��� ������ ���� �ٸ�)
	  
p.setLayout("subscription");
//p.setDebug(out);
p.setBody("contract.subscription_e");	
p.setVar("template", template); 
//p.setVar("query", u.getQueryString());
//p.setVar("form_script", f.getScript()); 
p.display(out);
%>