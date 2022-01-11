<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd",u.addDate("Y",-1)));
String s_edate = u.request("s_edate", u.getTimeString("yyyy-MM-dd"));
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);


DataObject clientDao = new DataObject("tcb_client");


DataSet list = clientDao.query(                                                
  "select                                                                      "
 +"       c.src_cd                                                             "
 +"     , (                                                                    "
 +"        select src_nm                                                       "
 +"          from tcb_src_adm                                                  "
 +"         where member_no = a.member_no                                      "
 +"           and src_cd = c.src_cd                                            "
 +"       ) src_nm                                                             "
 +"     , b.member_name                                                        "
 +"     , (                                                                    "
 +"         select  count(*)                                                   "
 +"            from tcb_bid_master aa, tcb_bid_supp ab                         "
 +"         where aa.main_member_no = ab.main_member_no                        "
 +"             and aa.bid_no = ab.bid_no                                      "
 +"             and aa.bid_deg = ab.bid_deg                                    "
 +"             and aa.main_member_no = '20160901598'                          "
 +"             and aa.bid_kind_cd = '90'                                      "
 +"             and aa.status = '07'                                           "
 +"             and ab.member_no = b.member_no                                 "
 +"             and aa.bid_date >= '"+s_sdate.replaceAll("-","")+"'            "
 +"             and aa.bid_date <= '"+s_edate.replaceAll("-","")+"'            "
 +"         ) esti_select_cnt                                                  "
 +"      , (                                                                   "
 +"         select  count(*)                                                   "
 +"            from tcb_bid_master aa, tcb_bid_supp ab                         "
 +"         where aa.main_member_no = ab.main_member_no                        "
 +"             and aa.bid_no = ab.bid_no                                      "
 +"             and aa.bid_deg = ab.bid_deg                                    "
 +"             and aa.main_member_no = '20160901598'                          "
 +"             and aa.bid_kind_cd = '90'                                      "
 +"             and aa.status = '07'                                           "
 +"             and ab.status = '30'                                           "
 +"             and ab.member_no = b.member_no                                 "
 +"             and aa.bid_date >= '"+s_sdate.replaceAll("-","")+"'            "
 +"             and aa.bid_date <= '"+s_edate.replaceAll("-","")+"'            "
 +"         ) esti_submit_cnt                                                  "
 +"     , (                                                                    "
 +"         select  count(*)                                                   "
 +"            from tcb_bid_master aa, tcb_bid_supp ab                         "
 +"         where aa.main_member_no = ab.main_member_no                        "
 +"             and aa.bid_no = ab.bid_no                                      "
 +"             and aa.bid_deg = ab.bid_deg                                    "
 +"             and aa.main_member_no = '20160901598'                          "
 +"             and aa.bid_kind_cd = '90'                                      "
 +"             and aa.status = '07'                                           "
 +"             and ab.bid_succ_yn = 'Y'                                       "
 +"             and ab.member_no = b.member_no                                 "
 +"             and aa.bid_date >= '"+s_sdate.replaceAll("-","")+"'            "
 +"             and aa.bid_date <= '"+s_edate.replaceAll("-","")+"'            "
 +"         ) esti_succ_cnt                                                    "
 +"     , (                                                                    "
 +"         select  sum(ab.total_cost)                                         "
 +"            from tcb_bid_master aa, tcb_bid_supp ab                         "
 +"         where aa.main_member_no = ab.main_member_no                        "
 +"             and aa.bid_no = ab.bid_no                                      "
 +"             and aa.bid_deg = ab.bid_deg                                    "
 +"             and aa.main_member_no = '20160901598'                          "
 +"             and aa.bid_kind_cd = '90'                                      "
 +"             and aa.status = '07'                                           "
 +"             and ab.bid_succ_yn = 'Y'                                       "
 +"             and ab.member_no = b.member_no                                 "
 +"             and aa.bid_date >= '"+s_sdate.replaceAll("-","")+"'            "
 +"             and aa.bid_date <= '"+s_edate.replaceAll("-","")+"'            "
 +"         ) esti_succ_amt                                                    "
 +"        , (                                                                 "
 +"         select  count(*)                                                   "
 +"            from tcb_bid_master aa, tcb_bid_supp ab                         "
 +"         where aa.main_member_no = ab.main_member_no                        "
 +"             and aa.bid_no = ab.bid_no                                      "
 +"             and aa.bid_deg = ab.bid_deg                                    "
 +"             and aa.main_member_no = '20160901598'                          "
 +"             and aa.bid_kind_cd in ('10','20','30')                         "
 +"             and ab.member_no = b.member_no                                 "
 +"             and aa.status = '07'                                           "
 +"             and aa.bid_date >= '"+s_sdate.replaceAll("-","")+"'            "
 +"             and aa.bid_date <= '"+s_edate.replaceAll("-","")+"'            "
 +"         ) bid_select_cnt                                                   "
 +"         ,(                                                                 "
 +"         select  count(*)                                                   "
 +"            from tcb_bid_master aa, tcb_bid_supp ab                         "
 +"         where aa.main_member_no = ab.main_member_no                        "
 +"             and aa.bid_no = ab.bid_no                                      "
 +"             and aa.bid_deg = ab.bid_deg                                    "
 +"             and aa.main_member_no = '20160901598'                          "
 +"             and aa.bid_kind_cd in ('10','20','30')                         "
 +"             and ab.member_no = b.member_no                                 "
 +"             and aa.status = '07'                                           "
 +"             and ab.status <> '10'                                          "
 +"             and aa.bid_date >= '"+s_sdate.replaceAll("-","")+"'            "
 +"             and aa.bid_date <= '"+s_edate.replaceAll("-","")+"'            "
 +"         ) bid_response_cnt                                                 "
 +"         ,(                                                                 "
 +"         select  count(*)                                                   "
 +"            from tcb_bid_master aa, tcb_bid_supp ab                         "
 +"         where aa.main_member_no = ab.main_member_no                        "
 +"             and aa.bid_no = ab.bid_no                                      "
 +"             and aa.bid_deg = ab.bid_deg                                    "
 +"             and aa.main_member_no = '20160901598'                          "
 +"             and aa.bid_kind_cd in ('10','20','30')                         "
 +"             and ab.member_no = b.member_no                                 "
 +"             and ab.status = '30'                                           "
 +"             and aa.status = '07'                                           "
 +"             and aa.bid_date >= '"+s_sdate.replaceAll("-","")+"'            "
 +"             and aa.bid_date <= '"+s_edate.replaceAll("-","")+"'            "
 +"         ) bid_submit_cnt                                                   "
 +"         ,(                                                                 "
 +"         select  count(*)                                                   "
 +"            from tcb_bid_master aa, tcb_bid_supp ab                         "
 +"         where aa.main_member_no = ab.main_member_no                        "
 +"             and aa.bid_no = ab.bid_no                                      "
 +"             and aa.bid_deg = ab.bid_deg                                    "
 +"             and aa.main_member_no = '20160901598'                          "
 +"             and aa.bid_kind_cd in ('10','20','30')                         "
 +"             and ab.member_no = b.member_no                                 "
 +"             and ab.bid_succ_yn = 'Y'                                       "
 +"             and aa.status = '07'                                           "
 +"             and aa.bid_date >= '"+s_sdate.replaceAll("-","")+"'            "
 +"             and aa.bid_date <= '"+s_edate.replaceAll("-","")+"'            "
 +"         ) bid_succ_cnt                                                     "
 +"          ,(                                                                "
 +"         select  sum(total_cost)                                            "
 +"            from tcb_bid_master aa, tcb_bid_supp ab                         "
 +"         where aa.main_member_no = ab.main_member_no                        "
 +"             and aa.bid_no = ab.bid_no                                      "
 +"             and aa.bid_deg = ab.bid_deg                                    "
 +"             and aa.main_member_no = '20160901598'                          "
 +"             and aa.bid_kind_cd in ('10','20','30')                         "
 +"             and ab.member_no = b.member_no                                 "
 +"             and ab.bid_succ_yn = 'Y'                                       "
 +"             and aa.status = '07'                                           "
 +"             and aa.bid_date >= '"+s_sdate.replaceAll("-","")+"'            "
 +"             and aa.bid_date <= '"+s_edate.replaceAll("-","")+"'            "
 +"         ) bid_succ_amt                                                     "
 +"          ,(                                                                "
 +"         select  count(*)                                                   "
 +"            from tcb_bid_master aa, tcb_bid_supp ab                         "
 +"         where aa.main_member_no = ab.main_member_no                        "
 +"             and aa.bid_no = ab.bid_no                                      "
 +"             and aa.bid_deg = ab.bid_deg                                    "
 +"             and aa.main_member_no = '20160901598'                          "
 +"             and aa.bid_kind_cd in ('10','20','30')                         "
 +"             and ab.member_no = b.member_no                                 "
 +"             and ab.member_no = b.member_no                                 "
 +"             and aa.status = '07'                                           "
 +"             and ab.status = '10'                                           "
 +"             and aa.bid_date >= '"+s_sdate.replaceAll("-","")+"'            "
 +"             and aa.bid_date <= '"+s_edate.replaceAll("-","")+"'            "
 +"         ) bid_not_join_cnt                                                 "
 +"         ,(                                                                 "
 +"         select  count(*)                                                   "
 +"            from tcb_bid_master aa, tcb_bid_supp ab                         "
 +"         where aa.main_member_no = ab.main_member_no                        "
 +"             and aa.bid_no = ab.bid_no                                      "
 +"             and aa.bid_deg = ab.bid_deg                                    "
 +"             and aa.main_member_no = '20160901598'                          "
 +"             and aa.bid_kind_cd in ('10','20','30')                         "
 +"             and ab.member_no = b.member_no                                 "
 +"             and aa.status = '07'                                           "
 +"             and ab.status in ('92')                                        "
 +"             and aa.bid_date >= '"+s_sdate.replaceAll("-","")+"'            "
 +"             and aa.bid_date <= '"+s_edate.replaceAll("-","")+"'            "
 +"         ) bid_giveup_cnt                                                   "
 +"         , (                                                                "
 +"        select count(*)                                                     "
 +"           from tcb_assemaster aa, tcb_assedetail ab, tcb_bid_master ac     "
 +"          where aa.asse_no = ab.asse_no                                     "
 +"            and aa.main_member_no = ac.main_member_no                       "
 +"            and aa.bid_no = ac.bid_no                                       "
 +"            and aa.bid_deg = ac.bid_deg                                     "
 +"            and aa.main_member_no = '20160901598'                           "
 +"            and aa.s_yn = 'Y'                                               "
 +"            and ab.template_cd = '2017001'                                  "
 +"            and ab.status = '20'                                            "
 +"            and aa.member_no = b.member_no                                  "
 +"            and ac.bid_date >= '"+s_sdate.replaceAll("-","")+"'             "
 +"            and ac.bid_date <= '"+s_edate.replaceAll("-","")+"'             "
 +"           ) asse_cnt                                                       "
 +"           , (                                                              "
 +"         select TRUNC(avg(total_point),2)                                   "
 +"           from tcb_assemaster aa, tcb_assedetail ab, tcb_bid_master ac     "
 +"          where aa.asse_no = ab.asse_no                                     "
 +"            and aa.main_member_no = ac.main_member_no                       "
 +"            and aa.bid_no = ac.bid_no                                       "
 +"            and aa.bid_deg = ac.bid_deg                                     "
 +"            and aa.main_member_no = '20160901598'                           "
 +"            and aa.s_yn = 'Y'                                               "
 +"            and ab.template_cd = '2017001'                                  "
 +"            and ab.status = '20'                                            "
 +"            and aa.member_no = b.member_no                                  "
 +"            and ac.bid_date >= '"+s_sdate.replaceAll("-","")+"'             "
 +"            and ac.bid_date <= '"+s_edate.replaceAll("-","")+"'             "
 +"           ) asse_point                                                     "
 +"     from tcb_client a, tcb_member b, tcb_src_member c                      "
 +"    where a.client_no = b.member_no                                         "
 +"      and a.member_no = c.member_no                                         "
 +"      and a.member_no = c.member_no                                         "
 +"      and a.client_no = c.src_member_no                                     "
 +"      and a.member_no = '20160901598'                                       "
 +"      and c.src_cd in ('001001001','001001002','001001003','001001004','001001005','001001006','001001007') "
 +"      and a.client_type = '1'                                               "
 +"      and a.client_reg_cd = '1'                                             "
 +"    order by src_cd asc, member_name asc                                    "
 
		);

while(list.next()){
	double bid_submit_rate = 0;
	double bid_succ_rate = 0;
	if(list.getInt("bid_submit_cnt")> 0){
		bid_submit_rate = Math.ceil((list.getDouble("bid_submit_cnt")/list.getDouble("bid_select_cnt"))*10000)/100;
		bid_succ_rate = Math.ceil((list.getInt("bid_succ_cnt")/list.getDouble("bid_select_cnt"))*10000)/100;
	}
	list.put("bid_submit_rate", bid_submit_rate);
	list.put("bid_succ_rate", bid_succ_rate);
	list.put("bid_succ_amt", u.numberFormat(list.getString("bid_succ_amt")));
	list.put("bid_optional_amt", u.numberFormat(list.getString("bid_optional_amt")));
	list.put("esti_succ_amt", u.numberFormat(list.getString("esti_succ_amt")));
}

if(f.get("mode").equals("excel")){
	p.setVar("title", "수시평가 기초자료");
	p.setLoop("list", list);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("수시평가기초자료.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/cust/nhqv_asse_list_excel.html"));
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.nhqv_asse_list");
p.setVar("menu_cd","000161");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000161", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", list);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.display(out);
%>
