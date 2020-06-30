<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="../contract/include_cont_push.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String agree_seq = u.request("agree_seq");

if(cont_no.equals("")||cont_chasu.equals("")||agree_seq.equals("")){
	u.jsErrClose("정상적인 경로로 접근 하세요.");
	return;
}

DataObject contDao = new DataObject("tcb_contmaster");
//contDao.setDebug(out);
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
if(!cont.next()){
	u.jsErrClose("계약정보가 없습니다.");
	return;
}

f.addElement("mod_req_reason", cont.getString("mod_req_reason"), "hname:'반려사유', required:'Y', maxbyte:'256'");

if(u.isPost()&&f.validate()){

	DB db = new DB();
	
	DataObject agreeDao = new DataObject("tcb_cont_agree");
	//agreeDao.setDebug(out);
	DataSet agreeDs = agreeDao.find("cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' and agree_seq="+agree_seq);
	if(!agreeDs.next())
	{
		u.jsErrClose("서명 정보가 없습니다.");
		return;
	}

	agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
	agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
	agreeDao.item("mod_reason", f.get("mod_req_reason"));
	agreeDao.item("ag_md_date", u.getTimeString());
	db.setCommand(agreeDao.getUpdateQuery("cont_no = '"+cont_no+"' and cont_chasu = "+cont_chasu+" and agree_seq="+agree_seq) , agreeDao.record);
	
	contDao = new DataObject("tcb_contmaster");
	contDao.item("status", "12");  // 내부반려
	db.setCommand(contDao.getUpdateQuery("cont_no = '"+cont_no+"' and cont_chasu = "+cont_chasu), contDao.record);
	
	/* 계약로그 START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "승인 반려",  f.get("mod_req_reason"), "12","20");
	/* 계약로그 END*/
	
	if(!db.executeArray()){
		u.jsErrClose("반려에 실패 하였습니다.");
		return;
	}
	

	// 작성자에게 반려를 이메일로 알림
	String to_member_name = ""; // 계약업체명
	String to_email = "";		// 검토자 이메일
	String to_hp1 = "";		// 휴대폰
	String to_hp2 = "";		// 휴대폰
	String to_hp3 = "";		// 휴대폰

	DataObject custDao = new DataObject("tcb_cust");
	DataSet cust = custDao.find("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq=2");	// 업체정보
	if(cust.next())
	{
		to_member_name = cust.getString("member_name");
		to_hp1 = cust.getString("hp1");
		to_hp2 = cust.getString("hp2");
		to_hp3 = cust.getString("hp3");
	}

	DataObject personDao = new DataObject("tcb_person");
	DataSet dsPerson = personDao.find("user_id='"+cont.getString("reg_id")+"'");	// 작성자
	if(dsPerson.next())
	{
		to_email = dsPerson.getString("email");

		System.out.println("to_member_name : " + to_member_name);
		System.out.println("to_email : " + to_email);

		p.clear();
		p.setVar("mod_reason", f.get("mod_req_reason"));
		p.setVar("ag_md_date", u.getTimeString("yyyy-MM-dd HH:mm:ss"));
		p.setVar("from_user_name", auth.getString("_USER_NAME"));
		p.setVar("cust_name", to_member_name);
		p.setVar("cont_name", cont.getString("cont_name"));
		p.setVar("cont_day", u.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));
		p.setVar("img_url", webUrl+"/images/email/20110620/");
		p.setVar("ret_url", webUrl+"/web/buyer/");
		System.out.println(p.fetch("mail/cont_agree_reject.html"));
		u.mail(to_email, "[계약 반려 알림] \"" +  cont.getString("cont_name") + "\" 계약서를 반려하였습니다.", p.fetch("mail/cont_agree_reject.html"));
	}


	// 업체가 서명한 후 반려인 경우 업체에게도 알려준다.
	if(agreeDs.getString("agree_cd").equals("2"))
	{
		SmsDao smsDao= new SmsDao();
		smsDao.sendSMS("buyer", to_hp1, to_hp2, to_hp3, auth.getString("_MEMBER_NAME")+" 에서 계약서 재검토를 위해 회수 하였습니다.- 나이스다큐(일반기업용)");
	}

	//SMS전송
	/**
	String sender_name = auth.getString("_MEMBER_NAME");
	DataObject custDao = new DataObject("tcb_cust");
	if(u.inArray(cont.getString("status"),new String[]{"20","41"})){//반려 또는 서명요청 상태이면 수정 요청이다.
		DataSet cust = custDao.find("cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"'");
		if(cust.next()){
				// sms 전송
		}
	}

	if(u.inArray(cont.getString("status"),new String[]{"30","40"})){//수정요청상태이면 반려이다.
		String where = "cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"'";
		if(!cont.getString("mod_req_member_no").equals("")) where+=" and member_no = '"+cont.getString("mod_req_member_no")+"'";
		DataSet cust = custDao.find(where);
		while(cust.next()){
				// sms 전송
				if(!cust.getString("member_no").equals(_member_no)){
				}
		}
	}
	**/

	//계약서 push
	if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK스토아, 에스케이브로드밴드일 경우
		DataSet result = contPush_skstoa(cont_no, cont_chasu);//계약완료 push
		if(!result.getString("succ_yn").equals("Y")){
			u.sp(" skstore 계약정보 전송 실패!!!\npage:pop_reject_req_pop.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
			u.mail("nicedocu@nicednr.co.kr","skstore 계약정보 전송 실패!!! ", " skstore 계약정보 전송 실패!!!\npage:pop_reject_req_pop.jsp\ncont_no: "+ cont_no +"-"+ cont_chasu);
		}
	}

	out.println("<script>");
	out.println("opener.location.reload();");
	out.println("self.close();");
	out.println("</script>");
	return;
}


p.setLayout("popup");
p.setDebug(out);
p.setBody("contract.pop_reject_req");
p.setVar("popup_title", "반려");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>