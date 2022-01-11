<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String view_gubun = u.request("view_gubun");
String callback = u.request("callback");


f.addElement("s_project_cd", null, null);
f.addElement("s_project_name", null, null);
f.addElement("s_use_yn", null, null);

//목록 생성
ListManager list = new ListManager(jndi);
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_project");
list.setFields("*");
list.addWhere("member_no='"+_member_no+"'");
list.addSearch("project_name", f.get("s_project_name"), "LIKE");
list.addSearch("project_cd", f.get("s_project_cd"), "LIKE");
list.addSearch("use_yn", f.get("s_use_yn"));
list.setOrderBy("project_seq desc ");

//목록 데이타 수정
DataSet rs = list.getDataSet();

p.setLayout(view_gubun.equals("popup")?"popup":"default");
//p.setDebug(out);
p.setVar("popup_title","프로젝트관리");
p.setVar("menu_cd","000117");
p.setBody("info.project_list");
p.setLoop("list", rs);
p.setVar("view_popup", view_gubun.equals("popup"));
p.setVar("callback", callback);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("project_seq"));
p.setVar("form_script",f.getScript());
p.display(out);
%>