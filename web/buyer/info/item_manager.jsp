<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_mat_cd = {"10=>��ǰ","20=>����","30=>�뿪"};
if(true){
	code_mat_cd[0]= "10=>���";
	code_mat_cd[1]= "20=>����";
	code_mat_cd[2]= "30=>����";
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.item_manager");
p.setVar("menu_cd","000137");
p.setVar("sys_date", u.getTimeString());
p.setLoop("code_mat_cd", u.arr2loop(code_mat_cd));
p.display(out);
%>