<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String admin_id = u.request("admin_id");
if(admin_id.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject mgrUserDao = new DataObject("tcc_admin");
DataSet mgr_user = mgrUserDao.find("admin_id = '"+admin_id+"' ");
if(!mgr_user.next()){
	u.jsError("관리자 정보가 없습니다.");
	return;
}

f.addElement("admin_id", mgr_user.getString("admin_id"),"hname:'관리자아이디', required:'Y'");
f.addElement("admin_name", mgr_user.getString("admin_name"),"hname:'관리자명' , required:'Y'");
f.addElement("passwd", null,"hname:'비밀번호',option:'userpw', match:'passwd2'");
f.addElement("admin_ip", mgr_user.getString("admin_ip"),"hname:'관리자IP' ");
f.addElement("auth_cd", mgr_user.getString("auth_cd"),"hname:'권한코드' , required:'Y'");

DataObject authDao = new DataObject("tcc_auth");
DataSet authInfo = authDao.find("status = '10' ","*","auth_nm asc");

// 입력수정
if(u.isPost() && f.validate()){

	DB db = new DB();
	mgrUserDao = new DataObject("tcc_admin");
	mgrUserDao.item("admin_name", f.get("admin_name"));
	mgrUserDao.item("admin_ip", f.get("admin_ip"));
	mgrUserDao.item("auth_cd", f.get("auth_cd"));
	if(!f.get("passwd").equals(""))
		mgrUserDao.item("passwd", u.sha256(f.get("passwd")));
	
	db.setCommand(mgrUserDao.getUpdateQuery(" admin_id = '"+admin_id+"' "), mgrUserDao.record);

	if(!db.executeArray()){
		u.jsError("처리중 오류가 발생 하였습니다");
		return;
	}
	
	u.jsAlertReplace("저장처리 하였습니다.","mgr_user_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
p.setDebug(out);
p.setBody("mgr.mgr_user_modify");
p.setLoop("authInfo", authInfo);
p.setVar("menu_cd","000024");
p.setVar("modify",true);
p.setVar("mgr_user", mgr_user);
p.setVar("authInfo", authInfo);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("admin_id"));
p.display(out);
%>