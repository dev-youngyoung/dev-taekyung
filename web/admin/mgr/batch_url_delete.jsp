<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String batch_seq = u.request("batch_seq");

if(batch_seq.equals("") || member_no.equals("") ){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

DB db = new DB();

DataObject batchTemplateDao = new DataObject("tcb_batch_url");

batchTemplateDao.item("status", "-1"); // ������ STATS = 1
db.setCommand(batchTemplateDao.getUpdateQuery("member_no = '"+member_no+"' and batch_seq = "+batch_seq), batchTemplateDao.record);

if(!db.executeArray()){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("���� �Ǿ����ϴ�.", "./batch_url_list.jsp?");

%>