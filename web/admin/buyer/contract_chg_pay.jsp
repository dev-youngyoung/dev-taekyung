<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String member_no = u.request("member_no");
if(cont_no.equals("")||cont_chasu.equals("")||member_no.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
ContractDao contDao = new ContractDao("tcb_contmaster");
DataSet cont = contDao.find(where);
if(!cont.next()){
	u.jsError("������ ���� ���� �ʽ��ϴ�.");
	return;
}

DB db = new DB();


DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(where + " and member_no = '"+member_no+"' " );
if(!cust.next()){
	u.jsError("����ó�� ��� ��ü�� �����ϴ�.");
	return;
}
custDao.item("pay_yn","Y");
db.setCommand(custDao.getUpdateQuery(where+" and member_no = '"+member_no+"' "), custDao.record);
	



if(!db.executeArray()){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}
u.jsAlertReplace("ó�� �Ͽ����ϴ�.","contract_list.jsp?"+u.getQueryString("cont_no,cont_chasu,member_no"));
return;
%>