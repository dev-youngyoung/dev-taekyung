<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000157";
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

String file_path = "";
boolean gap_yn = false;// �α����� ��ü�������� ���� cust_type == "01" �̸� ���̴�.
boolean pay_yn = false;// �α����� ��ü�� ���� ���� (�ۼ������� ���� ��� ����� �Ǿ� �ִ�.)

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("����� ������ �������� �ʽ��ϴ�.");
	return;
}


CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = new String[] {"30=>��û��","41=>�ݷ�","50=>�Ϸ�"};//code.getCodeArray("M008", " and code in ('30','41','50')"); // 30:��û��(������), 41:�ݷ�, 50:���Ϸ�
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_change_gubun = codeDao.getCodeArray("M010");
String[] code_auto_type = {"=>�ڵ�����","1=>�ڵ�÷��","2=>�ʼ�÷��","3=>���ο�"};

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and status in ('30','41','50') ",
 "tcb_contmaster.*"
+" ,(select max(user_name) from tcb_person where user_id = tcb_contmaster.reg_id ) writer_name "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is not null ) sign_cnt "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null  ) unsign_cnt "
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
cont.put("status_name", u.getItem(cont.getString("status"),code_status));
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
cont.put("reg_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("reg_date")));
cont.put("change_gubun_str", u.getItem(cont.getString("change_gubun"), code_change_gubun) + (_member_no.equals("20150500217") ? "" : "("+cont_chasu+"��)"));
if(!cont.getString("src_cd").equals(""))
cont.put("src_nm", cont.getString("l_src_nm")+" > "+cont.getString("m_src_nm")+" > "+cont.getString("s_src_nm"));

// �߰� ��༭ ��ȸ
DataObject contSubDao = new DataObject("tcb_cont_sub");
DataSet contSub = contSubDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and (gubun <> '40' or (gubun = '40' and option_yn in ('A','Y')))");
while(contSub.next()){
    contSub.put("cont_no", u.aseEnc(contSub.getString("cont_no")));
	contSub.put("hidden", u.inArray(contSub.getString("gubun"), new String[]{"20","30"}));
}

// �������� ��ȸ
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find("template_cd ='"+cont.getString("template_cd")+"'");
if(!template.next()){
}
DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","*","sign_seq asc");

// ���� �������� ��ȸ
// ���� �����ؾ� �ϴ� ����(�μ��ڵ� / ���̵�)
String now_field_seq = "";
String now_person_id = "";
String last_person_id = ""; // ���� ������ ��� id
int now_seq = 0;			// ���� ����ܰ� seq
int cust_seq = 0;
int total_seq = 0;
int last_agree_seq = 0;		// ���� ������ seq
boolean isReject = false;	// ���� �ݷ�����
DataObject agreeTemplateDao = new DataObject("tcb_cont_agree");
DataSet agreeTemplate= agreeTemplateDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", "agree_seq");
while(agreeTemplate.next()){
    agreeTemplate.put("cont_no", u.aseEnc(agreeTemplate.getString("cont_no")));
    agreeTemplate.put("is_cust", agreeTemplate.getString("agree_cd").equals("0"));
    agreeTemplate.put("ag_md_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", agreeTemplate.getString("ag_md_date")));
    
    if(!agreeTemplate.getString("r_agree_person_id").equals("")){
    	agreeTemplate.put("agree_status_nm", agreeTemplate.getString("mod_reason").equals("")?"�Ϸ�":"�ݷ�");
    	agreeTemplate.put("css", "is-active");
    	agreeTemplate.put("agree_person_name", agreeTemplate.getString("r_agree_person_name"));
    	last_agree_seq = agreeTemplate.getInt("agree_seq");
    	last_person_id = agreeTemplate.getString("r_agree_person_id");
    }else{
    	if(now_field_seq.equals("")&&now_person_id.equals("")){
    		now_field_seq = agreeTemplate.getString("agree_field_seq");
    		now_person_id = agreeTemplate.getString("agree_person_id");
    		now_seq = agreeTemplate.getInt("agree_seq");
    	}
    	agreeTemplate.put("agree_status_nm", "");
    	agreeTemplate.put("css", "");
    }
    if(!agreeTemplate.getString("mod_reason").equals("")){
    	agreeTemplate.put("agree_status_nm", agreeTemplate.getString("agree_cd").equals("0")?"����/�ݷ�":agreeTemplate.getString("agree_status_nm"));
    	agreeTemplate.put("agree_status_nm", "<font style='color:#0000ff'>"+agreeTemplate.getString("agree_status_nm")+"</font>");
    	agreeTemplate.put("ag_md_date", "<font style='color:#0000ff'>"+agreeTemplate.getString("ag_md_date")+"</font>");
    	if(!agreeTemplate.getString("agree_cd").equals("0")){
	    	p.setVar("isReject", true);
	        p.setVar("mod_reason", agreeTemplate.getString("mod_reason"));
	        isReject = true;
    	}
    }
    
    // �ŷ�ó�� seq
    if(agreeTemplate.getString("agree_cd").equals("0"))
        cust_seq = agreeTemplate.getInt("agree_seq");
}

