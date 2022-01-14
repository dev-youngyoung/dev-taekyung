<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ include file="include_cont_push.jsp" %>
<%@ include file="include_contract_modify_func.jsp" %>
<%@ include file="include_contract_msign_modify_func.jsp" %> 
<%@ include file="include_contract_free_modify_func.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
String agree_seq = u.request("agree_seq");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
} 

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(where+" and member_no = '"+_member_no+"'");
if(!cont.next()){
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}

// 티알엔
DataObject custDao1 = new DataObject("tcb_cust"); 
DataSet cust1 = custDao1.find(where+" and sign_seq ='2' " ); 
while(cust1.next()){  
	if(_member_no.equals("20150600110")){//티알엔만
		if(cust1.getString("email").equals("")){
			u.jsError("이메일이 없습니다. 입력 후 [저장] 하십시오.");
			return;
		} 
	}
}

 
//결제 정보
String now_agree_seq = "";
DataObject agreeDao = new DataObject("tcb_cont_agree");
DataSet agree = agreeDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and r_agree_person_id is null and agree_cd='1'","agree_seq","agree_seq asc", 1);
if(!agree.next()){
}
now_agree_seq = agree.getString("agree_seq");


if(!now_agree_seq.equals("")){
	if(!agree_seq.equals(now_agree_seq)){
		u.jsError("결재자가 올바르지 않습니다.");
		return;
	}
}

if(!u.inArray(cont.getString("status"),new String[]{"10","11"})){// 작성중, 내부결재 중 전송 가능
	u.jsError("계약건은 작성중,내부결재중 상태에서만 전송 가능 합니다.");
	return;
}

/************************************************************************************
	계약정보 저장 include 파일로 분리 20211014 이종환
	인증서서명계약 : include_contract_modify_func.jsp 			method -> _saveContract
	자필서명계약   : include_contract_msign_modify_func.jsp method -> _saveMsignContract
	자유서식계약   : include_contract_free_modify_func.jsp method -> _saveFreeContract
************************************************************************************/
if("10".equals(cont.getString("status")))	/* 계약상태[작성중]에서 서명요청을 하는 경우 */ 
{
	Map<String, String> rtnMap = new HashMap<String,String>(); 
	if(u.inArray(cont.getString("template_cd"), new String[]{"","9999999","9999998"}))	//	자유서식 계약의 경우
	{
		rtnMap	=	_saveFreeContract(response, request, u, f,_member_no, auth);
	}else
	{
		if("".equals(cont.getString("sign_types")))	//	인증서 서명 계약의 경우
		{
			rtnMap	=	_saveContract(response, request, u, f,_member_no, auth);
		}else	//	자필서명 계약의 경우
		{
			rtnMap	=	_saveMsignContract(response, request, u, f,_member_no, auth);
		}
	} 

	if(!"SUCC".equals(rtnMap.get("code")))
	{
		u.jsError(rtnMap.get("msg"));
		return;
	}
}

DB db = new DB(); 

contDao.item("mod_req_date","");
contDao.item("mod_req_reason","");
contDao.item("mod_req_member_no","");
contDao.item("status","20");
db.setCommand(contDao.getUpdateQuery(where), contDao.record);
if(!now_agree_seq.equals("")){
	agreeDao = new DataObject("tcb_cont_agree");
	agreeDao.item("ag_md_date", u.getTimeString());
	agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
	agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
	db.setCommand( agreeDao.getUpdateQuery( where +" and agree_seq='"+now_agree_seq+"'"),agreeDao.record);
}

/* 계약로그 START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 발신",  "", "20", "10");
/* 계약로그 END*/

if(!db.executeArray()){
	u.jsError("전송에 실패 하였습니다.");
	return;
}



DataObject templateDao = new DataObject("tcb_cont_template");
//String send_type = templateDao.getOne("select send_type from tcb_cont_template where template_cd='"+cont.getString("template_cd")+"' ");
String send_type="";
DataSet template = templateDao.find("template_cd='"+cont.getString("template_cd")+"'", "send_type, doc_gubun");
if(template.next()) {
	send_type = template.getString("send_type");
}

