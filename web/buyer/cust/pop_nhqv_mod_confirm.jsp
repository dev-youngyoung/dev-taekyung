<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String noti_seq = u.request("noti_seq");
String client_no = u.request("client_no");
if(noti_seq.equals("")||client_no.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject notiDao = new DataObject("tcb_recruit_noti");
DataSet noti = notiDao.find("member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"' ");
if(!noti.next()){
	u.jsError("���� ������ �����ϴ�.");
	return;
}


DataObject custDao = new DataObject("tcb_recruit_cust");
DataSet cust = custDao.find(" member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"'  and client_no = '"+client_no+"' ");
if(!cust.next()){
	u.jsError("��û������ �����ϴ�.");
	return;
}

if(!cust.getString("status").equals("31")){
	u.jsError("������û ���¿����� ����Ȯ�� ó�� ���� �մϴ�.");
	return;
}

custDao = new DataObject("tcb_recruit_cust");
custDao.item("mod_req_date", "");
custDao.item("mod_req_id", "");
custDao.item("mod_req_reason", "");
custDao.item("status", "20");
if(!custDao.update(" member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"'  and client_no = '"+client_no+"' ")){
	u.jsError("����Ȯ�� ó���� ���� �Ͽ����ϴ�.");
	return;
}

out.println("<script>");
out.println("alert('����Ȯ�� ó�� �Ͽ����ϴ�.');");
out.println("opener.location.reload();");
out.println("self.close();");
out.println("</script>");

return;

%>