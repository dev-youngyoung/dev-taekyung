<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String qnaseq = u.request("qnaseq");
if(qnaseq.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject qnaDao = new DataObject("tcb_qna");
DataSet qna = qnaDao.find("qnaseq = '"+qnaseq+"' ");
if(!qna.next()){
	u.jsError("�ý��۱��๮�� ������ �����ϴ�.");
	return;
}

if(!qnaDao.delete(" qnaseq = '"+qnaseq+"' ")){
	u.jsError("����ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("����ó�� �Ͽ����ϴ�.", "si_qna_list.jsp?"+u.getQueryString("qnaseq"));
%>