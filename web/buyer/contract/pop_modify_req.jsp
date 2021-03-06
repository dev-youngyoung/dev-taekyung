<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ include file="include_cont_push.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String agree_seq = u.request("agree_seq");

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsErrClose("정상적인 경로로 접근 하세요.");
	return;
}

DataObject contDao = new DataObject("tcb_contmaster");
//contDao.setDebug(out);
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'  ","tcb_contmaster.*,(select member_name from tcb_member where member_no = mod_req_member_no) req_member_name");
if(!cont.next()){
	u.jsErrClose("계약정보가 없습니다.");
	return;
}

String spliter = "\r\n-------------------------------------------------------\r\n";
	   spliter += cont.getString("req_member_name")+"("+u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date"))+")\r\n";
if(!cont.getString("mod_req_reason").equals(""))
	cont.put("mod_req_reason", spliter+cont.getString("mod_req_reason"));

f.addElement("mod_req_reason", cont.getString("mod_req_reason"), "hname:'사유', required:'Y', maxbyte:'1000'");

if(u.isPost()&&f.validate()){
	String next_status = u.inArray(cont.getString("status"),new String[]{"21","30","40"})?"41":"40";
	DB db = new DB();
	contDao = new DataObject("tcb_contmaster");
	//dao.setDebug(out);
	contDao .item("mod_req_date", u.getTimeString());
	contDao .item("mod_req_member_no", _member_no);
	contDao .item("mod_req_reason", f.get("mod_req_reason"));
	contDao .item("status", next_status);
	db.setCommand(contDao .getUpdateQuery(" cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' "), contDao .record);
	db.setCommand("update tcb_cust set sign_date=null, sign_dn=null,sign_data=null where cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' ", null);

	// 내부 결재
	DataObject agreeDao = new DataObject("tcb_cont_agree");
	agreeDao.item("ag_md_date", u.getTimeString());
	agreeDao.item("mod_reason", f.get("mod_req_reason"));
	agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
	agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
	if(!agree_seq.equals("")){
		db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_seq="+agree_seq),agreeDao.record);
	}else{
		db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd=0"),agreeDao.record);
	}

	/* 계약로그 START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  cont_chasu,  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), next_status.equals("40")?"전자문서 수정요청":"전자문서  반려",  f.get("mod_req_reason"), next_status, "20");
	/* 계약로그 END*/

	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	
	/* 20201014 : 이메일전송/SMS전송 제외
	//SMS, Email전송
	SmsDao smsDao= new SmsDao();
	DataObject custDao = new DataObject("tcb_cust");
	if(u.inArray(cont.getString("status"),new String[]{"20","41"})){//반려 또는 서명요청 상태이면 수정 요청이다.
		DataSet cust = custDao.find("cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"'");
		if(cust.next()){
			// sms 전송
			smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), auth.getString("_MEMBER_NAME")+" 에서 전자계약서 수정요청- 나이스다큐(일반기업용)");
		}
	}

	if(u.inArray(cont.getString("status"),new String[]{"21","30","40"})){//수정 요청상태이면 반려이다.
		String where = "cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"'";
		if(!cont.getString("mod_req_member_no").equals("")) where+=" and member_no = '"+cont.getString("mod_req_member_no")+"'";
		DataSet cust = custDao.find(where);
		while(cust.next()){
			// sms 전송
			if(!cust.getString("member_no").equals(_member_no)){
				smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), auth.getString("_MEMBER_NAME")+" 에서 전자계약서 반려- 나이스다큐(일반기업용)");
			}
		}

		//send_type 확인을 위해서 템플릿 조회
		DataObject templateDao = new DataObject();
		String send_type = templateDao.getOne("select send_type from tcb_cont_template where template_cd='"+cont.getString("template_cd")+"' ");
		
		String return_url = "/web/buyer/";
        if(send_type.equals("10")) {// 이메일 공인인증서명
        	return_url = "/web/buyer/sdd/email_callback.jsp?cont_no=" + u.aseEnc(cust.getString("cont_no")) + "&cont_chasu=" + cont_chasu + "&email_random=" + cust.getString("email_random");
        }else if(send_type.equals("20")){
        	return_url = "/web/buyer/sdd/email_msign_callback.jsp?cont_no="+u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random=" + cust.getString("email_random");
        }
        
        DataSet mailInfo = new DataSet();
        mailInfo.addRow();
        mailInfo.put("send_member_name", auth.getString("_MEMBER_NAME"));
        mailInfo.put("cont_name", cont.getString("cont_name"));
        mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));
        mailInfo.put("mod_req_reason", u.nl2br(f.get("mod_req_reason")));
        p.setVar("info", mailInfo);
        p.setVar("server_name", request.getServerName());
        p.setVar("return_url", return_url);
        if (!cust.getString("email").equals("")) {
            String mail_body = p.fetch("../html/mail/cont_reject_mail.html");
            u.mail(cust.getString("email"), "[나이스다큐] " + auth.getString("_MEMBER_NAME") + "에서 전자계약서 반려", mail_body);
        }
	} */

	out.println("<script language=\"javascript\" >");
	out.println("opener.location.reload();");
	out.println("window.close();");
	out.println("</script>");
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_modify_req");
p.setVar("popup_title",u.inArray(cont.getString("status"),new String[]{"30","40"})?"반려":"수정요청");
p.setVar("req_name",u.inArray(cont.getString("status"),new String[]{"30","40"})?"반려":"수정요청");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>