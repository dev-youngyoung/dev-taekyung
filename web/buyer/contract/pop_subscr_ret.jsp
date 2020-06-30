<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

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
	ContractDao dao = new  ContractDao();
	//dao.setDebug(out);
	dao.item("mod_req_date", u.getTimeString());
	dao.item("mod_req_member_no", _member_no);
	dao.item("mod_req_reason", f.get("mod_req_reason"));
	dao.item("status", next_status);
	//dao.item("reg_date", u.getTimeString());
	//dao.item("reg_id", auth.getString("_USER_ID"));
	db.setCommand(dao.getUpdateQuery(" cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' "), dao.record);
	db.setCommand("update tcb_cust set sign_date=null, sign_dn=null,sign_data=null where cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' ", null);

	// 내부 결재
	DataObject agreeDao = new DataObject("tcb_cont_agree");
	agreeDao.item("ag_md_date", u.getTimeString());
	agreeDao.item("mod_reason", f.get("mod_req_reason"));
	agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
	agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
	if(!agree_seq.equals(""))
		db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_seq="+agree_seq),agreeDao.record);
	else
		db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd=0"),agreeDao.record);

	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}

	//SMS전송
	SmsDao smsDao= new SmsDao();
	String sender_name = auth.getString("_MEMBER_NAME");
	DataObject custDao = new DataObject("tcb_cust");
	DataSet cust = custDao.find("cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' and member_no <> '"+cont.getString("member_no")+"'");
	if(cust.next()){
		DataSet mailInfo = new DataSet();
		mailInfo.addRow();
		mailInfo.put("member_name", cust.getString("member_name"));
		mailInfo.put("user_name", cust.getString("user_name"));
		mailInfo.put("template_name", cont.getString("cont_name"));
		
		p.setVar("server_name", request.getServerName());
		//p.setVar("return_url", "/web/buyer/contract/subscription_v.jsp?c="+u.aseEnc(cont_no));
		p.setVar("return_url", "/web/buyer/contract/subscription_m.jsp?c="+u.aseEnc(cont_no)+"&s="+cont_chasu+"&tcode="+u.aseEnc(_member_no + "|" + cont.getString("template_cd")));
		p.setVar("info", mailInfo);
		if(!cust.getString("email").equals("")){
			DataObject emailDao = new DataObject("tcb_cont_email");

			int email_seq = emailDao.getOneInt("select nvl(max(email_seq),0)+1 from tcb_cont_email where cont_no='"+cont_no+"' and cont_chasu="+cont_chasu);
			p.setVar("emailChk", "/web/buyer/contract/emailReadCheck.jsp?cont_no="+cont_no+"&cont_chasu="+cont_chasu+"&member_no="+cust.getString("member_no")+"&num="+email_seq);
			String mail_body = p.fetch("../html/mail/subscription_ret.html");
			System.out.println(mail_body);
			u.mail(cust.getString("email"), "[알림] "+cont.getString("cont_name")+" 문서가 반려되었습니다.", mail_body );

			emailDao.item("cont_no", cont_no);
			emailDao.item("cont_chasu", cont_chasu);
			emailDao.item("member_no", cust.getString("member_no"));
			emailDao.item("email_seq", email_seq);
			emailDao.item("send_date", u.getTimeString());
			emailDao.item("member_name", "반려");
			emailDao.item("user_name", cust.getString("user_name"));
			emailDao.item("email", cust.getString("email"));
			emailDao.item("status", "01");
			emailDao.insert();
		}

		// sms 전송
		smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), sender_name+" 에서 "+cont.getString("cont_name")+" 문서를 반려 하였습니다.");
	}
	
	out.println("<script language=\"javascript\" >");
	out.println("opener.location.reload();");
	out.println("window.close();");
	out.println("</script>");		
	
	return;
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("contract.pop_subscr_ret");
p.setVar("popup_title",u.inArray(cont.getString("status"),new String[]{"30","40"})?"반려":"수정요청");
p.setVar("req_name",u.inArray(cont.getString("status"),new String[]{"30","40"})?"반려":"수정요청");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>