// SMS email 전송
DataObject custDao = new DataObject("tcb_cust");
//custDao.setDebug(out);
DataSet cust = custDao.find(where, "tcb_cust.*, (select status from tcb_member where member_no = tcb_cust.member_no) member_status");
 

String sender_name = auth.getString("_MEMBER_NAME");
while(cust.next()){

	if(!cust.getString("member_no").equals(_member_no) && !u.inArray(cont.getString("template_cd"), new String[] {"2017021","2017023","2017024","2017025","2017048"})){//한수테크니컬은 연봉계약서 전송 안함.

		SmsDao smsDao= new SmsDao();
		/* Kakao_SmsDao kakao_smsDao= new Kakao_SmsDao();   */
		String email_random = u.getRandString(20);
		custDao = new DataObject("tcb_cust");
		custDao.item("email_random", email_random);
		if(!custDao.update(where+" and member_no = '"+cust.getString("member_no")+"' ")){
		}
		
		//SMS전송
		if(!cust.getString("hp2").equals("0000") && !cust.getString("hp1").equals("") && !cust.getString("hp2").equals("")){
			String mail_site = cust.getString("email").split("@")[1];
			if(send_type.equals("10")) {    
				String param =cust.getString("member_name")+ "#;"+auth.getString("_MEMBER_NAME") + "#;" +auth.getString("_MEMBER_NAME")+ "#;"+  cont.getString("cont_name") +  "#;"+ u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")) +"#;" + cust.getString("email") + "#;";  
				/* kakao_smsDao.sendKkoLMS_2(param, "#;" ,"Y" ,"ufit_2021021814585725563981048" ,"S" ,  cust.getString("hp1") , cust.getString("hp2"), cust.getString("hp3"),"","","" ,"AT")  ; */  
				 
			} else if(send_type.equals("20")&& !(cont.getString("template_cd").equals("2019177")&&cust.getString("sign_seq").equals("3")) ){// 휴대폰 본인 인증 서명 
				
				/* 알림톡 */
				String link_full = "";
				// 모바일 UI 개편용
				if(u.inArray(template.getString("doc_gubun"), new String[]{"11", "13"})) { // 11 : 모바일_근로(신규UI), 13 : 모바일_업무(신규UI)
					link_full = "https://www.nicedocu.com/web/buyer/sdd/msign_callback.jsp?cont_no=";
				} else {
					link_full = "https://www.nicedocu.com/web/buyer/sdd/email_msign_callback.jsp?cont_no=";
				}
 
				String kakao_link = link_full + u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+email_random;
				String param_mo = cust.getString("member_name") +"#;" + auth.getString("_MEMBER_NAME") +"#;" + auth.getString("_MEMBER_NAME") +"#;" + cont.getString("cont_name") +"#;" + u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")) +"#;" 
				                          + cust.getString("email") +"#;" + kakao_link + "#;" ;  
				/* kakao_smsDao.sendKkoLMS_2(param_mo, "#;" ,"Y" ,"ufit_2021012116201825563436649" ,"S" ,  cust.getString("hp1") , cust.getString("hp2"), cust.getString("hp3"),"","","" ,"AT")  ; */  
				  
			}else{// 일반 사이트 로그인 서명
				String cust_name = auth.getString("_MEMBER_NAME"); 
				if(cust.getString("member_no").substring(0,9).equals("000000000") && cust.getString("sign_type").equals("20")) { // 연대보증인이면 안내문자 + 휴대폰 서명
					 
					/* 알림톡 */
					String link_full = "https://www.nicedocu.com/web/buyer/sdd/email_msign_callback.jsp?cont_no=";
					String kakao_link = link_full + u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+email_random;
					String param_mo = cust.getString("member_name") +"#;" + auth.getString("_MEMBER_NAME") +"#;" + auth.getString("_MEMBER_NAME") +"#;" + cont.getString("cont_name") +"#;" + u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")) +"#;" 
					                          + cust.getString("email") +"#;" + kakao_link + "#;" ; 
					/* kakao_smsDao.sendKkoLMS_2(param_mo, "#;" ,"Y" ,"ufit_2021012116201825563436649" ,"S" ,  cust.getString("hp1") , cust.getString("hp2"), cust.getString("hp3"),"","","" ,"AT")  ; */   
					 
				} else {
					if(cust.getString("member_status").equals("02")) {//비회원 전송일 경우  
						String param =cust.getString("member_name")+ "#;"+cust_name + "#;" +cust_name+ "#;"+  cont.getString("cont_name") +  "#;"+ u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")) + "#;";  
						/* kakao_smsDao.sendKkoLMS_2(param, "#;" ,"Y" ,"ufit_2021021814515726670771050" ,"S" ,  cust.getString("hp1") , cust.getString("hp2"), cust.getString("hp3"),"","","" ,"AT")  ; */   
						 
					} else {
						if(u.inArray(_member_no, new String[]{"20180101078", "20180101074"})) { 
							cust_name = "얼리페이"; 
						} 
						//연대보증 (인증서) 
						if(cust.getString("member_no").substring(0,9).equals("000000000")){ 
							String param =cust.getString("member_name")+ "#;"+cust_name + "#;" + cust_name + "#;"+  cont.getString("cont_name") +  "#;"+ u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")) +"#;" + cust.getString("email") + "#;";  
							/* kakao_smsDao.sendKkoLMS_2(param, "#;" ,"Y" ,"ufit_2021021814585725563981048" ,"S" ,  cust.getString("hp1") , cust.getString("hp2"), cust.getString("hp3"),"","","" ,"AT")  ; */  
						 }else{  
							String param =cust.getString("member_name")+ "#;"+ cust_name + "#;" + cust_name + "#;"+  cont.getString("cont_name") +  "#;"+ u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")) + "#;";  
							/* kakao_smsDao.sendKkoLMS_2(param, "#;" ,"Y" ,"ufit_2021021814585626670769054" ,"S" ,  cust.getString("hp1") , cust.getString("hp2"), cust.getString("hp3"),"","","" ,"AT")  ; */  
							 
						} 
					}
				}
			}
			
			if(_member_no.equals("20150600110") && !cont.getString("template_cd").equals("2020228")){ //// 티알엔은 작성자에게 무조건 알림   
				DataSet cust2 = custDao.find(where+" and member_no = '"+_member_no+"'"); 
				while(cust2.next()){	 
					String sSmsMsg = "계약 팀장 검토 완료 - " +  cont.getString("cont_name")  ;
					sSmsMsg = StrUtil.lengthLimit(sSmsMsg, 55, "...") + "_나이스다큐(일반기업용)" ;   //cust.getString("member_name")
					smsDao.sendSMS("buyer", cust2.getString("hp1"), cust2.getString("hp2"), cust2.getString("hp3"),  sSmsMsg); 
				}
			} 
		}
		 
		//이메일 전송
		if(!cust.getString("email").equals("")){
			DataObject contEmailDao = new DataObject("tcb_cont_email");
			String email_seq = contEmailDao.getOne("select nvl(max(email_seq),0)+1 from tcb_cont_email where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cust.getString("member_no")+"' ");
			contEmailDao.item("cont_no", cont_no);
			contEmailDao.item("cont_chasu", cont_chasu);
			contEmailDao.item("member_no", cust.getString("member_no"));
			contEmailDao.item("email_seq", email_seq);
			contEmailDao.item("send_date", u.getTimeString());
			contEmailDao.item("user_name", cust.getString("user_name"));
			contEmailDao.item("email", cust.getString("email"));
			contEmailDao.item("status", "01");
			if(!contEmailDao.insert()){
			}
			
			String return_url = "";
			if(send_type.equals("10")){  // 공인인증서 서명
				return_url = "web/buyer/sdd/email_callback.jsp?cont_no="+u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+email_random;
			}else if(send_type.equals("20") && !(cont.getString("template_cd").equals("2019177")&&cust.getString("sign_seq").equals("3"))){
				// 모바일 UI 개편용
				String email_link = "web/buyer/sdd/email_msign_callback.jsp?cont_no=";
				//if(u.inArray(cont.getString("template_cd"), new String[]{"2021039", "2021040", "2020354","2021098","2021117","2021122","2021124"})) { ////한국조에티스, (주)제때, 건국유업, 한국전자금융 ,삼성전자서비스 의 서식의 경우
				if(u.inArray(template.getString("doc_gubun"), new String[]{"11", "13"})) { // 11 : 모바일_근로(신규UI), 13 : 모바일_업무(신규UI)
					email_link = "web/buyer/sdd/msign_callback.jsp?cont_no=";
				}
				return_url = email_link+u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+email_random;
			}else{
				if(cust.getString("member_no").substring(0,9).equals("000000000")){ // 연대보증인
					if(cust.getString("sign_type").equals("20")) { // 이메일로 휴대폰서명
						return_url = "web/buyer/sdd/email_msign_callback.jsp?cont_no="+u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+email_random;
					} else {  // 이메일로 공인인증서명
						return_url = "web/buyer/contract/emailView.jsp?rs=" + email_random;
					}
				}else{
					if(cust.getString("member_status").equals("02")){  // 비회원
						return_url = "web/buyer/member/join_agree.jsp";
					}else{  // 회원
						return_url =  "web/buyer/index.jsp";
					}
				}
			}
			
			DataSet mailInfo = new DataSet();
			mailInfo.addRow();
			mailInfo.put("send_member_name", auth.getString("_MEMBER_NAME"));
			mailInfo.put("cont_name", cont.getString("cont_name"));
			mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
			mailInfo.put("member_name", cust.getString("member_name"));
			p.setVar("info", mailInfo);
			p.setVar("server_name", request.getServerName());
			p.setVar("return_url", return_url);
			p.setVar("recv_check_url", "/web/buyer/contract/emailReadCheck.jsp?cont_no="+cont_no+"&cont_chasu="+cont_chasu+"&member_no="+cust.getString("member_no")+"&num="+email_seq);
			String mail_body = p.fetch("../html/mail/cont_send_mail.html");
			u.mail(cust.getString("email"), "[나이스다큐] "+auth.getString("_MEMBER_NAME")+"에서 "+ cust.getString("member_name")+"에게 계약서 서명요청", mail_body );
			 
			if(_member_no.equals("20150600110") && !cont.getString("template_cd").equals("2020228")){ //// 티알엔은 작성자에게 무조건 알림   
				DataSet cust2 = custDao.find(where+" and member_no = '"+_member_no+"'"); 
				while(cust2.next()){	  
					u.mail(cust2.getString("email"), "[팀장 검토 완료 알림] " +  cont.getString("cont_name") + " 계약-전자계약 서명을 완료하였습니다.", mail_body); 
				}
			}
		}
	}
}

//계약서 push
if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK스토아, 에스케이브로드밴드일 경우
	DataSet result = contPush_skstoa(cont_no, cont_chasu);//계약완료 push
	if(!result.getString("succ_yn").equals("Y")){
		u.sp(" skstore 계약정보 전송 실패!!!\npage:contract_send.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		u.mail("nicedocu@nicednr.co.kr","skstore 계약정보 전송 실패!!! ", " skstore 계약정보 전송 실패!!!\npage:contract_send.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
	}
}

if(now_agree_seq.equals("")){
	u.jsAlertReplace("계약서를 전송하였습니다.\\n\\n진행중(보낸계약) 목록에서 전송한 계약건을 확인 하실 수 있습니다." ,"contract_writing_list.jsp?"+u.getQueryString("cont_no, cont_chasu"));
}else{
	u.jsAlertReplace("계약서를 전송하였습니다.\\n\\n진행중(보낸계약) 목록에서 전송한 계약건을 확인 하실 수 있습니다." ,"contract_send_list.jsp?"+u.getQueryString("cont_no, cont_chasu, agree_seq"));
}

	
%>
<%!

%>