<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
DataObject dao = new DataObject("tcb_member_boss");
DataSet ds =  dao.find("boss_ci = '" + u.request("ci") + "'");
if(ds.next()){
	out.print("<script>");
	out.print("alert('�Է��Ͻ� ������ ȸ�������� ���� �մϴ�.\\n\\nȸ�� ������ �н��� ��� ID/PASSWORD ã�⸦\\n���� �Ͽ� �ֽʽÿ�.');");
	out.print("</script>");
	return;	
}else{
	out.print("<script>");
	out.print("alert('���� ���� �Ǿ����ϴ�.');");
	out.print("ciCallBack('"+u.request("ci")
                         +"','"+u.request("userName")
                         +"','"+u.request("birthDate")
                         +"','"+u.request("hp")
                         +"','"+u.request("genDer")+"');");
	out.print("</script>");
	return;
}
%>