<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ּ���.");
	return;
}

DataObject clientDao = new DataObject("tcb_client");

if(!clientDao.delete(" member_no = '"+_member_no+"' and client_no = '"+member_no+"' ")){
	u.jsError("����Ͼ�ü ������ ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("����� ��ü�� ���� �Ͽ����ϴ�.", "./tmp_cust_list_type.jsp");
return;
%>