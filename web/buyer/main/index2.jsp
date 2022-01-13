<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
if(auth.getString("_MEMBER_NO")==null||auth.getString("_MEMBER_NO").equals("")){
	u.redirect("index.jsp");
	return;
}

//알림방
boolean view_gap_pds = false;
boolean view_eul_pds = false;
boolean view_slist = false;
boolean view_rlist = false;
boolean useCont = false;

DataSet slist = new DataSet();

if(auth.getString("_MEMBER_TYPE").equals("01")||auth.getString("_MEMBER_TYPE").equals("03")){//갑사
	view_gap_pds = true;
	view_slist = true;
	CodeDao codeDao = new CodeDao("tcb_comcode");
	
	
	DataObject menuMemberDao = new DataObject("tcb_menu_member");
	if(menuMemberDao.findCount( "member_no = '"+auth.getString("_MEMBER_NO")+"' and menu_cd in ('000033','000036') ")>0){//입찰사용여부
		String[] code_bid_status = codeDao.getCodeArray("M022");
		String[] code_bid_link = {"01=>gap_plan_list.jsp","02=>gap_field_list.jsp","03=>gap_field_list.jsp","04=>gap_bid_list.jsp","05=>gap_bid_list.jsp","06=>gap_select_list.jsp"};
		String[] code_esti_status = codeDao.getCodeArray("M034");
		
		DataObject bidDao = new DataObject("tcb_bid_master");
		DataSet bid = bidDao.query(
				 " select bid_kind_cd, bid_name, submit_edate, status  "
				+"   from tcb_bid_master                                     "
				+"  where main_member_no = '"+auth.getString("_MEMBER_NO")+"'" 
				+"    and status in ('01','02','03','04','05','06')          "
				+"    and reg_id = '"+auth.getString("_USER_ID")+"'          "
				+"  order by bid_no desc                                     "
				,10);
		while(bid.next()){
			slist.addRow();
			if(bid.getString("bid_kind_cd").equals("90")){
				slist.put("gubun", "전자견적");
				slist.put("link", "/web/buyer/esti/gap_esti_list.jsp");
				slist.put("status_nm", u.getItem(bid.getString("status"), code_esti_status));
				if(bid.getString("status").equals("05")&&bid.getLong("submit_edate")<=Long.parseLong(u.getTimeString())){
					slist.put("status_nm","견적마감");
				}
			}else{
				slist.put("gubun", "전자입찰" );
				slist.put("link", "/web/buyer/bid/"+u.getItem(bid.getString("status"),code_bid_link));
				if(bid.getString("status").equals("06")){
					slist.put("status_nm", "낙찰업체선정대상");
				}else{
					slist.put("status_nm", u.getItem(bid.getString("status"), code_bid_status));
				}
			}
			slist.put("name", bid.getString("bid_name"));
		}
		
		DataSet openbid = bidDao.query(
				 " select  bid_kind_cd, bid_name, submit_edate, status  "
				+"   from tcb_bid_master                                     "
				+"  where main_member_no = '"+auth.getString("_MEMBER_NO")+"'" 
				+"    and bid_kind_cd in ('10','20','30') "
				+"    and status in ('05')          "
				+"    and submit_edate <  '"+u.getTimeString()+"'            "
				+"    and open_user_id = '"+auth.getString("_USER_ID")+"'    "
				+"  order by bid_no desc                                     "
				,10);
		while(openbid.next()){
			slist.addRow();
			slist.put("gubun", "전자입찰" );
			slist.put("link", "/web/buyer/bid/gap_open_list.jsp");
			slist.put("status_nm", "<span class='caution-text'>개찰대상</span>");
			slist.put("name", openbid.getString("bid_name"));
		}
	}
	if(menuMemberDao.findCount( "member_no = '"+auth.getString("_MEMBER_NO")+"' and menu_cd = '000053'  ") >0){//전자계약 사용여부
		useCont = true;
		String[] code_cont_status = codeDao.getCodeArray("M008");
		String[] code_recv_status = new String[] {"30=>신청중","41=>반려","50=>완료"};

		DataObject contDao = new DataObject("tcb_contmaster");
		DataSet cont = contDao.query(
			   " select  a.template_cd, a.cont_no, a.cont_chasu , a.cont_name, a.status, a.subscription_yn "
			  +"      , b.member_name                                          "
			  +"   from tcb_contmaster a, tcb_cust b                           "
			  +"  where a.cont_no = b.cont_no                                  "
			  +"    and a.cont_chasu = b.cont_chasu                            "
			  +"    and b.member_no <> a.member_no                             "
			  +"    and b.list_cust_yn = 'Y'                                   "
			  +"    and a.status in ('10','11','12','20','21','30','40','41')  "
			  +"    and a.member_no = '"+auth.getString("_MEMBER_NO")+"'       "
			  +"    and a.reg_id = '"+auth.getString("_USER_ID")+"'            "
			  +"  order by a.cont_no desc                                      "
			 ,10);
		while(cont.next()){
			slist.addRow();
			if(cont.getString("subscription_yn").equals("Y")) {
				slist.put("gubun", "전자문서");
				slist.put("link", "/web/buyer/contract/subscription_view.jsp?cont_no="+u.aseEnc(cont.getString("cont_no"))+"&cont_chasu="+cont.getString("cont_chasu") );
				slist.put("status_nm", u.getItem(cont.getString("status"), code_recv_status));
			} else {
				slist.put("gubun", "전자계약");
				slist.put("status_nm", u.getItem(cont.getString("status"), code_cont_status));

				String link_page = "";
				if(cont.getString("paper_yn").equals("Y")){
					link_page = "offcont_modify.jsp";
				}else{
				    if(cont.getString("status").equals("10")) {
						link_page = cont.getString("template_cd").trim().equals("") ? "contract_free_modify.jsp" : "contract_modify.jsp";
					} else {
						link_page = cont.getString("template_cd").trim().equals("") ? "contract_free_sendview.jsp" : "contract_sendview.jsp";
					}
				}

				slist.put("link", "/web/buyer/contract/"+ link_page + "?cont_no="+u.aseEnc(cont.getString("cont_no"))+"&cont_chasu="+cont.getString("cont_chasu"));

			}

			if(cont.getString("status").equals("40")){
				slist.put("status_nm", "<span style='color:blue'>수정요청</span>");
			}
			slist.put("name", cont.getString("cont_name")+" (거래업체 : "+cont.getString("member_name")+")");
		}
	}
	if(menuMemberDao.findCount( "member_no = '"+auth.getString("_MEMBER_NO")+"' and menu_cd = '000078'  ") >0){//채권잔액 사용여부
		DataObject debtGroupDao = new DataObject("tcb_debt_group");
		DataSet debtGroup = debtGroupDao.query(
				 " select group_name, send_yn                   "
				+"   from tcb_debt_group                                "
				+"  where member_no = '"+auth.getString("_MEMBER_NO")+"'"
				+"    and reg_id = '"+auth.getString("_USER_ID")+"'     "
				+"    and send_yn = 'N'                                 "
				+"  order by group_no desc                              "
				,5);
		while(debtGroup.next()){
			slist.addRow();
			slist.put("gubun", "채권잔액" );
			slist.put("link", "/web/buyer/debt/debt_group_list.jsp" );
			slist.put("status_nm", "미전송");
			slist.put("name", debtGroup.getString("group_name"));
		}
	}
}

