<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String cust_member_no = u.request("cust_member_no");
if(cont_no.equals("")||cont_chasu.equals("")||cust_member_no.equals("")){
	u.jsErrClose("정상적인 경로로 접근 하세요.");
	return;
}

String where = "cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";

DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find(where);
if(!cont.next()){
	u.jsErrClose("계약정보가 없습니다.");
	return;
}

DataObject emailDao = new DataObject("tcb_cont_email");
DataSet contEmail = emailDao.find( where + "  and member_no='"+cust_member_no+"'", "*", "email_seq desc", 1);
if(!contEmail.next()){
	u.jsErrClose("메일 발송 이력 정보가 없습니다.");
	return;
}
contEmail.put("send_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", contEmail.getString("send_date")));
contEmail.put("recv_dete", contEmail.getString("recv_dete").equals("")?"읽지 않음":u.getTimeString("yyyy-MM-dd HH:mm:ss", contEmail.getString("recv_dete")));

f.addElement("email",contEmail.getString("email"),"hname:'이메일', required:'Y'");

if(u.isPost()&&f.validate()){

	// SMS email 전송
	DataObject custDao = new DataObject("tcb_cust");
	//custDao.setDebug(out);
	DataSet cust = custDao.find(where + " and member_no = '"+cust_member_no+"' ");

	String sender_name = auth.getString("_MEMBER_NAME");
	while(cust.next()){
			//이메일 전송
			DataObject contEmailDao = new DataObject("tcb_cont_email");
			String email_seq = contEmailDao.getOne("select nvl(max(email_seq),0)+1 from tcb_cont_email where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cust.getString("member_no")+"' ");
			contEmailDao.item("cont_no", cont_no);
			contEmailDao.item("cont_chasu", cont_chasu);
			contEmailDao.item("member_no", cust.getString("member_no"));
			contEmailDao.item("email_seq", email_seq);
			contEmailDao.item("send_date", u.getTimeString());
			contEmailDao.item("user_name", cust.getString("user_name"));
			contEmailDao.item("email", f.get("email"));
			contEmailDao.item("status", "01");
			if(!contEmailDao.insert()){
			}

			String return_url = "web/buyer/contract/emailView.jsp?rs="+cust.getString("email_random");

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
			u.mail(f.get("email"), "[나이스다큐] "+auth.getString("_MEMBER_NAME")+"에서 "+ cust.getString("member_name")+"에게 계약서 서명요청", mail_body );
	}

	out.println("<script language=\"javascript\" >");
	out.print("alert(\"재전송 하였습니다.\");");
	out.println("window.close();");
	out.println("</script>");
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_email");
p.setVar("popup_title","이메일 재전송");
p.setVar("contEmail", contEmail);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>