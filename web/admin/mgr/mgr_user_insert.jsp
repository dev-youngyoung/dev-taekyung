<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
f.addElement("admin_id", null,"hname:'관리자아이디', required:'Y'");
f.addElement("admin_name", null,"hname:'관리자명' , required:'Y'");
f.addElement("passwd", null,"hname:'비밀번호' , required:'Y',option:'userpw', match:'passwd2'");
f.addElement("admin_ip", null, "hname:'관리자IP' ");
f.addElement("auth_cd", null,"hname:'권한코드' , required:'Y'");

DataObject authDao = new DataObject("tcc_auth");
DataSet authInfo = authDao.find("status = '10' ","*","auth_nm asc");

// 입력수정
if(u.isPost() && f.validate()){

	DB db = new DB();
	DataObject mgrUserDao = new DataObject("tcc_admin");
	mgrUserDao.item("admin_id", f.get("admin_id"));
	mgrUserDao.item("admin_name", f.get("admin_name"));
	mgrUserDao.item("passwd", u.sha256(f.get("passwd")));
	mgrUserDao.item("reg_date", u.getTimeString());
	mgrUserDao.item("reg_id", auth.getString("_ADMIN_ID"));
	mgrUserDao.item("admin_ip", f.get("admin_ip"));
	mgrUserDao.item("auth_cd", f.get("auth_cd"));
	
	db.setCommand(mgrUserDao.getInsertQuery(), mgrUserDao.record);

	if(!db.executeArray()){
		u.jsError("처리중 오류가 발생 하였습니다");
		return;
	}
	
	u.jsAlertReplace("저장처리 하였습니다.","mgr_user_list.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
p.setDebug(out);
p.setBody("mgr.mgr_user_modify");
p.setLoop("authInfo", authInfo);
p.setVar("menu_cd","000024");
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString());
p.display(out);
%>