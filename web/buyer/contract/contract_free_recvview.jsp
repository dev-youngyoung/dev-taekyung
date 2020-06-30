<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="include_cont_func.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}


boolean sign_able = false;
String cust_type = "";// �޴� ����� ���� ��� 01 ���� ��� 02
boolean gap_yn = false;// �α����� ��ü�������� ���� cust_type == "01" �̸� ���̴�.
String file_path = "";


CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");

boolean person_yn = false;
String jumin_no = "";
String pay_yn = "";

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'",
" tcb_contmaster.* "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is not null ) sign_cnt "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null ) unsign_cnt "
+" ,(select member_name from tcb_member where member_no = tcb_contmaster.mod_req_member_no ) mod_req_name "
+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,3) = substr(tcb_contmaster.src_cd,0,3) and depth='1') l_src_nm "
+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,6) = substr(tcb_contmaster.src_cd,0,6) and depth='2') m_src_nm "
+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and src_cd = tcb_contmaster.src_cd and depth='3') s_src_nm "
);
if(!cont.next()){
	u.jsError("��������� ���� ���� �ʽ��ϴ�.");
	return;
}
cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
cont.put("cont_date",u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
cont.put("cont_edate",u.getTimeString("yyyy-MM-dd",cont.getString("cont_edate")));
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
if(!cont.getString("src_cd").equals(""))
cont.put("src_nm", cont.getString("l_src_nm")+" > "+cont.getString("m_src_nm")+" > "+cont.getString("s_src_nm"));

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+cont.getString("member_no")+"' ");
if(!member.next()){
	u.jsError("�ۼ���ü ������ ���� ���� �ʽ��ϴ�.");
	return;
}


DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","*","sign_seq asc");

// ����ü ��ȸ
DataObject custDao = new DataObject("tcb_cust a");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","a.*, (select cust_type from tcb_cont_sign where cont_no = a.cont_no and cont_chasu=a.cont_chasu and sign_seq = a.sign_seq ) cust_type");
if(cust.size()<1){
	u.jsError("����ü ������ ���� ���� �ʽ��ϴ�.");
	return;
}

while(cust.next()){
	cust.put("cont_no", u.aseEnc(cust.getString("cont_no")));
	if(cust.getString("member_no").equals(_member_no)){
		cust_type = cust.getString("cust_type");
		if(cust.getString("sign_dn").equals("")){
			sign_able = true;
		}
		
		if(!cust.getString("jumin_no").equals("")){
			jumin_no = u.aseDec(cust.getString("jumin_no"));
			if(jumin_no.length()==7) // 7401031
				jumin_no = jumin_no.substring(0,6);
			person_yn = true;
		}else{
			person_yn = false;
		}
		
		if(cust.getString("cust_type").equals("01"))gap_yn = true;
		pay_yn = cust.getString("pay_yn");
	}
	cust.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust.getString("sign_date")));
}


//��༭�� ��ȸ
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	if(file_path.equals("")){
		file_path = cfile.getString("file_path");
	}
	cfile.put("auto", cfile.getString("auto_yn").equals("Y")?true:false);
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	cfile.put("pdf_yn", cfile.getString("file_ext").toLowerCase().equals("pdf"));
}

