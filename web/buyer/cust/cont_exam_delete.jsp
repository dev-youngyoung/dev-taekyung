<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String result_seq = u.request("result_seq");
if(result_seq.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

String where = " member_no = '"+_member_no+"' and result_seq = '"+result_seq+"' ";
DataObject resultDao = new DataObject("tcb_exam_result");
DataSet result = resultDao.find(where);
if(!result.next()){
	u.jsError("�� ������ �����ϴ�.");
	return;
}

if(!result.getString("status").equals("10")){
	u.jsError("���� ���¿����� ����� �� �� �ֽ��ϴ�.");
	return;
}

DB db = new DB();
//db.setDebug(out);
db.setCommand(" delete from tcb_exam_result_grade where "+where,null);
db.setCommand(" delete from tcb_exam_result_item where "+where,null);
db.setCommand(" delete from tcb_exam_result_question where "+where,null);
db.setCommand(" delete from tcb_exam_result where "+where,null);
if(!db.executeArray()){
	u.jsError("����ҿ� ���� �Ͽ����ϴ�.");
	return;
}
u.jsAlertReplace("�� ��� �Ͽ����ϴ�.","cont_exam_list.jsp?"+u.getQueryString("cont_no, cont_chasu, result_seq"));
%>