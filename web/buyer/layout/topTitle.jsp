<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%
String menu_cd = u.request("menu_cd");
if(menu_cd.equals("")){
	return;
}

String menu_nm = "";

DataObject menuDao = new DataObject("tcb_menu");
DataSet title = menuDao.query(
		 " select menu_cd, depth, menu_nm        "
		+"    from tcb_menu                      "     
		+"   start with menu_cd = '"+menu_cd+"'  "
		+" connect by prior  p_menu_cd = menu_cd "     
		+"   order by depth  asc 			     "
		);

while(title.next()){
	if(title.getString("depth").equals("3")){
		menu_nm = title.getString("menu_nm");
		break;
	}
}

p.setVar("menu_nm", menu_nm);
p.setLoop("title", title);
out.print(p.fetch("../html/layout/topTitle.html"));
%>
	
	