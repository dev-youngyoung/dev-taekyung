<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String member_no = u.request("member_no");
if(cont_no.equals("")||cont_chasu.equals("")||member_no.equals("")){
	u.jsErrClose("정상적인 경로로 접근해 주세요.");
	return;
}
DataObject stampDao = new DataObject("tcb_stamp");
DataSet stamp = stampDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+member_no+"' ");

stampDao.item("cert_no", "");
stampDao.item("stamp_money", ""); 	
stampDao.item("issue_date", ""); 	
stampDao.item("channel", ""); 	
stampDao.item("file_title", "");
stampDao.item("file_name", "");
stampDao.item("file_path", "");
stampDao.item("file_ext", "");
stampDao.item("file_size", "");
	
if(!stampDao.update(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+member_no+"' ")){
	u.jsError("처리에 실패 하였습니다.");
	return;
}


if(!Startup.conf.getString("file.path.bcont_pdf").equals("") && !stamp.getString("file_path").equals("") && !stamp.getString("file_name").equals(""))
{
	System.out.println("DELETE FILE : " + Startup.conf.getString("file.path.bcont_pdf")+stamp.getString("file_path")+stamp.getString("file_name"));
	u.delFile(Startup.conf.getString("file.path.bcont_pdf")+stamp.getString("file_path")+stamp.getString("file_name"));
}


out.print("<script>");
out.print("alert(\"삭제하였습니다.\");");
out.print("opener.location.reload();");
out.print("self.close();");
out.print("</script>");
return;


%>