<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_pay_type = {"01=>카드", "02=>계좌", "03=>통장", "04=>포인트", "05=>후불"};
String[] code_receit_type = {"0=>거래","1=>소득","2=>지출","3=>통장"};

String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM")+"-01");

f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", null, null);
f.addElement("s_member_name", null, null);
f.addElement("s_pay_type", null, null);

//목록 생성
ListManager list = new ListManager(jndi);
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:10);
list.setTable("tcb_bid_pay a, tcb_bid_master b, tcb_member c, tcb_member d ");
list.setFields(" a.*, c.member_name, d.member_name main_member_name ");
list.addWhere("a.main_member_no= b.main_member_no");
list.addWhere("a.bid_no= b.bid_no");
list.addWhere("a.bid_deg= b.bid_deg");
list.addWhere("a.member_no = c.member_no");
list.addWhere("b.main_member_no = d.member_no");
if(!s_sdate.equals("")){
	list.addWhere(" a.accept_date >= '"+s_sdate.replaceAll("-", "") +"000000'");
}
if(!f.get("s_edate").equals("")){
	list.addWhere(" a.accept_date <= '"+f.get("s_edate").replaceAll("-", "")+"240000'");
}
list.addSearch("c.member_name", f.get("s_member_name"),"LIKE");
list.addSearch("c.vendcd", f.get("s_vendcd").replaceAll("-", ""));
if(f.get("s_pay_type").equals("03"))  // 통장이면
{
	list.addSearch("a.pay_type", "02", "=");
	list.addSearch("a.receit_type", "3", "=");
}
else
	list.addSearch("a.pay_type", f.get("s_pay_type"), "=");
list.setOrderBy("a.accept_date desc, a.bid_no desc ");

//목록 데이타 수정
DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("accept_date", u.getTimeString("yyyy-MM-dd HH:mm:ss",ds.getString("accept_date")));
	ds.put("pay_type_nm", u.getItem(ds.getString("pay_type"), code_pay_type));
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	ds.put("pay_amount", u.numberFormat(ds.getLong("pay_amount")));
	ds.put("supply_amt", u.numberFormat(ds.getLong("supply_amt")));
	ds.put("vat_amt", u.numberFormat(ds.getLong("vat_amt")));
	ds.put("receit_type", ds.getString("receit_type").equals("")?"0":ds.getString("receit_type"));
	if(ds.getString("pay_type").equals("02")){
		ds.put("btn_name", u.getItem(ds.getString("receit_type"), code_receit_type));
	}else{
		ds.put("btn_name", u.getItem(ds.getString("pay_type"),code_pay_type));
	}
}

if(u.request("mode").equals("excel")){
	if(ds.size()<1){
		u.jsError("검색결과가 없습니다.");
		return;
	}
	DataObject payDao = new DataObject("tcb_bid_pay");
	//payDao.setDebug(out);
	DataSet sum = payDao.query(
			"select sum(a.pay_amount) pay_amount "
					+"      ,sum(DECODE(a.pay_type, '01', FLOOR(0.0298*a.pay_amount),                  "
					+"                               '02', DECODE(a.receit_type, '3', 0, 220))) charge_amt  "
					+"      ,sum(10*a.pay_amount/11) supply_amt                    "
					+"      ,sum(a.pay_amount/11) vat_amt                          "
					+"  from "+ list.table
					+" where "+ list.where
	);
	if(!sum.next()){}
	sum.put("pay_amount", u.numberFormat(sum.getLong("pay_amount")));
	sum.put("charge_amt", u.numberFormat(sum.getLong("charge_amt")));
	sum.put("supply_amt", u.numberFormat(sum.getLong("supply_amt")));
	sum.put("vat_amt", u.numberFormat(sum.getLong("vat_amt")));
	p.setLoop("list", ds);
	p.setVar("sum", sum);

	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("매출내역.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/buyer/pay_list_excel.html"));
	return;
}

//합계금액
DataObject payDao = new DataObject("tcb_pay");
//payDao.setDebug(out);
DataSet sum = payDao.query(" select nvl(sum(pay_amount*10/11),0) total_pay from "+ list.table + " where 1=1 and "+list.where );
if(!sum.next()){
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.bid_pay_list");
p.setVar("menu_cd","000067");
p.setLoop("code_pay_type", u.arr2loop(code_pay_type));
p.setLoop("list", ds);
p.setVar("total_num", list.getTotalNum());
p.setVar("total_amt", u.numberFormat(sum.getLong("total_pay")));
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>