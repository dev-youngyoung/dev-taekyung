<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<% 
     
	/*
    ��ȿ�� URL���� Ȯ�� �ʿ�

    ���URL�� [���� ȸ����ȣ + "|" + ����ڵ�]�� AES ��ȣȭ�ؼ� ����, �ɼ����� ���� ���� URL�� ���ߴ� ��ȵ� ���
    �� : http://dev.nicedocu.com/web/buyer/contract/subscription.jsp?tcode=689663dfeeb0441e795e80a2e03fdf2e11e6be24e09a3ae6772099a5167a7f5d

  	SDD��û�� 

  	NICEPAY�� ���� 1�� ���� ���� (������ : 02-2186-4900, �̴��� : T 02-2186-4808)
  	NICEPAY �����������̿�� �̿��û�� (2012014)                                 
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=689663dfeeb0441e795e80a2e03fdf2e11e6be24e09a3ae6772099a5167a7f5d
  	NICEPAY ��ǥ��༭ (2017331)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=1dcdd471686090c83a6d90ca0d67412b053531eb22aacd61066714d5c3655ec4
  	NICEPAY ��༭ makeshop(soho) (2018168)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=566c5baac06349aef96234e0a4b39bfc91b1917129c916bb4075dd76bb01916f
  	NICEPAY ��������_�Ľ��� (2019129)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=ba7f45089f3a9517b85097a35521312fe341bfd111fd19cd19c1c95d665fa4dd
  	NICEPAY ����ιٿ�ó ���ڰ�༭ (2019266)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=ba7f45089f3a9517b85097a35521312f4f2dd4aa162b0ec44eeaf97be56c762e
	NICEPAY ��ǥ��༭_test (2019295)
	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=ba7f45089f3a9517b85097a35521312fa502f8251310dd22ca534d1a2dd8226b

  	Link ADX ���� ���� ��û��
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=05e88916f7d63f28587b9994de2780556973b41ce434a38c146c458d60c6075f
  	Linkprice ���� ���� ��û��
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=05e88916f7d63f28587b9994de278055fc7c24b1c7af372b5828ca69389ffcb7
	
    NICEPAY ��༭(������)(2020172)
    http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=6f3f650b27ae82317ec58c100d861fc7b6b3950bf5b5cd3d0d1a4657385461d3
 
    NICEPAY ��༭(������)_��Ϻ���� (2020173)
    http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=6f3f650b27ae82317ec58c100d861fc7b79934d16552c64afa6578cc31158903
  		
	NICE������� ���̽����� ���� ���� ��û�� (2019285)    
	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=f457a0124c5a4d0f042a0ecd4c9d630a35c1c8d49e60948c19e422d18141ad5b
	
    NICEPAY ��༭(����Ƽ��) (2020202)
	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=6f3f650b27ae82317ec58c100d861fc7d51542b7e1854d8526909034e20e4b2f
		  		
	
		
    */
	String[] tcode;
	String _member_no = "";
	String template_cd = "";

	try {
		tcode = u.aseDec(u.request("tcode")).split("\\|");
		_member_no = tcode[0];
		template_cd = tcode[1];
		System.out.println("tcode["+tcode+"]");
		System.out.println("_member_no["+_member_no+"]");
		System.out.println("template_cd["+template_cd+"]");

		if(_member_no.equals("")||template_cd.equals("")){
			u.jsError("�������� ��η� ���� �ϼ���.");
			return;
		}
	}
	catch(Exception e)
	{
		u.jsError("�������� ��η� ���� �ϼ���.");
		return;
	}

	if(!u.inArray(template_cd, new String[] {"2017331","2018168","2019295","2020172","2020173","2020202"})) // �ߺ���û ��� (��ǥ��༭)
	{
		DataObject contCheck = new DataObject("tcb_contmaster tm inner join tcb_cust tc on tm.cont_no=tc.cont_no and tm.cont_chasu=tc.cont_chasu");
		DataSet cCheck = contCheck.find("tm.subscription_yn='Y' and tm.template_cd='" + template_cd + "' and tc.vendcd='" + f.get("vendcd") + "'", "tm.cont_no");
		if (cCheck.next()) {
			u.jsError("�̹� ��û�� ��û���� �ֽ��ϴ�.");
			return;
		}
	}

	DataObject memberDao = new DataObject("tcb_member");
	DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
	if(!member.next()){
		u.jsError("����� ������ ���� ���� �ʽ��ϴ�.");
		return;
	}

