<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String person_seq = u.request("person_seq");
String callback= u.request("callback");
if(person_seq.equals("")){
	u.jsError("�������� ��η� ���� �Ͽ� �ּ���.");
	return;
}

DataObject dao = new DataObject("tcb_person");
dao.item("reg_date", u.getTimeString());
dao.item("reg_id", auth.getString("_USER_ID"));
dao.item("status","-1");
if(!dao.update(" member_no = '"+_member_no+"' and person_seq = '"+person_seq+"' ")){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}
u.jsAlertReplace("����ó�� �Ͽ����ϴ�.",callback+"?"+u.getQueryString("person_seq"));
return;
%>