<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String asse_no = u.request("asse_no", "");
String div_cd = u.request("div_cd");  // �򰡺μ� �ڵ� : S ������, Q:QC��, E: ENC
String mode = u.request("mode", "00"); // 00 : ��������, 10 : ���� ����
String mstatus = u.request("mstatus");
String ret = u.request("ret");


if(asse_no.equals("") || mode.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}
	
DB db = new DB();

if(mode.equals("00"))  // ��������
{
	db.setCommand("delete from tcb_assedetail where asse_no = '"+asse_no+"'", null);
	db.setCommand("delete from tcb_assemaster where asse_no = '"+asse_no+"'", null);
}
else if(mode.equals("10"))  
{
	if(mstatus.equals("20")) // ���� -> �� ��� ��� : �ش� ��� ��� ���� 
	{
		db.setCommand("delete from tcb_assedetail where asse_no = '"+asse_no+"'", null);
		db.setCommand("update tcb_assemaster set status='10' where asse_no = '"+asse_no+"'", null);
	}
	else if(mstatus.equals("50")) // �򰡿Ϸ� -> ����
	{
		db.setCommand("update tcb_assedetail set status='20' where asse_no = '"+asse_no+"' and div_cd='"+div_cd+"'", null);
		db.setCommand("update tcb_assemaster set status='20' where asse_no = '"+asse_no+"'", null);
	}
}

if(!db.executeArray()){
	u.jsError("ó���� ������ �߻� �Ͽ����ϴ�.");
	return;
}

if(mode.equals("00"))  // ��������
	u.jsAlertReplace("���� �Ͽ����ϴ�.","assessment_list.jsp?"+u.getQueryString());
else if(mode.equals("10"))  // ���º���
	u.jsAlertReplace("���� ���·� ���� �Ͽ����ϴ�.", ret + "?"+u.getQueryString());

%>