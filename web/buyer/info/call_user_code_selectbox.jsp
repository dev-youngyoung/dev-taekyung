<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%
String main_member_no = u.request("main_member_no");
String code_gubun = u.request("code_gubun");
String m_cd = u.request("m_cd");
String s_cd = u.request("s_cd");

DataObject dao = new DataObject("tcb_user_code");
DataSet ds = dao.find(" member_no = '"+main_member_no+"' and depth='3'  and l_cd = '"+code_gubun+"' and m_cd = '"+m_cd+"' ");

out.print("<select name=\"s_cd\" onchange=\"document.forms['form1'].submit()\"> ");
	out.print("<option value=\"\">-중분류 전체-</option>");
while(ds.next()){
	String selected = "";
	if(ds.getString("s_cd").equals(s_cd))selected="selected";
	out.print("<option value=\""+ds.getString("s_cd")+"\" "+selected+">"+ds.getString("code_nm")+"</option>");
}
out.print("</select>");
%>