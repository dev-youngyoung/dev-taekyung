 <%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="org.jsoup.Jsoup
				,org.jsoup.nodes.Document
				,org.jsoup.nodes.Element
				,java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

String gridData = u.request("gridData");
String template_cd = u.request("template_cd");
String jobGubun = "B2C";	//B2B, B2C 구분

/**
 * B2B
 * 2020902 : [영업] 거래약정서_직거래점
 * 2020903 : [영업] 거래약정서_특약점
 * 2020904 : [영업] 자금이체 약정서
 * 2020905 : [영업] 판매장려금 약정서_상품
 * 2020906 : [영업] 판매장려금 약정서_제품종합
 * 2020907 : [영업] 판매장려금 약정서_직거래점
 * 2020908 : [영업] 판매장려금 약정서_판매
 * 2020909 : [구매] 기술자료 요구서
 * 2020917 : [구매] 2020년도 (하도급)공정거래 협약서
 * 2020928 : [영업] 공정거래및상생협력 협약서(대리점분야)
 */
 if("2020902".equals(template_cd) || "2020903".equals(template_cd) || "2020904".equals(template_cd) || "2020905".equals(template_cd) || "2020906".equals(template_cd) ||
   "2020907".equals(template_cd) || "2020908".equals(template_cd) || "2020909".equals(template_cd) || "2020917".equals(template_cd) || "2020928".equals(template_cd)
   ){
	jobGubun = "B2B";
}

if(!gridData.equals("")){
	gridData = URLDecoder.decode(gridData,"UTF-8");
}

JSONArray gridRows = JSONArray.fromObject(gridData);

