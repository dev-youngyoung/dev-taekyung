<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_pay_type_cd = codeDao.getCodeArray("M006");
String[] code_calc_day = codeDao.getCodeArray("M048");

String s_yyyymm = u.request("s_yyyymm", u.getTimeString("yyyy-MM"));
String pre_yyyymm =  u.getTimeString("yyyyMM",u.addDate("M",-1, u.strToDate(s_yyyymm+"-01")));

f.addElement("s_yyyymm", s_yyyymm, "rquired:'Y', hname:'정산기준년월', fixbyte:'7'");
f.addElement("s_calc_day", null, null);
f.addElement("s_sdate", null, null);
f.addElement("s_edate", null, null);
f.addElement("s_member_name", null, null);
f.addElement("s_vendcd", null, null);

DataObject memberDao = new DataObject("tcb_member");
StringBuffer query = new StringBuffer();
query.append(" select a.member_no ");
query.append("      , a.member_name ");
query.append("      , a.vendcd ");
query.append("      , b.paytypecd pay_type_cd ");
query.append("      , b.useendday use_edate ");
query.append("      , b.calc_day ");
query.append("      , d.calc_date ");
query.append("      , nvl(d.user_name, c.user_name ) user_name");
query.append("      , nvl(d.hp1, c.hp1) hp1 ");
query.append("      , nvl(d.hp2, c.hp2 ) hp2");
query.append("      , nvl(d.hp3, c.hp3 ) hp3 ");
query.append("      , nvl(d.email, c.email) email ");
query.append("      , nvl(d.field_seq, c.field_seq) field_seq ");
query.append("      , c.seq calc_person_seq ");
query.append("      , '"+pre_yyyymm+"'||nvl(b.calc_day,'01') pay_sdate");
query.append("      , to_char(to_date('"+s_yyyymm.replaceAll("-","")+"'||nvl(b.calc_day,'01') ,'yyyymmdd')-1,'yyyymmdd') pay_edate");
query.append("  from tcb_member a ");
query.append(" inner join tcb_useinfo b  ");
query.append("    on a.member_no = b.member_no  ");
query.append("  left join tcb_calc_person c  ");
query.append("    on a.member_no = c.member_no  ");
query.append("  left join tcb_calc_month d  ");
query.append("    on a.member_no = d.member_no  ");
query.append("   and c.seq = d.calc_person_seq  ");
query.append("   and d.yyyymm = '"+s_yyyymm.replaceAll("-","")+"'  ");
query.append(" where b.paytypecd = '50' ");
query.append("   and exists (select * from tcb_pay where member_no = a.member_no and accept_date >= '"+pre_yyyymm+"'||nvl(b.calc_day,'01' ) )");
query.append("   and exists (select * from tcb_pay where member_no = a.member_no and accept_date <= to_char(to_date('"+s_yyyymm.replaceAll("-","")+"'||nvl(b.calc_day,'01') ,'yyyymmdd')-1,'yyyymmdd') )");
if(!f.get("s_calc_day").equals("")){
    query.append(" and b.calc_day = '"+f.get("s_calc_day")+"'");
}
if(!f.get("s_member_name").equals("")){
	query.append(" and a.member_name like '%"+f.get("s_member_name")+"%'");
}
if(!f.get("s_sdate").equals("")){
    query.append(" and b.useendday >= '"+f.get("s_sdate").replaceAll("-","")+"' ");
}
if(!f.get("s_edate").equals("")){
    query.append(" and b.useendday <= '"+f.get("s_edate").replaceAll("-","")+"' ");
}
query.append(" order by member_no desc");
//memberDao.setDebug(out);
DataSet ds = memberDao.query(query.toString());
long sum_pay_amount = 0L;
long sum_cnt = 0L;
int num = ds.size();
while(ds.next()){
	ds.put("__ord", num--);
	DataSet payInfo = memberDao.query(
         " select sum(pay_amount) pay_amount , count(*) pay_cnt "
        +"   from tcb_pay a1, tcb_contmaster b1"
        +"  where a1.cont_no = b1.cont_no "
        +"    and a1.cont_chasu = b1.cont_chasu "
        +"    and a1.member_no = '"+ds.getString("member_no")+"'"
        +"    and a1.pay_type = '05' "
        +(ds.getString("field_seq").equals("")?"":"    and b1.field_seq in ("+ds.getString("field_seq")+")")
        +"    and a1.accept_date >= '"+ds.getString("pay_sdate")+"000000' "
        +"    and a1.accept_date <= '"+ds.getString("pay_edate")+"999999' "
    );
	if(!payInfo.next()){
        ds.put("pay_amount", "");
        ds.put("pay_cnt", "");
    }else{
        ds.put("pay_amount", payInfo.getString("pay_amount"));
        ds.put("pay_cnt", payInfo.getString("pay_cnt"));
    }

	if(ds.getString("field_seq").equals("")){
        ds.put("field_name","전체");
    }else{
        ds.put("field_name","부서지정");
    }
    ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
    ds.put("use_edate", u.getTimeString("yyyy-MM-dd", ds.getString("use_edate")));
    if(u.request("mode").equals("excel")){
        ds.put("calc_day_nm", ds.getString("calc_day").equals("") ? "<span style='color:red'>미등록</span>" : u.getItem(ds.getString("calc_day"), code_calc_day));
    }else {
        ds.put("calc_day_nm", ds.getString("calc_day").equals("") ? "<span style='color:red'>미등록</span>" : u.getItem(ds.getString("calc_day"), code_calc_day).replaceAll("\\(", "<br>("));
    }
    if(!ds.getString("calc_day").equals("")) {
        ds.put("pay_sdate", u.getTimeString("yyyy-MM-dd", ds.getString("pay_sdate")));
        ds.put("pay_edate", u.getTimeString("yyyy-MM-dd", ds.getString("pay_edate")));
        ds.put("str_pay_sdate", u.getTimeString("yy-MM-dd", ds.getString("pay_sdate")));
        ds.put("str_pay_edate", u.getTimeString("yy-MM-dd", ds.getString("pay_edate")));
        ds.put("str_pay_cnt", u.numberFormat(ds.getString("pay_cnt")));
        ds.put("str_pay_amount", u.numberFormat(ds.getString("pay_amount")));
        if(ds.getLong("pay_amount")> 0 ){
        	String calc_key = "{member_no:'"+ds.getString("member_no")+"',pay_sdate:'"+ds.getString("pay_sdate")+"', pay_edate:'"+ds.getString("pay_edate")+"', field_seq:'"+ds.getString("field_seq")+"'}";
        	String enc_key = u.aseEnc(calc_key);
            if(u.request("mode").equals("excel")){
                ds.put("str_pay_cnt",  ds.getString("str_pay_cnt"));
                ds.put("str_pay_amount",  ds.getString("str_pay_amount"));
            }else {
                ds.put("str_pay_cnt", "<a href=\"javascript:downExcel('" + enc_key + "')\" style='color:blue'>" + ds.getString("str_pay_cnt") + "</a>");
                ds.put("str_pay_amount", "<a href=\"javascript:downExcel('" + enc_key + "')\" style='color:blue'>" + ds.getString("str_pay_amount") + "</a>");
            }
            ds.put("str_pay_supp", u.numberFormat(ds.getLong("pay_amount") / 11 * 10));
            ds.put("str_pay_tax", u.numberFormat(ds.getLong("pay_amount") / 11));

            sum_pay_amount += ds.getLong("pay_amount");
            sum_cnt +=ds.getLong("pay_cnt");
        }else{
            ds.put("str_pay_supp", "0");
            ds.put("str_pay_tax", "0");
        }
    }else{
        ds.put("str_pay_cnt", "");
        ds.put("str_pay_amount", "");
        ds.put("str_pay_supp", "");
        ds.put("str_pay_tax", "");
    }
    if(ds.getLong("pay_amount")>0 && !ds.getString("user_name").equals("")){
    	String btn_name = "정산발송";
    	if(!ds.getString("calc_date").equals("")){
    		btn_name = "재전송";
        }
    	String btn_send =
                "<button type=\"button\" onclick=\"sendReq('"+s_yyyymm+"','"+ds.getString("member_no")+"','"+ds.getString("pay_sdate")+"','"+ds.getString("pay_edate")+"','"+ds.getString("pay_amount")+"','"+ds.getString("calc_person_seq")+"')\" class=\"sbtn\">"
                +btn_name
                +"</button>";
        if(u.request("mode").equals("excel"))btn_send = "";
        ds.put("calc_date", u.getTimeString("yyyy-MM-dd", ds.getString("calc_date"))+btn_send);
    }else{
        ds.put("calc_date", u.getTimeString("yyyy-MM-dd", ds.getString("calc_date")));
    }

}

DataSet sumInfo = new DataSet();
sumInfo.addRow();
sumInfo.put("cnt", ds.size());
sumInfo.put("str_sum_cnt", u.numberFormat(sum_cnt));
sumInfo.put("str_pay_amount", u.numberFormat(sum_pay_amount));
sumInfo.put("str_pay_supp", u.numberFormat(sum_pay_amount/11*10));
sumInfo.put("str_pay_tax", u.numberFormat(sum_pay_amount/11));

if(u.request("mode").equals("excel")){
    p.setVar("title", s_yyyymm+"후불정산내역");
    p.setVar("sumInfo", sumInfo);
    p.setLoop("list", ds);
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; filename=\"" + new String((s_yyyymm+"후불정산내역.xls").getBytes("KSC5601"),"8859_1") + "\"");
    out.println(p.fetch("../html/buyer/calc_deferred_list_excel.html"));
    return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.calc_deferred_list");
p.setVar("menu_cd","000091");
p.setLoop("code_calc_day",u.arr2loop(code_calc_day));
p.setVar("sumInfo", sumInfo);
p.setLoop("list", ds);
p.setVar("list_query", u.getQueryString("yyyymm,member_no,pay_sdate,pay_edate,pay_amount"));
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>