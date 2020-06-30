<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String batch_seq = u.request("batch_seq");

if(batch_seq.equals("") || member_no.equals("") ){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

DB db = new DB();

DataObject batchTemplateDao = new DataObject("tcb_batch_url");

batchTemplateDao.item("status", "-1"); // 삭제시 STATS = 1
db.setCommand(batchTemplateDao.getUpdateQuery("member_no = '"+member_no+"' and batch_seq = "+batch_seq), batchTemplateDao.record);

if(!db.executeArray()){
	u.jsError("처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("삭제 되었습니다.", "./batch_url_list.jsp?");

%>