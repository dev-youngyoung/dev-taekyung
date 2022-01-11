<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] code_status = {"10=>미청구","20=>청구"};

String s_sdate = u.request("s_sdate");

f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", null, null);
f.addElement("s_status", null, null);
f.addElement("s_main_member_name", null, null);
f.addElement("s_member_name", null, null);

//목록 생성
ListManager list = new ListManager(jndi);
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:10);
list.setTable("tcb_bid_master a, tcb_bid_supp b, tcb_bid_supp_succpay c, tcb_member d");
list.setFields(
		 " a.bid_name, a.bid_date, a.bid_end_date"
        +", b.member_name, b.total_cost"
        +", c.*"
        +", d.member_name main_member_name"
		);
list.addWhere("a.main_member_no = b.main_member_no");
list.addWhere("a.bid_no = b.bid_no");
list.addWhere("a.bid_deg = b.bid_deg");
list.addWhere("a.main_member_no = c.main_member_no");
list.addWhere("a.bid_no = c.bid_no");
list.addWhere("b.member_no = c.member_no");
list.addWhere("a.main_member_no= d.member_no");
list.addWhere("a.status = '07'");
list.addWhere("b.bid_succ_yn = 'Y'");
if(!s_sdate.equals("")){
	list.addWhere(" a.bid_date >= '"+s_sdate.replaceAll("-", "")+"'");
}
if(!f.get("s_edate").equals("")){
	list.addWhere(" a.bid_date <= '"+f.get("s_edate").replaceAll("-", "")+"'");
}
list.addSearch("d.member_name", f.get("s_main_member_name"),"LIKE");//발주사
list.addSearch("b.member_name", f.get("s_member_name"),"LIKE");//
list.addSearch("c.status", f.get("s_status"));//
list.setOrderBy("a.bid_date desc, a.bid_no desc, a.main_member_no desc, a.bid_deg desc ");

//목록 데이타 수정
DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("bid_date", u.getTimeString("yyyy-MM-dd", ds.getString("bid_date")));
	ds.put("bid_end_date", u.getTimeString("yyyy-MM-dd", ds.getString("bid_end_date")));
	ds.put("total_cost", u.numberFormat(ds.getString("total_cost")));
	ds.put("succ_pay_amt", u.numberFormat(ds.getString("succ_pay_amt")));
	ds.put("status_nm", u.getItem(ds.getString("status"), code_status));
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.bid_succpay_list");
p.setVar("menu_cd","000072");
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>