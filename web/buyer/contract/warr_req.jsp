<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
CodeDao code = new CodeDao("tcb_comcode");
String[] code_warr_type = code.getCodeArray("M007");
 
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String warr_seq = u.request("warr_seq");
if(cont_no.equals("")||cont_chasu.equals("")||warr_seq.equals("")){
	//u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

ContractDao contDao = new ContractDao();
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cont.next()){
	u.jsError("��������� �����ϴ�.");
	return;
} 

DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and warr_seq = '"+warr_seq+"' ");
if(!warr.next()){
	u.jsError("���������� �����ϴ�.");
	return;
}

if(!warr.getString("status").equals("")){
	u.jsError("������û������ ���°� �ƴմϴ�.");
	return;
}

warrDao.item("status", "10");
if(!warrDao.update("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and warr_seq = '"+warr_seq+"' ")){
	u.jsError("��û�� ���� �Ͽ����ϴ�.");
	return;
}

DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");


String warr_name = u.getItem(warr.getString("warr_type"),code_warr_type);
SmsDao smsDao= new SmsDao();
String sender_name = auth.getString("_MEMBER_NAME");
while(cust.next()){
	if(!cust.getString("member_no").equals(_member_no)){
		// sms ����
		smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), auth.getString("_MEMBER_NAME")+" ���� ���ڰ�� "+warr_name+" ������û- ���̽���ť(�Ϲݱ����)");
	}
}
u.jsAlertReplace("������û �Ͽ����ϴ�.","contend_warr_list.jsp?"+u.getQueryString("cont_no,cont_chasu,warr_seq"));
%>