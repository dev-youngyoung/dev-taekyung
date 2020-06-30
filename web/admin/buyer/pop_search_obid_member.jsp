<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%
String callback = u.request("callback");
if(callback.equals("")){
	u.jsErrClose("정상적인 경로로 접근하세요.");
	return;
}

	CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_bid_status = codeDao.getCodeArray("M022");
String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd", u.addDate("Y", -1)));

f.addElement("s_status", null, null);
f.addElement("s_field_name",null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", null, null);
f.addElement("s_cont_name",null, null);
f.addElement("s_member_name",null, null);
f.addElement("s_client_name",null, null);


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
list.setTable("tcb_bid_master a , tcb_bid_supp b, tcb_member c ");
list.setFields(
		 " a.main_member_no, a.bid_no, a.bid_deg							"
		+" , a.bid_name, b.member_no, b.member_name 						"
		+" , a.bid_date, a.status, b.pay_yn, c.member_name main_member_name "
		);
list.addWhere("a.main_member_no = b.main_member_no ");
list.addWhere("a.bid_no = b.bid_no ");
list.addWhere("a.bid_deg = b.bid_deg ");
list.addWhere("a.main_member_no = c.member_no ");
list.addSearch("a.status", f.get("s_status"));
list.addSearch("b.member_name", f.get("s_member_name"), "LIKE");
list.addSearch("a.bid_name", f.get("s_bid_name"), "LIKE");
if(!s_sdate.equals("")){
	list.addWhere("a.bid_date >= '"+s_sdate.replaceAll("-", "")+"' ");
}
if(!f.get("s_edate").equals("")){
	list.addWhere("a.bid_date <= '"+f.get("s_edate").replaceAll("-", "")+"' ");
}
list.setOrderBy("a.main_member_no, a.bid_no desc, a.bid_deg asc");

DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("cont_no", ds.getString("cont_no"));
	if(!ds.getString("cont_chasu").equals("0")){
		ds.put("cont_name", ds.getString("cont_name"));
	}
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("status_name", ds.getString("status").equals("00")?"숨김":u.getItem(ds.getString("status"), code_bid_status));
	
	//버튼설정
	ds.put("btn_writing", !ds.getString("status").equals("10"));
	ds.put("btn_finish", !u.inArray( ds.getString("status"), new String[]{"50","60","70"}));
	ds.put("btn_hide", !ds.getString("status").equals("00"));
	ds.put("btn_won_pay", ds.getString("won_pay").equals("")&&ds.getString("paytypecd").equals("10"));//종량제인 경우만.
	ds.put("btn_su_pay", ds.getString("su_pay").equals(""));
}


p.setLayout("popup");
//p.setDebug(out);
p.setBody("buyer.pop_search_obid_member");
p.setVar("popup_title","공고(공개)참여업체 검색");
p.setLoop("code_status", u.arr2loop(code_bid_status));
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("main_member_no,bid_no,bid_deg"));
p.setVar("form_script", f.getScript());
p.display(out);
%>