<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String person_seq = u.request("person_seq");
if(member_no.equals("")||person_seq.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

DataObject dao = new DataObject("tcb_person");

dao.item("passwd", u.sha256("a"+u.getTimeString("yyyyMMdd")+"?"));
if(!dao.update("member_no = '"+member_no+"' and person_seq = '"+person_seq+"'")){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("��й�ȣ�� �ʱ�ȭ �Ǿ����ϴ�.", "./person_view.jsp?"+u.getQueryString("person_seq"));
%>