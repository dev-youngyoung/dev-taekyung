<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="java.net.URLDecoder" %>
<%
String yyyymm = u.request("yyyymm");

DataObject evaluateDao = new DataObject("tcb_samsong_evaluate");
DataSet evaluate = evaluateDao.find("yyyymm = '"+yyyymm+"' ");
if(!evaluate.next()){
	u.jsError("���� ��� ���� �����ϴ�.");
	return;
}

if(evaluate.getString("status").equals("status")){
	u.jsError("�ۼ��� ���¿����� Ȯ�� ���� �մϴ�.");
	return;
}


DB db = new DB();

evaluateDao.item("status","20");
evaluateDao.item("mod_date", u.getTimeString());
evaluateDao.item("mod_id", auth.getString("_USER_ID"));
evaluateDao.item("status", "20");


if(!evaluateDao.update("yyyymm='"+yyyymm+"'")){
	u.jsError("Ȯ�� ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("Ȯ��ó�� �Ͽ����ϴ�.", "./samsong_evaluate_view.jsp?"+u.getQueryString());



%>