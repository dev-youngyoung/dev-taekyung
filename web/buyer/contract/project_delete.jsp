<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String id = u.request("id");
String mode = u.request("mode");

if(id.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

DataObject dao = new DataObject("tcb_order_field");

if(!dao.delete("member_no='"+_member_no+"' and field_seq="+id)){
	u.jsError("처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("삭제 되었습니다.", "./project_list.jsp?"+u.getQueryString("id"));

%>