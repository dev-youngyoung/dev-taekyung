<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
DataObject dao = new DataObject("tcb_member");
DataSet member = dao.find("member_no = '"+_member_no+"'");
if(!member.next()){
	u.jsError("������ ������ ���� ���� �ʽ��ϴ�.");
	return;
}

dao.item("ci_img_path","");
if(!dao.update(" member_no = '"+_member_no+"'")){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}
u.delFile(Startup.conf.getString("file.path.bcont_logo")+member.getString("ci_img_path"));

out.print("<script typt='text/javascript'>");
out.print(" alert('���������� ó���Ǿ����ϴ�.');");
out.print(" opener.location.reload(); ");
out.print(" self.close(); ");
out.print("</script>");
%>