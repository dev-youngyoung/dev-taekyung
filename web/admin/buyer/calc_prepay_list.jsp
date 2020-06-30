<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_pay_type_cd = codeDao.getCodeArray("M006");

String s_yyyymm = u.request("s_yyyymm", u.getTimeString("yyyy-MM"));

f.addElement("s_yyyymm", s_yyyymm, "rquired:'Y', hname:'정산기준년월', fixbyte:'7'");
f.addElement("s_sdate", null, null);
f.addElement("s_edate", null, null);
f.addElement("s_pay_type_cd", null, null);
f.addElement("s_member_name", null, null);

DataObject memberDao = new DataObject("tcb_member");
StringBuffer query = new StringBuffer();
  query.append("  select a.member_no ");
  query.append("      , a.member_name ");
  query.append("      , a.vendcd ");
  query.append("      , b.usestartday use_sdate ");
  query.append("      , b.useendday use_edate ");
  query.append("      , b.paytypecd pay_type_cd ");
  query.append("      , b.bid_amt ");
  query.append("      , b.recpmoneyamt won_cont_amt ");
  query.append("      , d.calc_date ");
  query.append("      , c.seq calc_person_seq");
  query.append("      , nvl(d.user_name, c.user_name ) user_name ");
  query.append("      , nvl(d.hp1, c.hp1) hp1 ");
  query.append("      , nvl(d.hp2, c.hp2 ) hp2 ");
  query.append("      , nvl(d.hp3, c.hp3 ) hp3 ");
  query.append("      , nvl(d.email, c.email) email ");
  query.append("   from tcb_member a ");
  query.append("  inner join tcb_useinfo b ");
  query.append("     on b.member_no = a.member_no ");
  query.append("   left join  tcb_calc_person c ");
  query.append("     on c.member_no = a.member_no ");
  query.append("   and c.seq = '1' ");
  query.append("   left join tcb_calc_month d ");
  query.append("     on d.member_no = c.member_no ");
  query.append("    and d.calc_person_seq = c.seq ");
  query.append("   and d.yyyymm = '"+s_yyyymm.replaceAll("-","")+"'");
  query.append("  where (b.paytypecd in ('10','20') or bid_amt > 0 ) ");
  query.append("   and substr(b.usestartday,0,8) <= '"+s_yyyymm.replaceAll("-","")+"31' ");
  query.append("   and substr(b.useendday,0,8) >= '"+s_yyyymm.replaceAll("-","")+"01' ");
if(!f.get("s_pay_type_cd").equals("")){
    query.append(" and b.paytypecd = '"+f.get("s_pay_type_cd")+"' ");
}
if(!f.get("s_member_name").equals("")){
	query.append(" and a.member_name like '%"+f.get("s_member_name")+"%'");
}
if(!f.get("s_sdate").equals("")){
    query.append(" and b.usestartday >= '"+f.get("s_sdate").replaceAll("-","")+"' ");
}
if(!f.get("s_edate").equals("")){
    query.append(" and b.useenddayh <= '"+f.get("s_edate").replaceAll("-","")+"' ");
}
  query.append(" order by b.useendday asc , b.member_no");

//memberDao.setDebug(out);
DataSet list = memberDao.query(query.toString());
long sum_pay_amount = 0L;
long sum_bid_amt = 0L;
int num = list.size();
while(list.next()){
	list.put("__ord", num--);
    list.put("vendcd", u.getBizNo(list.getString("vendcd")));
    list.put("use_sdate", u.getTimeString("yyyy-MM-dd", list.getString("use_sdate")));
    list.put("use_edate", u.getTimeString("yyyy-MM-dd", list.getString("use_edate")));
    list.put("pay_type_cd_nm", u.getItem(list.getString("pay_type_cd"),code_pay_type_cd));
    list.put("str_pay_supp", u.numberFormat(list.getLong("won_cont_amt")));
    list.put("str_pay_tax", u.numberFormat(list.getLong("won_cont_amt")/10));
    String sum  =  u.numberFormat(list.getLong("won_cont_amt") + list.getLong("won_cont_amt")/10);
    list.put("str_pay_amount", sum );
    sum_pay_amount +=   list.getLong("won_cont_amt") + list.getLong("won_cont_amt")/10;

    list.put("str_bid_supp", u.numberFormat(list.getLong("bid_amt")));
    list.put("str_bid_tax", u.numberFormat(list.getLong("bid_amt")/10));
    sum_bid_amt +=  list.getLong("bid_amt") + list.getLong("bid_amt")/10;
    String bid_sum  =  u.numberFormat(list.getLong("bid_amt") + list.getLong("bid_amt")/10);
    list.put("str_bid_amt", bid_sum);

    if(!list.getString("user_name").equals("")){
    	String btn_name = "안내발송";
    	if(!list.getString("calc_date").equals("")){
    		btn_name = "재발송";
        }
    	String btn_send =
                "<button type=\"button\" onclick=\"sendReq('"+s_yyyymm+"','"+list.getString("member_no")+"','"+list.getString("calc_person_seq")+"')\" class=\"sbtn\">"
                +btn_name
                +"</button>";
        if(u.request("mode").equals("excel"))btn_send = "";
        list.put("calc_date", u.getTimeString("yyyy-MM-dd", list.getString("calc_date"))+btn_send);
    }

}

DataSet sumInfo = new DataSet();
sumInfo.addRow();
sumInfo.put("cnt", list.size());
sumInfo.put("str_pay_amount", u.numberFormat(sum_pay_amount));
sumInfo.put("str_pay_supp", u.numberFormat(sum_pay_amount/11*10));
sumInfo.put("str_pay_tax", u.numberFormat(sum_pay_amount/11));
sumInfo.put("str_bid_amount", u.numberFormat(sum_bid_amt));
sumInfo.put("str_bid_supp", u.numberFormat(sum_bid_amt/11*10));
sumInfo.put("str_bid_tax", u.numberFormat(sum_bid_amt/11));

if(u.request("mode").equals("excel")){
    p.setVar("title", s_yyyymm+"정액제 정산내역");
    p.setVar("sumInfo", sumInfo);
    p.setLoop("list", list);
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; filename=\"" + new String((s_yyyymm+"정액제 정산내역.xls").getBytes("KSC5601"),"8859_1") + "\"");
    out.println(p.fetch("../html/buyer/calc_prepay_list_excel.html"));
    return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.calc_prepay_list");
p.setVar("menu_cd","000092");
p.setLoop("code_pay_type_cd", u.arr2loop(code_pay_type_cd));
p.setVar("sumInfo", sumInfo);
p.setLoop("list", list);
p.setVar("list_query", u.getQueryString("yyyymm,member_no"));
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>