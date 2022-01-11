<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String project_seq = u.request("project_seq");
if(project_seq.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

//입찰에 사용된 건 확인
DataObject bidDao = new DataObject("tcb_bid_master");
if(bidDao.findCount("main_member_no = '"+_member_no+"' and project_seq = '"+project_seq+"' ")>0){
	u.jsError("해당 프로젝트로 진행된 입찰 건이 있습니다.\\n\\n삭제 할 수 없습니다.");
	return;
}

//계약에 사용된 건 확인
DataObject contDao = new DataObject("tcb_contmaster");
if(contDao.findCount("member_no = '"+_member_no+"' and project_seq = '"+project_seq+"' ")>0){
	u.jsError("해당 프로젝트로 진행된 계약 건이 있습니다.\\n\\n삭제 할 수 없습니다.");
	return;
}



DataObject projectDao = new DataObject("tcb_project");
if(!projectDao.delete("member_no = '"+_member_no+"' and project_seq = '"+project_seq+"' ")){
	u.jsError("삭제처리에 실패 하였습니다.");
	return;
}


u.jsAlertReplace("삭제 되었습니다.", "./project_list.jsp?"+u.getQueryString("project_seq"));
%>