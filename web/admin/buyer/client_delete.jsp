<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String main_member_no = u.request("main_member_no");
String client_seq = u.request("client_seq");
if(main_member_no.equals("")&&client_seq.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject clientDao = new DataObject("tcb_client");
DataSet client = clientDao.find("member_no = '"+main_member_no+"' and client_seq = '"+client_seq+"' ");
if(!client.next()){
	u.jsError("삭제 대상 데이터가 존재 하지 않습니다.");
	return;
}
if(!clientDao.delete("member_no = '"+main_member_no+"' and client_seq = '"+client_seq+"'")){
	u.jsError("삭제 처리에 실패 하였습니다.");
	return;
}
u.jsAlertReplace("삭제 처리 하였습니다.", "client_view.jsp?"+u.getQueryString("main_member_no,client_seq"));
%>