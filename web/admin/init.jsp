<%@ page import="java.util.*,java.io.*,nicelib.db.*,nicelib.util.*,dao.*" %>
<%@page import="procure.common.conf.Startup"%>
<%@page import="procure.common.utils.*"%><%
// 로그아웃 후 뒤로가기 캐시 방지 2012.11.1 add by 유성훈
response.setHeader("Pragma", "No-cache");
response.setDateHeader("Expires", 0);
response.setHeader("Cache-Control", "no-Cache");
//-------------------------------------------------------

String docRoot = Startup.conf.getString("nicelib.admin_root");
String webUrl = Config.getWebUrl();
String jndi = Config.getJndi();
String tplRoot = docRoot + "/html";
String dataDir = docRoot + "/data";

Util u = new Util(request, response, out);

if(request.getServerName().equals("nicedocu.com")){//www.가 빠진 건 웹 방화벽에 등록되어 있지 않은 도매인이다.
	u.redirect("https://www.nicedocu.com"+u.getThisURI()+"?"+u.getQueryString());
	return;
}

if(request.getServerName().equals("www.nicedocu.com")&&!request.isSecure()){
	if(u.isPost()){
		u.jsError("보안을 위해 https로  접근 하세요.\\n\\nhttp접근시 post방식으로는 접근이 불가합니다.");
	}else{
		u.redirect(request.getRequestURL().toString().replaceAll("http://", "https://")+"?"+u.getQueryString());
	}
	return;
}


Form f = new Form("form1");
f.setRequest(request);

Page p = new Page(tplRoot);
p.setRequest(request);
p.setPageContext(pageContext);

String jspDir = u.getScriptDir();

Auth auth = new Auth(request, response);
//auth.loginURL = webUrl + "/member/login.jsp?mid=LOGIN";
auth.keyName = "AUTHID094";
if(auth.isValid()) {
	DataSet _auth = new DataSet();
	_auth.addRow();
	_auth.put("_ADMIN_ID", auth.getString("_ADMIN_ID"));
	_auth.put("_ADMIN_NAME", auth.getString("_ADMIN_NAME"));
	_auth.put("_AUTH_CD", auth.getString("_AUTH_CD"));
	_auth.put("_BEFORE_LOGIN_DATE", auth.getString("_BEFORE_LOGIN_DATE"));

	p.setVar("login_block", true);
	p.setVar("_auth", _auth);
} else {
	p.setVar("logo", "main_02.gif");
	p.setVar("login_block", false);
}
p.setVar("_sysdate", u.getTimeString());

p.setVar("realgrid_path", "../../../../cab/realgrid/");

p.setVar("SYS_HTTPHOST", request.getServerName());
p.setVar("SYS_PAGE_URL", request.getRequestURL() + (!"".equals(u.getQueryString()) ? "?" + u.getQueryString() : ""));
p.setVar("webUrl", webUrl);
%>