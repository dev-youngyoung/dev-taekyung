<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String warr_seq = u.request("warr_seq");
if(cont_no.equals("")||cont_chasu.equals("")||warr_seq.equals("")){
	u.jsErrClose("�������� ��η� ������ �ּ���.");
	return;
}

ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cont.next()){
	u.jsError("��������� �������� �ʽ��ϴ�.");
	return;
}

DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and warr_seq = '"+warr_seq+"' ");
if(!warr.next()){
	u.jsError("���Ŵ�� ���� ������ �����ϴ�.");
	return;
}

String new_warr_seq = warrDao.getOne("select nvl(max(warr_seq),0)+1 from tcb_warr where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
warrDao = new DataObject("tcb_warr");
warrDao.item("cont_no", cont_no);
warrDao.item("cont_chasu", cont_chasu);
warrDao.item("member_no", "");
warrDao.item("warr_seq", new_warr_seq);
warrDao.item("warr_type", warr.getString("warr_type"));
warrDao.item("etc", warr.getString("etc"));
if(!warrDao.insert()){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}
u.jsAlertReplace("���ŵ� ���������� �Է� �� ���� �ϼ���.", "pop_warr_modify.jsp?"+u.getQueryString("warr_seq")+"&warr_seq="+new_warr_seq);

%>