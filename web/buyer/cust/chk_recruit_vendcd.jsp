<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
String member_no = u.request("member_no");
String seq = u.request("seq");
String vendcd = u.request("vendcd");
if(member_no.equals("")||seq.equals("")||vendcd.equals("")){
	return;
}

DataObject recruitDao = new DataObject("tcb_recruit");
DataSet recruit = recruitDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' ");
if(!recruit.next()){
	u.jsAlert("�������� ��η� �����ϼ���.");
	return;
}

DataObject suppDao = new DataObject("tcb_recruit_supp");
DataSet supp = suppDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' and vendcd = '"+vendcd+"'  ");
if(supp.next()){
	out.println("<script>");
	out.println("alert('�̹� ��ϵ� ����� ��� ��ȣ �Դϴ�.\\n\\n ����Ȯ���� ��û���� ���� �����մϴ�.');");
	out.println("showPasswd();");
	out.println("</script>");
	return;
}
out.println("<script>");
out.println("document.forms['form1']['chk_vendcd'].value='1';");
out.println("alert('��û ������ ����ڵ�� ��ȣ�Դϴ�.\\n\\n��û������ �ۼ��ϼ���.');");
out.println("setWrite();");
out.println("</script>");
%>