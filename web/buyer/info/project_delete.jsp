<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String project_seq = u.request("project_seq");
if(project_seq.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

//������ ���� �� Ȯ��
DataObject bidDao = new DataObject("tcb_bid_master");
if(bidDao.findCount("main_member_no = '"+_member_no+"' and project_seq = '"+project_seq+"' ")>0){
	u.jsError("�ش� ������Ʈ�� ����� ���� ���� �ֽ��ϴ�.\\n\\n���� �� �� �����ϴ�.");
	return;
}

//��࿡ ���� �� Ȯ��
DataObject contDao = new DataObject("tcb_contmaster");
if(contDao.findCount("member_no = '"+_member_no+"' and project_seq = '"+project_seq+"' ")>0){
	u.jsError("�ش� ������Ʈ�� ����� ��� ���� �ֽ��ϴ�.\\n\\n���� �� �� �����ϴ�.");
	return;
}



DataObject projectDao = new DataObject("tcb_project");
if(!projectDao.delete("member_no = '"+_member_no+"' and project_seq = '"+project_seq+"' ")){
	u.jsError("����ó���� ���� �Ͽ����ϴ�.");
	return;
}


u.jsAlertReplace("���� �Ǿ����ϴ�.", "./project_list.jsp?"+u.getQueryString("project_seq"));
%>