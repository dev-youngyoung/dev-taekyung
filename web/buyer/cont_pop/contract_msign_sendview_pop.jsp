<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] server_cert_member = {"20171101813"};//�������̽����
String[] server_cert_passwd = {"20171101813=>skstoa2018!"}; 
boolean serverSign = u.inArray(_member_no, server_cert_member); 

String key = u.request("key");

String contstr = u.aseDec(key);  // ���ڵ�
if(contstr.length() != 12)
{
	out.print("No Permission!!");
	return;
}
String cont_no = contstr.substring(0,11);
String cont_chasu = contstr.substring(11);

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
String[] code_status = codeDao.getCodeArray("M008");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_change_gubun = codeDao.getCodeArray("M010");
String[] code_auto_type = {"=>�ڵ�����","1=>�ڵ�÷��","2=>�ʼ�÷��","3=>���ο�"};
String[] code_sign_type = codeDao.getCodeArray("M042");

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and status in ('11','12','20','21','30','40','41') ",
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

//���� �����ؾ� �ϴ� ����(�μ��ڵ� / ���̵�)
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
        , "a.*"
         +", (select cust_type from tcb_cont_sign where cont_no = a.cont_no and cont_chasu=a.cont_chasu and sign_seq = a.sign_seq ) cust_type"
         +", (select member_gubun from tcb_member where member_no = a.member_no ) member_gubun"
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
	cust.put("sign_type_nm",  u.getItem(cust.getString("sign_type"), code_sign_type));

	if(!cust.getString("jumin_no").equals("")){
		cust.put("jumin_no", u.aseDec(cust.getString("jumin_no")));
	}else{
		cust.put("jumin_no", "");
	}
	cust.put("boss_birth_date", u.getTimeString("yyyy-MM-dd", cust.getString("boss_birth_date")));
}

// ���뺸�� ��ü
DataObject custChainDao = new DataObject("tcb_cust");
DataSet cust_chain = custChainDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq > 10","*");
while(cust_chain.next()){
	cust_chain.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust_chain.getString("sign_date")));
}


//��༭�� ��ȸ
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
    if(cfile.getString("cfile_seq").equals("1")){
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
        cfile.put("down_script","contPdfViewer('"+cfile.getString("cont_no") +"','"+cfile.getString("cont_chasu")+"','"+cfile.getString("cfile_seq")+"')");
    }else{
        cfile.put("btn_name", "�ٿ�ε�");
        cfile.put("down_script","filedown('file.path.bcont_pdf','"+cfile.getString("file_path")+cfile.getString("file_name")+"','"+cfile.getString("doc_name")+"."+cfile.getString("file_ext")+"')");
    }
}

