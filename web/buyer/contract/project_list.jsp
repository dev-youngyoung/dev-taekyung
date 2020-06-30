<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
f.addElement("s_field_name", u.request("s_field_name"), null);

//목록 생성
ListManager list = new ListManager(jndi);
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
list.setTable("tcb_order_field");
list.setFields("*");
list.addWhere("member_no='"+_member_no+"'");
list.addSearch("lower(field_name)", f.get("s_field_name").toLowerCase(), "LIKE");
list.setOrderBy("field_seq desc ");

//목록 데이타 수정
DataSet rs = list.getDataSet();

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.project_list");
p.setVar("popup_title","프로젝트 정보");
p.setLoop("list", rs);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("order_field_seq"));
p.setVar("form_script",f.getScript());
p.display(out);
%>