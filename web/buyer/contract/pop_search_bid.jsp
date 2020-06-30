<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd",u.addDate("Y",-1)));
String s_edate = u.request("s_edate", u.getTimeString("yyyy-MM-dd"));

f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_bid_name",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
list.setTable("tcb_bid_master a, tcb_bid_supp b ");
list.setFields("a.bid_no, a.bid_deg, a.bid_name, a.bid_date, b.member_no, b.member_name, b.total_cost ");
list.addWhere(" a.main_member_no = b.main_member_no ");
list.addWhere(" a.bid_no = b.bid_no ");
list.addWhere(" a.bid_deg = b.bid_deg ");
list.addWhere(" a.status = '07' ");//낙찰인건만
list.addWhere(" b.bid_succ_yn = 'Y'"); //낙찰된 업체만.
list.addWhere(" a.cont_yn = 'Y'");// 계약대상인 건만.
list.addWhere(" a.cont_no is null ");// 계약안된것만.
list.addWhere(" a.main_member_no = '"+_member_no+"' ");
list.addSearch("a.bid_name", f.get("s_bid_name"), "LIKE");
if(!s_sdate.equals(""))list.addWhere(" bid_date >= '"+s_sdate.replaceAll("-","")+"'");
if(!s_edate.equals(""))list.addWhere(" bid_date <= '"+s_edate.replaceAll("-","")+"'");
list.setOrderBy("bid_no desc ");

DataSet	ds = list.getDataSet();
while(ds.next()){
	ds.put("total_cost", u.numberFormat(ds.getString("total_cost")));
	ds.put("bid_date", u.getTimeString("yyyy-MM-dd", ds.getString("bid_date")));
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("contract.pop_search_bid");
p.setVar("popup_title","입찰결과검색");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>