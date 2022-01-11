<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String result_seq = u.request("result_seq");
if(result_seq.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

String where = " member_no = '"+_member_no+"' and result_seq = '"+result_seq+"' ";
DataObject resultDao = new DataObject("tcb_exam_result");
DataSet result = resultDao.find(where);
if(!result.next()){
	u.jsError("평가 정보가 없습니다.");
	return;
}

if(!result.getString("status").equals("10")){
	u.jsError("평가중 상태에서만 평가취소 할 수 있습니다.");
	return;
}

DB db = new DB();
//db.setDebug(out);
db.setCommand(" delete from tcb_exam_result_grade where "+where,null);
db.setCommand(" delete from tcb_exam_result_item where "+where,null);
db.setCommand(" delete from tcb_exam_result_question where "+where,null);
db.setCommand(" delete from tcb_exam_result where "+where,null);
if(!db.executeArray()){
	u.jsError("평가취소에 실패 하였습니다.");
	return;
}
u.jsAlertReplace("평가 취소 하였습니다.","cont_exam_list.jsp?"+u.getQueryString("cont_no, cont_chasu, result_seq"));
%>