<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String exam_cd = u.request("exam_cd");
if(exam_cd.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

String where = " member_no = '"+_member_no+"' and exam_cd = '"+exam_cd+"' ";


// �������� �� ��ȹ�� �ִٸ� ���� �Ұ�

DB db = new DB();
//db.setDebug(out);
db.setCommand("delete from tcb_exam_item where "+where ,null);
db.setCommand("delete from tcb_exam_question where "+where ,null);
db.setCommand("delete from tcb_exam where "+ where ,null);
if(!db.executeArray()){
	u.jsError("���� ó���� ���� �Ͽ����ϴ�.");
	return;
}
u.jsAlertReplace("���� �Ͽ����ϴ�.","exam_list.jsp?"+u.getQueryString("exam_cd"));
%>