//�������� ��ȸ
	DataObject templateDao = new DataObject("tcb_cont_template");
	DataSet template= templateDao.find(" status > 0 and template_cd ='"+template_cd+"'");
	if(!template.next()){
	}
	

//�߰� �������� ��ȸ
	DataObject templateSubDao = new DataObject("tcb_cont_template_sub");
	DataSet templateSub= templateSubDao.find("template_cd ='"+template_cd+"'", "*", "sub_seq");
	while(templateSub.next()){
		templateSub.put("hidden", u.inArray(templateSub.getString("gubun"), new String[]{"20","30"}) );
		if(templateSub.getString("option_yn").equals("A")) // �ڵ� �����ؾ� �ϴ� ���
			templateSub.put("option_yn", false);

	}

	String chkVendcd = f.get("vendcd").substring(3,5);
	String mgubun = "";
	if( u.inArray(chkVendcd, new String[] {"81","82","83","84","86","87","88"}) ){
		mgubun = "01";
	}else if(chkVendcd.equals("85")){
		mgubun = "01";
	}else{
		mgubun = "02";
	}

	f.addElement("vendcd", u.request("vendcd"), "hname:'����ڹ�ȣ', required:'Y'");
	f.addElement("vendcd1", u.request("vendcd").substring(0,3), "hname:'����ڹ�ȣ', required:'Y'");
	f.addElement("vendcd2", u.request("vendcd").substring(3,5), "hname:'����ڹ�ȣ', required:'Y'");
	f.addElement("vendcd3", u.request("vendcd").substring(5), "hname:'����ڹ�ȣ', required:'Y'");
	f.addElement("member_name", null, "hname:'ȸ���', required:'Y'");
	f.addElement("boss_name", null, "hname:'��ǥ�ڸ�', required:'Y'");
	f.addElement("post_code", null, "required:'Y'");
	f.addElement("slno1", null, "hname:'���ε�Ϲ�ȣ ���ڸ�', fixbyte:6, maxlength:6, option:'number'");
	f.addElement("slno2", null, "hname:'���ε�Ϲ�ȣ ���ڸ�', fixbyte:7, maxlength:7, option:'number'");
	if(mgubun.equals("01")) { // ����
		f.addElement("birthday", null, "hname:'�������', fixbyte:6, maxlength:6, option:'number'");
	} else {
		f.addElement("birthday", null, "hname:'�������', required:'Y', fixbyte:6, maxlength:6, option:'number'");
	}

	f.addElement("address", null, "hname:'����� �ּ�', required:'Y'");
	f.addElement("user_name", null, "hname:'��û�ڸ�', required:'Y'");
	f.addElement("hp1", null, "hname:'�޴�����ȣ ���ڸ�', required:'Y', fixbyte:3, option:'number'");
	f.addElement("hp2", null, "hname:'�޴�����ȣ �߰��ڸ�', required:'Y', minbyte:3, maxlength:4, option:'number'");
	f.addElement("hp3", null, "hname:'�޴�����ȣ ���ڸ�', required:'Y', fixbyte:4, option:'number'");
	f.addElement("tel_num", null, "hname:'��û�� ��ȭ��ȣ', required:'Y'");
	f.addElement("email", null, "hname:'��û�� �̸���', required:'Y', option:'email'");

//�������� ��ȸ
	DataObject signTemplateDao = new DataObject("tcb_cont_sign_template");
	DataSet signTemplate = signTemplateDao.find(" template_cd = '"+template_cd+"'","*","sign_seq asc");
	String default_sign_seq = "";
	while(signTemplate.next()){
		if(signTemplate.getString("cust_type").equals("01"))   // cust_type -  01:��, 02:��, 00:���뺸��      member_type - 01:�ۼ���ü, 02:���ž�ü
			default_sign_seq = signTemplate.getString("sign_seq");
	}

//���񼭷� ��ȸ
	DataObject rfileDao = new DataObject("tcb_rfile_template");
