<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String auth_cd = u.request("auth_cd");

if(auth_cd.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

DB db = new DB();

DataObject authDao = new DataObject("tcc_auth");

authDao.item("status", "1"); // 삭제시 STATS = 1
db.setCommand(authDao.getUpdateQuery("auth_cd= '"+auth_cd+"'"), authDao.record);

if(!db.executeArray()){
	u.jsError("처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("삭제 되었습니다.", "./auth_list.jsp?"+u.getQueryString("auth_cd"));

%>