// ���� �ݷ������̸� �ۼ��ڰ� ������ �� �ֵ��� ����.
if(isReject){
    agreeTemplate.first();
    now_field_seq = agreeTemplate.getString("agree_field_seq");
    now_person_id = agreeTemplate.getString("agree_person_id");
    now_seq = agreeTemplate.getInt("agree_seq");
}

// ����ü ��ȸ
DataObject custDao = new DataObject("tcb_cust a");
DataSet cust = custDao.find(
		" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq <= 10"
		,"a.*, (select cust_type from tcb_cont_sign where cont_no = a.cont_no and cont_chasu=a.cont_chasu and sign_seq = a.sign_seq ) cust_type"
		,"a.display_seq asc"
		);
if(cust.size()<1){
	u.jsError("����ü ������ ���� ���� �ʽ��ϴ�.");
	return;
}
while(cust.next()){
	
    cust.put("cont_no", u.aseEnc(cust.getString("cont_no")));
	if(cust.getString("member_no").equals(_member_no)&&cust.getString("cust_type").equals("01")) {
		gap_yn = true;
	}
	if(cust.getString("member_no").equals(_member_no)&&cust.getString("pay_yn").equals("Y"))pay_yn = true;
	cust.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust.getString("sign_date")));
	cust.put("sign_str", cust.getString("member_no").equals(_member_no)?"�����Ͻ�":"��û�Ͻ�");
}


