<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
// ���� : http://dev.nicedocu.com/web/buyer/contract/emailView.jsp?rs=K6aUwRo6n1EItPeNxWEdMnqwmJH9X7
// ���뺸���� �̸��� Ȯ��
String rs = u.request("rs");  // �̸��� ���� ���ڿ�
if(rs.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

// ������� ��ȸ
String cont_no = "";
String cont_chasu = "";
String member_no  = "";
String member_name = "";
boolean person_yn = false;
String jumin_no = "";
Security security = new Security();

DataObject emailDao = new DataObject("tcb_cust");
DataSet email = emailDao.find("email_random = '" + rs + "'");
if(!email.next()){
	u.jsError("��������� ���� ���� �ʽ��ϴ�.");
	return;
} else {
	cont_no = email.getString("cont_no");
	cont_chasu = email.getString("cont_chasu");
	member_no = email.getString("member_no");
	member_name = email.getString("member_name");
}

boolean sign_able = false;
String file_path = "";

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_change_gubun = codeDao.getCodeArray("M010");

ContractDao contDao = new ContractDao("tcb_contmaster");
//contDao.setDebug(out);
DataSet cont = contDao.find(
" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'  and status in ('20','21','30','40','41') ",
"tcb_contmaster.*"
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null and member_no <> tcb_contmaster.member_no and sign_seq <= 10 ) recv_unsign_cnt "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null and sign_seq > 10) chain_unsign_cnt "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null and sign_seq <= 10 ) unsign_cnt "
+" ,(select member_name from tcb_member where member_no = tcb_contmaster.mod_req_member_no ) mod_req_name "
);
if(!cont.next()){
	u.jsError("��������� ���� ���� �ʽ��ϴ�.");
	return;
}
cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
cont.put("cont_date",u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
cont.put("change_gubun_str", u.getItem(cont.getString("change_gubun"), code_change_gubun)+"("+cont_chasu+"��)");

// �������� ��ȸ
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" status > 0 and template_cd ='"+cont.getString("template_cd")+"'", "agree_html, writer_type");
while(template.next()){
}

//������ �ۼ��׸��� �ְ� ���뺸������ �����ϴ� ��� ������ ���� ���θ� üũ �Ѵ�.
if(template.getString("writer_type").equals("Y")&&cont.getInt("recv_unsign_cnt")>0 ){
	cont.put("main_recv_sign_check", true);
}

// ����ü ��ȸ
DataObject custDao = new DataObject("tcb_cust a");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", "sign_seq asc");
if(cust.size()<1){
	u.jsError("����ü ������ ���� ���� �ʽ��ϴ�.");
	return;
}

while(cust.next()){
	cust.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust.getString("sign_date")));
	if(cust.getString("member_no").equals(member_no)){
		if(!cust.getString("jumin_no").equals("")){
			jumin_no = security.AESdecrypt(cust.getString("jumin_no"));
			if(jumin_no.length()==7) // 7401031
				jumin_no = jumin_no.substring(0,6);
			person_yn = true;
		}else{
			person_yn = false;
		}
		if(cust.getString("sign_dn").equals("")){
			sign_able = true;
		}
	}
}


//��༭�� ��ȸ
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and  (auto_type is null or auto_type <> '3')"); // �ۼ���ü�� ���� ��� ���� ����
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	if(cfile.getString("cfile_seq").equals("1")&&cfile.getString("auto_yn").equals("Y")){
		file_path = cfile.getString("file_path");
	}
	if(cfile.getString("auto_yn").equals("Y")){
		if(cfile.getString("auto_type").equals("1")){
			cfile.put("auto_str","�ڵ�÷��");
		}
		if(cfile.getString("auto_type").equals("2")){
			cfile.put("auto_str","�ʼ�÷��");
		}
		if(cfile.getString("auto_type").equals("")){
			cfile.put("auto_str","�ڵ�����");
			cfile.put("auto_type","0");
		}
	}else{
		cfile.put("auto_str", "����÷��");
	}
	cfile.put("auto_class", cfile.getString("auto_yn").equals("Y")?"caution-text":"");
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	if(cfile.getString("file_ext").toLowerCase().equals("pdf")){
		cfile.put("btn_name", "��ȸ(�μ�)");
		cfile.put("down_script","contPdfViewer2('"+u.aseEnc(cont_no)+"','"+cont_chasu+"','"+cfile.getString("cfile_seq")+"')");
	}else{
		cfile.put("btn_name", "�ٿ�ε�");
		cfile.put("down_script","filedown('file.path.bcont_pdf','"+cfile.getString("file_path")+cfile.getString("file_name")+"','"+cfile.getString("doc_name")+"."+cfile.getString("file_ext")+"')");
	}
}