DataSet rlist = new DataSet();
if(auth.getString("_MEMBER_TYPE").equals("02")||auth.getString("_MEMBER_TYPE").equals("03")){//을사
	//view_gap_pds = false;
	view_eul_pds = true;
	view_rlist = true;
	
	boolean findBid = true;
	boolean findCont = true;
	boolean findDebt = true;
	if(auth.getString("_MEMBER_TYPE").equals("03")&&!auth.getString("_DEFAULT_YN").equals("Y")){
		DataObject authMenuDao = new DataObject("tcb_auth_menu");
		findBid = authMenuDao.findCount(" member_no = '"+auth.getString("_MEMBER_NO")+"' and auth_cd = '"+auth.getString("_AUTH_CD")+"' and menu_cd = '000050' ")>0?true:false;//을사 입찰공고메뉴
		findCont = authMenuDao.findCount(" member_no = '"+auth.getString("_MEMBER_NO")+"' and auth_cd = '"+auth.getString("_AUTH_CD")+"' and menu_cd = '000061' ")>0?true:false;//을사 진행중인 받은계약
		//findDebt = authMenuDao.findCount(" member_no = '"+auth.getString("_MEMBER_NO")+"' and auth_cd = '"+auth.getString("_AUTH_CD")+"' and menu_cd = '' ")>0?true:false;
		view_eul_pds = view_rlist = findCont;
	}
	
	//입찰 검사
	if(findBid){
		DataObject bidDao = new DataObject("tcb_bid_master");
		//bidDao.setDebug(out);
		DataSet bid = bidDao.query(
				 " select a.main_member_no, a.bid_no, a.bid_deg    "
			    +"      , a.bid_kind_cd, a.bid_name , a.submit_edate   "
			    +"      , a.status ,a.public_bid_yn, c.member_name     "
			    +"  from tcb_bid_master a, tcb_bid_supp b, tcb_member c"
			    +" where a.main_member_no = b.main_member_no           "
			    +"   and a.bid_no = b.bid_no                           "
			    +"   and a.bid_deg = b.bid_deg                         "
			    +"   and a.main_member_no = c.member_no                "
			    +"   and (                                             " 
			    +"         (a.status = '03' and (b.field_enter_yn is null) and a.field_date >= '"+u.getTimeString("yyyyMMdd")+"000000'  )  "// 현설인 경우
			    +"      or (a.status = '05' and b.status = '10' and a.submit_edate >= '"+u.getTimeString()+"'  )  ) " // 입찰인경우
			    +"   and b.member_no = '"+auth.getString("_MEMBER_NO")+"' "
			    +" order by a.submit_edate asc                        "
				, 5);
		while(bid.next()){
			rlist.addRow();
			if(bid.getString("bid_kind_cd").equals("90")){
				rlist.put("gubun", "견적");
				rlist.put("link", "/web/buyer/bid/eul_bid_list.jsp");
				rlist.put("status_nm", "견적요청중");
			}else{
				rlist.put("gubun", "입찰");
				rlist.put("link", bid.getString("public_bid_yn").equals("Y")?"/web/buyer/bid/eul_obid_list.jsp":"/web/buyer/bid/eul_bid_list.jsp");
				rlist.put("status_nm", bid.getString("status").equals("03")?"현설공고중":"입찰공고중");
			}
			rlist.put("client_name",  bid.getString("member_name"));
			rlist.put("name", bid.getString("bid_name"));
		}
	}
	
	//계약검사
	if(findCont){
		DataObject contDao = new DataObject("tcb_contmaster");
		DataSet cont = contDao.query(
				 " select a.cont_no, a.cont_chasu , a.cont_name    "
				+"      , b.member_name, a.status                          "
			    +"   from tcb_contmaster a, tcb_cust b, tcb_cust c         "
			    +"  where a.cont_no = b.cont_no                            "
			    +"    and a.cont_chasu = b.cont_chasu                      "
			    +"    and a.member_no = b.member_no                        "
			    +"    and a.cont_no = c.cont_no                            "
			    +"    and a.cont_chasu = c.cont_chasu                      "
			    +"    and a.member_no <> c.member_no                       "
			    +"    and a.status in ('20','41')                          "
			    +"    and a.member_no <> '"+auth.getString("_MEMBER_NO")+"' "
			    +"    and c.member_no = '"+auth.getString("_MEMBER_NO")+"' "
			    +"  order by cont_date desc, cont_no desc, cont_chasu desc "
				,5);
		while(cont.next()){
			rlist.addRow();
			rlist.put("gubun","계약");
			rlist.put("link","/web/buyer/contract/contract_recv_list.jsp");
			rlist.put("client_name", cont.getString("member_name"));
			rlist.put("name", cont.getString("cont_name"));
			rlist.put("status_nm", cont.getString("status").equals("20")?"<span class='caution-text'>서명요청</span>":"<span style='color:blue'>반려</span>");
		}
	}
	
	//채권잔액
	if(findDebt){
		DataObject debtDao = new DataObject("tcb_debt");
		DataSet debt = debtDao.query(
			  " select a.debt_no,  d.group_name, b.member_name, a.status        "
			 +"   from tcb_debt a, tcb_debt_cust b, tcb_debt_cust c, tcb_debt_group  d  "
			 +"  where a.debt_no = b.debt_no                                            "
			 +"    and  a.member_no = b.member_no                                       "
			 +"    and  a.debt_no = c.debt_no                                           "
			 +"    and  a.group_no = d.group_no                                         "
			 +"    and a.status in ('20')                                               "
			 +"    and  c.member_no = '"+auth.getString("_MEMBER_NO")+"'                "
			,5	);
		while(debt.next()){
			rlist.addRow();
			rlist.put("gubun","채권잔액");
			rlist.put("link","/web/buyer/debt/debt_recv_list.jsp");
			rlist.put("client_name", debt.getString("member_name"));
			rlist.put("name", debt.getString("group_name"));
			rlist.put("status_nm","<span class='caution-text'>서명요청</span>");
		}
	}
}