//��༭�� ��ȸ
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	//if(cfile.getString("cfile_seq").equals("1")&&cfile.getString("auto_yn").equals("Y")){
	if(cfile.getString("cfile_seq").equals("1")){   // �������Ŀ��� ���񼭷� ����� �������� auto_yn ����
		file_path = cfile.getString("file_path");
	}
	if(cfile.getString("auto_yn").equals("Y")){
		cfile.put("auto_str", u.getItem(cfile.getString("auto_type"), code_auto_type));
		if(cfile.getString("auto_type").equals("")){
			cfile.put("auto_type","0");
		}
	}else{
		cfile.put("auto_str", "����÷��");
	}
	cfile.put("auto_class", cfile.getString("auto_yn").equals("Y")?"caution-text":"");
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	if(cfile.getString("file_ext").toLowerCase().equals("pdf")){
		cfile.put("btn_name", "��ȸ(�μ�)");
		cfile.put("down_script","contPdfViewer('"+u.request("cont_no")+"','"+cont_chasu+"','"+cfile.getString("cfile_seq")+"')");
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

// ��ü�� ���� ���� ��ȸ
DataObject rfileDao = new DataObject("tcb_rfile");

//custDao.setDebug(out);
DataSet rfile_cust = custDao.query(
 " select a.*  "
+"   from tcb_cust a, tcb_cont_sign b "
+"  where a.cont_no= b.cont_no  "
+"    and a.cont_chasu = b.cont_chasu "
+"    and a.sign_seq = b.sign_seq  "
+"    and a.cont_no = '"+cont_no+"' "
+"    and a.cont_chasu = '"+cont_chasu+"' "
+"    and b.cust_type <> '01' "
+"  order by a.cont_no asc, a.cont_chasu asc, a.sign_seq asc "
);
while(rfile_cust.next()){
    rfile_cust.put("cont_no", u.aseEnc(rfile_cust.getString("cont_no")));

	String rfile_query = "";
	if(rfile_cust.getString("sign_seq").equals("2")){
		rfile_query =	 "  select a.attch_yn, a.doc_name, a.rfile_seq, a.allow_ext,b.file_path, b.file_name, b.file_ext, b.file_size,  b.member_no"
						+"    from tcb_rfile a  "
						+"    left outer join  tcb_rfile_cust b "
						+"      on a.cont_no = b.cont_no  "
						+"     and a.cont_chasu = b.cont_chasu "
						+"     and a.rfile_seq = b.rfile_seq "
						+"     and b.member_no in ('"+rfile_cust.getString("member_no")+"', '"+cont.getString("member_no")+"'  )"
						+"   where  a.cont_no = '"+cont_no+"'  "
						+"     and a.cont_chasu = '"+cont_chasu+"' " ;
	}else{
		rfile_query =	 "  select a.attch_yn, a.doc_name, a.rfile_seq, a.allow_ext,b.file_path, b.file_name, b.file_ext, b.file_size,  b.member_no"
						+"    from tcb_rfile a  "
						+"    left outer join  tcb_rfile_cust b "
						+"      on a.cont_no = b.cont_no  "
						+"     and a.cont_chasu = b.cont_chasu "
						+"     and a.rfile_seq = b.rfile_seq "
						+"     and b.member_no = '"+rfile_cust.getString("member_no")+"' "
						+"   where  a.cont_no = '"+cont_no+"'  "
						+"     and a.cont_chasu = '"+cont_chasu+"' " ;
	}

	//rfileDao.setDebug(out);
	DataSet rfile = rfileDao.query(rfile_query);
	while(rfile.next()){
		rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
		rfile.put("file_size", u.getFileSize(rfile.getLong("file_size")));
	}
	rfile_cust.put(".rfile",rfile);
}


//���� ���� ���� ��ȸ
String[] code_reg_type = {"10=><span class='caution-text'>�ʼ�÷��</span>","20=>����÷��","30=>�߰�÷��"};
DataObject efileDao = new DataObject("tcb_efile");
DataSet efile = new DataSet();
if(cont.getString("efile_yn").equals("Y")){
	efile = efileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
	while(efile.next()){
		efile.put("str_reg_type", u.getItem(efile.getString("reg_type"), code_reg_type));
		efile.put("required", u.inArray(efile.getString("reg_type"), new String[]{"10","30"})?"required='Y'":"");
		efile.put("doc_name_readonly", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"readonly":"");
		efile.put("doc_name_class", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"in_readonly":"label");
		efile.put("del_yn10", efile.getString("reg_type").equals("10")&&!efile.getString("file_name").equals(""));
		efile.put("del_yn20", efile.getString("reg_type").equals("20")&&!efile.getString("file_name").equals(""));
		efile.put("del_yn30", efile.getString("reg_type").equals("30"));
		efile.put("file_size_str", u.getFileSize(efile.getInt("file_size")));
		efile.put("down_script","filedown('file.path.bcont_pdf','"+efile.getString("file_path")+efile.getString("file_name")+"','"+efile.getString("doc_name")+"."+efile.getString("file_ext")+"')");
	}
}

if(u.isPost()&&f.validate()){
	String agree_seq = f.get("agree_seq");

	DB db = new DB();
	//db.setDebug(out);
	custDao = new DataObject("tcb_cust");
	custDao.item("sign_date", u.getTimeString());
	db.setCommand( custDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+_member_no+"'"),custDao.record);

	contDao = new ContractDao();
	contDao.item("status", "50");
	contDao.item("mod_req_date", "");
	contDao.item("mod_req_member_no", "");
	contDao.item("mod_req_reason", "");
	
	db.setCommand(contDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), contDao.record);

	if(cont.getString("change_gubun").equals("90")){
		contDao = new ContractDao();
		contDao.item("status", "91");
		db.setCommand(contDao.getUpdateQuery("cont_no='"+cont_no+"'"), contDao.record);
	}

	boolean bWriterNoti = false;
	if(!agree_seq.equals("")) // ���� ���� ���μ����� �ִ� ���. ���� ����Ǿ����� ǥ��
	{
		DataObject agreeDao = new DataObject("tcb_cont_agree");
		agreeDao.item("ag_md_date", u.getTimeString());
		agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
		agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
		db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_seq="+agree_seq),agreeDao.record);

		// �Ϸ�� ��� �̸��Ϸ� ������ڿ��� ���ξ˸��� ���̽���ť ����ȣ + ��༭PDF��ũ�� �����ش�.
		bWriterNoti = true;
	}

	if( u.inArray(auth.getString("_MEMBER_TYPE"), new String[]{"01","03"})&&!pay_yn){//��� �ۼ� ��ü�̰� ���� ���������
		//��� ���� ��ȸ
		DataObject useInfoDao = new DataObject("tcb_useinfo");
		DataSet useInfo = useInfoDao.find("member_no = '"+_member_no+"' and useseq = (select max(useseq) from tcb_useinfo where member_no = '"+_member_no+"' )");
		if(!useInfo.next()){
			u.jsError("����� ������ �����ϴ�.");
			return;
		}
		
		// �ĺ��� ���
		if(useInfo.getString("paytypecd").equals("50")){
			
			DataObject payDao = new DataObject("tcb_pay");		
			int iPayAmount = 0;  //���� �ݾ�
			int iVatAmount = 0;
			int iCustNum = 1; 
			String payContName = cont.getString("cont_name");
			
			if(useInfo.getString("order_write_type").equals("Y")) { // �����ڸ��� ����
				iCustNum = custDao.getOneInt("select count(*) from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq < 10 and member_no <> '"+_member_no+"'");
			}
			
			DataObject useinfoaddDao = new DataObject("tcb_useinfo_add");
			DataSet useInfoAdd = useinfoaddDao.find("template_cd='"+cont.getString("template_cd")+"' and member_no='"+_member_no+"'");
			
			// �ĺ��ε� ��ĺ��� ��� �ΰ��Ұ� �ִٸ�
			if(useInfoAdd.next()) {
				iPayAmount = useInfoAdd.getInt("recpmoneyamt") * iCustNum;
				if(useInfoAdd.getString("insteadyn").equals("Y")){  // ���޾�ü�� �볳�� ���
					iPayAmount += useInfoAdd.getInt("suppmoneyamt");
					payContName += "(�볳����)";
				}
			}else{
				iPayAmount = useInfo.getInt("recpmoneyamt") * iCustNum;
				if(useInfo.getString("insteadyn").equals("Y")){  // ���޾�ü�� �볳�� ���
					iPayAmount += useInfo.getInt("suppmoneyamt");
					payContName += "(�볳����)";
				}
			}

			iVatAmount = iPayAmount/10;
			iPayAmount = iPayAmount+iVatAmount;				
			
			//tcb_pay insert
			payDao.item("cont_no", cont_no);
			payDao.item("cont_chasu", cont_chasu);
			payDao.item("member_no", _member_no);
			payDao.item("cont_name", payContName);
			payDao.item("pay_amount", iPayAmount);
			payDao.item("pay_type", "05");
			payDao.item("accept_date", u.getTimeString());
			payDao.item("receit_type","0");
			db.setCommand(payDao.getInsertQuery(), payDao.record);				

			//tcb_cust update
			custDao = new DataObject("tcb_cust");
			custDao.item("pay_yn", "Y");
			db.setCommand(custDao.getUpdateQuery("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no= '"+_member_no+"' "),custDao.record);
		}
	}

	if(!db.executeArray()){
		u.jsError("���� ���忡 ���� �Ͽ����ϴ�.");
		return;
	}

	// �̸��� �˸�(��� ���� ��ü).
	String from_member_name = "";
	String to_member_name = "";
	String from_email = "";
	String to_email = "";
	String to_username = "";
	DataSet dsCust = custDao.find("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
	while(dsCust.next())
	{
		if(dsCust.getInt("sign_seq")==1)
		{
			from_member_name = dsCust.getString("member_name");
			from_email = dsCust.getString("email");
		}
		else
		{
			to_member_name = dsCust.getString("member_name");
			to_email = dsCust.getString("email");
			to_username = dsCust.getString("user_name");
		}
	}

	DataSet mailInfo = new DataSet();
	mailInfo.addRow();
	mailInfo.put("member_name", to_member_name);
	mailInfo.put("user_name", to_username);
	mailInfo.put("template_name", cont.getString("cont_name"));
	
	p.setVar("server_name", request.getServerName());
	p.setVar("return_url", "/web/buyer/contract/subscription_v.jsp?c="+u.aseEnc(cont_no));
	p.setVar("info", mailInfo);
	if(!cust.getString("email").equals("")){
		DataObject emailDao = new DataObject("tcb_cont_email");
		int email_seq = emailDao.getOneInt("select nvl(max(email_seq),0)+1 from tcb_cont_email where cont_no='"+cont_no+"' and cont_chasu="+cont_chasu);
		p.setVar("emailChk", "/web/buyer/contract/emailReadCheck.jsp?cont_no="+cont_no+"&cont_chasu="+cont_chasu+"&member_no="+cust.getString("member_no")+"&num="+email_seq);
		String mail_body = p.fetch("../html/mail/subscription_finish.html");
		System.out.println(mail_body);
		u.mail(cust.getString("email"), "[�˸�] "+cont.getString("cont_name")+" ����� �Ϸ� �Ǿ����ϴ�.", mail_body );

		emailDao.item("cont_no", cont_no);
		emailDao.item("cont_chasu", cont_chasu);
		emailDao.item("member_no", cust.getString("member_no"));
		emailDao.item("email_seq", email_seq);
		emailDao.item("send_date", u.getTimeString());
		emailDao.item("member_name", "�Ϸ�");
		emailDao.item("user_name", cust.getString("user_name"));
		emailDao.item("email", cust.getString("email"));
		emailDao.item("status", "01");
		emailDao.insert();
	}
	
	
	// ���ΰ����� �ִ� ��� �̸��Ϸ� ������ڿ��� ���ξ˸��� ���̽���ť ����ȣ + ��༭PDF��ũ�� �����ش�.
	if(bWriterNoti)
	{
		p.clear();
		p.setVar("from_member_name", from_member_name);
		p.setVar("to_member_name", to_member_name);
		p.setVar("cont_name", cont.getString("cont_name"));
		p.setVar("cont_day", u.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));
		p.setVar("img_url", webUrl+"/images/email/20110620/");
		p.setVar("ret_url", webUrl+"/web/buyer/");
		p.setVar("copy_url", webUrl+"/web/buyer/contract/cin.jsp?key=" + u.aseEnc(cont_no+cont_chasu));
		p.setVar("manage_no", cont_no + "-" + cont_chasu + "-" + cont.getString("true_random"));
		u.mail(from_email, "[��� ü�� �˸�] " +  cont.getString("cont_name") + " ����� �Ϸ� �Ǿ����ϴ�.", p.fetch("mail/cont_finish_link_mail.html"));
		
	}

	u.jsAlertReplace("����� �Ϸ� �Ǿ����ϴ�.","subscription_list.jsp?"+u.getQueryString());
	return;
}
p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.subscription_view");
p.setVar("menu_cd", _menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("change_cont", Integer.parseInt(cont_chasu)>0);
p.setVar("gap_yn",gap_yn);
p.setVar("cont", cont);
p.setLoop("contSub", contSub);
p.setVar("btn_cont_delete", cont.getString("status").equals("30"));
if(agreeTemplate.size() > 0)
{
	total_seq = agreeTemplate.size();
/*
	u.p("total_seq : " + total_seq);
	u.p("cust_seq : " + cust_seq);
	u.p("now_seq : " + now_seq);
	u.p("now_field_seq : " + now_field_seq + " / login_field : " + auth.getString("_FIELD_SEQ"));
	u.p("now_person_id : " + now_person_id + " / login_person : " + auth.getString("_USER_ID"));
	u.p("reg_id : " + cont.getString("reg_id"));
*/

	boolean bFieldEqual = false;
	boolean bPersonEqual = false;
	if(now_person_id.equals("")) // �μ����̸� ������
		bPersonEqual = true;
	else if(now_person_id.equals(auth.getString("_USER_ID"))) // �α����� ����� �����ؾ߸�
		bPersonEqual = true;

	if(now_field_seq.equals(auth.getString("_FIELD_SEQ")))	// �α����� ����� �����μ�
		bFieldEqual = true;


	
	/*
	u.p("now_field_seq : " + now_field_seq);
	u.p("_FIELD_SEQ : " + auth.getString("_FIELD_SEQ"));
	u.p("bFieldEqual : " + bFieldEqual);
	u.p("bPersonEqual : " + bPersonEqual);
	*/
	
	if(bPersonEqual && !u.inArray(cont.getString("status"),new String[]{"41"}))  //41 : �ݷ�
	{
	 
		
	//u.p("now_seq : " + now_seq);
	//u.p("cust_seq : " + cust_seq);

		if(now_seq == (cust_seq-1)) // ��ü���� ���� ����
		{
			p.setVar("send_able", true);  // ��ü�� ����
			p.setVar("towriter_reject_able", true);  // �ۼ��ڿ��� �ݷ�
		}
		else if(now_seq == total_seq)  // ���� ������
		{
			p.setVar("sign_able", true);	// ����
			p.setVar("tocust_reject_able", true);  // ��ü���� �ݷ�
		}
		else if(now_seq >= (cust_seq+1) && now_seq < total_seq && !cont.getString("status").equals("20") ) // ��ü���� �����̰� �����ڰ� �ƴ� ������ ��� ( ��ü����->������(O)->������ )
		{
			p.setVar("agree_able", true);   // �������
			p.setVar("tocust_reject_able", true);  // ��ü���� �ݷ�
		}
		else 
		{
			if(cont.getString("status").equals("20")){ 
				p.setVar("agree_able", false);   // �������
			}else{ // 
				p.setVar("agree_able", true);   // �������
				p.setVar("towriter_reject_able", true);  // �ۼ��ڿ��� �ݷ�
			}
		}
		
		
		

	}
	if(now_seq == cust_seq)
		p.setVar("send_cancel", cont.getInt("sign_cnt")==0&&cont.getString("status").equals("20"));// ���� �� ��� ������츸 ���� ��� ����

	if(isReject) // ���ιݷ�
	{
		p.setVar("send_able", false);  // ��ü�� ����
		if(cont.getString("reg_id").equals(auth.getString("_USER_ID"))) 
		{
			p.setVar("modify_able", true);   // ��༭����
		}
	}

	if(!isReject && cont.getString("reg_id").equals(auth.getString("_USER_ID")) ) // ���� �ݷ� �ƴ����� ��ü ������û�̸�
		p.setVar("return_able", u.inArray(cont.getString("status"),new String[]{"40"}));// ������û�̸� ��������
		//p.setVar("return_able", u.inArray(cont.getString("status"),new String[]{"40","21","30"}));// ������û(40),���δ��(21),������(30) �̸� ��������

	if(!isReject && last_person_id.equals(auth.getString("_USER_ID")) && now_seq != cust_seq)	// ������ �������̰� ��ü �������ʰ� �ƴ϶�� '���� ���'�� �� �ִ�.
		p.setVar("agree_cancel", true);

	p.setVar("agree_seq", now_seq);
}
else
{

	p.setVar("send_cancel", cont.getInt("sign_cnt")==0&&cont.getString("status").equals("20"));// ���� �� ��� ������츸 ���� ��� ����
	p.setVar("return_able", u.inArray(cont.getString("status"),new String[]{"40","30"}));// ������û�̸� �ݷ�����
	p.setVar("sign_able", cont.getInt("unsign_cnt")==1 && cont.getString("status").equals("30"));// Ÿ�� ���� �Ϸ� �� ���� ����
}


p.setVar("file_path", file_path);
p.setVar("template", template);
p.setLoop("sign_template", signTemplate);
p.setLoop("agreeTemplate", agreeTemplate);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("warr", warr);
p.setLoop("rfile_cust", rfile_cust);
p.setLoop("efile", efile);
p.setVar("reSendMail", u.inArray(cont.getString("status"), new String[]{"41","50"}));
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>