//����������ȸ
DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(warr.next()){
    warr.put("cont_no", u.aseEnc(warr.getString("cont_no")));
	warr.put("haja", warr.getString("warr_type").equals("20"));
	warr.put("warr_type", u.getItem(warr.getString("warr_type"),code_warr));
	warr.put("warr_date", u.getTimeString("yyyy-MM-dd", warr.getString("warr_date")));
	warr.put("warr_sdate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_sdate")));
	warr.put("warr_edate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_edate")));
	warr.put("warr_amt", u.numberFormat(warr.getDouble("warr_amt"),0));
}


/* ���α� START*/
if(sign_able) {
	ContBLogDao logDao = new ContBLogDao();
	int view_cnt= logDao.findCount(
			 "     cont_no = '"+cont_no+"' "
			+" and cont_chasu = '"+cont_chasu+"' " 
			+" and member_no = '"+member_no+"' "
			+" and log_seq > (select max(log_seq) from tcb_cont_log where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"' and cont_status = '20' )"
			);
	if(view_cnt < 1){//�������ķ� ���� �α� ������ ������
		logDao = new ContBLogDao();
		logDao.setInsert(cont_no, String.valueOf(cont_chasu), member_no, "1", email.getString("user_name"), request.getRemoteAddr(), "���ڹ��� ��ȸ", "", cont.getString("status"),"20");
	}
}
/* ���α� END*/

