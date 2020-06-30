<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String person_seq = u.request("person_seq");

f.addElement("s_field_name", null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_field");
list.setFields("*");
list.addWhere(" member_no = '"+_member_no+"'and status > 0 ");
if(!person_seq.equals("")){
list.addWhere(
 " field_seq not in (						"
+"       select field_seq			 		"
+"         from tcb_fieldperson				"
+"        where member_no = '"+_member_no+"'"
+"          and person_seq = '"+person_seq+"'"
+"          			)					 "
);
}
list.addSearch("field_name", f.get("s_field_name"), "LIKE");
list.setOrderBy("field_seq desc ");

DataSet ds = list.getDataSet();
while(ds.next()){
	ds.put("use_yn", ds.getString("use_yn").equals("Y")?"사용":"사용중지");
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("info.pop_search_place");
p.setVar("popup_title","지점검색");
p.setLoop("list", ds);
p.setVar("form_script", f.getScript());
p.setVar("pagerbar",list.getPaging());
p.display(out);
%>