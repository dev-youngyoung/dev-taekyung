<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String id = u.request("id");
String mode = u.request("mode");

if(id.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

DataObject dao = new DataObject("tcb_board");

if(!dao.delete("category='faq' and board_id="+id)){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("���� �Ǿ����ϴ�.", "./faq_list.jsp?"+u.getQueryString("id"));

%>