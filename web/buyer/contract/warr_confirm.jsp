<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String warr_seq = u.request("warr_seq");
if(cont_no.equals("")||cont_chasu.equals("")||warr_seq.equals("")){
	//u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

ContractDao contDao = new ContractDao();
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cont.next()){
	u.jsError("��������� �����ϴ�.");
	return;
} 

DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and warr_seq = '"+warr_seq+"' ");
if(!warr.next()){
	u.jsError("���������� �����ϴ�.");
	return;
}

if(!warr.getString("status").equals("20")){
	u.jsError("����Ȯ��ó�� ������ ���°� �ƴմϴ�.");
	return;
}

warrDao.item("status", "30");
if(!warrDao.update("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and warr_seq = '"+warr_seq+"' ")){
	u.jsError("Ȯ��ó���� ���� �Ͽ����ϴ�.");
	return;
}
out.print("<script>alert('Ȯ��ó�� �Ͽ����ϴ�.');opener.location.reload();self.close();</script>");

%>