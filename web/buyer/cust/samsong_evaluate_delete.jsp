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
	u.jsError("�ۼ��� ���¿����� ���� ���� �մϴ�.");
	return;
}

DataObject bidDao = new DataObject("tcb_bid_master");
if(bidDao.findCount("main_member_no = '20121203450' and yyyymm='"+yyyymm+"'")>0){
	u.jsError("�ش������� ������� �������� �ֽ��ϴ�.");
	 return;
	
}

DB db = new DB();
db.setCommand("delete from tcb_samsong_evaluate_supp where yyyymm='"+yyyymm+"' ", null);
db.setCommand("delete from tcb_samsong_evaluate where yyyymm='"+yyyymm+"' ", null);
if(!db.executeArray()){
	u.jsError("���� ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("����ó�� �Ͽ����ϴ�.", "./samsong_evaluate_list.jsp?"+u.getQueryString("yyyymm,mode"));



%>