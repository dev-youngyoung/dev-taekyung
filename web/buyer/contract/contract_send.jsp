<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ include file="include_cont_push.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu", "0");
String agree_seq = u.request("agree_seq");
if (cont_no.equals("") || cont_chasu.equals("")) {
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'";
ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(where + " and member_no = '" + _member_no + "'");
if (!cont.next()) {
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}

// 결재 정보
String now_agree_seq = "";
DataObject agreeDao = new DataObject("tcb_cont_agree");
DataSet agree = agreeDao.find(
		  "cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' and r_agree_person_id is null and agree_cd = '1'"
		, "agree_seq"
		, "agree_seq asc"
		, 1);
agree.next();

now_agree_seq = agree.getString("agree_seq");
if (!now_agree_seq.equals("")) {
	if (!agree_seq.equals(now_agree_seq)) {
		u.jsError("결재자가 올바르지 않습니다.");
		return;
	}
}

/* if (cont.getString("appr_yn").equals("Y") && !cont.getString("appr_status").equals("50")) { // 결재상태가 50(최종승인)인 경우
	u.jsError("계약건은 결재상태가 최종승인 상태에서만 전송 가능 합니다.");
	return;
} */
if (!u.inArray(cont.getString("status"), new String[]{"10", "11"})) { // 작성중,내부결재 중 전송 가능
	u.jsError("계약건은 계약상태가 작성중,내부결재중 상태에서만 전송 가능 합니다.");
	return;
}

DB db = new DB();

contDao.item("mod_req_date", "");
contDao.item("mod_req_reason", "");
contDao.item("mod_req_member_no", "");
contDao.item("status", "20");
db.setCommand(contDao.getUpdateQuery(where), contDao.record);
if (!now_agree_seq.equals("")) {
	agreeDao = new DataObject("tcb_cont_agree");
	agreeDao.item("ag_md_date", u.getTimeString());
	agreeDao.item("r_agree_person_id", auth.getString("_USER_ID"));
	agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
	db.setCommand( agreeDao.getUpdateQuery(where + " and agree_seq='" + now_agree_seq + "'"), agreeDao.record);
}

DataObject templateDao = new DataObject();
String send_type = templateDao.getOne("select send_type from tcb_cont_template where template_cd='" + cont.getString("template_cd") + "'");

//B2C 농심 갑 서버서명
if (send_type.equals("20")) {
	/* 계약로그 START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no, String.valueOf(cont_chasu), auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 발신+전자서명 완료",  "", "20", "10");
	/* 계약로그 END*/
	
	String contHash = cont.getString("cont_hash");
	System.out.println("[contract_send.jsp] contHash :: " + contHash);
	Crosscert crosscert = new Crosscert();
	crosscert.setEncoding("UTF-8");
	DataSet signDs = crosscert.serverSign(contHash);
	// 서버서명 리턴값에서 SIGN_DATA와 SIGN_DN을 획득하여 DB에 서명정보 UPDATE
	String serverError = signDs.getString("err");
	String serverSignDn = signDs.getString("signDn");
	String serverSignData = signDs.getString("signData");
	System.out.println("[contract_send.jsp] serverError :: " + serverError);
	System.out.println("[contract_send.jsp] serverSignDn :: " + serverSignDn);
	System.out.println("[contract_send.jsp] serverSignData :: " + serverSignData);
	
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

if (!db.executeArray()) {
	u.jsError("전송에 실패 하였습니다.");
	return;
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
				smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), auth.getString("_MEMBER_NAME") + " 에서 전자계약서 서명요청 " + mail_site + "이메일 확인 - 나이스다큐");
			} else if (send_type.equals("20")) {
				// 휴대폰 본인 인증 서명
				String linkUrl = Config.getWebUrl() + "/web/buyer/sdd/email_msign_callback.jsp?cont_no=" + u.aseEnc(cust.getString("cont_no")) + "&cont_chasu=" + cont_chasu + "&email_random=" + email_random;
				String subject = "농심 전자계약 안내";
				String message = "[전자계약][농심] " + auth.getString("_MEMBER_NAME") + " 안내\n"
						+ "[" + auth.getString("_MEMBER_NAME") + "] 계약서를 전자서명해주세요\n"
						+ "*안내*\n"
						+ "1.수신받은 계약서에 대해 PC에서도 전자서명이 가능합니다.(" + cust.getString("email") + "에서 확인가능)\n"
						+ "2.시스템 이용 문의는 농심 전자결제서비스 고객센터로 해주세요.\n"
						+ "3.계약 내용 문의는 계약업체의 계약담당자에게 해주세요.\n"
						+ linkUrl + "\n"
						+ "에서 확인하세요.";
				// smsDao.sendKakaoTalk
				// 서명요청(농심>을) B2C
				smsDao.sendKakaoTalk(cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), "ESC-SD-0001", subject, message, message);
				// smsDao.sendLMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), subject, longMessage);
			} else {
				// 일반 사이트 로그인 서명
				String subject = "농심 전자계약 안내";
				String message = "[전자계약][농심] " + auth.getString("_MEMBER_NAME") + " 안내\n"
						+ auth.getString("_MEMBER_NAME") + "에서 전자계약서 서명요청\n"
						+ "http://ecs.nongshim.com 접속 > 회원가입/로그인 후 계약진행";
				// smsDao.sendKakaoTalk
				// 서명요청(농심>을) B2B
				smsDao.sendKakaoTalk(cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), "ESC-SD-0002", subject, message, message);
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
				if (cust.getString("member_status").equals("02")) { // 비회원
					return_url = "web/buyer/member/join_agree.jsp";
				} else { // 회원
					return_url =  "web/buyer/index.jsp";
				}
			}
			
			DataSet mailInfo = new DataSet();
			mailInfo.addRow();
			mailInfo.put("send_member_name", auth.getString("_MEMBER_NAME"));
			mailInfo.put("cont_name", cont.getString("cont_name"));
			mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
			mailInfo.put("member_name", cust.getString("member_name"));
			p.setVar("info", mailInfo);
			p.setVar("server_name", Config.getWebUrl());
			p.setVar("return_url", return_url);
			p.setVar("recv_check_url", "/web/buyer/contract/emailReadCheck.jsp?cont_no=" + cont_no + "&cont_chasu=" + cont_chasu + "&member_no=" + cust.getString("member_no") + "&num=" + email_seq);
			String mail_body = p.fetch("../html/mail/cont_send_mail.html");
			u.mail(cust.getString("email"), "[농심] " + auth.getString("_MEMBER_NAME") + "에서 " + cust.getString("member_name") + "에게 계약서 서명요청", mail_body);
		}
	}
}

if (now_agree_seq.equals("")) {
	u.jsAlertReplace("계약서를 전송하였습니다.\\n\\n진행중(보낸계약) 목록에서 전송한 계약건을 확인 하실 수 있습니다." ,"contract_send_list.jsp?"+u.getQueryString("cont_no, cont_chasu"));
} else {
	u.jsAlertReplace("계약서를 전송하였습니다.\\n\\n진행중(보낸계약) 목록에서 전송한 계약건을 확인 하실 수 있습니다." ,"contract_send_list.jsp?"+u.getQueryString("cont_no, cont_chasu, agree_seq"));
}
%>