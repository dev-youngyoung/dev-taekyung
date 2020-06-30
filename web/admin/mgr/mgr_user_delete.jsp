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

if(!mgrUserDao.delete(" admin_id = '"+admin_id+"' ")){
	u.jsError("삭제처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("삭제처리 하였습니다.", "mgr_user_list.jsp?"+u.getQueryString("admin_id"));
%>