if(gridRows.size() > 0){
	try {
		String error_message = "";
		int loop_cnt = 0;
		// 일괄전송 진행
		DataObject templateDao = new DataObject();
		String send_type = templateDao.getOne("select send_type from tcb_cont_template where template_cd='" + template_cd + "'");
		for(int i=0; i<gridRows.size(); i ++){
			DB db = new DB();
			JSONObject gridRow = (JSONObject)gridRows.get(i);
			String cont_no = u.aseDec(gridRow.get("cont_no").toString());
			String cont_chasu = gridRow.get("cont_chasu").toString();
			String cont_userno = gridRow.get("cont_userno").toString();
			
			String where = " cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'";
			ContractDao contDao = new ContractDao();
			contDao.item("status", "20");
			db.setCommand(contDao.getUpdateQuery(where), contDao.record);
			
			DataSet cont = contDao.find(where + " and member_no = '" + _member_no + "'");
			
			if (!cont.next()) {
				u.jsError("계약건이 존재 하지 않습니다.");
				return;
			}
			if("B2C".equals(jobGubun)){
				/* 계약로그 START*/
				ContBLogDao logDao = new ContBLogDao();
				logDao.setInsert(db, cont_no, String.valueOf(cont_chasu), auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 발신+전자서명 완료",  "", "20", "10");
				/* 계약로그 END*/
				
				String contHash = cont.getString("cont_hash");
				System.out.println("[batch_contract_writing_update.jsp] contHash :: " + contHash);
				Crosscert crosscert = new Crosscert();
				crosscert.setEncoding("UTF-8");
				DataSet signDs = crosscert.serverSign(contHash);
				// 서버서명 리턴값에서 SIGN_DATA와 SIGN_DN을 획득하여 DB에 서명정보 UPDATE
				String serverError = signDs.getString("err");
				String serverSignDn = signDs.getString("signDn");
				String serverSignData = signDs.getString("signData");
				System.out.println("[batch_contract_writing_update.jsp] serverError :: " + serverError);
				System.out.println("[batch_contract_writing_update.jsp] serverSignDn :: " + serverSignDn);
				System.out.println("[batch_contract_writing_update.jsp] serverSignData :: " + serverSignData);
				
				DataObject custNDao = new DataObject("tcb_cust");
				custNDao.item("sign_dn", serverSignDn);
				custNDao.item("sign_data", serverSignData);
				custNDao.item("sign_date", u.getTimeString());
				db.setCommand( custNDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+_member_no+"' and sign_seq = 1"), custNDao.record);
			}else{
				/* 계약로그 START*/
				ContBLogDao logDao = new ContBLogDao();
				logDao.setInsert(db, cont_no, String.valueOf(cont_chasu), auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 발신",  "", "20", "10");
				/* 계약로그 END*/
			}
			
			if(!db.executeArray()){
				error_message += "ERROR => 계약번호 :" + cont_userno + " (계약서저장실패.)";
				continue;
			}
			
			// SMS email 전송
			DataObject custDao = new DataObject("tcb_cust");
			//custDao.setDebug(out);
			DataSet cust = custDao.find(where, "tcb_cust.*, (select status from tcb_member where member_no = tcb_cust.member_no) member_status");
			
			String sender_name = auth.getString("_MEMBER_NAME");
			while (cust.next()) {
				if (!cust.getString("member_no").equals(_member_no)) {
					SmsDao smsDao= new SmsDao();
					String email_random = u.getRandString(20);
					custDao = new DataObject("tcb_cust");
					custDao.item("email_random", email_random);
					custDao.update(where + " and member_no = '" + cust.getString("member_no") + "'");
					
					// 알림톡 전송
					if (!cust.getString("hp1").equals("") && !cust.getString("hp2").equals("") && !cust.getString("hp3").equals("")) {
						String mail_site = cust.getString("email").split("@")[1];
						if (send_type.equals("10")) {
							// 메일 팝업 공인 인증서 서명
							smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), auth.getString("_MEMBER_NAME") + " 에서 전자계약서 서명요청 " + mail_site + "이메일 확인");
						} else if (send_type.equals("20")) {
							// 휴대폰 본인 인증 서명
							String linkUrl = request.getRequestURL().substring(0, request.getRequestURL().indexOf("/web/buyer")) + "/web/buyer/sdd/email_msign_callback.jsp?cont_no=" + u.aseEnc(cust.getString("cont_no")) + "&cont_chasu=" + cont_chasu + "&email_random=" + email_random;
							String subject = "[농심]" + auth.getString("_MEMBER_NAME") + " 안내";
							String longMessage = "[" + auth.getString("_MEMBER_NAME") + "] 계약서를 전자서명해주세요 \n"
									+ " *안내* \n1.수신받은 계약서에 대해 PC에서도 전자서명이 가능합니다.(" + cust.getString("email")
									+ "에서 확인가능) \n2.시스템 이용 문의는 계약담당자에게 해주세요. \n3.계약 내용 문의는 계약업체의 계약담당자에게 해주세요.\n"
									+ linkUrl;
							smsDao.sendLMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), subject, longMessage);
						} else {
							// 일반 사이트 로그인 서명
							String cust_name = auth.getString("_MEMBER_NAME");
							if (cust.getString("member_status").equals("02")) {
								//비회원 전송일 경우
								//일괄계약전송시 카카오 알림톡으로 전송(2021.05.14 swplus)
				                //smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), cust_name + "에서 계약서 서명요청-ecs.nongshim.com > 로그인 후 계약");
								String subject = "농심 전자계약 안내";
								String message = "[전자계약][농심] " + auth.getString("_MEMBER_NAME") + " 안내\n"
										+ auth.getString("_MEMBER_NAME") + "에서 전자계약서 서명요청\n"
										+ "http://ecs.nongshim.com 접속 > 회원가입/로그인 후 계약진행";
								smsDao.sendKakaoTalk(cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), "ESC-SD-0002", subject, message, message);

							} else {
				                //일괄계약전송시 카카오 알림톡으로 전송(2021.05.14 swplus)
								//smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), cust_name + "에서 계약서 서명요청-ecs.nongshim.com > 로그인 후 계약");
								String subject = "농심 전자계약 안내";
								String message = "[전자계약][농심] " + auth.getString("_MEMBER_NAME") + " 안내\n"
										+ auth.getString("_MEMBER_NAME") + "에서 전자계약서 서명요청\n"
										+ "http://ecs.nongshim.com 접속 > 회원가입/로그인 후 계약진행";
								smsDao.sendKakaoTalk(cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), "ESC-SD-0002", subject, message, message);
				                
							}
						}
					}
					
					// 이메일 전송
					if (!cust.getString("email").equals("")) {
						DataObject contEmailDao = new DataObject("tcb_cont_email");
						String email_seq = contEmailDao.getOne("select nvl(max(email_seq),0) + 1 from tcb_cont_email where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' and member_no = '" + cust.getString("member_no") + "'");
						contEmailDao.item("cont_no", cont_no);
						contEmailDao.item("cont_chasu", cont_chasu);
						contEmailDao.item("member_no", cust.getString("member_no"));
						contEmailDao.item("email_seq", email_seq);
						contEmailDao.item("send_date", u.getTimeString());
						contEmailDao.item("user_name", cust.getString("user_name"));
						contEmailDao.item("email", cust.getString("email"));
						contEmailDao.item("status", "01");
						contEmailDao.insert();
						
						String return_url = "";
						if (send_type.equals("10")) {
							return_url = "web/buyer/sdd/email_callback.jsp?cont_no=" + u.aseEnc(cust.getString("cont_no")) + "&cont_chasu=" + cont_chasu + "&email_random=" + email_random;
						} else if (send_type.equals("20")) {
							return_url = "web/buyer/sdd/email_msign_callback.jsp?cont_no=" + u.aseEnc(cust.getString("cont_no")) + "&cont_chasu=" + cont_chasu + "&email_random=" + email_random;
						} else {
							if (cust.getString("member_no").substring(0,9).equals("000000000")) {
								// 연대보증인은 이메일로 바로 서명 가능하고 회원은 사이트로 로그인하도록
								return_url = "web/buyer/contract/emailView.jsp?rs=" + email_random;
							} else {
								if (cust.getString("member_status").equals("02")) {
									// 비회원
									return_url = "web/buyer/member/join_agree.jsp";
								} else {
									// 회원
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
						p.setVar("recv_check_url", "/web/buyer/contract/emailReadCheck.jsp?cont_no=" + cont_no + "&cont_chasu=" + cont_chasu + "&member_no=" + cust.getString("member_no") + "&num=" + email_seq);
						String mail_body = p.fetch("../html/mail/cont_send_mail.html");
						u.mail(cust.getString("email"), "[농심] " + auth.getString("_MEMBER_NAME") + "에서 " + cust.getString("member_name") + "에게 계약서 서명요청", mail_body);
					}
				}
			}
			
			loop_cnt ++;
			
			System.out.println("------------------------------------------------------------ 일괄생성 ["+loop_cnt+"]건 생성 중");
			Thread.sleep(500);
		}
		
		out.clearBuffer();
		if(error_message.equals("")) {
			out.write(loop_cnt+"건 계약서를 전송하였습니다.\n진행중(보낸계약) 메뉴에서 확인하세요.");
		}else {
			out.write(loop_cnt+"건 계약서를 전송하였습니다.\n\n[실패건]\n\n"+error_message);
		}
	}catch(Exception e){
		out.print("알수 없는 에러 발생 : " + e.getCause() + "\n" + e.getMessage());
		e.printStackTrace();
	}
}else{
	out.print("알수 없는 에러 발생 : 계약서가 존재하지 않습니다.");
}
%>