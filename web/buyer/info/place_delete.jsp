<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String id = u.request("id");
if(id.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}


DataObject dao = new DataObject("tcb_field");
dao.item("status","-1");
if(!dao.update("member_no="+_member_no+" and field_seq="+id)){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("���� �Ǿ����ϴ�.", "./place_list.jsp?"+u.getQueryString("id"));

%>