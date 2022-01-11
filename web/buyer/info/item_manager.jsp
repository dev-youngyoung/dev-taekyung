<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] code_mat_cd = {"10=>물품","20=>공사","30=>용역"};
if(true){
	code_mat_cd[0]= "10=>모빌";
	code_mat_cd[1]= "20=>외주";
	code_mat_cd[2]= "30=>자제";
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.item_manager");
p.setVar("menu_cd","000137");
p.setVar("sys_date", u.getTimeString());
p.setLoop("code_mat_cd", u.arr2loop(code_mat_cd));
p.display(out);
%>