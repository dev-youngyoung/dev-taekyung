<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");

if(member_no.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

String where = " member_no = '"+member_no+"'";

DataObject memberDao = new DataObject("tcb_member");
DataObject personDao = new DataObject("tcb_person");
DataObject memberBossDao = new DataObject("tcb_member_boss");
DataObject fieldDao = new DataObject("tcb_field");
DataObject fieldPersonDao = new DataObject("tcb_fieldperson");
DataObject clientDao = new DataObject("tcb_client");
DataObject clientDetailDao = new DataObject("tcb_client_detail");

DataSet clientDs = clientDao.find(" client_no = '"+member_no+"'");

String org_member_no = "";
String client_seq = "";
if(clientDs.next())
{
	org_member_no = clientDs.getString("member_no");
	client_seq = clientDs.getString("client_seq");
}

//u.p("org_member_no : " + org_member_no);
//u.p("client_seq : " + client_seq);

DB db = new DB();

db.setCommand(fieldDao.getDeleteQuery(where),null);
db.setCommand(fieldPersonDao.getDeleteQuery(where),null);
db.setCommand(personDao.getDeleteQuery(where),null);
db.setCommand(memberBossDao.getDeleteQuery(where),null);
if(!org_member_no.equals("") && !client_seq.equals(""))
	db.setCommand(clientDetailDao.getDeleteQuery(" member_no = '"+org_member_no+"' and client_seq = " + client_seq),null);
db.setCommand(clientDao.getDeleteQuery(" client_no = '"+member_no+"'"),null);
db.setCommand(memberDao.getDeleteQuery(where),null);

if(!db.executeArray()){
	u.jsError("����ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("���� ó�� �Ͽ����ϴ�.","member_list.jsp?"+u.getQueryString("member_no"));

return;

%>