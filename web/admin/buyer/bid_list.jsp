<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M022");
String[] code_bid_kind_cd = {"10=>전자입찰","20=>전자입찰","30=>전자입찰","90=>견적요청"};

String s_bid_sdate = u.request("s_bid_sdate", u.getTimeString("yyyy-MM-dd", u.addDate("M", -1)));


f.addElement("s_bid_kind", null, null);
f.addElement("s_bid_sdate", s_bid_sdate, null);
f.addElement("s_bid_edate", null, null);
f.addElement("s_status", null, null);
f.addElement("s_member_name", null, null);
f.addElement("s_bid_name", null, null);


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_bid_master a, tcb_field b, tcb_member c");
list.setFields("a.*, b.field_name, c.member_name");
list.addWhere(" a.main_member_no = b.member_no");
list.addWhere(" a.field_seq = b.field_seq");
list.addWhere(" a.main_member_no = c.member_no");
list.addWhere(" a.bid_deg = (select max(bid_deg) from tcb_bid_master where main_member_no = a.main_member_no and bid_no = a.bid_no) ");

if(f.get("s_bid_kind").equals("10"))list.addWhere(" a.bid_kind_cd in ('10','20','30')");
if(f.get("s_bid_kind").equals("90"))list.addWhere(" a.bid_kind_cd = '90'");
if(!s_bid_sdate.equals(""))list.addWhere(" a.bid_date >= '"+s_bid_sdate.replaceAll("-","")+"000000' ");
if(!f.get("s_bid_edate").equals(""))list.addWhere(" a.bid_date <= '"+f.get("s_bid_edate").replaceAll("-","")+"999999' ");
list.addSearch(" a.status", f.get("s_status"));
list.addSearch("c.member_name", f.get("s_member_name"), "LIKE");
list.addSearch("a.bid_name", f.get("s_bid_name"), "LIKE");
list.setOrderBy("a.bid_no desc, a.bid_deg desc");

//목록 데이타 수정
DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("bid_cate_nm", u.getItem(ds.getString("bid_kind_cd"), code_bid_kind_cd));
	ds.put("bid_date", u.getTimeString("yyyy-MM-dd", ds.getString("bid_date")));
	ds.put("submit_edate", u.getTimeString("yyyy-MM-dd HH:mm", ds.getString("submit_edate")));
	ds.put("status_name", u.getItem(ds.getString("status"), code_status ));
	if(ds.getString("status").equals("05"))ds.put("status_name","<span style='color:red'>"+ds.getString("status_name")+"</span>");
	if(ds.getInt("bid_deg")>1)ds.put("bid_name", "<font style='color:#FF0000;'>[재입찰]</font>"+ds.getString("bid_name"));
	ds.put("delay_able", ds.getString("status").equals("05"));//공고중인 경우만 연기 가능
}

DataObject bidDao = new DataObject(list.table);
int tot_cnt = bidDao.findCount(list.where);

p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.bid_list");
p.setVar("menu_cd","000048");
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setVar("tot_cnt", u.numberFormat(tot_cnt));
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("main_member_no, bid_no, bid_deg, mode, bid_kind_cd"));
p.setVar("form_script", f.getScript());
p.display(out);
%>