<%!

/*���� �ĺ� ���� ���� �Է�*/
public DataSet setSenderContPay(DB db, String cont_no, String cont_chasu){
	DataSet result = new DataSet();
	result.addRow();
	//���� ����
	//��� ���� ��ȸ
	DataObject contDao = new DataObject("tcb_contmaster");
	DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
	if(!cont.next()){
		result.put("succ_yn","N");
		result.put("err_msg","��������� �����ϴ�.");
		return result;
	}

	DataObject useInfoDao = new DataObject("tcb_useinfo");
	DataSet useInfo = useInfoDao.find("member_no = '"+cont.getString("member_no")+"' and useseq = (select max(useseq) from tcb_useinfo where member_no = '"+cont.getString("member_no")+"' )");
	if(!useInfo.next()){
		result.put("succ_yn","N");
		result.put("err_msg","����� ������ �����ϴ�.");
	    return result;
	}
	
	// �ĺ��� ���
	if(useInfo.getString("paytypecd").equals("50")){
		DataObject payDao = new DataObject("tcb_pay");
		int iPayAmount = 0;  //���� �ݾ�
		int iVatAmount = 0;
		int iCustNum = 1;
		String payContName = cont.getString("cont_name");
		
		if(useInfo.getString("order_write_type").equals("Y")) { // �����ڸ��� ����
			DataObject custDao = new DataObject("tcb_cust");
			iCustNum = custDao.getOneInt("select count(*) from tcb_cust where cont_no = '"+cont.getString("cont_no")+"' and cont_chasu = '"+cont.getString("cont_chasu")+"' and sign_seq < 10 and member_no <> '"+cont.getString("member_no")+"'");
		}
		
		DataObject useinfoaddDao = new DataObject("tcb_useinfo_add");
		DataSet useInfoAdd = useinfoaddDao.find("template_cd='"+cont.getString("template_cd")+"' and member_no='"+cont.getString("member_no")+"'");
		
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
		payDao.item("cont_no", cont.getString("cont_no"));
		payDao.item("cont_chasu", cont.getString("cont_chasu"));
		payDao.item("member_no", cont.getString("member_no"));
		payDao.item("cont_name", payContName);
		payDao.item("pay_amount", iPayAmount);
		payDao.item("pay_type", "05");
		payDao.item("accept_date", Util.getTimeString());
		payDao.item("receit_type","0");
		db.setCommand(payDao.getInsertQuery(), payDao.record);
		
		//tcb_cust update
		DataObject custDao = new DataObject("tcb_cust");
		custDao.item("pay_yn", "Y");
		db.setCommand(custDao.getUpdateQuery("cont_no = '"+cont.getString("cont_no")+"' and cont_chasu = '"+cont.getString("cont_chasu")+"' and member_no= '"+cont.getString("member_no")+"' "),custDao.record);
	}
	result.put("succ_yn","Y");
	result.put("err_msg", "");
	return result;
}

