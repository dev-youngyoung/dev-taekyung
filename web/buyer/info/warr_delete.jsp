<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String member_no = u.aseDec(u.request("member_no"));
String warr_seq = u.request("warr_seq");
if(member_no.equals("")||warr_seq.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

String where = " member_no = '"+member_no+"' and warr_seq = '"+warr_seq+"'";
DataObject warrDao = new DataObject("tcb_warr_add");
DataSet warr = warrDao.find(" member_no = '"+member_no+"' and warr_seq = '"+warr_seq+"' ");
if(!warr.next()){
	u.jsError("�߸��� �����Դϴ�.");
	return;
}

if(!Startup.conf.getString("file.path.bcompany").equals("") && !warr.getString("file_path").equals("") && !warr.getString("file_name").equals(""))
{
	System.out.println("DELETE FILE : " + Startup.conf.getString("file.path.bcompany")+warr.getString("file_path")+warr.getString("file_name"));
	u.delFile(Startup.conf.getString("file.path.bcompany")+warr.getString("file_path")+warr.getString("file_name"));
}

if(!warrDao.delete(" member_no = '"+member_no+"' and warr_seq = '"+warr_seq+"' ")){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}

out.print("<script>");
out.print("alert(\"ó�� �Ͽ����ϴ�.\");");
out.print("opener.location.reload();");
out.print("self.close();");
out.print("</script>");
return;
%>