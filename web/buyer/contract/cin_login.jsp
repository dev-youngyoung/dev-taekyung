<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%

// http://dev.nicedocu.com/web/buyer/contract/cin_login.jsp
// co.kr ���������� ������ .com ���������� ������. ������ ssl �������� .com �ۿ� ����.
String sServerName = request.getServerName();
String sLoginUrl = "/web/buyer/main/login.jsp?re=/web/buyer/contract/cin.jsp&"+u.getQueryString();


p.setLayout("default");
//p.setDebug(out);
p.setVar("loginurl", sLoginUrl);
p.setBody("contract.cin_login");
p.setVar("form_script", f.getScript());
p.display(out);
%>