//rfileDao.setDebug(out);
	DataSet rfile = rfileDao.find("template_cd = '"+template_cd+"' and member_no ='"+_member_no+"'");
	while(rfile.next()){
		rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
		if(rfile.getString("reg_type").equals("10")){
			rfile.put("attch_disabled","disabled");
			rfile.put("doc_name_class", "in_readonly");
			rfile.put("doc_name_readonly", "readonly");
			rfile.put("del_btn_yn", false);
		}else{
			rfile.put("attch_disabled","");
			rfile.put("doc_name_class", "label");
			rfile.put("doc_name_readonly", "");
			rfile.put("del_btn_yn", true);
		}
	}

//������ ���� ��ȸ
	DataObject recvDao = new DataObject("tcb_subscription");
	DataSet recv_user = recvDao.query(
			"	select b.user_id, c.member_no, c.vendcd, c.post_code, c.member_slno, c.address, c.member_name, c.boss_name, c.member_gubun"
					+"	        ,b.user_name, b.email ,b.tel_num, b.hp1, b.hp2,b.hp3, b.field_seq, b.division "
					+"	  from tcb_subscription a "
					+"	       inner join tcb_person b on a.recv_userid=b.user_id "
					+"	       inner join tcb_member c on b.member_no=c.member_no "
					+"	 where a.template_cd = '"+ template_cd +"'"
	);
	if(!recv_user.next()){
		u.jsError("������ ������ �������� �ʽ��ϴ�.");
		return;
	}


	if(u.isPost()&&f.validate()){
		response.setHeader("Cache-Control","no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		if (request.getProtocol().equals("HTTP/1.1"))
			response.setHeader("Cache-Control", "no-cache");

		//���� ����
		String sign_dn = f.get("sign_dn");
		String sign_data = f.get("sign_data");
		String cont_no = f.get("cont_no");
		String cont_chasu = f.get("cont_chasu");
		String cont_hash = f.get("cont_hash");

		Crosscert cert = new Crosscert();
		cert.setEncoding("UTF-8");
		if (cert.chkSignVerify(sign_data).equals("SIGN_ERROR")){
			u.jsError("��������� ���� �Ͽ����ϴ�.");
			return;
		}
		if(!cert.getDn().equals(sign_dn)){
			u.jsError("��������� DN���� ���� ���� �ʽ��ϴ�.");
			return;
		}

		//���Ⱓ���ϱ�
		String cont_sdate = f.get("cont_sdate").replaceAll("-","");
		String cont_edate = f.get("cont_edate").replaceAll("-","");
		if(!f.get("cont_syear").equals("")&&!f.get("cont_smonth").equals("")&&!f.get("cont_sday").equals("")){
			cont_sdate = Util.strrpad(f.get("cont_syear"),4,"0")+Util.strrpad(f.get("cont_smonth"),2,"0")+Util.strrpad(f.get("cont_sday"),2,"0");
		}
		if(!f.get("cont_eyear").equals("")&&!f.get("cont_emonth").equals("")&&!f.get("cont_eday").equals("")){
			cont_edate = Util.strrpad(f.get("cont_eyear"),4,"0")+Util.strrpad(f.get("cont_emonth"),2,"0")+Util.strrpad(f.get("cont_eday"),2,"0");
		}else if(!f.get("cont_term").equals("")){
			Date date = Util.addDate("D", -1, Util.strToDate("yyyy-MM-dd",f.get("cont_date")));
			cont_sdate = f.get("cont_date").replaceAll("-", "");
			cont_edate = Util.addDate("Y",Integer.parseInt(f.get("cont_term")),date,"yyyyMMdd");
		}else if(!f.get("cont_term_month").equals("")){
			Date date = Util.addDate("D", -1, Util.strToDate("yyyy-MM-dd",f.get("cont_date")));
			cont_sdate = f.get("cont_date").replaceAll("-", "");
			cont_edate = Util.addDate("M",Integer.parseInt(f.get("cont_term_month")),date,"yyyyMMdd");
		}
		if(cont_sdate.equals("") && !cont_edate.equals(""))
			cont_sdate = f.get("cont_date").replaceAll("-","");

		String cont_html_rm_str = "";
		String[] cont_html_rm = f.getArr("cont_html_rm");
		String[] cont_html = f.getArr("cont_html");
		String[] cont_sub_name = f.getArr("cont_sub_name");
		String[] cont_sub_style = f.getArr("cont_sub_style");
		String[] gubun = f.getArr("gubun");
		String[] sub_seq = f.getArr("sub_seq");
		String arrOption_yn[] = new String[cont_html_rm.length];


		//decodeing ó�� START
		for(int i = 0 ; i < cont_html_rm.length; i ++){
			cont_html_rm[i] = new String(Base64Coder.decode(cont_html_rm[i]),"UTF-8");
		}
		for(int i = 0 ; i < cont_html.length; i ++){
			cont_html[i] =  new String(Base64Coder.decode(cont_html[i]),"UTF-8");
		}
		//decodeing ó�� END

		for(int i = 0 ; i < cont_html_rm.length; i ++){
			arrOption_yn[i] = f.get("option_yn_"+i);
		}


		DataObject cfileDao = new DataObject("tcb_cfile");
		DataSet cfile = cfileDao.find("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu, "file_path", 1);
		if(!cfile.next()) {
			u.jsError("��û�� ������ �ùٸ��� �ʽ��ϴ�.");
			return;
		}
		f.uploadDir = Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path");


		DB db = new DB();
		//db.setDebug(out);
		ContractDao cont = new ContractDao();
		cont.item("cont_no", cont_no);
		cont.item("cont_chasu", cont_chasu);
		cont.item("member_no", _member_no);
		cont.item("field_seq", recv_user.getString("field_seq"));
		cont.item("template_cd", template.getString("template_cd"));
		cont.item("cont_name", template.getString("template_name")+"_"+f.get("member_name"));
		cont.item("cont_date", Util.getTimeString("yyyyMMdd"));
		cont.item("cont_sdate", cont_sdate);
		cont.item("cont_edate", cont_edate);
		cont.item("supp_tax", f.get("supp_tax").replaceAll(",",""));
		cont.item("supp_taxfree", f.get("supp_taxfree").replaceAll(",",""));
		cont.item("supp_vat", f.get("supp_vat").replaceAll(",",""));
		cont.item("cont_total", f.get("cont_total").replaceAll(",",""));
		cont.item("cont_hash", cont_hash);
		cont.item("cont_html", cont_html[0]);
		cont.item("reg_date", Util.getTimeString());
		cont.item("true_random", f.get("random_no"));
		cont.item("reg_id", recv_user.getString("user_id"));
		//cont.item("sign_dn", sign_dn);
		//cont.item("sign_data", sign_data);
		cont.item("status", "30"); // ��û�� ���� ���� �Ϸ�
		cont.item("src_cd", f.get("src_cd"));
		cont.item("stamp_type", f.get("stamp_type"));
		db.setCommand(cont.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu), cont.record);


		db.setCommand("delete from tcb_cont_sub where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
		for(int i = 1 ; i < cont_html.length; i++) {
			DataObject cont_sub = new DataObject("tcb_cont_sub");
			cont_sub.item("cont_no", cont_no);
			cont_sub.item("cont_chasu", cont_chasu);
			cont_sub.item("sub_seq", i);
			cont_sub.item("cont_sub_html",cont_html[i]);
			cont_sub.item("cont_sub_name",cont_sub_name[i]);
			cont_sub.item("cont_sub_style",cont_sub_style[i]);
			cont_sub.item("gubun", gubun[i]);

			cont_sub.item("option_yn",arrOption_yn[i]);


			db.setCommand(cont_sub.getInsertQuery(), cont_sub.record);
		}
		
		

		
		// ��༭ �߰� �Է����� (DBȭ�Ͽ� �˻��� �ʿ��� ���)
		DataObject tempaddDao = new DataObject("tcb_cont_template_add"); 
		DataSet tempaddDs = tempaddDao.find("template_cd = '"+template_cd+"'");
		db.setCommand("delete from tcb_cont_add where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", null);
		
		if(tempaddDs.size()>0){
			DataObject contaddDao = new DataObject("tcb_cont_add"); // Array�� �ƴ� �����ʹ� ������ ������.
			contaddDao.item("cont_no", cont_no);
			contaddDao.item("cont_chasu", cont_chasu);
			contaddDao.item("seq", 1);

			while(tempaddDs.next()){
				if(tempaddDs.getString("mul_yn").equals("Y")) { // ����
					String[] colVals = f.getArr(tempaddDs.getString("template_name_en"));
					String colVal = "";
					for(int i=0; i<colVals.length; i++) {
						colVal += colVals[i] + "|";
					}
					contaddDao.item(tempaddDs.getString("col_name"), colVal);
				} else { // �ܼ�
					contaddDao.item(tempaddDs.getString("col_name"), f.get(tempaddDs.getString("template_name_en")));
				}
				
			}
			db.setCommand(contaddDao.getInsertQuery(), contaddDao.record);
		}
		

		System.out.println("----4---------");
		// ���� ���� ����
		String[] sign_seq = f.getArr("sign_seq");
		String[] signer_name = f.getArr("signer_name");
		String[] signer_max = f.getArr("signer_max");
		String[] member_type = f.getArr("member_type");
		String[] cust_type  = f.getArr("cust_type");
		db.setCommand("delete from tcb_cont_sign where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
		signTemplate.first();
		while(signTemplate.next()){
			DataObject cont_sign = new DataObject("tcb_cont_sign");
			cont_sign.item("cont_no",cont_no);
			cont_sign.item("cont_chasu",cont_chasu);
			cont_sign.item("sign_seq", signTemplate.getString("sign_seq"));
			cont_sign.item("signer_name", signTemplate.getString("signer_name"));
			cont_sign.item("signer_max", signTemplate.getString("signer_max"));
			cont_sign.item("member_type", signTemplate.getString("member_type"));// 01:���̽��� ����� ��ü 02:���̽� �̰���ü
			cont_sign.item("cust_type", signTemplate.getString("cust_type"));// 01:�� 02:��
			db.setCommand(cont_sign.getInsertQuery(), cont_sign.record);
		}

		System.out.println("----5---------");
		// ���ž�ü ����
		DataSet cust = new DataSet();
		cust.addRow();
		cust.put("member_no", recv_user.getString("member_no"));
		cust.put("cust_sign_seq", "1");
		cust.put("vendcd", recv_user.getString("vendcd"));
		cust.put("member_name", recv_user.getString("member_name"));
		cust.put("boss_name", recv_user.getString("boss_name"));
		cust.put("post_code", recv_user.getString("post_code"));
		cust.put("address", recv_user.getString("address"));
		cust.put("tel_num", recv_user.getString("tel_num"));
		cust.put("member_slno", recv_user.getString("member_slno"));
		cust.put("user_name", recv_user.getString("user_name"));
		cust.put("hp1", recv_user.getString("hp1"));
		cust.put("hp2", recv_user.getString("hp2"));
		cust.put("hp3", recv_user.getString("hp3"));
		cust.put("email", recv_user.getString("email"));
		cust.put("birthday", "");
		cust.put("member_gubun", recv_user.getString("member_gubun")); // 01:����(����), 02:����(����), 03:���λ����
		cust.put("cust_gubun", "01"); // 01:����� 02:����
		cust.put("cust_detail_code", ""); // ��ü�ڵ�

		// ��û�� �ۼ��� ����
		cust.addRow();
		cust.put("member_no", "");
		cust.put("cust_sign_seq", "2");
		cust.put("vendcd", f.get("vendcd").replaceAll("-", ""));
		cust.put("member_name", f.get("member_name"));
		cust.put("boss_name", f.get("boss_name"));
		cust.put("post_code", f.get("post_code").replaceAll("-", ""));
		cust.put("address", f.get("address"));
		cust.put("tel_num", f.get("tel_num"));
		cust.put("member_slno", "");
		cust.put("user_name", f.get("user_name"));
		cust.put("hp1", f.get("hp1"));
		cust.put("hp2", f.get("hp2"));
		cust.put("hp3", f.get("hp3"));
		cust.put("email", f.get("email"));
		cust.put("birthday", f.get("birthday"));

		chkVendcd = f.get("vendcd").substring(3,5);
		if( u.inArray(chkVendcd, new String[] {"81","82","83","84","86","87","88"}) ){
			cust.put("member_gubun", "01");	// ���λ����(����)
			cust.put("cust_gubun", "01");
		}else if(chkVendcd.equals("85")){
			cust.put("member_gubun", "02");	// ���λ����(����)
			cust.put("cust_gubun", "01");
		}else{
			cust.put("member_gubun", "03"); // ���λ����
			cust.put("cust_gubun", "02");
		}
		cust.put("cust_detail_code", ""); // ��ü�ڵ�

		// ���� ȸ������ üũ
		String w_member_no = "";
		DataObject daoWMember = new DataObject("tcb_member");
		DataSet dsWMember = daoWMember.find("vendcd = '"+cust.getString("vendcd")+"'", "member_no");
		if(dsWMember.next()) // ���� ȸ��
		{
			System.out.println("���� ���� ȸ�� : " + cust.getString("vendcd"));
			cust.put("member_no", dsWMember.getString("member_no"));
			w_member_no = dsWMember.getString("member_no");
		}
		else
		{	// �̰��� ȸ��
			w_member_no = daoWMember.getOne(
					"SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(SUBSTR(member_no, 7)), 0) + 1),5,'0' ) member_no"+
							"  FROM tcb_member WHERE member_no like '"+Util.getTimeString("yyyyMM")+"%'"
			);
			cust.put("member_no", w_member_no);//cust �� member_no �߰�

			daoWMember.item("member_no", w_member_no);
			daoWMember.item("vendcd", cust.getString("vendcd"));
			daoWMember.item("member_name", cust.getString("member_name"));
			daoWMember.item("member_gubun", cust.getString("member_gubun"));
			daoWMember.item("member_type", "02");  // ȸ������ (02 : �������)
			daoWMember.item("boss_name", cust.getString("boss_name"));
			daoWMember.item("post_code", cust.getString("post_code"));
			daoWMember.item("address", cust.getString("address"));
			daoWMember.item("reg_date", Util.getTimeString());
			daoWMember.item("reg_id", "systemadmin");
			daoWMember.item("status", "02"); // ȸ������ (02 : ��ȸ��)
			db.setCommand(daoWMember.getInsertQuery(), daoWMember.record);

			DataObject daoRPerson = new DataObject("tcb_person");
			String w_person_seq = daoRPerson.getOne("select nvl(max(person_seq),0)+1 person_seq from tcb_person where member_no = '"+w_member_no+"'");
			if(w_person_seq.equals("")){
				Util.log("����� SEQ ���� ���� : ����ڹ�ȣ->" + cust.getString("vendcd"));
			}

			daoRPerson.item("member_no", w_member_no);
			daoRPerson.item("person_seq", w_person_seq);
			daoRPerson.item("user_name", cust.getString("user_name"));
			daoRPerson.item("tel_num",  cust.getString("tel_num"));
			daoRPerson.item("hp1",  cust.getString("hp1"));
			daoRPerson.item("hp2",  cust.getString("hp2"));
			daoRPerson.item("hp3",  cust.getString("hp3"));
			daoRPerson.item("email",  cust.getString("email"));
			if(w_person_seq.equals("1"))
				daoRPerson.item("default_yn", "Y");
			else
				daoRPerson.item("default_yn", "N");
			daoRPerson.item("use_yn","N");
			daoRPerson.item("reg_date", Util.getTimeString());
			daoRPerson.item("reg_id", "systemadmin");
			daoRPerson.item("user_gubun", "10");		// 10-����, 20-����
			daoRPerson.item("status", "1");
			db.setCommand(daoRPerson.getInsertQuery(), daoRPerson.record);
		}
		//��ü���� ����
		int display_seq = 0;
		db.setCommand("delete from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
		cust.first();

		while(cust.next()){
			signTemplate.first();
			while(signTemplate.next()){
				if(signTemplate.getString("sign_seq").equals(cust.getString("cust_sign_seq"))){
					break;
				}
			}
			DataObject custDao = new DataObject("tcb_cust");
			custDao.item("cont_no", cont_no);
			custDao.item("cont_chasu",cont_chasu);
			custDao.item("member_no",cust.getString("member_no"));
			custDao.item("sign_seq", cust.getString("cust_sign_seq"));
			custDao.item("cust_gubun", cust.getString("cust_gubun")); //01:����� 02:����
			custDao.item("vendcd", cust.getString("vendcd"));
			if((cust.getString("member_gubun").equals("04") || cust.getString("member_gubun").equals("03")) && !cust.getString("birthday").equals("")){ // ���� �Ǵ� ���λ�����̰� ��������� �ִ� ���
				custDao.item("jumin_no", Security.AESencrypt(cust.getString("birthday")));
			}

			custDao.item("member_name", cust.getString("member_name"));
			custDao.item("boss_name", cust.getString("boss_name"));
			custDao.item("post_code", cust.getString("post_code"));
			custDao.item("address", cust.getString("address"));
			custDao.item("tel_num", cust.getString("tel_num"));
			custDao.item("member_slno", cust.getString("member_slno"));
			custDao.item("user_name", cust.getString("user_name"));
			custDao.item("hp1", cust.getString("hp1"));
			custDao.item("hp2", cust.getString("hp2"));
			custDao.item("hp3", cust.getString("hp3"));
			custDao.item("email", cust.getString("email"));
			custDao.item("display_seq", display_seq++);
			custDao.item("cust_detail_code", cust.getString("cust_detail_code"));

			if(cust.getString("member_no").equals(w_member_no)) {
				custDao.item("sign_dn", sign_dn);
				custDao.item("sign_data", sign_data);
				custDao.item("sign_date", Util.getTimeString());
			}
			if(signTemplate.getString("pay_yn").equals("Y")){
				custDao.item("pay_yn","Y");
			}
			db.setCommand(custDao.getInsertQuery(), custDao.record);
		}
		
		db.setCommand(
				 " update tcb_cust "
				+"    set list_cust_yn = decode(display_seq, (select min(display_seq)  from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no <> '"+_member_no+"' ),'Y') "
				+"  where cont_no = '"+cont_no+"' "
				+"    and cont_chasu = '"+cont_chasu+"' "	 
						,null);
		
		//���񼭷�
		DataObject rfile_cust = null;
		String[] rfile_seq = f.getArr("rfile_seq");
		String[] attch_yn = f.getArr("rfile_required");
		String[] rfile_doc_name = f.getArr("rfile_doc_name");
		String[] reg_type = f.getArr("reg_type");
		String[] allow_ext = f.getArr("allow_ext");
		int rfile_cnt = rfile_seq == null? 0: rfile_seq.length;
		db.setCommand("delete from tcb_rfile_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
		db.setCommand("delete from tcb_rfile where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
		for(int i=0 ; i < rfile_cnt; i ++){
			rfileDao = new DataObject("tcb_rfile");
			rfileDao.item("cont_no", cont_no);
			rfileDao.item("cont_chasu", cont_chasu);
			rfileDao.item("rfile_seq", rfile_seq[i]);
			rfileDao.item("attch_yn", attch_yn[i].equals("Y")?"Y":"N");
			rfileDao.item("doc_name", rfile_doc_name[i]);
			rfileDao.item("reg_type", reg_type[i]);
			rfileDao.item("allow_ext", allow_ext[i]);
			db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);

			rfile_cust = new DataObject("tcb_rfile_cust");
			rfile_cust.item("cont_no", cont_no);
			rfile_cust.item("cont_chasu", cont_chasu);
			rfile_cust.item("member_no", w_member_no);
			rfile_cust.item("rfile_seq", rfile_seq[i]);
			File file = f.saveFileTime("rfile_"+rfile_seq[i]);
			if(file == null){
				rfile_cust.item("file_path", "");
				rfile_cust.item("file_name", "");
				rfile_cust.item("file_ext", "");
				rfile_cust.item("file_size", "");
				rfile_cust.item("reg_gubun", "");
			}else{
				rfile_cust.item("file_path", cfile.getString("file_path"));
				rfile_cust.item("file_name", file.getName());
				rfile_cust.item("file_ext", Util.getFileExt(file.getName()));
				rfile_cust.item("file_size", file.length());
				rfile_cust.item("reg_gubun", "20");
			}
			db.setCommand(rfile_cust.getInsertQuery(), rfile_cust.record);
		}

		if(!db.executeArray()){
			u.jsError("��û�� �ۼ��� ���� �Ͽ����ϴ�.");
			return;
		}

		// sms �� ���� �߼� ó��
		SmsDao smsDao = new SmsDao();
		cust.first();
		while(cust.next()){
			if(cust.getString("member_no").equals(w_member_no)){
				DataSet mailInfo = new DataSet();
				mailInfo.addRow();
				mailInfo.put("member_name", cust.getString("member_name"));
				mailInfo.put("user_name", cust.getString("user_name"));
				mailInfo.put("template_name", template.getString("template_name"));

				p.setVar("server_name", request.getServerName());
				//p.setVar("return_url", "/web/buyer/contract/subscription_v.jsp?c="+u.aseEnc(cont_no));
				p.setVar("return_url", "/web/buyer/contract/subscription_v.jsp?c="+u.aseEnc(cont_no));
				p.setVar("info", mailInfo);
				if(!cust.getString("email").equals("")){
					String mail_body = p.fetch("../html/mail/subscription_ing.html");
					//System.out.println(mail_body);
					u.mail(cust.getString("email"), "[�˸�] "+template.getString("template_name")+" ��û �Ϸ�", mail_body );
				}

				// sms ���� (�������� ��ȣ�� sms ����)
				if((!cust.getString("hp2").equals(""))&& !cust.getString("hp1").equals("") && !cust.getString("hp2").equals("")){
					smsDao.sendSMS("buyer",cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), template.getString("template_name")+" ��û�� �Ϸ�Ǿ����ϴ�.");
				}
			} else {
				// sms ���� (�������� ��ȣ�� sms ����)
				if((!cust.getString("hp2").equals(""))&& !cust.getString("hp1").equals("") && !cust.getString("hp2").equals("")){
					smsDao.sendSMS("buyer",cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), template.getString("template_name")+"_"+f.get("member_name")+" ��û �Ϸ�-���̽���ť(�Ϲݱ����)");
				}
			}
		}

		 u.jsReplace("/web/buyer/contract/subscription_e.jsp?c="+u.aseEnc(template_cd));  // ���̽����̸���, ���̽�������� �и��� ���ؼ� template_cd�� �޾Ƽ� �и� (�Ϸ�(html)�ܿ��� ������ ���� �ٸ�)
		//   u.jsReplace("./subscription_e.jsp");
		//System.out.println("<script>document.location='./subscription_e.jsp';</script>");
		//System.out.println("--end--");
		return;
	}

	boolean view_bank_valid = u.inArray(template_cd,new String[]{
			 "2012014"//	NICEPAY �����������̿�� �̿��û��
			,"2017331"//	NICEPAY ��ǥ��༭
			,"2018168"//	NICEPAY ��༭ makeshop(soho)
			,"2019129"//	NICEPAY ��������_�Ľ���
			,"2019266"//	NICEPAY ����ιٿ�ó ���ڰ�༭
			,"2019295"//	NICEPAY ��ǥ��༭_test
			,"2020172"//   NICEPAY ��༭(������)
			,"2020173"//   NICEPAY ��༭(������)_��Ϻ����
			,"2020202"//   NICEPAY ��༭(����Ƽ��)
	});

	p.setLayout("subscription");
//p.setDebug(out);
	p.setBody("contract.subscription");
	p.setVar("modify", false);
	p.setVar("member", member);
	p.setVar("mgubun", mgubun);
	p.setVar("template", template);
	p.setVar("member_name", member.getString("member_name"));
	p.setVar("template_name", template.getString("template_name"));
	p.setLoop("templateSub", templateSub);
	p.setLoop("sign_template", signTemplate);
	p.setLoop("rfile", rfile);
	p.setVar("view_bank_valid", view_bank_valid);
//p.setLoop("cust", cust);
//p.setLoop("cfile", cfile);
	p.setVar("nicePay", ("20120600068".equals(_member_no) || "20171100802".equals(_member_no))?true:false);
	p.setVar("query", u.getQueryString());
	p.setVar("form_script", f.getScript());
	p.display(out);
%>