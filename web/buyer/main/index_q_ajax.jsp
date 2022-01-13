<%@ page contentType="text/html; charset=EUC-KR"%><%@ include file="init.jsp"%>
<%
	String reqYM     = u.request("reqYM");			//	통계기준년월
	String member_no = u.request("member_no");	//	회원번호
	
	List<String>	lJson	=	new	ArrayList<String>();
	
	String	curYM	=	u.getTimeString("yyyyMM");
	
	long	lIngJob	 =	0;	//	해야할일건수
	long	lFinJob	 =	0;	//	업무완료건수
	long	lEstiCnt =	0;	//	이용현황(견적) 건수
	long	lBidCnt	 =	0;	//	이용현황(입찰) 건수
	long	lContCnt =	0;	//	이용현황(계약) 건수
	long	lWorkCnt =	0;	//	이용현황(근로계약) 건수

	/* 견적건수 */
	StringBuffer	sb	=	new	StringBuffer();
	sb.append("select (select count (main_member_no) ");
	sb.append("          from tcb_bid_master ");
	sb.append("         where main_member_no = '"+member_no+"' ");
	sb.append("           and bid_kind_cd = '90') esti_cnt, ");
	sb.append("       (select count (main_member_no) ");
	sb.append("          from tcb_bid_master ");
	sb.append("         where main_member_no = '"+member_no+"' ");
	sb.append("           and bid_kind_cd = '90' ");
	sb.append("           and status = '01' ");
	sb.append("           and submit_sdate < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') esti_01_cnt, ");
	sb.append("       (select count (main_member_no) ");
	sb.append("          from tcb_bid_master ");
	sb.append("         where main_member_no = '"+member_no+"' ");
	sb.append("           and bid_kind_cd = '90' ");
	sb.append("           and status in ('07', '91', '94') ");
	sb.append("           and submit_sdate > '"+reqYM+"01000000' ");
	sb.append("           and submit_sdate < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') esti_07_cnt, ");
	sb.append("       (select count(main_member_no) cnt ");
	sb.append("          from tcb_bid_master ");
	sb.append("         where main_member_no = '"+member_no+"' ");
	sb.append("           and bid_kind_cd = '90' ");
	sb.append("           and status in ('07', '91', '94') "); 
	sb.append("           and submit_sdate < to_char ( last_day ( to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') esti_use_cnt ");
	sb.append("  from dual ");
	DataSet	estiDS	=	new DataObject().query(sb.toString());
	while(estiDS.next())
	{
		lIngJob	+=	estiDS.getLong("esti_01_cnt");
		lFinJob	+=	estiDS.getLong("esti_07_cnt");
		lEstiCnt	=	estiDS.getLong("esti_use_cnt");
	}
	
	lJson.add("\"esti\":" + u.loop2json(estiDS)); 
	
	/* 입찰 건수 */
	sb	=	new	StringBuffer();
	sb.append("select (select count (main_member_no) cnt ");
	sb.append("          from tcb_bid_master a ");
	sb.append("         where a.bid_kind_cd not in ('90') ");
	sb.append("           and a.main_member_no = '"+member_no+"') bid_cnt, ");
	sb.append("       (select count (main_member_no) cnt ");
	sb.append("          from tcb_bid_master a ");
	sb.append("         where a.bid_kind_cd not in ('90') ");
	sb.append("           and a.main_member_no = '"+member_no+"' ");
	sb.append("           and a.status = '01' ");
  sb.append("		        and a.reg_date < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') bid_01_cnt, ");
	sb.append("       (select count (main_member_no) cnt ");
	sb.append("          from tcb_bid_master ");
	sb.append("         where bid_kind_cd not in ('90') ");
	sb.append("           and main_member_no = '"+member_no+"' ");
	sb.append("           and field_yn = 'Y' ");
	sb.append("           and bid_deg = '0' ");
	sb.append("           and field_date < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999' ");
	sb.append("           and status = '02') bid_02_cnt, ");
	sb.append("       (select count (main_member_no) ");
	sb.append("          from tcb_bid_master a ");
	sb.append("         where a.bid_kind_cd not in ('90') ");
	sb.append("           and a.main_member_no = '"+member_no+"' ");
	sb.append("           and a.bid_date < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999' ");
	sb.append("           and a.status = '04') bid_04_cnt, ");
	sb.append("       (select count(main_member_no) cnt ");
	sb.append("          from tcb_bid_master ");
	sb.append("         where bid_kind_cd not in ('90') ");
	sb.append("           and main_member_no = '"+member_no+"' ");
	sb.append("           and succ_method in ('02','03','06') ");
	sb.append("           and (status in ('05','06','07') or (status in ('91','92','94') and evaluate_status = '20')) ");  
	sb.append("           and  bid_date < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999' ");
	sb.append("           and  evaluate_status = '00') bid_eval_cnt, ");
	sb.append("       (select count(main_member_no) cnt ");
	sb.append("          from tcb_bid_master ");
	sb.append("         where main_member_no = '"+member_no+"' ");
	sb.append("           and bid_kind_cd not in ('90') ");
	sb.append("           and status = '05' ");
	sb.append("           and ( succ_method in ( '01','04','05','07','08','09','10','13' ) or ( succ_method in ( '02','03','06' ) and evaluate_status = '20' ) ) ");
	sb.append("           and bid_date <= to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') ");
	sb.append("           and submit_edate < to_char(sysdate,'yyyymmddhh24miss')) bid_05_cnt, ");
	sb.append("       (select count(main_member_no) cnt ");
	sb.append("          from tcb_bid_master ");
	sb.append("         where main_member_no = '"+member_no+"' ");
	sb.append("           and bid_kind_cd not in ('90') ");
	sb.append("           and status = '06' ");
  sb.append("		        and open_date  < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999' ) bid_06_cnt, ");
	sb.append("       (select count(main_member_no) cnt ");
	sb.append("          from tcb_bid_master ");
	sb.append("         where main_member_no = '"+member_no+"' ");
	sb.append("           and bid_kind_cd not in ('90') ");
	sb.append("           and status in ( '07','91','94' ) ");
	sb.append("           and bid_date >= '"+reqYM+"01' "); 
	sb.append("           and bid_date <= to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd'))  bid_07_cnt, ");
	sb.append("       (select count(main_member_no) cnt ");
	sb.append("          from tcb_bid_master ");
	sb.append("         where main_member_no = '"+member_no+"' ");
	sb.append("           and bid_kind_cd not in ('90') ");
	sb.append("           and status in ( '07','91','94' ) ");
	sb.append("           and bid_date <= to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd'))  bid_use_cnt ");
	sb.append("  from dual ");
	DataSet	bidDS	=	new DataObject().query(sb.toString());
	while(bidDS.next())
	{
		lIngJob	+=	bidDS.getLong("bid_01_cnt");
		lIngJob	+=	bidDS.getLong("bid_02_cnt");
		lIngJob	+=	bidDS.getLong("bid_04_cnt");
		lIngJob	+=	bidDS.getLong("bid_eval_cnt");
		lIngJob	+=	bidDS.getLong("bid_05_cnt");
		lIngJob	+=	bidDS.getLong("bid_06_cnt");		
		lFinJob	+=	bidDS.getLong("bid_07_cnt");
		lBidCnt	=	 	bidDS.getLong("bid_use_cnt");
	}
	lJson.add("\"bid\":" + u.loop2json(bidDS));
	
	sb	=	new	StringBuffer();
  sb.append("select (select count(cont_no) cnt ");
	sb.append("          from tcb_contmaster a ");
	sb.append("         inner join tcb_cont_template b  on b.template_cd = a.template_cd and b.doc_gubun not in ('10', '11') ");
	sb.append("         where a.member_no = '"+member_no+"') cont_cnt, ");
	sb.append("         (select count(cont_no) cnt ");
	sb.append("            from tcb_contmaster a ");
	sb.append("           inner join tcb_cont_template b  on b.template_cd = a.template_cd and b.doc_gubun not in ('10', '11') ");
	sb.append("           where a.member_no = '"+member_no+"' ");
	sb.append("             and a.status = '10' ");
  sb.append("             and a.reg_date  < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') cont_10_cnt, ");
  sb.append("         (select count(a.cont_no) cnt ");
  sb.append("            from tcb_contmaster a ");
  sb.append("           inner join tcb_cont_template b  on b.template_cd = a.template_cd and b.doc_gubun not in ('10', '11') ");
  sb.append("           inner join tcb_cont_log c on c.cont_no = a.cont_no and c.cont_chasu = a.cont_chasu and c.cont_status = a.status and c.log_seq = (select max(log_seq) from tcb_cont_log where cont_no = c.cont_no and cont_chasu = c.cont_chasu and cont_status = c.cont_status) ");
  sb.append("           where a.member_no = '"+member_no+"' ");
  sb.append("             and a.status = '20' ");
	sb.append("	            and a.subscription_yn is null ");
	sb.append("             and c.log_date < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') cont_20_cnt, ");
  sb.append("         (select count(a.cont_no) cnt ");
  sb.append("            from tcb_contmaster a ");
  sb.append("           inner join tcb_cont_template b  on b.template_cd = a.template_cd and b.doc_gubun not in ('10', '11') ");
  sb.append("           inner join tcb_cont_log c on c.cont_no = a.cont_no and c.cont_chasu = a.cont_chasu and c.cont_status = a.status and c.log_seq = (select max(log_seq) from tcb_cont_log where cont_no = c.cont_no and cont_chasu = c.cont_chasu and cont_status = c.cont_status) ");
  sb.append("           where a.member_no = '"+member_no+"' ");
  sb.append("             and a.status = '30' ");
	sb.append("	            and a.subscription_yn is null ");
  sb.append("             and c.log_date < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') cont_30_cnt, ");
  sb.append("         (select count(a1.cont_no) cnt ");
  sb.append("            from( ");
  sb.append("                 select a.cont_no, a.cont_chasu, nvl((select max(sign_date) from tcb_cust where cont_no = a.cont_no and cont_chasu = a.cont_chasu),a.cont_date||'000001') sign_date ");
  sb.append("                   from tcb_contmaster a ");
  sb.append("                  inner join tcb_cont_template b  on b.template_cd = a.template_cd and b.doc_gubun not in ('10', '11') ");
  sb.append("                  where a.member_no = '"+member_no+"' ");
  sb.append("                    and  a.status in ('50','91','99') ");              
  sb.append("                    and  a.subscription_yn is null ");
  sb.append("                )a1 ");
  sb.append("           where a1.sign_date > '"+reqYM+"01000000' ");
	sb.append("	            and a1.sign_date < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') cont_50_cnt, ");
	sb.append("         (select count(a1.cont_no) cnt ");
  sb.append("            from( ");
  sb.append("                 select a.cont_no, a.cont_chasu, nvl((select max(sign_date) from tcb_cust where cont_no = a.cont_no and cont_chasu = a.cont_chasu),a.cont_date||'000001') sign_date ");
  sb.append("                   from tcb_contmaster a ");
  sb.append("                  inner join tcb_cont_template b  on b.template_cd = a.template_cd and b.doc_gubun not in ('10', '11') ");
  sb.append("                  where a.member_no = '"+member_no+"' ");
  sb.append("                    and  a.status in ('50','91','99') ");              
  sb.append("                    and  a.subscription_yn is null ");
  sb.append("                )a1 ");
  sb.append("	          where a1.sign_date < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') cont_use_cnt ");
  sb.append("  from dual ");
  DataSet	contDS	=	new DataObject().query(sb.toString());
	while(contDS.next())
	{
		lIngJob		+=	contDS.getLong("cont_10_cnt");
		lIngJob		+=	contDS.getLong("cont_20_cnt");
		lIngJob		+=	contDS.getLong("cont_30_cnt");
		lFinJob		+=	contDS.getLong("cont_50_cnt");
		lContCnt	=	 	contDS.getLong("cont_use_cnt");
	}
	lJson.add("\"cont\":" + u.loop2json(contDS));
	
	sb	=	new	StringBuffer();
  sb.append("select (select count(cont_no) cnt ");
	sb.append("          from tcb_contmaster a ");
	sb.append("         inner join tcb_cont_template b  on b.template_cd = a.template_cd and b.doc_gubun in ('10', '11') ");
	sb.append("         where a.member_no = '"+member_no+"') work_cnt, ");
	sb.append("         (select count(cont_no) cnt ");
	sb.append("            from tcb_contmaster a ");
	sb.append("           inner join tcb_cont_template b  on b.template_cd = a.template_cd and b.doc_gubun in ('10', '11') ");
	sb.append("           where a.member_no = '"+member_no+"' ");
	sb.append("             and a.status = '10' ");
	sb.append("             and a.reg_date  < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') work_10_cnt, ");
	sb.append("         (select count(a.cont_no) cnt ");
	sb.append("            from tcb_contmaster a ");
	sb.append("           inner join tcb_cont_template b  on b.template_cd = a.template_cd and b.doc_gubun in ('10', '11') ");
	sb.append("           inner join tcb_cont_log c on c.cont_no = a.cont_no and c.cont_chasu = a.cont_chasu and c.cont_status = a.status and c.log_seq = (select max(log_seq) from tcb_cont_log where cont_no = c.cont_no and cont_chasu = c.cont_chasu and cont_status = c.cont_status) ");
	sb.append("           where a.member_no = '"+member_no+"' ");
	sb.append("             and a.status = '20' ");
	sb.append("	            and a.subscription_yn is null ");
  sb.append("             and c.log_date < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') work_20_cnt, ");			
	sb.append("         (select count(a.cont_no) cnt ");
	sb.append("            from tcb_contmaster a ");
	sb.append("           inner join tcb_cont_template b  on b.template_cd = a.template_cd and b.doc_gubun in ('10', '11') ");
	sb.append("           inner join tcb_cont_log c on c.cont_no = a.cont_no and c.cont_chasu = a.cont_chasu and c.cont_status = a.status and c.log_seq = (select max(log_seq) from tcb_cont_log where cont_no = c.cont_no and cont_chasu = c.cont_chasu and cont_status = c.cont_status) ");
	sb.append("           where a.member_no = '"+member_no+"' ");
	sb.append("             and a.subscription_yn is null ");
	sb.append("             and a.status = '30' ");
	sb.append("             and c.log_date < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') work_30_cnt, ");		
	sb.append("         (select count(a1.cont_no) cnt ");
  sb.append("            from( ");
  sb.append("                 select a.cont_no, a.cont_chasu, nvl((select max(sign_date) from tcb_cust where cont_no = a.cont_no and cont_chasu = a.cont_chasu),a.cont_date||'000001') sign_date ");
  sb.append("                   from tcb_contmaster a ");
  sb.append("                  inner join tcb_cont_template b  on b.template_cd = a.template_cd and b.doc_gubun in ('10', '11') ");
  sb.append("                  where a.member_no = '"+member_no+"' ");
  sb.append("                    and  a.status in ('50','91','99') ");              
  sb.append("                    and  a.subscription_yn is null ");
  sb.append("                )a1 ");
  sb.append("           where a1.sign_date > '"+reqYM+"01000000' ");
	sb.append("	            and a1.sign_date < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') work_50_cnt, ");
	sb.append("         (select count(a1.cont_no) cnt ");
  sb.append("            from( ");
  sb.append("                 select a.cont_no, a.cont_chasu, nvl((select max(sign_date) from tcb_cust where cont_no = a.cont_no and cont_chasu = a.cont_chasu),a.cont_date||'000001') sign_date ");
  sb.append("                   from tcb_contmaster a ");
  sb.append("                  inner join tcb_cont_template b  on b.template_cd = a.template_cd and b.doc_gubun in ('10', '11') ");
  sb.append("                  where a.member_no = '"+member_no+"' ");
  sb.append("                    and  a.status in ('50','91','99') ");              
  sb.append("                    and  a.subscription_yn is null ");
  sb.append("                )a1 ");
	sb.append("	          where a1.sign_date < to_char (last_day (to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') work_use_cnt ");
  sb.append("  from dual ");
  DataSet	workDS	=	new DataObject().query(sb.toString());
	while(workDS.next())
	{
		lIngJob		+=	workDS.getLong("work_10_cnt");
		lIngJob		+=	workDS.getLong("work_20_cnt");
		lIngJob		+=	workDS.getLong("work_30_cnt");
		lFinJob		+=	workDS.getLong("work_50_cnt");
		lWorkCnt	=	 	workDS.getLong("work_use_cnt");
	}
	lJson.add("\"work\":" + u.loop2json(workDS));
	
	sb	=	new	StringBuffer();
	sb.append("select a3.member_no, ");
	sb.append("       case when a3.field_seq = 999999 then '기타 부서' else nvl ( (select field_name ");
	sb.append("                                                                      from tcb_field ");
	sb.append("                                                                     where member_no = a3.member_no ");
	sb.append("                                                                       and field_seq = a3.field_seq), '부서 미지정') end field_name, ");
	sb.append("       a3.field_seq, ");
	sb.append("       sum (a3.cnt) cnt ");
	sb.append("  from (select case when a2.rnum > 5 then 999999 else a2.field_seq end field_seq, ");
	sb.append("               a2.cnt, ");
	sb.append("               a2.member_no ");
	sb.append("          from (select rownum rnum, ");
	sb.append("                       a1.field_seq, ");
	sb.append("                       a1.cnt, ");
	sb.append("                       a1.member_no ");
	sb.append("                  from (  select a.field_seq, ");
	sb.append("                                 count (a.person_seq) cnt, ");
	sb.append("                                 a.member_no ");
	sb.append("                            from tcb_person a ");
	sb.append("                           where a.member_no = '"+member_no+"' ");
	sb.append("                             and a.reg_date < to_char ( last_day ( to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999' ");
	sb.append("                             and a.status > 0 ");
	sb.append("                           group by a.member_no, a.field_seq ");
	sb.append("                           order by count (a.person_seq) desc) a1) a2) a3 ");
	sb.append(" group by a3.member_no, a3.field_seq ");
	sb.append(" order by case when a3.field_seq = 999999 then 0 else sum (a3.cnt) end desc ");

	DataSet	personDS	=	new DataObject().query(sb.toString());
	lJson.add("\"person\":" + u.loop2json(personDS));
	
	sb	=	new	StringBuffer();
	sb.append("select decode (a1.member_gubun, '01', '법인사업자', '03', '개인사업자', '개인') member_gubun_nm, ");
	sb.append("       count (a1.member_gubun) cnt ");
	sb.append("  from (select case when b.member_gubun in ('01', '02') then '01' else b.member_gubun end member_gubun ");
	sb.append("          from tcb_client a ");
	sb.append("         inner join tcb_member b on b.member_no = a.client_no ");
	sb.append("         where a.member_no = '"+member_no+"' ");
	sb.append("           and a.client_reg_date < to_char ( last_day ( to_date ('"+reqYM+"01', 'yyyymmdd')), 'yyyymmdd') || '999999') a1 ");
	sb.append(" group by a1.member_gubun ");
	sb.append(" order by a1.member_gubun ");
	DataSet	clientDS	=	new DataObject().query(sb.toString());
	lJson.add("\"client\":" + u.loop2json(clientDS));
	
	DataSet	serviceDS	=	new DataSet();
	if(lEstiCnt > 0)
	{
		serviceDS.addRow();
		serviceDS.put("nm",  "견적");
		serviceDS.put("cnt", Long.toString(lEstiCnt));	
	}
	if(lBidCnt > 0)
	{
		serviceDS.addRow();
		serviceDS.put("nm",  "입찰");
		serviceDS.put("cnt", Long.toString(lBidCnt));	
	}
	if(lContCnt > 0)
	{
		serviceDS.addRow();
		serviceDS.put("nm",  "계약");
		serviceDS.put("cnt", Long.toString(lContCnt));	
	}
	if(lWorkCnt > 0)
	{
		serviceDS.addRow();
		serviceDS.put("nm",  "근로계약");
		serviceDS.put("cnt", Long.toString(lWorkCnt));	
	}
	
	lJson.add("\"service\":" + u.loop2json(serviceDS));

	DataSet	totDS	=	new	DataSet();
	totDS.addRow();
	totDS.put("ing_cnt", Long.toString(lIngJob));
	totDS.put("fin_cnt", Long.toString(lFinJob));
	lJson.add("\"tot\":" + u.loop2json(totDS));
	
  StringBuffer	sbJson	=	new	StringBuffer();
	sbJson.append("{");
	for(int i=0; i<lJson.size(); i++)
	{
		if(i > 0)
		{
			sbJson.append(",");	
		}
		sbJson.append(lJson.get(i));
	}
	sbJson.append("}");
	
	System.out.println(sbJson.toString());
	
	out.print(sbJson.toString());
%>