<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
f.addElement("s_project_name",null, null);
f.addElement("s_member_name",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_assemaster a");
list.setFields("a.*");
list.addWhere(" a.main_member_no = '"+_member_no+"'");
list.addWhere(" a.status = '10' ");
list.addSearch("a.project_name", f.get("s_project_name"), "LIKE");
list.addSearch("a.member_name", f.get("s_member_name"), "LIKE");
list.setOrderBy("asse_no desc");

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.asse_plan_list");
p.setVar("menu_cd","000158");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000158", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", list.getDataSet());
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("asse_no"));
p.setVar("form_script",f.getScript());
p.display(out);
%>