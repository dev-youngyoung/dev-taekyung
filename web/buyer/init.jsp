<%@ page import="java.util.*,java.io.*,nicelib.db.*,nicelib.util.*,dao.*" %>
<%@page import="procure.common.conf.Startup"%>
<%@page import="procure.common.utils.*"%><%
// 로그아웃 후 뒤로가기 캐시 방지 2012.11.1 add by 유성훈
response.setHeader("Pragma", "No-cache");
response.setDateHeader("Expires", 0);
response.setHeader("Cache-Control", "no-Cache");
//-------------------------------------------------------

String docRoot = Config.getDocRoot();
String webUrl = Config.getWebUrl();
String jndi = Config.getJndi();
String tplRoot = Config.getTplRoot();
String dataDir = Config.getDataDir();

Util u = new Util(request, response, out);

String[] _tempUri = u.getThisURI().split("\\?")[0].split("/");
String _thisUri = "";
String _onlyFileName = "";
if (_tempUri != null) {
	if (_tempUri.length >= 5 ) {
		_thisUri = "../" + _tempUri[_tempUri.length-2] + "/" + _tempUri[_tempUri.length-1];
		_onlyFileName = _tempUri[_tempUri.length-1];
	}
}
Form f = new Form("form1");
f.setRequest(request);

Page p = new Page(tplRoot);
p.setRequest(request);
p.setPageContext(pageContext);

String jspDir = u.getScriptDir();

Auth auth = new Auth(request, response);
AuthDao _authDao = new AuthDao("tcb_auth");
//auth.loginURL = webUrl + "/member/login.jsp?mid=LOGIN";
auth.keyName = "AUTHID867";
if (auth.isValid()) {
	DataSet _auth = new DataSet();
	_auth.addRow();
	_auth.put("_MEMBER_NO", auth.getString("_MEMBER_NO"));
	_auth.put("_MEMBER_GUBUN", auth.getString("_MEMBER_GUBUN"));
	_auth.put("_MEMBER_TYPE", auth.getString("_MEMBER_TYPE"));
	_auth.put("_VENDCD", auth.getString("_VENDCD"));
	_auth.put("_MEMBER_NAME", auth.getString("_MEMBER_NAME"));
	_auth.put("_CERT_DN", auth.getString("_CERT_DN"));
	_auth.put("_CERT_END_DATE", auth.getString("_CERT_END_DATE"));
	_auth.put("_PERSON_SEQ", auth.getString("_PERSON_SEQ"));
	_auth.put("_USER_ID", auth.getString("_USER_ID"));
	_auth.put("_USER_NAME", auth.getString("_USER_NAME"));
	_auth.put("_DEFAULT_YN", auth.getString("_DEFAULT_YN"));
	_auth.put("_USER_LEVEL", auth.getString("_USER_LEVEL"));
	_auth.put("_USER_GUBUN", auth.getString("_USER_GUBUN"));
	_auth.put("_DIVISION", auth.getString("_DIVISION"));
	_auth.put("_FIELD_SEQ", auth.getString("_FIELD_SEQ"));
	_auth.put("_AUTH_CD", auth.getString("_AUTH_CD"));

	p.setVar("_LOGO", auth.getString("_LOGO_IMG_PATH"));
	p.setVar("login_block", true);
	p.setVar("_auth", _auth);

	p.setVar("default_user_block",_auth.getString("_DEFAULT_YN").equals("Y"));
	if(!_auth.getString("_MEMBER_GUBUN").equals("04")){//사업자
		p.setVar("person_block", false);
	}else{//개인
		p.setVar("person_block", true);
	}
	if(_auth.getString("_MEMBER_TYPE").equals("01")||_auth.getString("_MEMBER_TYPE").equals("03")){
		p.setVar("gap_block", true);
	}
	if(_auth.getString("_MEMBER_TYPE").equals("02")){
		p.setVar("eul_block", true);
	}
} else {
	p.setVar("login_block", false);
}
p.setVar("_sysdate", u.getTimeString());

p.setVar("realgrid_path", "../../../../cab/realgrid/");

p.setVar("SYS_HTTPHOST", request.getServerName());
p.setVar("SYS_PAGE_URL", request.getRequestURL() + (!"".equals(u.getQueryString()) ? "?" + u.getQueryString() : ""));
p.setVar("webUrl", webUrl);
%>