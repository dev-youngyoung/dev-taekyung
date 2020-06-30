<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="include_cont_push.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(where+" and member_no = '"+_member_no+"'");
if(!cont.next()){
	u.jsError("������ ���� ���� �ʽ��ϴ�.");
	return;
}

if(!u.inArray(cont.getString("status"),new String[]{"20"})){// �ۼ���, ���ΰ��� �� ���� ����
	u.jsError("������ �����û ���¿����� ������ ���� �մϴ�.");
	return;
}	

if(cont.getString("sign_types").equals("")){
	u.jsError("������ ��� ������ �ƴմϴ�.\\n\\n(����� ����������ุ ����)");
	return;
}

DB db = new DB();

/* ���α� START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "���ڹ��� ��߽�",  "", "20", "10");
/* ���α� END*/

if(!db.executeArray()){
	u.jsError("���ۿ� ���� �Ͽ����ϴ�.");
	return;
}


DataObject templateDao = new DataObject();
String send_type = templateDao.getOne("select send_type from tcb_cont_template where template_cd='"+cont.getString("template_cd")+"' ");

// SMS email ����
DataObject custDao = new DataObject("tcb_cust");
//custDao.setDebug(out);
DataSet cust = custDao.find(where, "tcb_cust.*, (select status from tcb_member where member_no = tcb_cust.member_no) member_status");

String sender_name = auth.getString("_MEMBER_NAME");
if(cont.getString("member_no").equals("20151100446")) {//���̽���ؾ� ����ó��
		DataObject contAddDao = new DataObject("tcb_cont_add");
		DataSet contAdd = contAddDao.find("cont_no = '"+cont.getString("cont_no")+"' and cont_chasu = '"+cont.getString("cont_chasu")+"' ");
		if(contAdd.next()){
			sender_name += "_"+contAdd.getString("add_col3");
		}
	}
while(cust.next()){
	if(!cust.getString("member_no").equals(_member_no)){

		SmsDao smsDao= new SmsDao();
		String email_random = u.getRandString(20);
		custDao = new DataObject("tcb_cust");
		custDao.item("email_random", email_random);
		if(!custDao.update(where+" and member_no = '"+cust.getString("member_no")+"' ")){
		}
		
		//SMS����
		if(!cust.getString("hp2").equals("0000") && !cust.getString("hp1").equals("") && !cust.getString("hp2").equals("")){
			String mail_site = cust.getString("email").split("@")[1];
			if(send_type.equals("20")&& !(cont.getString("template_cd").equals("2019177")&&cust.getString("sign_seq").equals("3")) ){// �޴��� ���� ���� ����
				String linkUrl = request.getRequestURL().substring(0, request.getRequestURL().indexOf("/web/buyer")) + "/web/buyer/sdd/email_msign_callback.jsp?cont_no="+u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+email_random;
				String subject = "[���̽���ť]"+auth.getString("_MEMBER_NAME")+" �ȳ�";
				String longMessage = "["+sender_name+"] ��༭�� ���ڼ������ּ��� \n"
						+ " *�ȳ�* \n1.���Ź��� ��༭�� ���� PC������ ���ڼ����� �����մϴ�.("+cust.getString("email")
						+ "���� Ȯ�ΰ���) \n2.�ý��� �̿� ���Ǵ� ���̽���ť �����ͷ� ���ּ���. \n3.��� ���� ���Ǵ� ����ü�� ������ڿ��� ���ּ���.\n"
						+ linkUrl;
				smsDao.sendLMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), subject, longMessage);
			}
		}
		
		//�̸��� ����
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
			if(send_type.equals("20") && !(cont.getString("template_cd").equals("2019177")&&cust.getString("sign_seq").equals("3"))){
				return_url = "web/buyer/sdd/email_msign_callback.jsp?cont_no="+u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+email_random;
				//System.out.println("/web/buyer/sdd/email_msign_callback.jsp?cont_no="+u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+email_random);
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
			u.mail(cust.getString("email"), "[���̽���ť] "+auth.getString("_MEMBER_NAME")+"���� "+ cust.getString("member_name")+"���� ��༭ �����û", mail_body );
		}
	}
}

u.jsAlertReplace("��༭�� ������ �Ͽ����ϴ�." ,"contract_msign_sendview.jsp?"+u.getQueryString());


	
%>