if(u.isPost()&&f.validate()){
	//���� ����
	String sign_dn = f.get("sign_dn");
	String sign_data = f.get("sign_data");

	
	Crosscert crosscert = new Crosscert();
	crosscert.setEncoding("UTF-8");
	if (crosscert.chkSignVerify(sign_data).equals("SIGN_ERROR")){
		u.jsError("��������� ���� �Ͽ����ϴ�.");
		return;
	}
	if(!crosscert.getDn().equals(sign_dn)){
		u.jsError("��������� DN���� ���� ���� �ʽ��ϴ�.");
		return;
	}

	boolean sms = false;

	//���� ����
	DB db = new DB();
	//db.setDebug(out);
	custDao = new DataObject("tcb_cust");
	custDao.item("sign_dn", sign_dn);
	custDao.item("sign_data", sign_data);
	custDao.item("sign_date", u.getTimeString());
	db.setCommand( custDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+member_no+"'"),custDao.record);
	
	String status = cont.getString("status");
	DataObject agreeDao = new DataObject("tcb_cont_agree");
	int nagreeCnt = agreeDao.findCount(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd = '2'");  // ��ü ���� �� �����ڵ� ��
	
	if((cont.getInt("unsign_cnt")-1)==0 && (cont.getInt("chain_unsign_cnt")-1)==0){// �ۼ��ڸ� ��༭�� ���� ���� ��� �����¸� ���� ���� ���� �Ѵ�.
		sms = true;
		if(nagreeCnt > 1){ 
			status = "21";  // ������ ���� 2���̻��̸� ���δ��
		}else if(nagreeCnt == 0 && ( cont.getInt("chain_unsign_cnt") == 1  && cont.getInt("unsign_cnt") == 1)){ //���뺸���ڰ� �̼���, �����ڵ��� �̼���  �� 1�� �϶� �����ڵ�  "20" (���������� ���� ���ĵ鵵 ����)
			status = "20";  
		}else{
			status = "30";  // ������
		}
		contDao = new ContractDao();
		contDao.item("status", status);
		db.setCommand(contDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' "), contDao.record);

		// ���� �����ڰ� �ִ� ���
		if(nagreeCnt>0)
		{
			// ���� ���� ������ �� ��ü���� �� ������ �ʱ�ȭ
			DataObject agreeDao2 = new DataObject("tcb_cont_agree");
			agreeDao2.item("ag_md_date", "");
			agreeDao2.item("mod_reason", "");
			agreeDao2.item("r_agree_person_id","");
			agreeDao2.item("r_agree_person_name", "");
			db.setCommand( agreeDao2.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd = '2' "),agreeDao2.record);
		}
	}
	
	/* ���α� START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  email.getString("member_no"), "1", email.getString("user_name"), request.getRemoteAddr(), "���ڼ��� �Ϸ�",  "", "","10");
	/* ���α� END*/
	
	if(!db.executeArray()){
		u.jsError("���忡 ���� �Ͽ����ϴ�.");
		return;
	}

	// sms �� ���� �߼� ó��
	if(sms){
		
		if(nagreeCnt>0){//���������� �ִ� ���
			// ���� ���� ���� ����ڿ��� �ŷ�ó ����Ϸ� �˸�.
			DataSet agree = agreeDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd='2' and length(agree_person_id) > 0"); // ��Ʈ�� ������ �����ڰ� �ְ� �� �����ڰ� �μ��� �ƴ� 1���� ��� ó�� �����ڿ��� ���� ���� ����
			if(agree.next())
			{
				// �̸��� �˸�.
				String cust_name = ""; // ����ü��
				String to_email = "";		// ������ �̸���
	
				cust_name = email.getString("member_name");
	
				DataObject personDao = new DataObject("tcb_person");
				DataSet dsPerson = personDao.find("user_id='"+agree.getString("agree_person_id")+"'");	// ������ ����
				if(dsPerson.next())
				{
					to_email = dsPerson.getString("email");
	
					System.out.println("to_member_name : " + cust_name);
					System.out.println("to_email : " + to_email);
	
					p.clear();
					p.setVar("from_user_name", email.getString("member_name"));
					p.setVar("cust_name", cust_name);
					p.setVar("cont_name", cont.getString("cont_name"));
					p.setVar("cont_day", u.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));
					p.setVar("img_url", webUrl+"/images/email/20110620/");
					p.setVar("ret_url", webUrl+"/web/buyer/");
					u.mail(to_email, "[��� ���� �˸�] \"" +  cust_name + "\" ��ü�� ���ڰ�༭ ������ �Ϸ��Ͽ����ϴ�.", p.fetch("mail/cont_cust_sign.html"));
				}
			}
		}else{//���������� ���� ���
			if(!template.getString("doc_type").equals("2")){
				//�ۼ��� email
				custDao = new DataObject("tcb_cust");
				String recv_email = custDao.getOne("select email from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"'  ");
				if(!email.equals("")){
					p.clear();
					DataSet mailInfo = new DataSet();
					mailInfo.addRow();
					mailInfo.put("cust_name", email.getString("member_name"));
					mailInfo.put("cont_name", cont.getString("cont_name"));
					mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
					p.setVar("info", mailInfo);
					p.setVar("server_name", request.getServerName());
					p.setVar("return_url", "web/buyer/");
					String mail_body = p.fetch("../html/mail/cont_send_mail.html");
					u.mail(recv_email, "[��� ���� �˸�] \"" +  email.getString("member_name") + "\" ��ü�� ���ڰ�༭ ������ �Ϸ��Ͽ����ϴ�.", p.fetch("mail/cont_cust_sign.html"));
				}
			}
			SmsDao smsDao= new SmsDao();
			// sms ����
			cust.first();
			while(cust.next()){
				if(cust.getString("member_no").equals(cont.getString("member_no"))){
					smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), email.getString("member_name")+" ���� ���ڰ�༭ ����Ϸ� - ���̽���ť(�Ϲݱ����)");
				}
			}
		}
	}

	u.jsAlertReplace("���������� ���� �Ǿ����ϴ�.","emailView.jsp?rs="+rs);
	return;
}


p.setLayout("link");
p.setDebug(out);
p.setBody("contract.emailView");
p.setVar("popup_title","������༭");
p.setVar("template", template);
p.setVar("cont", cont);
p.setVar("person_yn", person_yn);
p.setVar("jumin_no", jumin_no);
if(u.inArray(cont.getString("status"), new String[]{"20","21","30"})){
	p.setVar("status_name", sign_able?"�����û":"����������");
}
if(cont.getString("status").equals("40")){
	sign_able = false;
	p.setVar("status_name", "������û");
}
if(cont.getString("status").equals("41")){
	sign_able = true;
	p.setVar("status_name", "�ݷ�");
}

p.setVar("sign_able", sign_able);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("warr", warr);
p.setVar("rs", rs);
p.setVar("file_path", file_path);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>