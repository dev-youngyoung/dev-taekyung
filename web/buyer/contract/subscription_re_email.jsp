<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");

String cust_member_no = u.request("cust_member_no");
String cust_name = u.request("cust_name");
String cust_email = u.request("cust_email");

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsErrClose("정상적인 경로로 접근 하세요.");
	return;
}

f.addElement("cont_no", cont_no, "");
f.addElement("cont_chasu", cont_chasu, "");

DataObject emailDao = new DataObject("tcb_cont_email");
DataSet list = emailDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", "email_seq desc", 1);
while(list.next()){
	list.put("send_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", list.getString("send_date")));

	if(list.getString("recv_dete").equals(""))
		list.put("recv_dete", "읽지 않음");
	else
		list.put("recv_dete", u.getTimeString("yyyy-MM-dd HH:mm:ss", list.getString("recv_dete")));

}


if(u.isPost()&&f.validate()){

	DataObject contDao = new DataObject("tcb_contmaster");
	DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"'");
	if(!cont.next()){
		u.jsErrClose("정상적인 경로로 접근 하세요.");
		return;
	}

	String sender_name = auth.getString("_MEMBER_NAME");
	DataObject custDao = new DataObject("tcb_cust");
	DataSet cust = custDao.find("cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' and member_no <> '"+cont.getString("member_no")+"'");

	if(cust.next()) {
		DataSet mailInfo = new DataSet();
		mailInfo.addRow();
		mailInfo.put("member_name", cust.getString("member_name"));
		mailInfo.put("user_name", cust.getString("user_name"));
		mailInfo.put("template_name", cont.getString("cont_name"));
		p.setVar("server_name", request.getServerName());

		if(cont.getString("status").equals("41")) // 반려일 경우
		{
			//p.setVar("return_url", "/web/buyer/contract/subscription_v.jsp?c="+u.aseEnc(cont_no));
			p.setVar("return_url", "/web/buyer/contract/subscription_m.jsp?c=" + u.aseEnc(cont_no) + "&s=" + cont_chasu + "&tcode=" + u.aseEnc(_member_no + "|" + cont.getString("template_cd")));
			p.setVar("info", mailInfo);
			if (!cust.getString("email").equals("")) {
				int email_seq = emailDao.getOneInt("select nvl(max(email_seq),0)+1 from tcb_cont_email where cont_no='" + cont_no + "' and cont_chasu=" + cont_chasu);
				p.setVar("emailChk", "/web/buyer/contract/emailReadCheck.jsp?cont_no=" + cont_no + "&cont_chasu=" + cont_chasu + "&member_no=" + cust.getString("member_no") + "&num=" + email_seq);
				String mail_body = p.fetch("../html/mail/subscription_ret.html");
				System.out.println(mail_body);
				u.mail(cust_email, "[알림] " + cust_name + " 문서가 반려되었습니다.", mail_body);

				emailDao.item("cont_no", cont_no);
				emailDao.item("cont_chasu", cont_chasu);
				emailDao.item("member_no", cust.getString("member_no"));
				emailDao.item("email_seq", email_seq);
				emailDao.item("send_date", u.getTimeString());
				emailDao.item("member_name", "반려");
				emailDao.item("user_name", cust_name);
				emailDao.item("email", cust_email);
				emailDao.item("status", "01");
				emailDao.insert();
			}
		} else if(cont.getString("status").equals("50")) // 완료일 경우
		{
			p.setVar("return_url", "/web/buyer/contract/subscription_v.jsp?c="+u.aseEnc(cont_no));
			p.setVar("info", mailInfo);
			if(!cust.getString("email").equals("")){
                int email_seq = emailDao.getOneInt("select nvl(max(email_seq),0)+1 from tcb_cont_email where cont_no='" + cont_no + "' and cont_chasu=" + cont_chasu);
                p.setVar("emailChk", "/web/buyer/contract/emailReadCheck.jsp?cont_no=" + cont_no + "&cont_chasu=" + cont_chasu + "&member_no=" + cust.getString("member_no") + "&num=" + email_seq);
				String mail_body = p.fetch("../html/mail/subscription_finish.html");
				System.out.println(mail_body);
				u.mail(cust_email, "[알림] "+cust_name+" 계약이 완료 되었습니다.", mail_body );

                emailDao.item("cont_no", cont_no);
                emailDao.item("cont_chasu", cont_chasu);
                emailDao.item("member_no", cust.getString("member_no"));
                emailDao.item("email_seq", email_seq);
                emailDao.item("send_date", u.getTimeString());
                emailDao.item("member_name", "완료");
                emailDao.item("user_name", cust_name);
                emailDao.item("email", cust_email);
                emailDao.item("status", "01");
                emailDao.insert();
			}
		}

		out.println("<script language=\"javascript\" >");
		out.print("alert(\"재전송 하였습니다.\");");
		out.println("window.close();");
		out.println("</script>");
	}

	return;
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("contract.subscription_re_email");
p.setVar("popup_title","이메일 재전송");
p.setLoop("list", list);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>