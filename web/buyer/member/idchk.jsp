<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String user_id = u.request("user_id");
String type = u.request("type");

DataObject dao = new DataObject("tcb_person");
DataSet ds = new DataSet();
if("client".equals(type)){
	ds =  dao.find("lower(user_id) = lower('" + user_id + "') AND PASSWD IS NOT NULL");
}else{
	ds =  dao.find("lower(user_id) = lower('" + user_id + "') ");
}

if (ds.next()) {
	out.print("<script>");
	out.print("    alert('해당아이디는 사용중인 아이디 입니다.\\n\\n다른 아이디를 사용해 주십시요.');");
	out.print("    document.forms['form1']['user_id'].value='';");
	out.print("    document.forms['form1']['chk_id'].value='';");
	out.print("</script>");
	return;
} else {
	out.print("<script>");
	out.print("    alert('사용가능한 아이디 입니다.');");
	out.print("    document.forms['form1']['chk_id'].value='1';");
	out.print("</script>");
	return;
}
%>