//������ ������ȸ
//����� ���� ���� ���� �������� ��� ����ó �������� �������� �Ѵ�. 20160616 skl
DataObject stampDao = new DataObject("tcb_stamp ts left join tcb_member tm on ts.member_no=tm.member_no");
DataSet stamp = stampDao.find(" ts.cont_no = '"+cont_no+"' and ts.cont_chasu = '"+cont_chasu+"' and ts.member_no = '"+_member_no+"'  ", "ts.*, tm.member_name, tm.vendcd");
while(stamp.next()){
	stamp.put("cont_no", u.aseEnc(stamp.getString("cont_no")));
	stamp.put("stamp_money", u.numberFormat(stamp.getDouble("stamp_money"), 0));
	stamp.put("issue_date", u.getTimeString("yyyy-MM-dd", stamp.getString("issue_date")));
	stamp.put("vendcd", u.getBizNo(stamp.getString("vendcd")));
	stamp.put("recv_stamp", stamp.getString("member_no").equals(_member_no));
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


// ��ü�� ���� ���� ��ȸ
String rfile_query =
" select a.*  "
		+"   from tcb_cust a, tcb_cont_sign b "
		+"  where a.cont_no= b.cont_no  "
		+"    and a.cont_chasu = b.cont_chasu "
		+"    and a.sign_seq = b.sign_seq  "
		+"    and a.cont_no = '"+cont_no+"' "
		+"    and a.cont_chasu = '"+cont_chasu+"' "
		+"    and b.cust_type <> '01' ";
//if(!cust_type.equals("01")) rfile_query += " and a.member_no ='"+_member_no+"'";
rfile_query += "order by a.cont_no asc, a.cont_chasu asc, a.sign_seq asc";


DataObject rfileDao = new DataObject();
//rfileDao.setDebug(out);
DataSet rfile_cust = rfileDao.query(rfile_query);

while(rfile_cust.next()){
   
	rfile_cust.put("cont_no", u.aseEnc(rfile_cust.getString("cont_no")));
	rfile_cust.put("attch_area", rfile_cust.getString("member_no").equals(_member_no));

	//rfileDao.setDebug(out);
	DataSet rfile = rfileDao.query(
	 "  select a.attch_yn, a.doc_name, a.rfile_seq, b.file_path, b.file_name, b.file_ext, file_size "
	+"    from tcb_rfile a  "
	+"    left outer join  tcb_rfile_cust b "
	+"      on a.cont_no = b.cont_no  "
	+"     and a.rfile_seq = b.rfile_seq  "
	+"     and a.cont_chasu = b. cont_chasu "
	+"     and b.member_no = '"+rfile_cust.getString("member_no")+"' "
	+"   where  a.cont_no = '"+cont_no+"'  "
	+"     and a.cont_chasu = '"+cont_chasu+"' "
	);
	while(rfile.next()){
		rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
		rfile.put("file_size", u.getFileSize(rfile.getLong("file_size")));
	}
	rfile_cust.put(".rfile",rfile);
}

if(u.isPost()&&f.validate()){
	
	//��������
	DataObject useInfoDao = new DataObject("tcb_useinfo");
	DataSet useInfo = useInfoDao.find("member_no = '"+cont.getString("member_no")+"'");
	if(!useInfo.next()){
		u.jsError("��༭ �߽����� ����� ������ �����ϴ�.");
		return;
	}
	
	if(!pay_yn.equals("Y")){
		if(!useInfo.getString("insteadyn").equals("Y")&&useInfo.getInt("suppmoneyamt")>0){//�볳�� �ƴϰ� �����ݾ��� 0���� ũ��
			DataObject payDao = new DataObject("tcb_pay");
			DataSet pay = payDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no  = '"+_member_no+"' ");
			if(!pay.next()){
				u.jsError("���̽���ť �̿�� ���� ������ �����ϴ�.\\b\\b���� ���θ� Ȯ�� �ϼ���.");
				return;
			}
		}
	}
	
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
		u.jsError("������� DN���� ���� ���� �ʽ��ϴ�.");
		return;
	}

	boolean sms = false;
	SmsDao smsDao= new SmsDao();
	int nagreeCnt = 0 ;
	//���� ����
	DB db = new DB();
	//db.setDebug(out);
	custDao = new DataObject("tcb_cust");
	custDao.item("sign_dn", sign_dn);
	custDao.item("sign_data", sign_data);
	custDao.item("sign_date", u.getTimeString());
	db.setCommand( custDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+_member_no+"'"),custDao.record);

	String status = cont.getString("status");
	if((cont.getInt("unsign_cnt")-1)==1){// �ۼ��ڸ� ��༭�� ���� ���� ��� �����¸� ���� ���� ���� �Ѵ�.
		DataObject agreeDao = new DataObject("tcb_cont_agree");
		nagreeCnt = agreeDao.findCount(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd = '2'");  // ��ü ���� �� �����ڵ� ��
		
		if(cont.getInt("chain_unsign_cnt")==0){// �̼��� ���� ������ ���� ���
			sms = true;
			if(nagreeCnt > 1){
				status = "21";  // ������ ���� 2���̻��̸� ���δ��
			}else{
				status = "30";  // ������
			}
		}

		contDao = new ContractDao();
		contDao.item("mod_req_date","");
		contDao.item("mod_req_member_no","");
		contDao.item("mod_req_reason","");
		contDao.item("status", status);
		db.setCommand(contDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' "), contDao.record);

		// ���� �����ڰ� �ִ� ���
		if(nagreeCnt>0){
			// ���� ���� ������ �� ��ü���� �� ������ �ʱ�ȭ
			agreeDao = new DataObject("tcb_cont_agree");
			agreeDao.item("ag_md_date", "");
			agreeDao.item("mod_reason", "");
			agreeDao.item("r_agree_person_id","");
			agreeDao.item("r_agree_person_name", "");
			db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd = '2' "),agreeDao.record);

			// ���� ���� ������ �� ��ü���� �� �Է�
			agreeDao = new DataObject("tcb_cont_agree");
			agreeDao.item("ag_md_date", u.getTimeString());
			agreeDao.item("mod_reason", "");
			agreeDao.item("r_agree_person_id", auth.getString("_USER_ID"));
			agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
			db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd = '0' "),agreeDao.record);
			
		}
		
		//�Ϸ��� ��� ���� ���� �Է�
		if(status.equals("50")){//�Ϸ��� ��� �������� �Է�

			// ���¾�ü ����� �ٷ� �Ϸ��̰� �ĺ��̸�...  �翬�� ������ڰ� �볳.
			// �ĺ��� �ƴϸ� �̹� ���� �� �Ѿ�� �����̴� �Ϸ� ó����
			if(useInfo.getString("paytypecd").equals("50")){ // �ĺ�
				DataObject useinfoaddDao = new DataObject("tcb_useinfo_add");
				DataSet useInfoAdd = useinfoaddDao.find("template_cd='"+cont.getString("template_cd")+"' and member_no='"+cont.getString("member_no")+"'");

				String payContName = cont.getString("cont_name");
				int iPayAmount = 0;  //���� �ݾ�
				int iVatAmount = 0;

				// ��ĺ��� ������ �ݾ��� ������ ���޾�ü �ݾ� + ������� �ݾ�
				if ( useInfoAdd.next() ){ // ��ĺ��� ��� �ΰ��Ұ� �ִٸ�
					iPayAmount = useInfoAdd.getInt("recpmoneyamt");
					if(useInfoAdd.getString("insteadyn").equals("Y")){  // ���޾�ü �볳�ΰ��
						iPayAmount += useInfoAdd.getInt("suppmoneyamt");
						payContName += "(�볳����)";
					}
				}else{ // ������ �⺻������ ����.
					iPayAmount = useInfo.getInt("recpmoneyamt");
					if(useInfo.getString("insteadyn").equals("Y")){  // ���޾�ü�� �볳�� ���
						iPayAmount += useInfo.getInt("suppmoneyamt");
						payContName += "(�볳����)";
					}
				}

				iVatAmount = iPayAmount/10;
				iPayAmount = iPayAmount+iVatAmount;

				//tcb_pay insert
				DataObject payDao = new DataObject("tcb_pay");
				payDao.item("cont_no", cont_no);
				payDao.item("cont_chasu", cont_chasu);
				payDao.item("member_no", cont.getString("member_no"));
				payDao.item("cont_name", payContName);
				payDao.item("pay_amount", iPayAmount);
				payDao.item("pay_type", "05");
				payDao.item("accept_date", u.getTimeString());
				payDao.item("receit_type","0");
				db.setCommand(payDao.getInsertQuery(), payDao.record);

				//tcb_cust update
				DataObject custPayDao = new DataObject("tcb_cust");
				custPayDao.item("pay_yn", "Y");
				db.setCommand(custPayDao.getUpdateQuery("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no= '"+cont.getString("member_no")+"' "),custPayDao.record);
			}
		}
		
		
	}
	
	/* ���α� START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "���ڼ��� �Ϸ�",  "", status,"10");
	/* ���α� END*/

	if(!db.executeArray()){
		u.jsError("���忡 ���� �Ͽ����ϴ�.");
		return;
	}
	

	if(cont.getString("template_cd").equals("2016112")){// ���Ƿ��� �������� SMS�߼� ����
		sms = false;
	}

	if(u.inArray(cont.getString("template_cd"), new String[] {"2017021","2017023","2017024","2017025","2017048"})){ // �Ѽ���ũ���� ������༭�� SMS �߼� ����
		sms = false;
	}

	// sms �� ���� �߼� ó��
	if(sms){
		if(nagreeCnt>0){//���� ���� �ִ� ���
			// ���� ���� ���� ����ڿ��� �ŷ�ó ����Ϸ� �˸�.
			DataObject agreeDao = new DataObject("tcb_cont_agree");
			DataSet agree = agreeDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd='2' and length(agree_person_id) > 0","*"," agree_seq asc"); // ��Ʈ�� ������ �����ڰ� �ְ� �� �����ڰ� �μ��� �ƴ� 1���� ��� ó�� �����ڿ��� ���� ���� ����
			if(agree.next()){
				// �̸��� �˸�.

				DataObject personDao = new DataObject("tcb_person");
				DataSet agree_person = personDao.find("user_id='"+agree.getString("agree_person_id")+"'");	// ������ ����
				if(agree_person.next()){
					if(!agree_person.getString("email").equals("holic123@ktmns.com")){ // kt m&s ������ �迬�� ��� �Ȱ�����... �ʹ� ���� ���� ����
						p.clear();
						DataSet mailInfo = new DataSet();
						mailInfo.addRow();
						mailInfo.put("cust_name", auth.getString("_MEMBER_NAME"));
						mailInfo.put("cont_name", cont.getString("cont_name"));
						mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
						p.setVar("info", mailInfo);
						p.setVar("server_name", request.getServerName());
						p.setVar("return_url", "web/buyer/");
						String mail_body = p.fetch("../html/mail/cont_send_mail.html");
						u.mail(agree_person.getString("email"), "[��� ���� �˸�] \"" +  auth.getString("_MEMBER_NAME") + "\" ��ü�� ���ڰ�༭ ������ �Ϸ��Ͽ����ϴ�.", p.fetch("mail/cont_cust_sign.html"));
						smsDao.sendSMS("buyer", agree_person.getString("hp1"), agree_person.getString("hp2"), agree_person.getString("hp3"), auth.getString("_MEMBER_NAME")+" ���� ���ڰ�༭ ����Ϸ� - ���̽���ť(�Ϲݱ����)");
					}
				}
			}
		}else{//���� ���� ���� ���
			//�ۼ��� email
			custDao = new DataObject("tcb_cust");
			String email = custDao.getOne("select email from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"'  ");
			if(!email.equals("")){
				p.clear();
				DataSet mailInfo = new DataSet();
				mailInfo.addRow();
				mailInfo.put("cust_name", auth.getString("_MEMBER_NAME"));
				mailInfo.put("cont_name", cont.getString("cont_name"));
				mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
				p.setVar("info", mailInfo);
				p.setVar("server_name", request.getServerName());
				p.setVar("return_url", "web/buyer/");
				String mail_body = p.fetch("../html/mail/cont_send_mail.html");
				u.mail(email, "[��� ���� �˸�] \"" +  auth.getString("_MEMBER_NAME") + "\" ��ü�� ���ڰ�༭ ������ �Ϸ��Ͽ����ϴ�.", p.fetch("mail/cont_cust_sign.html"));
			}
			// sms ����
			cust.first();
			while(cust.next()){
				if(cust.getString("member_no").equals(cont.getString("member_no"))){
					smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), auth.getString("_MEMBER_NAME")+" ���� ���ڰ�༭ ����Ϸ� - ���̽���ť(�Ϲݱ����)");
				}
			}
		}
	}

	if(cont.getString("cont_etc1").equals("auto_sign")) {
		DataSet result = contAutoSign(cont_no, cont_chasu, request.getRemoteAddr());
		if(!result.getString("succ_yn").equals("Y")){
			u.sp("��༭ �ڵ����� ����!!!\npage:contract_free_recvview.jsp\ncont_no:"+cont_no+"-"+cont_chasu);
			u.mail("nicedocu@nicednr.co.kr","��༭ �ڵ����� ����!!!", " ��༭ �ڵ��������!!!\npage:contract_free_recvview.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		}
		status = "50";
	}
	if(status.equals("50")){  // ����Ϸ�
		u.jsAlertReplace("���ڼ����� �Ϸ� �Ǿ����ϴ�.","contend_free_recvview.jsp?"+u.getQueryString());
	}else{
		u.jsAlertReplace("���ڼ��� ó�� �Ǿ����ϴ�.","contract_free_recvview.jsp?"+u.getQueryString());
	}
	return;
}
p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_free_recvview");
p.setVar("menu_cd","000061");
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("person_yn", person_yn);
p.setVar("jumin_no", jumin_no);
p.setVar("gap_yn", gap_yn);
p.setVar("cont", cont);
if(u.inArray(cont.getString("status"), new String[]{"20","30"})){
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
p.setLoop("sign_template", signTemplate);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("stamp", stamp);
p.setLoop("warr", warr);
p.setLoop("rfile_cust", rfile_cust);
p.setVar("file_path", file_path);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>