<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String main_member_no = u.request("main_member_no");
String client_seq = u.request("client_seq");
if(main_member_no.equals("")&&client_seq.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject clientDao = new DataObject("tcb_client");
DataSet client = clientDao.find("member_no = '"+main_member_no+"' and client_seq = '"+client_seq+"' ");
if(!client.next()){
	u.jsError("���� ��� �����Ͱ� ���� ���� �ʽ��ϴ�.");
	return;
}
if(!clientDao.delete("member_no = '"+main_member_no+"' and client_seq = '"+client_seq+"'")){
	u.jsError("���� ó���� ���� �Ͽ����ϴ�.");
	return;
}
u.jsAlertReplace("���� ó�� �Ͽ����ϴ�.", "client_view.jsp?"+u.getQueryString("main_member_no,client_seq"));
%>