/*��༭ �ڵ� ����*/
public DataSet contAutoSign(String cont_no , String cont_chasu,  String user_ip) throws Exception{
	DataSet result = new DataSet();
	result.addRow();
	
	String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";
	
	DataObject contDao = new DataObject("tcb_contmaster");
	DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
	if(!cont.next()){
		result.put("succ_yn","N");
		result.put("err_msg", "��� ������ �����ϴ�.");
		return result;
	}
	
	if(!cont.getString("status").equals("30")){
		result.put("succ_yn","N");
		result.put("err_msg", "��༭ �ڵ� ���� ������ ���°� �ƴմϴ�.");
		return result;
	}
	
	DataObject custDao = new DataObject("tcb_cust");
	DataSet cust = custDao.find(where+" and member_no = '"+cont.getString("member_no")+"' ");
	if(!cust.next()){
		result.put("succ_yn","N");
		result.put("err_msg", "�ڵ� ���� ��ü ������ �����ϴ�.");
		return result;
	}
	
	if(!cust.getString("sign_date").equals("")){
		result.put("succ_yn","N");
		result.put("err_msg", "�̹� ���� �Ǿ� �ֽ��ϴ�.");
		return result;
	}
	
	String gap_sign_date = custDao.getOne("select max(sign_date) from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_date is not null") ;//����ö ����� ��û���� �ڵ�����ð��� �ŷ�ó ���Ѽ����Ͻ�+ 30��
	gap_sign_date = Util.addDate("S", 30, Util.strToDate(gap_sign_date), "yyyyMMddHHmmss");
	
	
	String[] agree_template_cds = {
			"20130500619|2016107"// ������ ������� ��༭ >������������
			,"20130500619|2019067"// ������ ������� ��༭(Ư������) > ������������ 2016107=>2019067 �� �����
			,"20130500619|2019189"// ������ ������� ��༭(Ư������) > ������������ 2016107=>2019067=>2019189 �� �����
			,"20130500619|2019188"// ������VIP ������ ���Ǽ�
			,"20130500619|2019274"// ������VIP ������ ���Ǽ�(�����)
			,"20130500619|2018147"// ������ ����Ź ������� ��༭
			,"20130500619|2020024"//������ �����༭(Ư������)

			,"20170501348|2018241"// �ƿ�Ȩ ���� ���ް�༭ >�е弭��
			,"20170501348|2018242"// �ƿ�Ȩ ���� ���ް�༭ >������������
			,"20170501348|2019047" // �ƿ�Ȩ �ٷΰ�༭(�����) > �е弭��
			,"20170501348|2019048" // �ƿ�Ȩ �ٷΰ�༭_������ > �е弭��
			,"20170501348|2019049" // �ƿ�Ȩ �ٷΰ�༭_������ > �е弭��
			,"20170501348|2019060" // �ƿ�Ȩ �ٷΰ�༭_������(����) > �е弭��
			,"20170501348|2019061" // �ƿ�Ȩ �ٷΰ�༭_������(����) > �е弭��
			,"20170501348|2019062" // �ƿ�Ȩ �ٷΰ�༭_�ϱ���(����) > �е弭��
			,"20170501348|2019063" // �ƿ�Ȩ �ٷΰ�༭_�ϱ��� > �е弭��
			,"20170501348|2019064" // �ƿ�Ȩ �ٷΰ�༭_��Ʈ(����) > �е弭��
			,"20170501348|2019065" // �ƿ�Ȩ �ٷΰ�༭_��Ʈ > �е弭��

			,"20181002679|2019058"// �����ũ����ũ> �ٷΰ�༭(�Ϲ���) >�е弭��
			,"20181002679|2019059"// �����ũ����ũ> ������༭ >�е弭��
			,"20181002679|2019074"// �����ũ����ũ> �ٷΰ�༭(�����) >�е弭��

			,"20150500312|2015037"// (��)����������>������༭(���� ����) > ������������
			,"20150500312|2015038"// (��)����������>��ǰ�Ǹ�(����)��༭ - �񿬵� ��༭ >������������
			,"20150500312|2018211"// (��)����������>��ǰ�Ǹ�(����)��༭(��ü��) >������������
			,"20150500312|2019209"// (��)����������>��ǰ�Ǹ�(����)��༭(��ü��) >������������
			,"20150500312|2018211"// (��)����������>��ǰ�Ǹ�(����)��༭>������������
			,"20150500312|2018212"// (��)����������>��ǰ�Ǹ�(ȥ��)��༭>������������
			,"20150500312|2018213"// (��)����������>����(����)��༭>������������

			,"20151100446|2019028"// ���̽���ؾ�> �������ް�༭ >�е弭��

			,"20171101813|2019015" //PGM)SK����� ������ ��༭[DB�Ǻ�]
			,"20171101813|2019016" //PGM)SK����� ������ ��༭[���׹��]
			,"20171101813|2019017" //PGM)SK����� �ǸŰ�༭[ȥ�ռ�����]
			,"20171101813|2019018" //PGM)SK����� �ǸŰ�༭[����Ź������]
			,"20171101813|2020192" //PGM)SK����� �ǸŹ�۰�༭[Ư��ȥ�ո���]

			,"20160500857|2020020"	//�ѱ����ڱ���>�ٷΰ�༭_������(���)
			,"20160500857|2020021"	//�ѱ����ڱ���>�ٷΰ�༭_������(�Ϲ���)
			,"20160500857|2020022"	//�ѱ����ڱ���>�ٷΰ�༭_�����(�Ϲݰ����)
			,"20160500857|2020035"	//�ѱ����ڱ���>NICE �������ޱ� ��ġ ǥ�ذ�༭
			,"20160500857|2020159"	//�ѱ����ڱ���>����������༭(������) 
			
			,"20190101731|2020053" //Ʈ����� �ֽ�ȸ�� �ٷΰ�༭_3õ�ʰ�
			,"20190101731|2020124" //Ʈ����� �ֽ�ȸ�� �ٷΰ�༭_3õ����
			,"20190101731|2020054" //Ʈ����� �ֽ�ȸ�� ������༭
			
			,"20180100028|2019112" // PBP��Ʈ���� �ٷΰ�༭ 
			,"20180100028|2020150" // PBP��Ʈ���� 2020��_���ް�༭_�ű�����
			,"20180100028|2020151" // PBP��Ʈ���� 2020��_���ް�༭_��������
			,"20180100028|2020152" // PBP��Ʈ���� 2020��_���ް�༭_�ű�ī��
			,"20180100028|2020153" // PBP��Ʈ���� 2020��_���ް�༭_����ī��
			,"20180100028|2020154" // PBP��Ʈ���� 2020��_������������������  
			};
	
	String[] server_cert_passwd = {
				 "20130500619=>wonder#001"//������
				,"20170501348=>ourhome7&&"//�ƿ�Ȩ
				,"20151100446=>nicednr1!@#"//���̽���ؾ�
				,"20181002679=>rudrltp_3010"//�����ũ����ũ
				,"20150500312=>bs220505^^"//(��)����������
				,"20171101813=>skstoa2018!"// SK�����
				,"20150700675=>vnemqlf1004!"//CJǪ���
				,"20150500269=>daeduck!12"//�������
				,"20160500857=>nice2122.."//�ѱ����ڱ���
				,"20190101731=>5dnjf7dlf@" // Ʈ����� �ֽ�ȸ�� 
				,"20180100028=>*adel0618*" //PBP��Ʈ����
			 };
	
	if(!(Util.inArray(cont.getString("member_no")+"|"+cont.getString("template_cd"), agree_template_cds)||cont.getString("cont_etc1").equals("auto_sign"))){
		result.put("succ_yn","N");
		result.put("err_msg", "�ڵ����� �������� �ƴմϴ�.");
		return result;
	}
	
	Crosscert crosscert = new Crosscert();
	DataSet signInfo = crosscert.serverSign(cont.getString("member_no"), Util.getItem(cont.getString("member_no"), server_cert_passwd), cont.getString("cont_hash"));
	
	if(!signInfo.getString("err").equals("")){
		result.put("succ_yn","N");
		result.put("err_msg", "��༭ ���� �����Ͽ����ϴ�.");
		return result;
	}
	
	String sign_dn = signInfo.getString("signDn");
	String sign_data = signInfo.getString("signData");
	if(sign_dn.equals("")||sign_data.equals("")){
		result.put("succ_yn","N");
		result.put("err_msg", "���ڼ��� �ʿ��� �����͸� ã�� �� �����ϴ�.\\n\\n�����ͷ� ���� �ٶ��ϴ�.");
		return result;
	}
	
	
	if (crosscert.chkSignVerify(sign_data).equals("SIGN_ERROR")){
		result.put("succ_yn","N");
		result.put("err_msg", "�ڵ����� ������ ���� �Ͽ����ϴ�.");
		return result;
	}
	
	if(!crosscert.getDn().equals(sign_dn)){
		result.put("succ_yn","N");
		result.put("err_msg", "�ڵ���������� DN���� ���� ���� �ʽ��ϴ�.");
		return result;
	}
	
	DB db = new DB();
	//db.setDebug(out);
	custDao = new DataObject("tcb_cust");
	custDao.item("sign_dn", sign_dn);
	custDao.item("sign_data", sign_data);
	custDao.item("sign_date", gap_sign_date);
	db.setCommand( custDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"'"),custDao.record);
	
	contDao = new DataObject("tcb_contmaster");
	contDao.item("status", "50");
	db.setCommand(contDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), contDao.record);
	
	String agree_seq = "";
	DataObject contAgreeDao = new DataObject("tcb_cont_agree");
	DataSet contAgree= contAgreeDao .find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", "agree_seq");
	while(contAgree.next()){
		agree_seq = contAgree.getString("agree_seq");
	}
	if(!agree_seq.equals("")){ // ���� ���� ���μ����� �ִ� ���. ���� ����Ǿ����� ǥ��
	
	    DataObject agreeDao = new DataObject("tcb_cont_agree");
	    agreeDao.item("ag_md_date", Util.getTimeString());
	    agreeDao.item("r_agree_person_id","SYSTEM");
	    agreeDao.item("r_agree_person_name", "�ý����ڵ�����");
	    db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_seq="+agree_seq),agreeDao.record);
	}

	result = setSenderContPay(db, cont_no, cont_chasu);
	if(!result.getString("succ_yn").equals("Y")){
		return result;
	}

	/* ���α� START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  cont.getString("member_no"), "0", "�ý����ڵ�����", user_ip, "���ڼ��� �Ϸ�",  "�ڵ�����", "50","10");
	/* ���α� END*/
	
	if(!db.executeArray()){
		result.put("succ_yn","N");
		result.put("err_msg", "�ڵ� ���� ���� �Է� ö�� ���� �Ͽ����ϴ�.");
		return result;
	}
	result.put("succ_yn","Y");
	result.put("err_msg", "");
	return result;
}


%>