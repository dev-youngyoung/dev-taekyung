<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
DataObject dao = new DataObject("tcb_member_boss");
DataSet ds =  dao.find("boss_ci = '" + u.request("ci") + "'");
if(ds.next()){
	out.print("<script>");
	out.print("alert('입력하신 정보의 회원정보가 존재 합니다.\\n\\n회원 정보를 분실한 경우 ID/PASSWORD 찾기를\\n진행 하여 주십시오.');");
	out.print("</script>");
	return;	
}else{
	out.print("<script>");
	out.print("alert('본인 인증 되었습니다.');");
	out.print("ciCallBack('"+u.request("ci")
                         +"','"+u.request("userName")
                         +"','"+u.request("birthDate")
                         +"','"+u.request("hp")
                         +"','"+u.request("genDer")+"');");
	out.print("</script>");
	return;
}
%>