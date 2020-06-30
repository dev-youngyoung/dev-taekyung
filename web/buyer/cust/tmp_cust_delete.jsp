<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("정상적인 경로로 접근하여 주세요.");
	return;
}

DataObject clientDao = new DataObject("tcb_client");

if(!clientDao.delete(" member_no = '"+_member_no+"' and client_no = '"+member_no+"' ")){
	u.jsError("가등록업체 삭제에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("가등록 업체를 삭제 하였습니다.", "./tmp_cust_list_type.jsp");
return;
%>