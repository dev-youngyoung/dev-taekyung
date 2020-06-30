<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String asse_no = u.request("asse_no");
String div_cd = u.request("div_cd");
if(asse_no.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject asseDao = new DataObject("tcb_assemaster");
DataSet asse = asseDao.find("main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"' and status = '20'");
if(!asse.next()){
	u.jsError("�򰡰�ȹ ������ �����ϴ�.");
	return;
}

DataObject detailDao = new DataObject("tcb_assedetail");
DataSet detail = detailDao.find(" asse_no = '"+asse_no+"' and div_cd = '"+div_cd+"'");
if(!detail.next()){
	u.jsError("�򰡻� ������ �����ϴ�.");
	return;
}

if(!detail.getString("status").equals("10")){
	u.jsError("�ۼ��� ���¿����� �� �Ϸ� ó�� ���� �մϴ�.");
	return;
}

String msg = "ó�� �Ϸ��Ͽ����ϴ�.";

DB db = new DB();

detailDao = new DataObject("tcb_assedetail");
detailDao.item("status","20");
detailDao.item("reg_date",u.getTimeString());
db.setCommand(detailDao.getUpdateQuery("asse_no = '"+asse_no+"' and div_cd = '"+div_cd+"' "), detailDao.record);

if(detailDao.findCount("asse_no = '"+asse_no+"' and status = '10'  and div_cd <> '"+div_cd+"' ")<1){
	asseDao.item("status","30");
	db.setCommand(asseDao.getUpdateQuery("main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"'"), asseDao.record);
	msg += "\\n\\n�򰡿Ϸ� �޴����� ��ȸ �����մϴ�.";
}

if(!db.executeArray()){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace(msg, "./asse_progress_list.jsp?"+u.getQueryString("asse_no"));
%>
