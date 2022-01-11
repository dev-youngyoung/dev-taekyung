<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_member_type = codeDao.getCodeArray("M002");
String[] code_member_gubun = codeDao.getCodeArray("M001");
String[] code_status = {"00=>탈퇴", "01=>정회원", "02=>비회원", "03=>재가입"};  // 회원상태

String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM-dd",u.addDate("M", -1)));

f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", null, null);
f.addElement("s_status", null, null);
f.addElement("s_member_type", null, null);
f.addElement("s_member_gubun", null, null);
f.addElement("s_member_name", null, null);
f.addElement("s_vendcd", null, null);

ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(15);
list.setTable("tcb_member a, tcb_person b");
list.setFields("a.*, b.user_id");
list.addWhere("a.member_no = b.member_no(+)");
list.addWhere("b.default_yn(+) = 'Y'");
list.addSearch("a.status", f.get("s_status"));
list.addSearch("a.member_type", f.get("s_member_type"));
list.addSearch("a.member_gubun", f.get("s_member_gubun"));
list.addSearch("lower(a.member_name)", f.get("s_member_name").toLowerCase() ,"LIKE");
list.addSearch("a.vendcd", f.get("s_vendcd").replaceAll("-", ""));

if(!s_sdate.equals("")){
	list.addWhere("a.reg_date >= '"+s_sdate.replaceAll("-", "")+"000000' ");
}
if(!f.get("s_edate").equals("")){
	list.addWhere("a.reg_date <= '"+f.get("s_edate").replaceAll("-", "")+"999999' ");
}
list.setOrderBy("a.status asc,  a.reg_date desc, a.member_no desc");

//목록 데이타 수정
DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("link", ds.getString("member_gubun").equals("04")?"member_view_person.jsp":"member_view.jsp");
	ds.put("member_type", u.getItem(ds.getString("member_type"),code_member_type));
	ds.put("member_gubun", u.getItem(ds.getString("member_gubun"),code_member_gubun));
	ds.put("status", u.getItem(ds.getString("status"),code_status));
	ds.put("join_date", u.getTimeString("yyyy-MM-dd", ds.getString("join_date")));
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.member_list");
p.setVar("menu_cd","000044");
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("code_member_type", u.arr2loop(code_member_type));
p.setLoop("code_member_gubun", u.arr2loop(code_member_gubun));
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>