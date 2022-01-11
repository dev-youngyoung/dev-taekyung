<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%

String template = "";  
template = u.aseDec(u.request("c")); // 나이스페이먼츠, 나이스정보통신 분리를 위해서 template_cd를 받아서 분리 (html단에서 문구가 서로 다름)
	  
p.setLayout("subscription");
//p.setDebug(out);
p.setBody("contract.subscription_e");	
p.setVar("template", template); 
//p.setVar("query", u.getQueryString());
//p.setVar("form_script", f.getScript()); 
p.display(out);
%>