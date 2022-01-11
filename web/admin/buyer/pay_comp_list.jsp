<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_pay_type_cd = codeDao.getCodeArray("M006");

String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM-dd"));
String s_status = u.request("s_status", "01");
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", null, null);
f.addElement("s_pay_type_cd", null, null);
f.addElement("s_member_name",null, null);

//목록 생성
ListManager list = new ListManager(jndi);
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_member a, tcb_useinfo b");
list.setFields(
		 "a.*"
		+", b.paytypecd,b.useendday "
		+", (select count(member_no) from tcb_menu_member where member_no = a.member_no and menu_cd = '000036') bid_cnt"//견적관리 메뉴가 있을 경우만.입찰설정함.
		+", (select count(member_no) from tcb_menu_member where member_no = a.member_no and menu_cd = '000033') esti_cnt"//견적요청현황 메뉴가 있을 경우만.견적설정.
		+", (select count(member_no) from tcb_useinfo where member_no = a.member_no) use_cnt"
		);
list.addWhere("a.member_type in ('01','03')");
list.addWhere("a.member_no = b.member_no(+)");
if(!s_sdate.equals("")){
	list.addWhere("b.useendday >= '"+s_sdate.replaceAll("-", "")+"' ");
}
if(!f.get("s_edate").equals("")){
	list.addWhere("b.useendday <= '"+f.get("s_edate").replaceAll("-", "")+"' ");
}
list.addSearch("b.paytypecd", f.get("s_pay_type_cd"));
list.addSearch("a.member_name", f.get("s_member_name"), "LIKE");
list.setOrderBy("b.useendday asc, a.member_no desc");

//목록 데이타 수정
DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	ds.put("paytypecd", u.getItem(ds.getString("paytypecd"), code_pay_type_cd));
	ds.put("useendday", u.getTimeString("yyyy-MM-dd", ds.getString("useendday")));
	ds.put("btn_bid", ds.getInt("bid_cnt")>0);
	ds.put("btn_esti", ds.getInt("esti_cnt")>0);
	ds.put("useinfo_link", ds.getInt("use_cnt")>0?"pay_useinfo_modify.jsp":"pay_useinfo_insert.jsp");

}

p.setLayout("default");
p.setBody("buyer.pay_comp_list");
p.setVar("menu_cd", "000045");
p.setLoop("code_pay_type_cd", u.arr2loop(code_pay_type_cd));
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.setVar("form_script",f.getScript());
p.display(out);
%>