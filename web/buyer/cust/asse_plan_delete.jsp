<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String asse_no = u.request("asse_no");
if(asse_no.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

DataObject asseDao = new DataObject("tcb_assemaster");
DataSet asse = asseDao.find("main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"' and status = '10'");
if(!asse.next()){
	u.jsError("�򰡰�ȹ ������ �����ϴ�.");
	return;
}
	
DB db = new DB();
db.setCommand("delete from tcb_assedetail where asse_no = '"+asse_no+"'", null);
db.setCommand("delete from tcb_assemaster where main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"'", null);

if(!db.executeArray()){
	u.jsError("ó���� ������ �߻� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("���� �Ͽ����ϴ�.","asse_plan_list.jsp?"+u.getQueryString("asse_no"));

%>