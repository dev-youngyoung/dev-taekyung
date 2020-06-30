<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String mode = u.request("mode");

String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM")+"-01");
String s_edate = u.request("s_edate",u.getTimeString("yyyy-MM-dd"));

f.addElement("s_member_name", null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);


//목록 생성
ListManager list = new ListManager(jndi);
list.setRequest(request);
//list.setDebug(out);
list.setListNum(mode.equals("excel")?-1:10);
list.setTable("tcb_pay_debt a, tcb_debt b , tcb_debt_cust c, tcb_debt_cust d");
list.setFields(" a.* , b.agent_name"
		       +" , 10*a.pay_amount/11 supp_amt, a.pay_amount/11 vat_amt " 
		       +" , (select group_name from tcb_debt_group where member_no = b.member_no and group_no = b.group_no)  group_name " 
		       +" , c.member_name sender_name, d.member_name  recver_name"
		       );
list.addWhere(
		  "     a.debt_no = b.debt_no"
	     +" and a.debt_no = c.debt_no"
	     +" and c.cust_gubun = '10'  "
	     +" and a.debt_no = d.debt_no"
	     +" and d.cust_gubun = '20'  "
	     +" and d.vendcd not like '123456789%'  "
		);
if(!s_sdate.equals(""))
	list.addWhere("a.reg_date >= '"+s_sdate.replaceAll("-", "")+"000000'");
if(!s_edate.equals(""))
	list.addWhere("a.reg_date <= '"+s_edate.replaceAll("-", "")+"999999'");
list.addSearch("c.member_name", f.get("s_member_name"), "LIKE");
list.setOrderBy("a.reg_date desc, a.debt_no desc");

//목록 데이타 수정
DataSet rs = list.getDataSet();

String btnReceitStr = "";
while(rs.next()){
	rs.put("reg_date", u.getTimeString("yyyy-MM-dd HH:mm:ss",rs.getString("reg_date")));
	rs.put("pay_amount", u.numberFormat(rs.getLong("pay_amount")));
	rs.put("supp_amt", u.numberFormat(rs.getLong("supp_amt")));
	rs.put("vat_amt", u.numberFormat(rs.getLong("vat_amt")));
}

if(mode.equals("excel")){
	if(rs.size()<1){
		u.jsError("검색결과가 없습니다.");
		return;
	}
	DataObject payDao = new DataObject("tcb_pay");
	//payDao.setDebug(out);
	DataSet sum = payDao.query(
		 "select sum(a.pay_amount) pay_amount "
	    +"      ,sum(10*a.pay_amount/11) supp_amt                    "
	    +"      ,sum(a.pay_amount/11) vat_amt                          "
	    +"  from "+ list.table
	    +" where "+ list.where
	);
	if(!sum.next()){}
	sum.put("pay_amount", u.numberFormat(sum.getLong("pay_amount")));
	sum.put("supp_amt", u.numberFormat(sum.getLong("supp_amt")));
	sum.put("vat_amt", u.numberFormat(sum.getLong("vat_amt")));
	p.setLoop("list", rs);
	p.setVar("sum", sum);

	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("채권잔액 결제현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/admin/debt_pay_list_excel.html"));
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
p.setBody("buyer.debt_pay_list");
p.setVar("menu_cd","000052");
p.setLoop("list", rs);
p.setVar("total_num", list.getTotalNum());
p.setVar("total_amt", u.numberFormat(sum.getLong("total_pay")));
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>