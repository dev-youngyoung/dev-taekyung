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

f.addElement("mod_req_reason", null, "hname:'����', required:'Y'");

if(u.isPost()&&f.validate()){
	custDao = new DataObject("tcb_recruit_cust");
	custDao.item("mod_req_date", u.getTimeString());
	custDao.item("mod_req_id", auth.getString("_USER_ID"));
	custDao.item("mod_req_reason", f.get("mod_req_reason"));
	custDao.item("status", "30");
	if(!custDao.update(" member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"'  and client_no = '"+client_no+"' ")){
		u.jsError("������û ó���� ���� �Ͽ����ϴ�.");
		return;
	}
	
	SmsDao smsDao= new SmsDao();
	smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), "NH�������ǿ��� ��Ͼ�ü��û�� ������ ���� ��û �Ͽ����ϴ�.-���̽���ť");
	
	out.println("<script>");
	out.println("alert('������û ó�� �Ͽ����ϴ�.');");
	out.println("opener.opener.location.reload();");
	out.println("opener.location.reload();");
	out.println("self.close();");
	out.println("</script>");
	
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("cust.pop_nhqv_mod_req");
p.setVar("popup_title", "������û");
p.setVar("noti", noti);
p.setVar("cust", cust);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>