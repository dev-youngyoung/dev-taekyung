<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String auth_cd = u.request("auth_cd");

if(auth_cd.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

DB db = new DB();

DataObject authDao = new DataObject("tcc_auth");

authDao.item("status", "1"); // ������ STATS = 1
db.setCommand(authDao.getUpdateQuery("auth_cd= '"+auth_cd+"'"), authDao.record);

if(!db.executeArray()){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("���� �Ǿ����ϴ�.", "./auth_list.jsp?"+u.getQueryString("auth_cd"));

%>