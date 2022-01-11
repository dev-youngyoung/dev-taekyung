<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

String member_no = u.aseDec(u.request("member_no"));
String warr_seq = u.request("warr_seq");
if(member_no.equals("")||warr_seq.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " member_no = '"+member_no+"' and warr_seq = '"+warr_seq+"'";
DataObject warrDao = new DataObject("tcb_warr_add");
DataSet warr = warrDao.find(" member_no = '"+member_no+"' and warr_seq = '"+warr_seq+"' ");
if(!warr.next()){
	u.jsError("잘못된 정보입니다.");
	return;
}

if(!Startup.conf.getString("file.path.bcompany").equals("") && !warr.getString("file_path").equals("") && !warr.getString("file_name").equals(""))
{
	System.out.println("DELETE FILE : " + Startup.conf.getString("file.path.bcompany")+warr.getString("file_path")+warr.getString("file_name"));
	u.delFile(Startup.conf.getString("file.path.bcompany")+warr.getString("file_path")+warr.getString("file_name"));
}

if(!warrDao.delete(" member_no = '"+member_no+"' and warr_seq = '"+warr_seq+"' ")){
	u.jsError("처리에 실패 하였습니다.");
	return;
}

out.print("<script>");
out.print("alert(\"처리 하였습니다.\");");
out.print("opener.location.reload();");
out.print("self.close();");
out.print("</script>");
return;
%>