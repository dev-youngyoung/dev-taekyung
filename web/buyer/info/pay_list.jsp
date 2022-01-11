<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

String[] pay_type_code = {"01=>카드", "02=>계좌", "03=>통장", "04=>포인트", "05=>후불"};

String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM")+"-01");
String s_edate = u.request("s_edate" , u.getTimeString("yyyy-MM-dd"));
String sFieldSeq = u.request("s_fieldseq");

f.addElement("s_cont_name",null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_pay_type", null, null);


//목록 생성
ListManager list = new ListManager(jndi);
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:10);
list.setTable(
 " (                                                                                                                                      "
+" 		(                                                                                                                                 "
+" 		        select                                                                                                                    "
+" 		                  a.cont_no                                                                                                       "
+" 		                , a.cont_chasu                                                                                                    "
+" 		                , a.cont_name                                                                                                     "
+" 		                , a.pay_amount                                                                                                    "
+" 		                , a.pay_amount/11*10 supp_amount                                                                                  "
+" 		                , a.pay_amount/11 vat_amount                                                                                      "
+" 		                , a.pay_type                                                                                                      "
+" 		                , a.tid                                                                                                           "
+" 		                , a.receit_type                                                                                                   "
+" 		                , a.accept_date                                                                                                   "
+" 		                , (select template_name from tcb_cont_template where template_cd = b.template_cd) template_name                   "
+" 		                , b.cont_date                                                                                                     "
+" 		                , b.reg_id                                                                                                        "
+" 		                , (select user_name from tcb_person where member_no = b.member_no  and user_id = b.reg_id) reg_name               "
+" 		                , (select field_name from tcb_field where member_no = b.member_no and field_seq = b.field_seq) field_name         "
+" 		                , c.member_name                                                                                                   "
+" 		                , c.vendcd                                                                                                        "
+" 		                , c.boss_name                                                                                                     "
+" 		                , c.address                                                                                                       "
+" 		                , c.user_name                                                                                                     "
+" 		                , c.sign_date                                                                                                     "
+" 		           from tcb_pay a, tcb_contmaster b, tcb_cust c                                                                           "
+" 		        where a.member_no = '"+_member_no+"'                                                                                      "
+" 		            and a.cont_no = b.cont_no                                                                                             "
+" 		            and a.cont_chasu = b.cont_chasu                                                                                       "
+" 		            and a.cont_no = c.cont_no                                                                                             "
+" 		            and a.cont_chasu = c.cont_chasu                                                                                       "
+" 		            and c.member_no <> '"+_member_no+"'                                                                                   "
+"                  and b.cont_name like '%"+f.get("s_cont_name")+"%' "
+" 		            and c.display_seq = (select min(display_seq) from tcb_cust where cont_no = a.cont_no and cont_chasu = a.cont_chasu and member_no <> a.member_no)                                                                                   "
+" 		 )                                                                                                                                "
+" 		union all                                                                                                                         "
+" 		(                                                                                                                                 "
+" 		        select  a.bid_no cont_no                                                                                                  "
+" 		                  , a.bid_deg cont_chasu                                                                                          "
+" 		                  , a.bid_name cont_name                                                                                           "
+" 		                  , a.pay_amount                                                                                                  "
+" 		                  , a.pay_amount/11*10 supp_amount                                                                                  "
+" 		                  , a.pay_amount/11 vat_amount                                                                                      "
+" 		                  , a.pay_type                                                                                                    "
+" 		                  , a.tid                                                                                                         "
+" 		                  , a.receit_type                                                                                                 "
+" 		                  , a.accept_date                                                                                                 "
+" 		                  , '' template_name                                                                                              "
+" 		                  , b.bid_date cont_date                                                                                          "
+" 		                  , b.reg_id                                                                                                      "
+" 		                  , (select user_name from tcb_person where member_no = b.main_member_no  and user_id = b.reg_id) reg_name        "       
+" 		                  , (select field_name from tcb_field where member_no = b.main_member_no and field_seq = b.field_seq) field_name  "
+" 		                  , c.member_name                                                                                                 "
+" 		                  , c.vendcd                                                                                                      "
+" 		                  , c.boss_name                                                                                                   "
+" 		                  , c.address                                                                                                     "
+" 		                  , (select user_name from tcb_person where member_no = b.main_member_no  and user_id = b.reg_id) user_name       "
+" 		                  , '' sign_date                                                                                                  "
+" 		           from tcb_bid_pay a , tcb_bid_master b, tcb_member c                                                                    "
+" 		        where a.member_no = '"+_member_no+"'                                                                                      "
+" 		            and a.main_member_no = b.main_member_no                                                                               "
+" 		            and a.bid_no = b.bid_no                                                                                               "
+" 		            and a.bid_deg = b.bid_deg                                                                                             "
+" 		            and b.main_member_no = c.member_no                                                                                    "
		+"                  and b.bid_name like '%"+f.get("s_cont_name")+"%' "
+" 		 )                                                                                                                                "
+" )		                                                                                                                              "
		);
