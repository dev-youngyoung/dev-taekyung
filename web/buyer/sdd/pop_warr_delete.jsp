<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String warr_seq = u.request("warr_seq");
if(cont_no.equals("")||cont_chasu.equals("")||warr_seq.equals("")){
	u.jsErrClose("�������� ��η� ������ �ּ���.");
	return;
}
DataObject warrDao = new DataObject("tcb_warr");

warrDao.item("warr_office", "");
warrDao.item("warr_no", "");
warrDao.item("warr_sdate", ""); 	
warrDao.item("warr_edate", ""); 	
warrDao.item("warr_amt", ""); 	
warrDao.item("warr_date", "");
warrDao.item("doc_name", "");
warrDao.item("file_path", "");
warrDao.item("file_name", "");
warrDao.item("file_ext", "");
warrDao.item("file_size", "");
warrDao.item("reg_date", u.getTimeString());
warrDao.item("reg_id", "");
	
if(!warrDao.update(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and warr_seq = '"+warr_seq+"' ")){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}
out.print("<script>");
out.print("alert(\"�����Ͽ����ϴ�.\");");
out.print("opener.location.reload();");
out.print("self.close();");
out.print("</script>");
return;



%>