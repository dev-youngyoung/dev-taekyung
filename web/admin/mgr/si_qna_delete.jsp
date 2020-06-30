<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String qnaseq = u.request("qnaseq");
if(qnaseq.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject qnaDao = new DataObject("tcb_qna");
DataSet qna = qnaDao.find("qnaseq = '"+qnaseq+"' ");
if(!qna.next()){
	u.jsError("시스템구축문의 정보가 없습니다.");
	return;
}

if(!qnaDao.delete(" qnaseq = '"+qnaseq+"' ")){
	u.jsError("삭제처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("삭제처리 하였습니다.", "si_qna_list.jsp?"+u.getQueryString("qnaseq"));
%>