if(auth.getString("_MEMBER_TYPE").equals("03")&&!auth.getString("_DEFAULT_YN").equals("Y")){//갑을사인 경우 기본 사용자가 아닐때 권한에 따른 알림방 조회
	DataObject authMenuDao = new DataObject("tcb_auth_menu");
	view_gap_pds = authMenuDao.findCount("member_no = '"+auth.getString("_MEMBER_NO")+"' and auth_cd = '"+auth.getString("_AUTH_CD")+"' and menu_cd in ('000036','000060') ") > 0;//갑사 알림방('입찰계획','진행중인보낸계약')
	view_eul_pds = authMenuDao.findCount("member_no = '"+auth.getString("_MEMBER_NO")+"' and auth_cd = '"+auth.getString("_AUTH_CD")+"' and menu_cd in ('000050','000061') ") > 0;//을사 알림방('임찰공고조회','진행중인 받은계약')
	view_slist = view_gap_pds; 
	view_rlist = view_eul_pds; 
}


//알림방
DataSet gap_pds = new DataSet();
DataSet eul_pds = new DataSet();
if(view_gap_pds){
	DataObject pdsDao = new DataObject("tcb_member_pds a, tcb_person b, tcb_member c");
	gap_pds = pdsDao.find(
	 "a.member_no= '"+auth.getString("_MEMBER_NO")+"' "+
	 "and a.member_no = b. member_no "+
	 "and b.member_no = c.member_no "+
	 "and a.reg_id = b.user_id"
	,"a.*, b.user_name"
	,"a.reg_date desc"
	,5
	);
	pdsDao = new DataObject("tcb_member_pds");
	int gap_pds_seq = pdsDao.findCount(" member_no = '"+auth.getString("_MEMBER_NO")+"' ");
	while(gap_pds.next()){
		gap_pds.put("__ord", gap_pds_seq --);
		gap_pds.put("reg_date", u.getTimeString("yyyy-MM-dd", gap_pds.getString("reg_date")));
	}
}
if(view_eul_pds){
	DataObject pdsDao = new DataObject("tcb_member a, tcb_client b, tcb_member_pds c");
	eul_pds = pdsDao.find(
	 "b.client_no = '"+auth.getString("_MEMBER_NO")+"' "+
	 "and b.member_no = a.member_no  "+
	 "and b.member_no = c.member_no "
	,"c.*, a.member_name"
	,"c.reg_date desc"
	,5
	);
	int eul_pds_seq = pdsDao.getOneInt(
			"select count(*) from tcb_member a, tcb_client b, tcb_member_pds c where  a.member_no=b.member_no and b.member_no = c.member_no and b.client_no = '"+auth.getString("_MEMBER_NO")+"' "
			);
	while(eul_pds.next()){
		eul_pds.put("__ord", eul_pds_seq--);
		eul_pds.put("reg_date", u.getTimeString("yyyy-MM-dd", eul_pds.getString("reg_date")));
	}
}



