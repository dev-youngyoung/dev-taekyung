<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="include_cont_push.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String agree_seq = u.request("agree_seq");

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsErrClose("�������� ��η� ���� �ϼ���.");
	return;
}

DataObject contDao = new DataObject("tcb_contmaster");
//contDao.setDebug(out);
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'  ","tcb_contmaster.*,(select member_name from tcb_member where member_no = mod_req_member_no) req_member_name");
if(!cont.next()){
	u.jsErrClose("��������� �����ϴ�.");
	return;
}

String spliter = "\r\n-------------------------------------------------------\r\n";
	   spliter += cont.getString("req_member_name")+"("+u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date"))+")\r\n";
if(!cont.getString("mod_req_reason").equals(""))
	cont.put("mod_req_reason", spliter+cont.getString("mod_req_reason"));

f.addElement("mod_req_reason", cont.getString("mod_req_reason"), "hname:'����', required:'Y', maxbyte:'1000'");

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

	// ���� ����
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

	/* ���α� START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  cont_chasu,  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), next_status.equals("40")?"���ڹ��� ������û":"���ڹ���  �ݷ�",  f.get("mod_req_reason"), next_status, "20");
	/* ���α� END*/

	if(!db.executeArray()){
		u.jsError("���忡 ���� �Ͽ����ϴ�.");
		return;
	}

	//SMS, Email����
	SmsDao smsDao= new SmsDao();
	DataObject custDao = new DataObject("tcb_cust");
	if(u.inArray(cont.getString("status"),new String[]{"20","41"})){//�ݷ� �Ǵ� �����û �����̸� ���� ��û�̴�.
		DataSet cust = custDao.find("cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"'");
		if(cust.next()){
			// sms ����
			smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), auth.getString("_MEMBER_NAME")+" ���� ���ڰ�༭ ������û- ���̽���ť(�Ϲݱ����)");
		}
	}

	if(u.inArray(cont.getString("status"),new String[]{"21","30","40"})){//���� ��û�����̸� �ݷ��̴�.
		String where = "cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"'";
		if(!cont.getString("mod_req_member_no").equals("")) where+=" and member_no = '"+cont.getString("mod_req_member_no")+"'";
		DataSet cust = custDao.find(where);
		while(cust.next()){
			// sms ����
			if(!cust.getString("member_no").equals(_member_no)){
				smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), auth.getString("_MEMBER_NAME")+" ���� ���ڰ�༭ �ݷ�- ���̽���ť(�Ϲݱ����)");
			}
		}

		//send_type Ȯ���� ���ؼ� ���ø� ��ȸ
		DataObject templateDao = new DataObject();
		String send_type = templateDao.getOne("select send_type from tcb_cont_template where template_cd='"+cont.getString("template_cd")+"' ");
		
		String return_url = "/web/buyer/";
        if(send_type.equals("10")) {// �̸��� ������������
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
            u.mail(cust.getString("email"), "[���̽���ť] " + auth.getString("_MEMBER_NAME") + "���� ���ڰ�༭ �ݷ�", mail_body);
        }
	}

	//��༭ push
	if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK�����, �������̺�ε����� ���
		DataSet result = contPush_skstoa(cont_no, cont_chasu);//���Ϸ� push
		if(!result.getString("succ_yn").equals("Y")){
			u.sp(" skstore ������� ���� ����!!!\npage:pop_modify_req.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
			u.mail("nicedocu@nicednr.co.kr","skstore ������� ���� ����!!! ", " skstore ������� ���� ����!!!\npage:pop_modify_req.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		}
	}

	out.println("<script language=\"javascript\" >");
	out.println("opener.location.reload();");
	out.println("window.close();");
	out.println("</script>");

	
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_modify_req");
p.setVar("popup_title",u.inArray(cont.getString("status"),new String[]{"30","40"})?"�ݷ�":"������û");
p.setVar("req_name",u.inArray(cont.getString("status"),new String[]{"30","40"})?"�ݷ�":"������û");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>