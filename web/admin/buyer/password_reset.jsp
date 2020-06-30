<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String person_seq = u.request("person_seq");
if(member_no.equals("")||person_seq.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

DataObject dao = new DataObject("tcb_person");

dao.item("passwd", u.sha256("a"+u.getTimeString("yyyyMMdd")+"?"));
if(!dao.update("member_no = '"+member_no+"' and person_seq = '"+person_seq+"'")){
	u.jsError("처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("비밀번호가 초기화 되었습니다.", "./person_view.jsp?"+u.getQueryString("person_seq"));
%>