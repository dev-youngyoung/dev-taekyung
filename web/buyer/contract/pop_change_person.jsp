<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%

String member_no = u.request("member_no");
String sign_seq = u.request("sign_seq");

f.addElement("s_member_name",null, null);


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
list.setTable("tcb_person b ");
list.setFields("user_name, tel_num, hp1, hp2, hp3, email");
list.addWhere("member_no = '"+_member_no+"'");
list.addSearch("member_name", f.get("s_member_name"), "LIKE");
list.setOrderBy("member_name asc ");

DataSet ds = null;
if(!u.request("search").equals("")){
	//목록 데이타 수정
	ds = list.getDataSet();
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("contract.pop_change_person");
p.setVar("popup_title","담당자 검색");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>