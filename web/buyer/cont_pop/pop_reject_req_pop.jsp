<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="../contract/include_cont_push.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String agree_seq = u.request("agree_seq");

if(cont_no.equals("")||cont_chasu.equals("")||agree_seq.equals("")){
	u.jsErrClose("�������� ��η� ���� �ϼ���.");
	return;
}

DataObject contDao = new DataObject("tcb_contmaster");
//contDao.setDebug(out);
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
if(!cont.next()){
	u.jsErrClose("��������� �����ϴ�.");
	return;
}

f.addElement("mod_req_reason", cont.getString("mod_req_reason"), "hname:'�ݷ�����', required:'Y', maxbyte:'256'");

if(u.isPost()&&f.validate()){

	DB db = new DB();
	
	DataObject agreeDao = new DataObject("tcb_cont_agree");
	//agreeDao.setDebug(out);
	DataSet agreeDs = agreeDao.find("cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' and agree_seq="+agree_seq);
	if(!agreeDs.next())
	{
		u.jsErrClose("���� ������ �����ϴ�.");
		return;
	}

	agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
	agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
	agreeDao.item("mod_reason", f.get("mod_req_reason"));
	agreeDao.item("ag_md_date", u.getTimeString());
	db.setCommand(agreeDao.getUpdateQuery("cont_no = '"+cont_no+"' and cont_chasu = "+cont_chasu+" and agree_seq="+agree_seq) , agreeDao.record);
	
	contDao = new DataObject("tcb_contmaster");
	contDao.item("status", "12");  // ���ιݷ�
	db.setCommand(contDao.getUpdateQuery("cont_no = '"+cont_no+"' and cont_chasu = "+cont_chasu), contDao.record);
	
	/* ���α� START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "���� �ݷ�",  f.get("mod_req_reason"), "12","20");
	/* ���α� END*/
	
	if(!db.executeArray()){
		u.jsErrClose("�ݷ��� ���� �Ͽ����ϴ�.");
		return;
	}
	

	// �ۼ��ڿ��� �ݷ��� �̸��Ϸ� �˸�
	String to_member_name = ""; // ����ü��
	String to_email = "";		// ������ �̸���
	String to_hp1 = "";		// �޴���
	String to_hp2 = "";		// �޴���
	String to_hp3 = "";		// �޴���

	DataObject custDao = new DataObject("tcb_cust");
	DataSet cust = custDao.find("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq=2");	// ��ü����
	if(cust.next())
	{
		to_member_name = cust.getString("member_name");
		to_hp1 = cust.getString("hp1");
		to_hp2 = cust.getString("hp2");
		to_hp3 = cust.getString("hp3");
	}

	DataObject personDao = new DataObject("tcb_person");
	DataSet dsPerson = personDao.find("user_id='"+cont.getString("reg_id")+"'");	// �ۼ���
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
		u.mail(to_email, "[��� �ݷ� �˸�] \"" +  cont.getString("cont_name") + "\" ��༭�� �ݷ��Ͽ����ϴ�.", p.fetch("mail/cont_agree_reject.html"));
	}


	// ��ü�� ������ �� �ݷ��� ��� ��ü���Ե� �˷��ش�.
	if(agreeDs.getString("agree_cd").equals("2"))
	{
		SmsDao smsDao= new SmsDao();
		smsDao.sendSMS("buyer", to_hp1, to_hp2, to_hp3, auth.getString("_MEMBER_NAME")+" ���� ��༭ ����並 ���� ȸ�� �Ͽ����ϴ�.- ���̽���ť(�Ϲݱ����)");
	}

	//SMS����
	/**
	String sender_name = auth.getString("_MEMBER_NAME");
	DataObject custDao = new DataObject("tcb_cust");
	if(u.inArray(cont.getString("status"),new String[]{"20","41"})){//�ݷ� �Ǵ� �����û �����̸� ���� ��û�̴�.
		DataSet cust = custDao.find("cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"'");
		if(cust.next()){
				// sms ����
		}
	}

	if(u.inArray(cont.getString("status"),new String[]{"30","40"})){//������û�����̸� �ݷ��̴�.
		String where = "cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"'";
		if(!cont.getString("mod_req_member_no").equals("")) where+=" and member_no = '"+cont.getString("mod_req_member_no")+"'";
		DataSet cust = custDao.find(where);
		while(cust.next()){
				// sms ����
				if(!cust.getString("member_no").equals(_member_no)){
				}
		}
	}
	**/

	//��༭ push
	if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK�����, �������̺�ε����� ���
		DataSet result = contPush_skstoa(cont_no, cont_chasu);//���Ϸ� push
		if(!result.getString("succ_yn").equals("Y")){
			u.sp(" skstore ������� ���� ����!!!\npage:pop_reject_req_pop.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
			u.mail("nicedocu@nicednr.co.kr","skstore ������� ���� ����!!! ", " skstore ������� ���� ����!!!\npage:pop_reject_req_pop.jsp\ncont_no: "+ cont_no +"-"+ cont_chasu);
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
p.setVar("popup_title", "�ݷ�");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>