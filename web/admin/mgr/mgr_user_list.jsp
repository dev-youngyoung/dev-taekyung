<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
ListManager list = new ListManager(jndi);
list.setRequest(request);
//list.setDebug(out);
list.setListNum(15);
list.setTable("tcc_admin");
list.setFields("*");

//��� ����Ÿ ����
DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("reg_date", u.getTimeString("yyyy-MM-dd", ds.getString("reg_date")));
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("mgr.mgr_user_list");
p.setVar("menu_cd","000024");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>