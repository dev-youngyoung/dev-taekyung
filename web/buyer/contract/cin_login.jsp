<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%

// http://dev.nicedocu.com/web/buyer/contract/cin_login.jsp
// co.kr 도메인으로 들어오면 .com 도메인으로 보낸다. 이유는 ssl 인증서가 .com 밖에 없다.
String sServerName = request.getServerName();
String sLoginUrl = "/web/buyer/main/login.jsp?re=/web/buyer/contract/cin.jsp&"+u.getQueryString();


p.setLayout("default");
//p.setDebug(out);
p.setVar("loginurl", sLoginUrl);
p.setBody("contract.cin_login");
p.setVar("form_script", f.getScript());
p.display(out);
%>