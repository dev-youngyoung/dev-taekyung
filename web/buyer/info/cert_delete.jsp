<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String member_no = u.aseDec(u.request("member_no"));
String cert_seq = u.request("cert_seq");
if(member_no.equals("")||cert_seq.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

String where = " member_no = '"+member_no+"' and cert_seq = '"+cert_seq+"'";
DataObject certDao = new DataObject("tcb_cert_add");
DataSet cert = certDao.find(" member_no = '"+member_no+"' and cert_seq = '"+cert_seq+"' ");
if(!cert.next()){
	u.jsError("�߸��� �����Դϴ�.");
	return;
}

if(!Startup.conf.getString("file.path.bcompany").equals("") && !cert.getString("file_path").equals("") && !cert.getString("file_name").equals(""))
{
	System.out.println("DELETE FILE : " + Startup.conf.getString("file.path.bcompany")+cert.getString("file_path")+cert.getString("file_name"));
	u.delFile(Startup.conf.getString("file.path.bcompany")+cert.getString("file_path")+cert.getString("file_name"));
}

if(!certDao.delete(" member_no = '"+member_no+"' and cert_seq = '"+cert_seq+"' ")){
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