String cert_msg = "";
if(auth.getString("_CERT_END_DATE")==null){
	/*
	if(auth.getString("_MEMBER_GUBUN").equals("04")){
		cert_msg = "인증서가 등록 되어 있지 않습니다.\\n\\n상단 우측 [회원정보수정] → [내정보수정]에서 인증서를 등록해 주세요.";
	}else{
		cert_msg = "인증서가 등록 되어 있지 않습니다.\\n\\n상단 우측 [회원정보수정] → [회사정보변경]에서 인증서를 등록해 주세요.";
	} ktm&s 사용시점부서 제외
	*/
}else{
	if(!auth.getString("_CERT_END_DATE").equals("")){
		if(Integer.parseInt(auth.getString("_CERT_END_DATE"))<Integer.parseInt(u.getTimeString("yyyyMMdd"))){
			if(auth.getString("_MEMBER_GUBUN").equals("04"))
			{
				cert_msg = "제출한 인증서의 유효기간이 만료 되었습니다.\\n\\n상단 우측 [회원정보수정] → [내정보수정]에서 인증서를 등록해 주세요.";
			}else
			{
				cert_msg = "제출한 인증서의 유효기간이 만료 되었습니다.\\n\\n상단 우측 [회원정보수정] → [회사정보변경]에서 인증서를 등록해 주세요.";
			}
		}
	}
}


