<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%
String _menu_cd = "000060";


f.addElement("s_cont_name",null, null);
f.addElement("s_member_name",null, null);
f.addElement("chk_conts",null, null);

if(u.isPost()&&!f.get("chk_conts").equals("")){
	String[] conts = f.get("chk_conts").split(",");
	for(int i = 0 ; i < conts.length; i++){
		String cont_no = conts[i].split("-")[0];
		String cont_chasu = conts[i].split("-")[1];

		String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
		ContractDao contDao = new ContractDao();
		DataSet cont = contDao.find(where+" and member_no = '"+_member_no+"'");
		if(!cont.next()){
			u.jsError("계약건이 존재 하지 않습니다.");
			return;
		}

		if(!u.inArray(cont.getString("status"),new String[]{"20"})){// 작성중, 내부결재 중 전송 가능
			u.jsError("계약건은 서명요청 상태에서만 재전송 가능 합니다.");
			return;
		}

		if(cont.getString("sign_types").equals("")){
			u.jsError("재전송 대상 계약건이 아닙니다.\\n\\n(모바일 서명지원계약만 가능)");
			return;
		}

		DB db = new DB();

		/* 계약로그 START*/
		ContBLogDao logDao = new ContBLogDao();
		logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 재발신",  "", "20", "10");
		/* 계약로그 END*/

		if(!db.executeArray()){
			u.jsError("전송에 실패 하였습니다.");
			return;
		}

		DataObject templateDao = new DataObject();
		String send_type = templateDao.getOne("select send_type from tcb_cont_template where template_cd='"+cont.getString("template_cd")+"' ");

		// SMS email 전송
		DataObject custDao = new DataObject("tcb_cust");
		//custDao.setDebug(out);
		DataSet cust = custDao.find(where, "tcb_cust.*, (select status from tcb_member where member_no = tcb_cust.member_no) member_status");

		String sender_name = auth.getString("_MEMBER_NAME");
		if(cont.getString("member_no").equals("20151100446")) {//나이스디앤알 예외처리
			DataObject contAddDao = new DataObject("tcb_cont_add");
			DataSet contAdd = contAddDao.find("cont_no = '"+cont.getString("cont_no")+"' and cont_chasu = '"+cont.getString("cont_chasu")+"' ");
			if(contAdd.next()){
				sender_name += "_"+contAdd.getString("add_col3");
			}
		}
		while (cust.next()) {
			if (!cust.getString("member_no").equals(_member_no)) {
				SmsDao smsDao= new SmsDao();
				String email_random = u.getRandString(20);
				custDao = new DataObject("tcb_cust");
				custDao.item("email_random", email_random);
				custDao.update(where+" and member_no = '"+cust.getString("member_no")+"' ");

				// SMS전송
				if (!cust.getString("hp2").equals("0000") && !cust.getString("hp1").equals("") && !cust.getString("hp2").equals("")) {
					String mail_site = cust.getString("email").split("@")[1];
					if (send_type.equals("20")) { // 휴대폰 본인 인증 서명
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
					}
				}

				// 이메일 전송
				if (!cust.getString("email").equals("")) {
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
					contEmailDao.insert();

					String return_url = "";
					if (send_type.equals("20")) {
						return_url = "web/buyer/sdd/email_msign_callback.jsp?cont_no="+u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+email_random;
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
					p.setVar("recv_check_url", "/web/buyer/contract/emailReadCheck.jsp?cont_no="+cont_no+"&cont_chasu="+cont_chasu+"&member_no="+cust.getString("member_no")+"&num="+email_seq);
					String mail_body = p.fetch("../html/mail/cont_send_mail.html");
					u.mail(cust.getString("email"), "[농심] "+auth.getString("_MEMBER_NAME")+"에서 "+ cust.getString("member_name")+"에게 계약서 서명요청", mail_body );
				}
			}
		}
	}
	u.jsAlertReplace("계약서를 재전송 하였습니다." ,"pop_msign_resend.jsp?"+u.getQueryString());
	return;
}

String auth_query = "";
if(!auth.getString("_DEFAULT_YN").equals("Y")){
	//10:담당조회  20:부서조회
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("10")){
		auth_query = "and (  "
				+"     a.agree_person_ids like '%"+auth.getString("_USER_ID")+"%' "
				+"  or a.reg_id = '"+auth.getString("_USER_ID")+"' "
				+"  or a.field_seq in (select field_seq from tcb_auth_field where member_no = '"+_member_no+"' and auth_cd = '"+auth.getString("_AUTH_CD")+"' and menu_cd = '"+_menu_cd+"') "
				+"           ) ";
	}
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("20")){
		auth_query = "and (  "
				+"     a.agree_field_seqs like '%|"+auth.getString("_FIELD_SEQ")+"|%' "
				+"  or a.agree_person_ids like '%"+auth.getString("_USER_ID")+"%' " // 결제 라인 조회 권한은 부여된 권한 보다 우선 한다.
				+"  or a.field_seq in ( select field_seq from tcb_field start with member_no = '"+_member_no+"' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq ) "
				+"  or a.field_seq in (select field_seq from tcb_auth_field where member_no = '"+_member_no+"' and auth_cd = '"+auth.getString("_AUTH_CD")+"' and menu_cd = '"+_menu_cd+"') "
				+"          ) ";
	}
}

DataObject contDao = new DataObject("tcb_contmaster");
String query =
	 " select a.cont_no "
	+"    , a.cont_chasu "
	+"    , a.cont_name "
	+"    , a.cont_date "
	+"    , b.member_name "
	+"    , b.hp1 "
	+"    , b.hp2 "
	+"    , b.hp3 "
	+"    , b.email "
	+"    , (select max(log_date) "
	+"         from tcb_cont_log "
	+"        where cont_no = a.cont_no "
	+"          and cont_chasu = a.cont_chasu "
	+"          and cont_status = '20' "
	+"      ) send_date "
	+" from tcb_contmaster a , tcb_cust b "
	+"where a.cont_no = b.cont_no "
	+"  and a.cont_chasu = b.cont_chasu "
	+"  and a.status = '20' "
	+"  and a.sign_types is not null "
	+"  and b.list_cust_yn = 'Y' "
	+"  and a.member_no = '"+_member_no+"' "
	+"  and a.cont_name like '%"+f.get("s_cont_name")+"%' "
	+"  and b.member_name like '%"+f.get("s_member_name")+"%' "
	+ auth_query
	+"order by cont_no desc ";


DataSet list = contDao.query(query);
while(list.next()){
	list.put("cont_date", u.getTimeString("yyyy-MM-dd", list.getString("cont_date")));
	list.put("send_date", u.getTimeString("yyyy-MM-dd HH:mm", list.getString("send_date")));
}
p.setLayout("popup");
p.setDebug(out);
p.setBody("contract.pop_msign_resend");
p.setVar("popup_title","계약 재전송");
p.setLoop("list", list);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>