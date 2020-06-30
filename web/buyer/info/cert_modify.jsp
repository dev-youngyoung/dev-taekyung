<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cert_dn = u.request("cert_dn");
String cert_end_date = u.request("cert_end_date");
String sign_data = u.request("sign_data");
if(cert_dn.equals("")||cert_end_date.equals("")||sign_data.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}


Crosscert crosscert = new Crosscert();
crosscert.setEncoding("UTF-8");
if (crosscert.chkSignVerify(sign_data).equals("SIGN_ERROR")){
	u.jsError("��������� ���� �Ͽ����ϴ�.");
	return;
}
if(!crosscert.getDn().equals(cert_dn)){
	u.jsError("������� DN���� ���� ���� �ʽ��ϴ�.");
	return;
}

DataObject member = new DataObject("tcb_member");
member.item("cert_dn",cert_dn);
member.item("cert_end_date", cert_end_date);
if(!member.update("member_no = '"+_member_no+"' ")){
	u.jsError("���忡 ���� �Ͽ����ϴ�.");
	return;
}

auth.put("_CERT_DN",cert_dn);
auth.put("_CERT_END_DATE", u.getTimeString("yyyyMMdd",cert_end_date));
auth.setAuthInfo();
u.jsAlertReplace("�������� ��� �Ͽ����ϴ�.", "cert_info.jsp");
	
%>