<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String user_id = u.request("user_id");


DataObject dao = new DataObject("tcb_person");
DataSet ds =  dao.find("lower(user_id) = lower('"+user_id+"') ");
if(ds.next()){
	out.print("<script>");
	out.print("alert('�ش���̵�� ������� ���̵� �Դϴ�.\\n\\n�ٸ� ���̵� ����� �ֽʽÿ�.');");
	out.print("document.forms['form1']['user_id'].value='';");
	out.print("document.forms['form1']['chk_id'].value='';");
	out.print("</script>");
	return;	
}else{
	out.print("<script>");
	out.print("alert('��밡���� ���̵� �Դϴ�.');");
	out.print("document.forms['form1']['chk_id'].value='1';");
	out.print("</script>");
	return;
}
%>