if((!useCont)&&(auth.getString("_MEMBER_TYPE").equals("01")||auth.getString("_MEMBER_TYPE").equals("03"))){
	cert_msg = "";
}


// 전자결재 승인 대상 목록
if(useCont){
	String s_status = auth.getString("_MEMBER_NO").equals("20171101813") ? "'21'" : "'11','21','30'";  // sk브로드밴드는 승인대기건만
	
	DataObject daoAgree = new DataObject();
	//daoAgree.setDebug(out);
	DataSet dsAgree = daoAgree.query(
			"select count(*) agree_cnt from" 
		    +"("
		    +"    select agree_seq, "
		    +"            (select min(agree_seq) from tcb_cont_agree where cont_no=ta.cont_no and cont_chasu=ta.cont_chasu and ag_md_date is null) confirm_seq"
		    +"    from tcb_cont_agree ta inner join tcb_contmaster tm on ta.cont_no=tm.cont_no and ta.cont_chasu=tm.cont_chasu"
		    +"    where ag_md_date is null"
		    +"      and tm.status in (" + s_status + ")"
		    +"      and agree_person_id = '"+auth.getString("_USER_ID")+"'"
		    +")"
    		+"where agree_seq = confirm_seq "
			);
	if(dsAgree.next()){
		p.setVar("view_agree", dsAgree.getInt("agree_cnt") > 0 ? true : false);
	}
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("main.index2");
if(auth.getString("_CERT_END_DATE")!=null){
p.setVar("cert_end_date", u.getTimeString("yyyy-MM-dd",auth.getString("_CERT_END_DATE")));
}
p.setVar("view_gap_pds", view_gap_pds);
p.setVar("view_eul_pds", view_eul_pds);
p.setVar("view_slist", view_slist);
p.setVar("view_rlist", view_rlist);
p.setLoop("gap_pds", gap_pds);
p.setLoop("eul_pds", eul_pds);
p.setLoop("slist", slist);
p.setLoop("rlist", rlist);
p.setVar("cert_msg", cert_msg);
p.display(out);
%>