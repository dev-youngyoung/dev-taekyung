<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String main_member_no = u.request("main_member_no");
String bid_no = u.request("bid_no");
String bid_deg = u.request("bid_deg");
String member_no = u.request("member_no");
if(main_member_no.equals("")||bid_no.equals("")||bid_deg.equals("")||member_no.equals("")){
	u.jsErrClose("�������� ��� �����ϼ���.");
	return;
}

String where = "main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"'";
DataObject bidDao = new DataObject("tcb_bid_master");
//bidDao.setDebug(out);
DataSet bid = bidDao.find(where);
if(!bid.next()){
	u.jsError("���������� �����ϴ�.");
	return;
}

DataObject suppSubDao = new DataObject("tcb_bid_supp");
DataSet suppSubDs = suppSubDao.find(where+" and member_no='"+member_no+"' and pay_yn='Y' ");
if(suppSubDs.next()) {
	u.jsError("�̹� ������ ��ü�Դϴ�. ���������� ������ �ּ���.");
	return;
}

DB db = new DB();
DataObject suppDao = new DataObject("tcb_bid_supp");
suppDao.item("pay_yn", "Y");
db.setCommand(suppDao.getUpdateQuery(where+" and member_no='"+member_no+"' "), suppDao.record);
if(!db.executeArray()){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("���� ����ó�� �Ǿ����ϴ�.", "./pop_bid_supp.jsp?"+u.getQueryString());
%>