<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String id = u.request("id");
String mode = u.request("mode");

if(id.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

DataObject dao = new DataObject("tcb_board");

if(!dao.delete("category='faq' and board_id="+id)){
	u.jsError("처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("삭제 되었습니다.", "./faq_list.jsp?"+u.getQueryString("id"));

%>