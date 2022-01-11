<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
DataObject dao = new DataObject("tcb_member");
DataSet member = dao.find("member_no = '"+_member_no+"'");
if(!member.next()){
	u.jsError("삭제할 파일이 존재 하지 않습니다.");
	return;
}

dao.item("ci_img_path","");
if(!dao.update(" member_no = '"+_member_no+"'")){
	u.jsError("처리에 실패 하였습니다.");
	return;
}
u.delFile(Startup.conf.getString("file.path.bcont_logo")+member.getString("ci_img_path"));

out.print("<script typt='text/javascript'>");
out.print(" alert('정상적으로 처리되었습니다.');");
out.print(" opener.location.reload(); ");
out.print(" self.close(); ");
out.print("</script>");
%>