<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String admin_id = u.request("admin_id");
if(admin_id.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject mgrUserDao = new DataObject("tcc_admin");
DataSet mgr_user = mgrUserDao.find("admin_id = '"+admin_id+"' ");
if(!mgr_user.next()){
	u.jsError("������ ������ �����ϴ�.");
	return;
}

if(!mgrUserDao.delete(" admin_id = '"+admin_id+"' ")){
	u.jsError("����ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("����ó�� �Ͽ����ϴ�.", "mgr_user_list.jsp?"+u.getQueryString("admin_id"));
%>