//������ ������ȸ
DataObject stampDao = new DataObject("tcb_stamp ts left join tcb_member tm on ts.member_no=tm.member_no");
DataSet stamp = stampDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "ts.*, tm.member_name, tm.vendcd");
while(stamp.next()){
    stamp.put("cont_no", u.aseEnc(stamp.getString("cont_no")));
    stamp.put("stamp_money", u.numberFormat(stamp.getDouble("stamp_money"), 0));
    stamp.put("issue_date", u.getTimeString("yyyy-MM-dd", stamp.getString("issue_date")));
    stamp.put("vendcd", u.getBizNo(stamp.getString("vendcd")));
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
						+"     and a.cont_chasu = '"+cont_chasu+"' " 
						+"   order by a.rfile_seq asc ";
	}else{
		rfile_query =	 "  select a.attch_yn, a.doc_name, a.rfile_seq, a.allow_ext,b.file_path, b.file_name, b.file_ext, b.file_size,  b.member_no"
						+"    from tcb_rfile a  "
						+"    left outer join  tcb_rfile_cust b "
						+"      on a.cont_no = b.cont_no  "
						+"     and a.cont_chasu = b.cont_chasu "
						+"     and a.rfile_seq = b.rfile_seq "
						+"     and b.member_no = '"+rfile_cust.getString("member_no")+"' "
						+"   where  a.cont_no = '"+cont_no+"'  "
						+"     and a.cont_chasu = '"+cont_chasu+"' " 
                                                +"   order by a.rfile_seq asc ";
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
	//���� ����
	//��� ���� ��ȸ
	DataObject useInfoDao = new DataObject("tcb_useinfo");
	DataSet useInfo = useInfoDao.find("member_no = '"+_member_no+"' and useseq = (select max(useseq) from tcb_useinfo where member_no = '"+_member_no+"' )");
	if(!useInfo.next()){
	    u.jsError("����� ������ �����ϴ�.");
	    return;
	}
	
	if(useInfo.getString("paytypecd").equals("30")){//�Ǻ���
		int pay_money = useInfo.getInt("recpmoneyamt");// �����ݾ� 
		if(useInfo.getString("instedyn").equals("Y")){
			pay_money += useInfo.getInt("suppmoneyamt");
		}
		if(pay_money> 0 ){
			DataObject payDao = new DataObject("tcb_pay");
			DataSet pay = payDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+_member_no+"'  ");
			if(!pay.next()){
				u.jsError("���̽���ť �̿�� ���� ������ �����ϴ�.\\b\\b���� ���θ� Ȯ�� �ϼ���.");
				return;
			}
		}
	}
	
    //���� ����
    String sign_dn = f.get("sign_dn");
    String sign_data = f.get("sign_data");
    String agree_seq = f.get("agree_seq");

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
    
    DB db = new DB();
    //db.setDebug(out);
    custDao = new DataObject("tcb_cust");
    custDao.item("sign_dn", sign_dn);
    custDao.item("sign_data", sign_data);
    custDao.item("sign_date", u.getTimeString());
    db.setCommand( custDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+_member_no+"'"),custDao.record);

    contDao = new ContractDao();
    contDao.item("status", "50");
    db.setCommand(contDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), contDao.record);

    if(cont.getString("change_gubun").equals("90")){
        contDao = new ContractDao();
        contDao.item("status", "91");
        db.setCommand(contDao.getUpdateQuery("cont_no='"+cont_no+"'"), contDao.record);
    }

    
    if(!agree_seq.equals("")){ // ���� ���� ���μ����� �ִ� ���. ���� ����Ǿ����� ǥ��
    
        DataObject agreeDao = new DataObject("tcb_cont_agree");
        agreeDao.item("ag_md_date", u.getTimeString());
        agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
        agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
        db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_seq="+agree_seq),agreeDao.record);
    }

    if( u.inArray(auth.getString("_MEMBER_TYPE"), new String[]{"01","03"})&&!pay_yn){//��� �ۼ� ��ü�̰� ���� ���������
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

    /* ���α� START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "���ڼ��� �Ϸ�",  "", "50","10");
	/* ���α� END*/

    if(!db.executeArray()){
        u.jsError("���� ���忡 ���� �Ͽ����ϴ�.");
        return;
    }

    // �̸��� �˸�(��� ���� ��ü).
    String from_member_name = "";
    String to_member_names = "";
    String from_email = "";
    
    //�̸� �����
    cust.first();
    while(cust.next()){
        if(cust.getString("member_no").equals(_member_no)){
            from_member_name = cust.getString("member_name");
            from_email = cust.getString("email");
        }else{
        	if(to_member_names.equals("")) to_member_names="/";
            to_member_names += cust.getString("member_name");
        }
    }
    
    //���۽���
    SmsDao smsDao = new SmsDao();
    String rtn_url = "web/buyer/";
    cust.first();
    while(cust.next()){
    	
    	rtn_url = "web/buyer/sdd/email_msign_callback.jsp?cont_no="+u.aseEnc(cont_no)+"&cont_chasu="+cont_chasu+"&email_random="+cust.getString("email_random");;
    	if(cust.getString("email").equals("")||cust.getString("member_no").equals(_member_no)) continue;
        p.clear();
        p.setVar("from_member_name", from_member_name);
        p.setVar("to_member_name", to_member_names);
        p.setVar("server_name", request.getServerName());
        p.setVar("cont_name", cont.getString("cont_name"));
        p.setVar("cont_date", u.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));
        p.setVar("ret_url", rtn_url);
        u.mail(cust.getString("email"), "[��� ü�� �˸�] " +  cont.getString("cont_name") + " ����� ü�� �Ǿ����ϴ�.", p.fetch("../html/mail/cont_finish_mail.html"));
        
        String linkUrl = request.getRequestURL().substring(0, request.getRequestURL().indexOf("/web/buyer")) + "/"+rtn_url;
        String subject = "[���̽���ť]"+auth.getString("_MEMBER_NAME")+" �ȳ�";
		String longMessage = "["+auth.getString("_MEMBER_NAME")+"] ���ü���� �Ϸ� �Ǿ����ϴ�. \n" 
				+ " *�ȳ�* \n1.���Ź��� ��༭�� ���� PC������ ��༭��ȸ�� �����մϴ�.("+cust.getString("email")
				+ "���� Ȯ�ΰ���) \n2.�ý��� �̿� ���Ǵ� ���̽���ť �����ͷ� ���ּ���. \n3.��� ���� ���Ǵ� ����ü�� ������ڿ��� ���ּ���.\n"
				+ linkUrl;
		smsDao.sendLMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), subject, longMessage);
    }

    // ���ΰ����� �ִ� ��� �̸��Ϸ� ������ڿ��� ���ξ˸��� ���̽���ť ����ȣ + ��༭PDF��ũ�� �����ش�.
    if(!agree_seq.equals("")){
        if(!cont.getString("reg_id").equals("mns1082074")){ // kt m&s ����ȭ �븮, �ʹ� ������ ���� �ͼ� ������ ����
            p.clear();
            p.setVar("from_member_name", from_member_name);
            p.setVar("to_member_name", to_member_names);
            p.setVar("cont_name", cont.getString("cont_name"));
            p.setVar("cont_date", u.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));
            p.setVar("server_name", request.getServerName());
            p.setVar("ret_url", "web/buyer/");
            p.setVar("copy_url","web/buyer/contract/cin.jsp?key=" + u.aseEnc(cont_no+cont_chasu));
            p.setVar("manage_no", cont_no + "-" + cont_chasu + "-" + cont.getString("true_random"));
            String mail_body =  p.fetch("../html/mail/cont_finish_link_mail.html");
            u.mail(from_email, "[��� ü�� �˸�] " +  cont.getString("cont_name") + " ����� ü�� �Ǿ����ϴ�.", mail_body);
        }
    }

    u.jsAlertReplace("���� ���� �Ͽ����ϴ�.\\n\\n����� �Ϸ� �Ǿ����ϴ�.\\n\\n�Ϸ�� ������ ���Ϸ�>�Ϸ�(�������)���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.","contract_send_list.jsp?"+u.getQueryString());
    return;
}
p.setLayout("popup");
//p.setDebug(out);
p.setBody("cont_pop.contract_msign_sendview_pop");
p.setVar("menu_cd","000060");
p.setVar("auth_select",u.request("view_readonly").equals("Y")?true:_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000060", "btn_auth").equals("10"));
p.setVar("popup_title","������(�������)");
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("change_cont", Integer.parseInt(cont_chasu)>0);
p.setVar("gap_yn",gap_yn);
p.setVar("cont", cont);
p.setLoop("contSub", contSub);

if(agreeTemplate.size() > 0)
{
	total_seq = agreeTemplate.size();

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
	
	if(now_person_id.equals("")?bFieldEqual:bPersonEqual && !u.inArray(cont.getString("status"),new String[]{"41"}))  //41 : �ݷ�
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
			p.setVar("towriter_reject_able", true);  // �ۼ��ڿ��� �ݷ�
		}
		else if(now_seq >= (cust_seq+1) && now_seq < total_seq && !cont.getString("status").equals("20") ) // ��ü���� �����̰� �����ڰ� �ƴ� ������ ��� ( ��ü����->������(O)->������ )
		{
			p.setVar("agree_able", true);   // �������
			p.setVar("towriter_reject_able", true);  // �ۼ��ڿ��� �ݷ�
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

	if(!isReject && last_person_id.equals(auth.getString("_USER_ID")) && now_seq != cust_seq)	// ������ �������̰� ��ü �������ʰ� �ƴ϶�� '���� ���'�� �� �ִ�.
		p.setVar("agree_cancel", true);

	p.setVar("agree_seq", now_seq);

}else{
	p.setVar("send_cancel", cont.getInt("sign_cnt")==0&&cont.getString("status").equals("20"));// ���� �� ��� ������츸 ���� ��� ����
	p.setVar("return_able", u.inArray(cont.getString("status"),new String[]{"40","30"}));// ������û�̸� �ݷ�����
	p.setVar("sign_able", cont.getInt("unsign_cnt")==1);// Ÿ�� ���� �Ϸ� �� ���� ����
}

p.setVar("file_path", file_path);
p.setVar("template", template);
p.setLoop("sign_template", signTemplate);
p.setLoop("agreeTemplate", agreeTemplate);
p.setLoop("cust", cust);
if(cust_chain.size()>0) p.setLoop("cust_chain", cust_chain);
p.setLoop("cfile", cfile);
p.setLoop("warr", warr);
p.setLoop("stamp", stamp);
p.setLoop("rfile_cust", rfile_cust);
p.setLoop("efile", efile);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>
