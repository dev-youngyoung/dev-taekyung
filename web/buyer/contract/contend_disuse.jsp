<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

String where = "cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";

DataObject contDao = new DataObject("tcb_contmaster");
contDao.setDebug(out);
DataSet cont  = contDao.find(where+" and member_no= '"+_member_no+"' ");
if(!cont.next()){
	//u.jsError(" ��������� ���� ���� �ʽ��ϴ�.");
	return;
}

if(!cont.getString("status").equals("50")){
	u.jsError("���Ϸ� ���¿����� ��� ó�� ���� �մϴ�.");
	return;
}


DB db = new DB();
contDao.item("status","99");
contDao.item("mod_req_date",u.getTimeString());
db.setCommand(contDao.getUpdateQuery(where), contDao.record);

/* ���α� START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "���ڹ��� ���",  "", "92","10");
/* ���α� END*/

if(!db.executeArray()){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}
String callback = "contend_sendview.jsp";
if(!cont.getString("sign_types").equals("")){
	callback = "contend_msign_sendview.jsp";
}

u.jsAlertReplace("��༭ ���ó�� �Ͽ����ϴ�.", "./"+callback+"?"+u.getQueryString());

%>