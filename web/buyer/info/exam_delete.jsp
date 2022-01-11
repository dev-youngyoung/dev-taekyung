<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String exam_cd = u.request("exam_cd");
if(exam_cd.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " member_no = '"+_member_no+"' and exam_cd = '"+exam_cd+"' ";


// 진행중인 평가 계획이 있다면 삭제 불가

DB db = new DB();
//db.setDebug(out);
db.setCommand("delete from tcb_exam_item where "+where ,null);
db.setCommand("delete from tcb_exam_question where "+where ,null);
db.setCommand("delete from tcb_exam where "+ where ,null);
if(!db.executeArray()){
	u.jsError("삭제 처리에 실패 하였습니다.");
	return;
}
u.jsAlertReplace("삭제 하였습니다.","exam_list.jsp?"+u.getQueryString("exam_cd"));
%>
