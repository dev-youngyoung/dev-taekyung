<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String seq = u.request("seq");
if(cont_no.equals("")||cont_chasu.equals("")||seq.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject shareDao = new DataObject("tcb_share");
DataSet share = shareDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and seq = '"+seq+"' ");
if(!share.next()){
	u.jsError("���� ������ �����ϴ�.");
	return;
}

if(!share.getString("status").equals("10")){
	u.jsError("���� ������ ���°� �ƴմϴ�.");
	return;
}

shareDao.item("status","-1");
if(!shareDao.update("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and seq = '"+seq+"' ")){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("����ó�� �Ͽ����ϴ�.", "ifm_cont_share.jsp?"+u.getQueryString("seq"));

%>