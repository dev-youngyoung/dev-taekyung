<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String[] code_asse_status = {"10=>평가대상","20=>평가중","50=>평가완료"};

String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd",u.addDate("Y",-1)));
String s_edate = u.request("s_edate", u.getTimeString("yyyy-MM-dd"));

f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_bid_name",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable(
	 "	  tcb_bid_master a                       "
    +"inner join  tcb_bid_supp  b                "
    +"   on a.main_member_no = b.main_member_no  "
    +"  and a.bid_no = b.bid_no                  "
    +"  and a.bid_deg = b.bid_deg                "
    +"  and b.bid_succ_yn = 'Y'                  "
    +" left outer join tcb_assemaster c          "
    +"   on a.main_member_no = c.main_member_no  "
    +"  and a.bid_no = c.bid_no                  "
    +"  and a.bid_deg = c.bid_deg                "
		);
list.setFields(
		 " a.main_member_no, a.bid_no, a.bid_deg,a.bid_name, a.bid_date                                              "
		+",a.reg_id charge_id                                                                                        "
        +",(select user_name from tcb_person where member_no = a.main_member_no  and user_id = a.reg_id) charge_name "
		+", b.member_no, b.member_name, b.total_cost                                                                 "
		+", c.asse_no, c.status                                                                                      "
		);
list.addWhere(" a.main_member_no = '"+_member_no+"' ");
list.addWhere(" a.bid_no not in (select bid_no from tcb_assemaster where main_member_no = '"+_member_no+"' )");
list.addSearch("a.bid_name", f.get("s_bid_name"), "LIKE");
if(!s_sdate.equals(""))list.addWhere(" a.bid_date >= '"+s_sdate.replaceAll("-","")+"'");
if(!s_edate.equals(""))list.addWhere(" a.bid_date <= '"+s_edate.replaceAll("-","")+"'");
list.setOrderBy("a.bid_no desc ");

DataSet	ds = list.getDataSet();
while(ds.next()){
	ds.put("total_cost", u.numberFormat(ds.getString("total_cost")));
	ds.put("bid_date", u.getTimeString("yyyy-MM-dd", ds.getString("bid_date")));
	ds.put("asse_status_nm",u.getItem(ds.getString("status"), code_asse_status));
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_search_bid");
p.setVar("popup_title","입찰결과검색");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>