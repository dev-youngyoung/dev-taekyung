<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsError("��ü������ �����ϴ�.");
	return;
}

DataObject useInfoDao = new DataObject("tcb_useinfo");
DataSet useInfo = useInfoDao.find("member_no = '"+member_no+"' ");
if(!useInfo.next()){
	u.jsError("�̿������� �����ϴ�.");
	return;
}

if(!useInfoDao.delete(" member_no = '"+member_no+"' ")){
	u.jsError("����ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("����ó�� �Ͽ����ϴ�.", "pay_comp_list.jsp?"+u.getQueryString("member_no"));
%>