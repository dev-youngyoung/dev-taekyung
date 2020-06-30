<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
String key = u.request("key");

if(key.equals("")){
	u.jsErrClose("정상적인 경로 접근 하세요.");
	return;
}
DataSet ds = u.json2Dataset(u.aseDec(key));
if(ds.next()){
}

String member_no = ds.getString("member_no");
String pay_sdate = ds.getString("pay_sdate");
String pay_edate = ds.getString("pay_edate");
String field_seq = ds.getString("field_seq");

String[] pay_type_code = {"01=>카드", "02=>계좌", "03=>통장", "04=>포인트", "05=>후불"};

DataObject memberDao = new DataObject("tcb_member");
DataSet member= memberDao.find(" member_no = '"+member_no+"' and (member_type='01' or member_type='03')", "member_no, member_name");
if(!member.next()){
	u.jsError("업체정보가 없습니다.");
}

//목록 생성
ListManager list = new ListManager(jndi);
list.setRequest(request);
//list.setDebug(out);
list.setListNum(-1);
list.setTable("tcb_pay a, tcb_contmaster b , (select * from tcb_cust where member_no <> '"+member.getString("member_no")+"' ) c");
list.setFields(
		        "   a.*                                                                                                 "
	          + " , a.pay_amount/11*10 supp_amount                                                                      "
	          + " , a.pay_amount/11 vat_amount                                                                          "
	          + " , b.cont_date                                                                                         "
	          + " , b.reg_id                                                                                            "
	          + " , (select user_name from tcb_person where member_no = b.member_no and user_id = b.reg_id) reg_name    "
	    	  + " , (select field_name from tcb_field where member_no = b.member_no and field_seq = b.field_seq) field_name    "
	          + " , (select template_name from tcb_cont_template where template_cd = b.template_cd) template_name       "
	          + " , b.cont_userno       																				"
	          + " , c.member_name                                                                                       "
	          + " , c.vendcd                                                                                            "
	          + " , c.boss_name                                                                                         "
	          + " , c.address                                                                                           "
	          + " , c.user_name                                                                                         "
	          + " , c.sign_date                                                                                         "
	          + " , (select count(member_no)-1 from tcb_cust where cont_no=a.cont_no and cont_chasu=a.cont_chasu and member_no <> a.member_no) cust_cnt "
				);
list.addWhere("a.cont_no  = b.cont_no");
list.addWhere("a.cont_chasu = b.cont_chasu");
list.addWhere("a.cont_no = c.cont_no");
list.addWhere("a.cont_chasu = c.cont_chasu");
list.addWhere("a.member_no = '"+member.getString("member_no")+"'");
list.addWhere("c.list_cust_yn = 'Y' ");
//list.addWhere("c.display_seq = (select min(display_seq) from tcb_cust where cont_no = a.cont_no and cont_chasu = a.cont_chasu and member_no <> a.member_no)");
if(!field_seq.equals("")) {
	list.addWhere("b.field_seq in ("+field_seq+")");
}
if(!pay_sdate.equals(""))
	list.addSearch("a.accept_date", pay_sdate.replaceAll("-","")+"000000", ">=");
if(!pay_edate.equals(""))
	list.addSearch("a.accept_date", pay_edate.replaceAll("-","")+"999999", "<=");
list.addSearch("a.pay_type", f.get("s_pay_type"), "=");
list.setOrderBy("a.accept_date asc ");
//목록 데이타 수정
DataSet rs = list.getDataSet();

String btnReceitStr = "";
int __ord2 = 1;
while(rs.next()){
	//결제수단 (01:신용카드, 02:계좌이체)
	if(rs.getString("pay_type").equals("01"))
	{
		btnReceitStr = "신용";
	}
	else if(rs.getString("pay_type").equals("02"))
	{
		//현금영수증유형(0:미발행, 1:소득공제, 2:지출증빙)
		if( rs.getString("receit_type").equals("0") || rs.getString("receit_type").equals("") )
			btnReceitStr = "거래";
		else if( rs.getString("receit_type").equals("1") )
			btnReceitStr = "소득";
		else if( rs.getString("receit_type").equals("2") )
			btnReceitStr = "지출";
	}
	else if(rs.getString("pay_type").equals("03"))
	{
		btnReceitStr = "통장";
	}
	else if(rs.getString("pay_type").equals("04"))
	{
		btnReceitStr = "포인트";
	}
	else if(rs.getString("pay_type").equals("05"))
	{
		btnReceitStr = "후불";
	}
	
	if(rs.getInt("cust_cnt") > 1)
		rs.put("member_name", rs.getString("member_name") + " 외 " + (rs.getInt("cust_cnt"))+"명");
	
	rs.put("btnReceitStr", btnReceitStr);
	rs.put("accept_date", u.getTimeString("yyyy-MM-dd HH:mm:ss",rs.getString("accept_date")));
	rs.put("pay_type_nm", u.getItem(rs.getString("pay_type"), pay_type_code));
	rs.put("pay_amount", u.numberFormat(rs.getLong("pay_amount")));

	rs.put("cont_date", u.getTimeString("yyyy-MM-dd",rs.getString("cont_date")));
	rs.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss",rs.getString("sign_date")));
	rs.put("supp_amount", u.numberFormat(rs.getLong("supp_amount")));
	rs.put("vat_amount", u.numberFormat(rs.getLong("vat_amount")));
	rs.put("vendcd", u.getBizNo(rs.getString("vendcd")));
	rs.put("__ord2", __ord2++);
}

String title = member.getString("member_name") + "_결제내역("+pay_sdate+"~"+pay_edate+")";
p.setVar("title", title);
p.setLoop("list", rs);

DataObject payDao = new DataObject("tcb_pay");
String sumQuery = " select sum(a.pay_amount) pay_amount from " + list.table +" where "+ list.where;
DataSet sumInfo = payDao.query(sumQuery);
if(!sumInfo.next()){}
long pay_amount = sumInfo.getLong("pay_amount");
sumInfo.put("pay_amount", u.numberFormat(pay_amount*10/11));
sumInfo.put("pay_tax", u.numberFormat(pay_amount/11));
sumInfo.put("pay_total", u.numberFormat(pay_amount));
p.setVar("sumInfo", sumInfo);

response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition", "attachment; filename=\"" + new String((title+".xls").getBytes("KSC5601"),"8859_1") + "\"");
out.println(p.fetch("../html/info/pay_info_list_excel.html"));
return;

%>