list.setFields("*");
list.addWhere("1=1");//이거 지우면 안됨 sumquery 에서 필요함. 없으면 에러
if(!s_sdate.equals("")){
	list.addWhere(" accept_date >= '"+s_sdate.replaceAll("-", "")+"000000' ");
}
if(!s_edate.equals("")){
	list.addWhere(" accept_date <= '"+s_edate.replaceAll("-", "")+"999999' ");
}
list.addSearch("pay_type", f.get("s_pay_type"));

list.setOrderBy("accept_date "+(u.request("mode").equals("excel")?"asc":"desc"));
//목록 데이타 수정
DataSet ds = list.getDataSet();

String btnReceitStr = "";
while(ds.next()){
	//결제수단 (01:신용카드, 02:계좌이체)
	if(ds.getString("pay_type").equals("01"))
	{
		btnReceitStr = "신용";
	}
	else if(ds.getString("pay_type").equals("02"))
	{
		//현금영수증유형(0:미발행, 1:소득공제, 2:지출증빙)
		if( ds.getString("receit_type").equals("0") || ds.getString("receit_type").equals("") )
			btnReceitStr = "거래";
		else if( ds.getString("receit_type").equals("1") )
			btnReceitStr = "소득";
		else if( ds.getString("receit_type").equals("2") )
			btnReceitStr = "지출";
	}
	else if(ds.getString("pay_type").equals("03"))
	{
		btnReceitStr = "통장";
	}
	else if(ds.getString("pay_type").equals("04"))
	{
		btnReceitStr = "포인트";
	}
	else if(ds.getString("pay_type").equals("05"))
	{
		btnReceitStr = "후불";
	}
	
	if(ds.getInt("cust_cnt") > 1)
		ds.put("member_name", ds.getString("member_name") + " 외 " + (ds.getInt("cust_cnt"))+"명");
	
	ds.put("btnReceitStr", btnReceitStr);
	ds.put("accept_date", u.getTimeString("yyyy-MM-dd HH:mm:ss",ds.getString("accept_date")));
	ds.put("pay_type_nm", u.getItem(ds.getString("pay_type"), pay_type_code));
	ds.put("pay_amount", u.numberFormat(ds.getLong("pay_amount")));

	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss",ds.getString("sign_date")));
	ds.put("supp_amount", u.numberFormat(ds.getLong("supp_amount")));
	ds.put("vat_amount", u.numberFormat(ds.getLong("vat_amount")));
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
}

if(u.request("mode").equals("excel")){
	String title = auth.getString("_MEMBER_NAME") + "_결제내역("+s_sdate+"~"+s_edate+")";
	p.setVar("title", title);
	p.setLoop("list", ds);

	DataObject payDao = new DataObject("tcb_pay");
	String sumQuery = " select sum(pay_amount) pay_amount from (" + list.table + ") where "+ list.where;
	DataSet sumInfo = payDao.query(sumQuery);
	if(!sumInfo.next()){}
	long pay_amount = sumInfo.getLong("pay_amount");
	sumInfo.put("pay_amount", u.numberFormat(pay_amount*10/11));
	sumInfo.put("pay_tax", u.numberFormat(pay_amount/11));
	sumInfo.put("pay_total", u.numberFormat(pay_amount));
	p.setVar("sumInfo", sumInfo);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String((title+".xls").getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/info/pay_list_excel.html"));
	return;
}

DataObject payDao = new DataObject("tcb_pay");
//payDao.setDebug(out);
String sumQuery = " select sum(pay_amount) pay_amount, count(pay_amount) cnt from (" + list.table + ") where "+ list.where;
DataSet sumInfo = payDao.query(sumQuery);
if(!sumInfo.next()){}
sumInfo.put("pay_amount", u.numberFormat(sumInfo.getLong("pay_amount")));
sumInfo.put("cnt", u.numberFormat(sumInfo.getLong("cnt")));

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.pay_list");
p.setVar("menu_cd","000135");
p.setLoop("pay_type_code", u.arr2loop(pay_type_code));
p.setVar("sumInfo", sumInfo);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>