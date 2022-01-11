<%@ page import="java.net.URLDecoder" %>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] agree_ip = {
		 "112.217.108.98"//나이스데이터LG
		,"112.217.108.99"//나이스데이터LG
		,"219.240.87.178"//나이스데이터SK
		,"219.240.87.179"//나이스데이터SK
		,"219.240.87.180"//나이스데이터SK
		,"127.0.0.1"//로컬 개발
};

String login_ip = request.getRemoteAddr();
/*
if(!login_ip.startsWith("192.168.10")){
	if(!u.inArray(login_ip, agree_ip)){
		out.println("<script>");
		out.println("//alert('허용되지 않는 IP의 접근입니다.\\n\\nIP:"+login_ip+"');");
		out.println("</script>");
		return;
	}
}
*/
if(auth.getString("_ADMIN_ID")!=null&&!auth.getString("_ADMIN_ID").equals("")){
	u.redirect("index2.jsp");
	return;
}

f.addElement("returl", u.request("returl"), "");
f.addElement("txtUserID", null, "hname:'아이디', required:'Y', maxbyte:'20'");
f.addElement("txtPassWD", null, "hname:'비밀번호', required:'Y'");

if(u.isPost() && f.validate())
{
	DataObject adminDao = new DataObject("tcc_admin");
	DataSet mgr_user = adminDao.find("admin_id='"+f.get("txtUserID")+"' and passwd='"+u.sha256(f.get("txtPassWD"))+"'");
	if(!mgr_user.next()){
		u.jsError("사용자 정보가 존재 하지 않습니다.");
		return;
	}
	DataObject loginLogDao = new DataObject("tcc_login_log");
	String before_login_date = loginLogDao.getOne("select max(log_date) from tcc_login_log where login_id = '"+f.get("txtUserID")+"' ");

	DB db = new DB();
	loginLogDao = new DataObject("tcc_login_log");
	loginLogDao.item("login_id", mgr_user.getString("admin_id"));
	loginLogDao.item("log_date", u.getTimeString());
	db.setCommand(loginLogDao.getInsertQuery(), loginLogDao.record);
	if(!db.executeArray()){
		u.jsError("처리중 오류가 발생 하였습니다");
		return;
	}

	// 어드민 정보 저장
	auth.put("_ADMIN_ID", mgr_user.getString("admin_id"));
	auth.put("_ADMIN_NAME", mgr_user.getString("admin_name"));
	auth.put("_AUTH_CD", mgr_user.getString("auth_cd"));
	if(!before_login_date.equals("")) {
		auth.put("_BEFORE_LOGIN_DATE", u.getTimeString("yyyy-MM-dd HH:mm:ss", before_login_date));
	}
	auth.setAuthInfo();

	u.jsReplace(URLDecoder.decode(f.get("returl"), "UTF-8"));
	return;
}



p.setLayout("default");
//p.setDebug(out);
p.setBody("main.index");
p.display(out);
%>