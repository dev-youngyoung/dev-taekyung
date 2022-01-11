<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
if(auth.getString("_ADMIN_ID")==null||auth.getString("_ADMIN_ID").equals("")){
	u.redirect("index.jsp");
	return;
}

String s_edate = u.request("s_edate",u.getTimeString("yyyy-MM-dd"));
f.addElement("s_edate", s_edate, null);
String edate = f.get("s_edate").replaceAll("-", "")+"999999";


DataObject memberDao = new DataObject("tck_member");
DataSet member = memberDao.query(
 " select 'supplier' gubun                                      "
+"      ,  sum( decode(pay_comp_yn,'Y',1,0))  pay_comp_cnt      "
+"      ,  sum( decode(pay_comp_yn,'Y',0,1)) comp_cnt           "
+"   from tck_member                                            "
+"  union all                                                   "
+" select 'buyer' gubun                                         "
+"      , sum(decode(member_type,'01',1,'03',1,0))  pay_comp_cnt"
+"      , sum(decode(member_type,'01',0,'03',0,1))  comp_cnt    "
+"   from tcb_member                                            "
+"  union all                                                   "
+" select 'fc' gubun                                            "
+"      , sum(decode(member_type,'10',1,0))  pay_comp_cnt       "
+"      , sum(decode(member_type,'01',0,1))  comp_cnt           "
+"   from tcf_member                                            "
+" union all                                                    "
+" select 'logis' gubun                                         "
+"      , sum(decode(member_type,'01',1,0))  pay_comp_cnt       "
+"      , sum(decode(member_type,'01',0,1))  comp_cnt           "
+"   from tcl_member                                            "
		);
DataSet sumMember = new DataSet();
sumMember.addRow();
while(member.next()){
	sumMember.put(member.getString("gubun")+"_pay_comp_cnt", u.numberFormat(member.getString("pay_comp_cnt")) );
	sumMember.put(member.getString("gubun")+"_comp_cnt", u.numberFormat(member.getString("comp_cnt")) );
}

DataObject contDao = new DataObject("tck_contmaster");
DataSet sumCont = contDao.query(
 " select                                                                         "
+"        (select count(*) from tck_contmaster where status <> '00') supplier_cnt "
+"      , (select count(*) from tcb_contmaster where status <> '00') buyer_cnt    "
+"      , (select count(*) from tcf_contmaster where status <> '00') fc_cnt       "
+"      , (select count(*) from tcl_contmaster where status <> '00') logis_cnt    "
+"   from dual                                                                    "
		);
if(!sumCont.next()){
}
sumCont.put("supplier_cnt", u.numberFormat(sumCont.getString("supplier_cnt")));
sumCont.put("buyer_cnt", u.numberFormat(sumCont.getString("buyer_cnt")));
sumCont.put("fc_cnt", u.numberFormat(sumCont.getString("fc_cnt")));
sumCont.put("logis_cnt", u.numberFormat(sumCont.getString("logis_cnt")));


DataObject memDao = new DataObject();
DataSet sumMemberSpe = memDao.query(
" select "+
		"(" +
				"    select sum(cnt) from (" +
					"    select count(*)-511 cnt from tck_member where member_type not IN ('01', '03') and  member_gubun in ('01','02') and join_date < '"+edate+"'  " + // -- 수급사업자 (건설)
					"    union" +
					"    select count(*)-55 cnt from tcb_member where member_type not IN ('01', '03') and  member_gubun in ('01','02') and join_date < '"+edate+"' " + //-- 비건설 (수급)
					"    union" +
					"    select count(*)-5 cnt from tcl_member where member_type not IN ('01', '03') and  member_gubun in ('01','02') and join_date < '"+edate+"' " + //-- 물류(수급)
					"    union" +
					"    select count(*) cnt from tcf_member where member_type not IN ('01', '03') and  member_gubun in ('01','02') and join_date < '"+edate+"' " + // -- 프랜차이즈(수급)
				"    )" +
		") member_type1, " +  // 법인사업(03)
		"( " +
				"    select sum(cnt) from (" +
					"    select count(*) cnt from tck_member where member_type not IN ('01', '03') and  member_gubun in ('03') and join_date < '"+edate+"' " + // -- 수급사업자 (건설)
					"    union" +
					"    select count(*) cnt from tcb_member where member_type not IN ('01', '03') and  member_gubun in ('03') and join_date < '"+edate+"' " + // -- 비건설 (수급)
					"    union" +
					"    select count(*) cnt from tcl_member where member_type not IN ('01', '03') and  member_gubun in ('03') and join_date < '"+edate+"' " + // -- 물류(수급)
					"    union" +
					"    select count(*) cnt from tcf_member where member_type not IN ('01', '03') and  member_gubun in ('03') and join_date < '"+edate+"' " + // -- 프랜차이즈(수급)
				"    ) " +
		") member_type2, " + // 개인사업(03)
		"( " +
				"    select sum(cnt) from (" +
					"    select count(*) cnt from tck_member where member_type not IN ('01', '03') and  member_gubun in ('04') and join_date < '"+edate+"' " + // -- 수급사업자 (건설)
					"    union" +
					"    select count(*) cnt from tcb_member where member_type not IN ('01', '03') and  member_gubun in ('04') and join_date < '"+edate+"' " + // -- 비건설 (수급)
					"    union" +
					"    select count(*) cnt from tcl_member where member_type not IN ('01', '03') and  member_gubun in ('04') and join_date < '"+edate+"' " + // -- 물류(수급)
					"    union" +
					"    select count(*) cnt from tcf_member where member_type not IN ('01', '03') and  member_gubun in ('04') and join_date < '"+edate+"' " + // -- 프랜차이즈(수급)
				"    ) " +
		") member_type3 "  // 개인(04)
+"from dual "
);
if(!sumMemberSpe.next()){
}
sumMemberSpe.put("member_type1_cnt", u.numberFormat(sumMemberSpe.getString("member_type1")));
sumMemberSpe.put("member_type2_cnt", u.numberFormat(sumMemberSpe.getString("member_type2")));
sumMemberSpe.put("member_type3_cnt", u.numberFormat(sumMemberSpe.getString("member_type3")));
sumMemberSpe.put("member_type_sum", "0");
sumMemberSpe.put("member_type_sum", u.numberFormat(sumMemberSpe.getInt("member_type1") + sumMemberSpe.getInt("member_type2") + sumMemberSpe.getInt("member_type3")));

DataObject bidDao = new DataObject("tck_bid_master");
DataSet sumBid = bidDao.query(
 " select                                                                         "
+"        (select count(*) from tck_bid_master where status <> '00') supplier_cnt "
+"      , (select count(*) from tcb_bid_master where status <> '00') buyer_cnt    "
+"   from dual                                                                    "
		);
if(!sumBid.next()){
}
sumBid.put("supplier_cnt", u.numberFormat(sumBid.getString("supplier_cnt")));
sumBid.put("buyer_cnt", u.numberFormat(sumBid.getString("buyer_cnt")));



p.setLayout("default");
p.setDebug(out);
p.setBody("main.index2");
p.setVar("sumMember",sumMember);
p.setVar("sumMemberSpe",sumMemberSpe);
p.setVar("sumCont",sumCont);
p.setVar("sumBid",sumBid);
p.setVar("form_script",f.getScript());
p.display(out);
%>