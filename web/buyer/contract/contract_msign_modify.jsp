<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
Security	security	=	new	Security();

//String template_cd = "";
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
String template_cd = u.request("template_cd");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("����� ������ �������� �ʽ��ϴ�.");
	return;
}

boolean bAutoContUserNo = u.inArray(_member_no, new String[]{"20121200073"});

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_change_gubun = codeDao.getCodeArray("M010"," AND code <> '90' ");
String[] code_auto_type = {"=>�ڵ�����","1=>�ڵ�÷��","2=>�ʼ�÷��","3=>���ο�"};

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
							" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'and status = '10'"
						   ," tcb_contmaster.*"
						   +" ,(select max(user_name) from tcb_person where member_no = tcb_contmaster.member_no and user_id = tcb_contmaster.reg_id ) writer_name "
						   +" ,(select member_name from tcb_member where member_no = mod_req_member_no) mod_req_name "
						   +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,3) = substr(tcb_contmaster.src_cd,0,3) and depth='1') l_src_nm "
						   +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,6) = substr(tcb_contmaster.src_cd,0,6) and depth='2') m_src_nm "
						   +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and src_cd = tcb_contmaster.src_cd and depth='3') s_src_nm "
							);
if(!cont.next()){
	u.jsError("��������� ���� ���� �ʽ��ϴ�.");
	return;
}
cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
template_cd = cont.getString("template_cd");
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
cont.put("cont_userno", cont.getString("cont_userno"));
if(!cont.getString("src_cd").equals(""))
cont.put("src_nm", cont.getString("l_src_nm")+" > "+cont.getString("m_src_nm")+" > "+cont.getString("s_src_nm"));

// �߰� ��༭ ��ȸ
DataObject contSubDao = new DataObject("tcb_cont_sub");
DataSet contSub = contSubDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");

int k=1;
while(contSub.next()){
    contSub.put("cont_no", u.aseEnc(contSub.getString("cont_no")));
	contSub.put("hidden", u.inArray(contSub.getString("gubun"),new String[]{"20","30"}));
	contSub.put("template_name", contSub.getString("cont_sub_name"));
	contSub.put("template_cd", template_cd);
	contSub.put("chk", contSub.getString("chk_yn").equals("Y")?"checked":"");

	if(contSub.getString("option_yn").equals("A")) // �ڵ� �����ؾ� �ϴ� ���
		contSub.put("option_yn", false);
	else
	{
		if(contSub.getString("option_yn").equals("Y")) // ������ ����� ��� üũ ǥ�����ش�.
			f.addElement("option_yn_"+k, "Y", null);
		contSub.put("option_yn", true);
	}
	k++;
}


// �������� ��ȸ
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" template_cd ='"+template_cd+"'");
if(!template.next()){
}

// ���� �������� ��ȸ
boolean btnSend = true;
DataObject agreeTemplateDao = new DataObject("tcb_cont_agree");
DataSet agreeTemplate= agreeTemplateDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", "agree_seq");
while(agreeTemplate.next()){
    agreeTemplate.put("cont_no", u.aseEnc(agreeTemplate.getString("cont_no")));
    agreeTemplate.put("is_cust", agreeTemplate.getString("agree_cd").equals("0"));
	if(agreeTemplate.getString("agree_seq").equals("1")){  
		btnSend = agreeTemplate.getString("agree_cd").equals("0");// ���� ���� �����ڰ� �ŷ�ó�� ���� ����	
	}
}



DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","*","sign_seq asc");

// ����ü ��ȸ
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.query(
		 " select a.*, nvl(b.member_gubun,'04') member_gubun "
		+"   from tcb_cust a, tcb_member b       "
		+"  where a.member_no = b.member_no(+)   "
		+"    and a.cont_no = '"+cont_no+"'      "
		+"    and a.cont_chasu = '"+cont_chasu+"'"
		+"    and a.sign_seq <= 10               "
		+"  order by display_seq  asc            "
		);  // sign_seq �� 10���� ū�Ŵ� ���뺸��
if(!cust.next()){
	u.jsError("����ü ������ ���� ���� �ʽ��ϴ�.");
	return;
}
while(cust.next()){
    cust.put("cont_no", u.aseEnc(cust.getString("cont_no")));
	if(!cust.getString("jumin_no").equals("")){
		cust.put("jumin_no", security.AESdecrypt(cust.getString("jumin_no")));
	}else{
		cust.put("jumin_no", "");
	}
	cust.put("boss_birth_date", u.getTimeString("yyyy-MM-dd", cust.getString("boss_birth_date")));

}

//��༭�� ��ȸ
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	if(cfile.getString("auto_yn").equals("Y")){

		cfile.put("auto_str", u.getItem(cfile.getString("auto_type"), code_auto_type));
		if(cfile.getString("auto_type").equals("")){
			cfile.put("auto_type","0");
		}

		/*
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
		*/
	}else{
		cfile.put("auto_str", "����÷��");
	}
	cfile.put("auto", cfile.getString("auto_yn").equals("Y"));
	cfile.put("auto_class", cfile.getString("auto_yn").equals("Y")?"caution-text":"");
	cfile.put("file_yn", !cfile.getString("file_name").equals(""));
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	cfile.put("doc_name_readonly", cfile.getString("auto_yn").equals("Y")?"readonly":"");
	cfile.put("modfiy_file", cfile.getString("auto_type").equals("2"));
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
}


// ���񼭷� ��ȸ
DataObject rfileDao = new DataObject("tcb_rfile");
//rfileDao.setDebug(out);
DataSet rfile = rfileDao.query(
		 " select a.*, b.file_name, b.file_path, b.file_ext, b.file_size "
		+"   from tcb_rfile a                                            "
		+"   left outer join tcb_rfile_cust b                            "
		+"     on a.cont_no = b.cont_no                                  "
		+"    and a.cont_chasu = b.cont_chasu                            "
		+"    and a.rfile_seq = b.rfile_seq                              "
		+"    and member_no = '"+_member_no+"'                           "
		+"  where a.cont_no = '"+cont_no+"'                              "
		+"    and a.cont_chasu = '"+cont_chasu+"'                        "
		+"  order by a.rfile_seq asc"
		);
while(rfile.next()){
    rfile.put("cont_no", u.aseEnc(rfile.getString("cont_no")));
	rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
	if(!rfile.getString("file_name").equals(""))
	rfile.put("str_file_size", u.getFileSize(rfile.getLong("file_size")));

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


//���� ���� ���� ��ȸ
String[] code_reg_type = {"10=><span class='caution-text'>�ʼ�÷��</span>","20=>����÷��","30=>�߰�÷��"};
DataObject efileDao = new DataObject("tcb_efile");
DataSet efile = new DataSet();
if(cont.getString("efile_yn").equals("Y")){
	efile = efileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
	while(efile.next()){
		efile.put("str_reg_type", u.getItem(efile.getString("reg_type"), code_reg_type));
		//efile.put("required", u.inArray(efile.getString("reg_type"), new String[]{"10","30"})?"required='Y'":"");
		efile.put("doc_name_readonly", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"readonly":"");
		efile.put("doc_name_class", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"in_readonly":"label");
		efile.put("del_yn10", efile.getString("reg_type").equals("10")&&!efile.getString("file_name").equals(""));
		efile.put("del_yn20", efile.getString("reg_type").equals("20")&&!efile.getString("file_name").equals(""));
		efile.put("del_yn30", efile.getString("reg_type").equals("30"));
		efile.put("file_size_str", u.getFileSize(efile.getInt("file_size")));
		efile.put("down_script","filedown('file.path.bcont_pdf','"+efile.getString("file_path")+efile.getString("file_name")+"','"+efile.getString("doc_name")+"."+efile.getString("file_ext")+"')");
	}
}


f.addElement("cont_name", cont.getString("cont_name"), "hname:'����', required:'Y'");
f.addElement("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")), "hname:'�������', required:'Y'");


f.addElement("cont_userno", cont.getString("cont_userno"), "hname:'����ȣ', maxbyte:'40'");
if(Integer.parseInt(cont_chasu)>0)
	f.addElement("change_gubun", cont.getString("change_gubun"), "hname:'��౸��', required:'Y'");
if(!member.getString("src_depth").equals(""))
	f.addElement("src_cd", cont.getString("src_cd"), "hname:'�ҽ̱׷�'");

if(template.getString("stamp_yn").equals("Y")){
	f.addElement("stamp_type", cont.getString("stamp_type"), "hname:'������ ���� ���', required:'Y'");
}

if(u.isPost()&&f.validate()){
	response.setHeader("Cache-Control", "no-Cache, no-store, must-revalidate");
	
	//��༭ ����
	contDao = new ContractDao();
	String random_no = u.strpad(u.getRandInt(0,99999)+"",5,"0");

	String cont_html_rm_str = "";
	String[] cont_html_rm = f.getArr("cont_html_rm");
	String[] cont_html = f.getArr("cont_html");
	String[] cont_sub_name = f.getArr("cont_sub_name");
	String[] cont_sub_style = f.getArr("cont_sub_style");
	String[] gubun = f.getArr("gubun");
	String[] sub_seq = f.getArr("sub_seq");
	
	//decodeing ó�� START
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		cont_html_rm[i] = new String(Base64Coder.decode(cont_html_rm[i]),"UTF-8");
	}
	for(int i = 0 ; i < cont_html.length; i ++){
		cont_html[i] =  new String(Base64Coder.decode(cont_html[i]),"UTF-8");
	}
	//decodeing ó�� END
	
	String arrOption_yn[] = new String[cont_html_rm.length];

	for(int i = 0 ; i < cont_html_rm.length; i ++){
		arrOption_yn[i] = f.get("option_yn_"+i);
	}

	for(int i = 0 ; i < cont_html_rm.length; i ++){
		if(i != 0)
			cont_html_rm_str += "<pd4ml:page.break>";
		if(gubun[i].equals("10")){
			cont_html_rm_str += cont_html_rm[i];
		}
	}
	
	ArrayList autoFiles = new ArrayList();

	int file_seq = 1;

	String cont_userno = "";
	/*
	if(bAutoContUserNo)  // �׷����� ���� ��������ȣ�� ����� ����ȣ�� ����
		cont_userno = cont_no + "-" + cont_chasu;
	else
	*/
		cont_userno = f.get("cont_userno");


	// ��༭���� ����
	DataSet pdfInfo = new DataSet();
	pdfInfo.addRow();
	pdfInfo.put("member_no",_member_no);
	pdfInfo.put("cont_no", cont_no);
	pdfInfo.put("cont_chasu", cont_chasu);
	pdfInfo.put("random_no", random_no);
	pdfInfo.put("cont_userno", cont_userno);
	pdfInfo.put("html", cont_html_rm_str);
	pdfInfo.put("doc_type", template.getString("doc_type"));
	pdfInfo.put("file_seq", file_seq++);
	DataSet pdf = contDao.makePdf(pdfInfo);
	if(pdf==null){
		u.jsError("��༭ ���� ������ ���� �Ͽ����ϴ�.");
		return;
	}

	//�ڵ��������� ����
	for(int i = 0 ; i < cont_html_rm.length; i++){
		if(    gubun[i].equals("20")
			|| gubun[i].equals("50")  // �ۼ���ü�� ���� �μ��ϴ� ���(������ X)
			|| ( gubun[i].equals("40") && arrOption_yn[i].equals("A") || arrOption_yn[i].equals("Y")) // �ڵ����� �����Ǵ� ��� �Ǵ� üũ�� ����� ���
		  )
		{
			DataSet pdfInfo2 = new DataSet();
			pdfInfo2.addRow();
			pdfInfo2.put("member_no",_member_no);
			pdfInfo2.put("cont_no", cont_no);
			pdfInfo2.put("cont_chasu", cont_chasu);
			pdfInfo2.put("random_no", random_no);
			pdfInfo2.put("cont_userno", cont_userno);
			pdfInfo2.put("html", cont_html_rm[i]);
			pdfInfo2.put("doc_type", template.getString("doc_type"));
			pdfInfo2.put("file_seq", file_seq++);
			DataSet pdf2 = contDao.makePdf(pdfInfo2);
			pdf2.put("cont_sub_name", cont_sub_name[i]);
			pdf2.put("gubun", gubun[i]);
			autoFiles.add(pdf2);
		}
	}

	//���Ⱓ���ϱ�
	String cont_sdate = f.get("cont_sdate").replaceAll("-","");
	String cont_edate = f.get("cont_edate").replaceAll("-","");;
	if(!f.get("cont_syear").equals("")&&!f.get("cont_smonth").equals("")&&!f.get("cont_sday").equals("")){
		cont_sdate = u.strrpad(f.get("cont_syear"),4,"0")+u.strrpad(f.get("cont_smonth"),2,"0")+u.strrpad(f.get("cont_sday"),2,"0");
	}
	// ����������� ���� ��� ���Ⱓ +1���̴�.
	if(!f.get("cont_eyear").equals("")&&!f.get("cont_emonth").equals("")&&!f.get("cont_eday").equals("")){
		cont_edate = u.strrpad(f.get("cont_eyear"),4,"0")+u.strrpad(f.get("cont_emonth"),2,"0")+u.strrpad(f.get("cont_eday"),2,"0");
	}else if(!f.get("cont_term").equals("")){
		Date date = u.addDate("D", -1, u.strToDate("yyyy-MM-dd",f.get("cont_date")));
		cont_sdate = f.get("cont_date").replaceAll("-", "");
		cont_edate = u.addDate("Y",Integer.parseInt(f.get("cont_term")),date,"yyyyMMdd");
	}else if(!f.get("cont_term_month").equals("")){
		Date date = u.addDate("D", -1, u.strToDate("yyyy-MM-dd",f.get("cont_date")));
		cont_sdate = f.get("cont_date").replaceAll("-", "");
		cont_edate = u.addDate("M",Integer.parseInt(f.get("cont_term_month")),date,"yyyyMMdd");
	}
	if(cont_sdate.equals("") && !cont_edate.equals(""))
		cont_sdate = f.get("cont_date").replaceAll("-","");
	
	DB db = new DB();
	//db.setDebug(out);
	contDao = new ContractDao();

	contDao.item("member_no", _member_no);
	contDao.item("template_cd", template_cd);
	contDao.item("cont_name", f.get("cont_name"));
	contDao.item("cont_date", f.get("cont_date").replaceAll("-",""));
	contDao.item("cont_sdate", cont_sdate);
	contDao.item("cont_edate", cont_edate);
	contDao.item("supp_tax", f.get("supp_tax").replaceAll(",",""));
	contDao.item("supp_taxfree", f.get("supp_taxfree").replaceAll(",",""));
	contDao.item("supp_vat", f.get("supp_vat").replaceAll(",",""));
	contDao.item("cont_total", f.get("cont_total").replaceAll(",",""));
	contDao.item("cont_userno", cont_userno);
	contDao.item("cont_html", cont_html[0]);
	contDao.item("org_cont_html", cont_html[0]);
	contDao.item("reg_date", u.getTimeString());
	contDao.item("true_random", random_no);
	contDao.item("status", "10");
	contDao.item("stamp_type", f.get("stamp_type"));
	contDao.item("change_gubun", f.get("change_gubun"));
	contDao.item("src_cd", f.get("src_cd"));
	if(!f.get("cont_etc1").equals("")) {
		contDao.item("cont_etc1", f.get("cont_etc1"));
	}
	
	db.setCommand(contDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), contDao.record);

	for(int i = 1 ; i < cont_html.length; i++) {
		DataObject cont_sub = new DataObject("tcb_cont_sub");
		cont_sub.item("cont_sub_html",cont_html[i]);
		cont_sub.item("org_cont_sub_html",cont_html[i]);
		cont_sub.item("cont_sub_name",cont_sub_name[i]);
		cont_sub.item("cont_sub_style",cont_sub_style[i]);
		cont_sub.item("option_yn",arrOption_yn[i]);
		db.setCommand(cont_sub.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sub_seq = " + i), cont_sub.record);
	}


	// ���� ���� ����
	db.setCommand("delete from tcb_cont_sign where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
	String[] sign_seq = f.getArr("sign_seq");
	String[] signer_name = f.getArr("signer_name");
	String[] signer_max = f.getArr("signer_max");
	String[] member_type = f.getArr("member_type");
	String[] cust_type = f.getArr("cust_type");
	for(int i = 0 ; i < sign_seq.length; i ++){
		DataObject cont_sign = new DataObject("tcb_cont_sign");
		cont_sign.item("cont_no",cont_no);
		cont_sign.item("cont_chasu",cont_chasu);
		cont_sign.item("sign_seq", sign_seq[i]);
		cont_sign.item("signer_name", signer_name[i]);
		cont_sign.item("signer_max", signer_max[i]);
		cont_sign.item("member_type", member_type[i]);
		cont_sign.item("cust_type", cust_type[i]);
		db.setCommand(cont_sign.getInsertQuery(), cont_sign.record);
	}

	// ���� ���� ���� ����
	String[] agree_seq = f.getArr("agree_seq");
	String agree_field_seqs = "";
	String agree_person_ids = "";
	int agree_cnt = agree_seq == null? 0: agree_seq.length;
	if(agree_cnt > 0)
	{
		db.setCommand("delete from tcb_cont_agree where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
		db.setCommand("delete from tcb_agree_user where template_cd = '"+template_cd+"' and user_id = '"+auth.getString("_USER_ID")+"' ",null);
		String[] agree_name = f.getArr("agree_name");
		String[] agree_field_seq = f.getArr("agree_field_seq");
		String[] agree_person_name = f.getArr("agree_person_name");
		String[] agree_person_id = f.getArr("agree_person_id");
		String[] agree_cd = f.getArr("agree_cd");
		for(int i = 0 ; i < agree_cnt; i ++){
			DataObject cont_agree = new DataObject("tcb_cont_agree");
			cont_agree.item("cont_no",cont_no);
			cont_agree.item("cont_chasu",cont_chasu);
			cont_agree.item("agree_seq", agree_seq[i]);
			cont_agree.item("agree_name", agree_name[i]);
			cont_agree.item("agree_field_seq", agree_field_seq[i]);
			cont_agree.item("agree_person_name", agree_person_name[i]);
			cont_agree.item("agree_person_id", agree_person_id[i]);
			cont_agree.item("ag_md_date", "");
			cont_agree.item("mod_reason", "");
			cont_agree.item("r_agree_person_id","");
			cont_agree.item("r_agree_person_name", "");
			cont_agree.item("agree_cd", agree_cd[i]);	// ���籸���ڵ�(0:��ü������, 1:��ü������)
			db.setCommand(cont_agree.getInsertQuery(), cont_agree.record);
			agree_field_seqs += agree_field_seq[i] + "|";
			agree_person_ids += agree_person_id[i] + "|";

			// ���� ���� ���ο� ����
			DataObject cont_agree_user = new DataObject("tcb_agree_user");
			cont_agree_user.item("template_cd", template_cd);
			cont_agree_user.item("user_id", auth.getString("_USER_ID"));
			cont_agree_user.item("agree_seq", agree_seq[i]);
			cont_agree_user.item("agree_name", agree_name[i]);
			cont_agree_user.item("agree_field_seq", agree_field_seq[i]);
			cont_agree_user.item("agree_person_name", agree_person_name[i]);
			cont_agree_user.item("agree_person_id", agree_person_id[i]);
			cont_agree_user.item("agree_cd", agree_cd[i]);	// ���籸���ڵ�(0:��ü������, 1:��ü������)
			db.setCommand(cont_agree_user.getInsertQuery(), cont_agree_user.record);
		}
	}


	// ��ü ����
	db.setCommand("delete from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
	String[] member_no = f.getArr("member_no");
	String[] cust_sign_seq = f.getArr("cust_sign_seq");
	String[] vendcd = f.getArr("vendcd");
	String[] member_name = f.getArr("member_name");
	String[] boss_name = f.getArr("boss_name");
	String[] post_code = f.getArr("post_code");
	String[] address = f.getArr("address");
	String[] tel_num = f.getArr("tel_num");
	String[] member_slno = f.getArr("member_slno");
	String[] user_name = f.getArr("user_name");
	String[] hp1 = f.getArr("hp1");
	String[] hp2 = f.getArr("hp2");
	String[] hp3 = f.getArr("hp3");
	String[] email = f.getArr("email");
	String[] jumin_no = f.getArr("jumin_no");
	String[] member_gubun = f.getArr("member_gubun");  // 01:����(����), 02:����(����), 03:���λ����
	String[] cust_gubun = f.getArr("cust_gubun");
	String[] cust_detail_code = f.getArr("cust_detail_code");
	String[] boss_birth_date = f.getArr("boss_birth_date");
	String[] boss_gender = f.getArr("boss_gender");
	int member_cnt = member_no == null? 0: member_no.length;
	for(int i = 0 ; i < member_cnt; i ++){
		custDao = new DataObject("tcb_cust");
		custDao.item("cont_no", cont_no);
		custDao.item("cont_chasu",cont_chasu);
		custDao.item("member_no",member_no[i]);
		custDao.item("sign_seq", cust_sign_seq[i]);
		custDao.item("cust_gubun", cust_gubun[i]);//01:����� 02:����
		custDao.item("vendcd", vendcd[i].replaceAll("-",""));
		if(cust_gubun[i].equals("02")&&!jumin_no[i].equals("")){
			custDao.item("jumin_no", security.AESencrypt(jumin_no[i].replaceAll("-","")));
		}
		if(cust_gubun[i].equals("01")&&!jumin_no[i].equals("")){  // ���λ���������� ��������� �ִ� ���
			custDao.item("jumin_no", security.AESencrypt(jumin_no[i].replaceAll("-","")));
		}

		custDao.item("member_name", member_name[i]);
		custDao.item("boss_name", boss_name[i]);
		custDao.item("post_code", post_code[i].replaceAll("-",""));
		custDao.item("address", address[i]);
		custDao.item("tel_num", tel_num[i]);
		custDao.item("member_slno", member_slno[i].replaceAll("-",""));
		custDao.item("user_name", user_name[i]);
		custDao.item("hp1", hp1[i]);
		custDao.item("hp2", hp2[i]);
		custDao.item("hp3", hp3[i]);
		custDao.item("email", email[i]);
		custDao.item("display_seq", i);
		custDao.item("cust_detail_code", cust_detail_code[i]);
		custDao.item("boss_birth_date", boss_birth_date[i].replaceAll("-", ""));
		custDao.item("boss_gender", boss_gender[i]);
		cust.first();
		while(cust.next()){
			if(cust.getString("member_no").equals(member_no[i]) && !cust.getString("pay_yn").equals("")){
				custDao.item("pay_yn", cust.getString("pay_yn"));
			}
		}

		if(member_no[i].startsWith("0")) {
			custDao.item("boss_name", member_name[i]);
			custDao.item("user_name", member_name[i]);
		}

		db.setCommand(custDao.getInsertQuery(), custDao.record);
		

		// �ҽ�ī�װ��� �����ϴ� ��ü�� ��༭ �ۼ��� �ҽ̱׷� ������ �Ǿ� �ִٸ� �ۼ��� ������ �ҽ� �׷����� �ҽ� ������ �Է��Ѵ�. (��, �ҽ� �׷��� 1����ü�� �������� ������ �� �����Ƿ� insert�� �Ѵ�.)
		if( !member.getString("src_depth").equals("") && !f.get("src_cd").equals("") && !member_no[i].equals(_member_no) )
		{
			DataObject srcDao = new DataObject("tcb_src_member");
			if(srcDao.findCount("member_no='"+_member_no+"' and src_member_no='"+member_no[i]+"' and src_cd='"+f.get("src_cd")+"'") == 0)
			{
				srcDao.item("member_no", _member_no);
				srcDao.item("src_member_no", member_no[i]);
				srcDao.item("src_cd",f.get("src_cd"));
				db.setCommand(srcDao.getInsertQuery(), srcDao.record);
			}
		}

	}
	
	db.setCommand(
			 " update tcb_cust "
			+"    set list_cust_yn = decode(display_seq, (select min(display_seq)  from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no <> '"+_member_no+"' ),'Y') "
			+"  where cont_no = '"+cont_no+"' "
			+"    and cont_chasu = '"+cont_chasu+"' "	 
					,null);

	int cfile_seq_real = 1;
	String file_hash = pdf.getString("file_hash");
	f.uploadDir = Startup.conf.getString("file.path.bcont_pdf")+pdf.getString("file_path");
	//��༭������
	db.setCommand("delete from tcb_cfile where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
	cfileDao = new DataObject("tcb_cfile");
	cfileDao.item("cont_no", cont_no);
	cfileDao.item("cont_chasu", cont_chasu);
	cfileDao.item("cfile_seq", cfile_seq_real++);
	cfileDao.item("doc_name", template.getString("template_name"));
	cfileDao.item("file_path", pdf.getString("file_path"));
	cfileDao.item("file_name", pdf.getString("file_name"));
	cfileDao.item("file_ext", pdf.getString("file_ext"));
	cfileDao.item("file_size", pdf.getString("file_size"));
	cfileDao.item("auto_yn","Y");
	cfileDao.item("auto_type", "");
	db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);

	//�ڵ���������
	System.out.println("autoFiles.size() ==> " + autoFiles.size());
	for(int i=0; i <autoFiles.size(); i ++){
		DataSet temp = (DataSet)autoFiles.get(i);
		cfileDao = new DataObject("tcb_cfile");
		cfileDao.item("cont_no", cont_no);
		cfileDao.item("cont_chasu", cont_chasu);
		cfileDao.item("cfile_seq", cfile_seq_real++);
		cfileDao.item("doc_name", temp.getString("cont_sub_name"));
		cfileDao.item("file_path", temp.getString("file_path"));
		cfileDao.item("file_name", temp.getString("file_name"));
		cfileDao.item("file_ext", temp.getString("file_ext"));
		cfileDao.item("file_size", temp.getString("file_size"));
		cfileDao.item("auto_yn","Y");
		if(temp.getString("gubun").equals("50"))	// �ۼ���ü�� ���� �μ��ϴ� ����� �������� �ƴ�.  gubun[i].equals("50")
			cfileDao.item("auto_type", "3");	// null:�ڵ�����, 1:�ڵ�÷��, 2:�ʼ�÷��, 3:���ο�
		else
		{
			file_hash+="|"+temp.getString("file_hash");
			cfileDao.item("auto_type", "");
		}
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
	}



	String[] cfile_seq = f.getArr("cfile_seq");
	String[] cfile_doc_name = f.getArr("cfile_doc_name");
	String[] cfile_auto_type = f.getArr("cfile_auto_type");
	int cfile_cnt = cfile_seq==null? 0 : cfile_seq.length;
	for(int i = 0 ;i < cfile_cnt; i ++){
		if(cfile_auto_type[i].equals("0") || cfile_auto_type[i].equals("3")){  // �ڵ����� �Ǵ� ���ο�
			continue;
		}
		String cfile_name = "";
		cfileDao = new DataObject("tcb_cfile");
		cfileDao.item("cont_no", cont_no);
		cfileDao.item("cont_chasu", cont_chasu);
		cfileDao.item("cfile_seq", cfile_seq_real++);
		cfileDao.item("doc_name", cfile_doc_name[i]);
		cfileDao.item("file_path", pdf.getString("file_path"));
		File attFile = f.saveFileTime("cfile_"+cfile_seq[i]);
		if(attFile == null){
			cfile.first();
			while(cfile.next()){
				if(cfile_seq[i].equals(cfile.getString("cfile_seq"))){
					cfileDao.item("file_name", cfile.getString("file_name"));
					cfileDao.item("file_ext", cfile.getString("file_ext"));
					cfileDao.item("file_size", cfile.getString("file_size"));
					cfile_name = cfile.getString("file_name");
				}
			}
		}else{
			cfileDao.item("file_name", attFile.getName());
			cfileDao.item("file_ext", u.getFileExt(attFile.getName()));
			cfileDao.item("file_size", attFile.length());
			cfile_name = attFile.getName();
		}
		if(cfile_name.equals("")){
			u.jsError("���忡 ���� �Ͽ����ϴ�.");
			return;
		}
		cfileDao.item("auto_yn", cfile_auto_type[i].equals("")?"N":"Y");
		cfileDao.item("auto_type", cfile_auto_type[i]);
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
		file_hash +="|"+contDao.getHash("file.path.bcont_pdf",pdf.getString("file_path")+cfile_name);
	}

	//������
	db.setCommand("delete from tcb_warr where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
	String[] warr_type = f.getArr("warr_type");
	String[] warr_etc = f.getArr("warr_etc");
	int warr_cnt = warr_type== null? 0: warr_type.length;
	for(int i = 0 ; i < warr_cnt; i ++){
		warrDao = new DataObject("tcb_warr");
		warrDao.item("cont_no", cont_no);
		warrDao.item("cont_chasu", cont_chasu);
		warrDao.item("member_no", "");
		warrDao.item("warr_seq", i);
		warrDao.item("warr_type", warr_type[i]);
		warrDao.item("etc", warr_etc[i]);
		db.setCommand(warrDao.getInsertQuery(), warrDao.record);
	}

	//���񼭷�
	db.setCommand("delete from tcb_rfile_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
	db.setCommand("delete from tcb_rfile where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
	DataObject rfile_cust = null;
	String[] rfile_seq = f.getArr("rfile_seq");
	String[] attch_yn = f.getArr("attch_yn");
	String[] rfile_doc_name = f.getArr("rfile_doc_name");
	String[] rfile_attch_type = f.getArr("attch_type");
	String[] reg_type = f.getArr("reg_type");
	String[] allow_ext = f.getArr("allow_ext");
	int rfile_cnt = rfile_seq == null? 0: rfile_seq.length;
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

		if(rfile_attch_type[i].equals("2")){//����÷�� �ΰ��
			rfile_cust = new DataObject("tcb_rfile_cust");
			rfile_cust.item("cont_no", cont_no);
			rfile_cust.item("cont_chasu", cont_chasu);
			rfile_cust.item("member_no", _member_no);
			rfile_cust.item("rfile_seq", rfile_seq[i]);
			File file = f.saveFileTime("rfile_"+rfile_seq[i]);
			if(file == null){
				rfile_cust.item("file_path", "");
				rfile_cust.item("file_name", "");
				rfile_cust.item("file_ext", "");
				rfile_cust.item("file_size", "");
				rfile_cust.item("reg_gubun", "");
			}else{
				rfile_cust.item("file_path", pdf.getString("file_path"));
				rfile_cust.item("file_name", file.getName());
				rfile_cust.item("file_ext", u.getFileExt(file.getName()));
				rfile_cust.item("file_size", file.length());
				rfile_cust.item("reg_gubun", "20");
			}
			db.setCommand(rfile_cust.getInsertQuery(), rfile_cust.record);
		}

		if(rfile_attch_type[i].equals("3")){
			rfile_cust = new DataObject("tcb_rfile_cust");
			rfile_cust.item("cont_no", cont_no);
			rfile_cust.item("cont_chasu", cont_chasu);
			rfile_cust.item("member_no", _member_no);
			rfile_cust.item("rfile_seq", rfile_seq[i]);
			rfile_cust.item("file_path", f.get("rfile_file_path_"+rfile_seq[i]));
			rfile_cust.item("file_name", f.get("rfile_file_name_"+rfile_seq[i]));
			rfile_cust.item("file_ext", f.get("rfile_file_ext_"+rfile_seq[i]));
			rfile_cust.item("file_size", f.get("rfile_file_size_"+rfile_seq[i]));
			db.setCommand(rfile_cust.getInsertQuery(), rfile_cust.record);
		}
	}

	
	// ���ΰ�������
	if(cont.getString("efile_yn").equals("Y")){
		db.setCommand("delete from tcb_efile where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
		String[] efile_seq = f.getArr("efile_seq");
		String[] efile_reg_type = f.getArr("efile_reg_type");
		String[] efile_doc_name = f.getArr("efile_doc_name");
		String[] efile_del_yn = f.getArr("efile_del_yn");
		int efile_cnt = efile_seq == null? 0: efile_seq.length;
		for(int i=0 ; i < efile_cnt; i ++){
			efileDao = new DataObject("tcb_efile");
			efileDao.item("cont_no", cont_no);
			efileDao.item("cont_chasu", cont_chasu);
			efileDao.item("efile_seq", efile_seq[i]);
			efileDao.item("doc_name", efile_doc_name[i]);
			File attfile = f.saveFileTime("efile_"+efile_seq[i]);
			String efile_name = "";
			if(attfile == null){
				if(!efile_del_yn[i].equals("Y")){
					efile.first();
					while(efile.next()){
						if(efile_seq[i].equals(efile.getString("efile_seq"))){
							efileDao.item("file_path", pdf.getString("file_path"));
							efileDao.item("file_name", efile.getString("file_name"));
							efileDao.item("file_ext", efile.getString("file_ext"));
							efileDao.item("file_size", efile.getString("file_size"));
							efileDao.item("reg_date", efile.getString("reg_date"));
							efileDao.item("reg_id", efile.getString("reg_id"));
						}
					}	
				}else{
					efileDao.item("file_path", "");
					efileDao.item("file_name", "");
					efileDao.item("file_ext", "");
					efileDao.item("file_size", "");
					efileDao.item("reg_date", efile.getString("reg_date"));
					efileDao.item("reg_id", efile.getString("reg_id"));
				}
				
			}else{
				efileDao.item("file_path", pdf.getString("file_path"));
				efileDao.item("file_name", attfile.getName());
				efileDao.item("file_ext", u.getFileExt(attfile.getName()));
				efileDao.item("file_size", attfile.length());
				efileDao.item("reg_date", u.getTimeString());
				efileDao.item("reg_id", auth.getString("_USER_ID"));
			}
			efileDao.item("reg_type", efile_reg_type[i]);
			db.setCommand(efileDao.getInsertQuery(), efileDao.record);
		}
	}
	
	// ������
	if(template.getString("stamp_yn").equals("Y")){
		db.setCommand("delete from tcb_stamp where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
		int nStampType = f.getInt("stamp_type");
		for(int i = 0 ; i < member_cnt; i ++){
			if(nStampType==0) break;  // �ش� ���� ����
			if(nStampType==1 && i==1) continue; // ������� ����
			if(nStampType==2 && i==0) continue; // ���޻���� ����
			
			DataObject stampDao = new DataObject("tcb_stamp");
			stampDao.item("cont_no", cont_no);
			stampDao.item("cont_chasu", cont_chasu);
			stampDao.item("member_no", member_no[i]);
			db.setCommand(stampDao.getInsertQuery(), stampDao.record);
		}
	}
	
	ContractDao cont2 = new ContractDao();
	cont2.item("cont_hash", file_hash);
	if(agree_cnt > 0)
	{
		cont2.item("agree_field_seqs", agree_field_seqs);
		cont2.item("agree_person_ids", agree_person_ids);
	}
	db.setCommand(cont2.getUpdateQuery("cont_no= '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), cont2.record);
	
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

	/* ���α� START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "���ڹ��� ����",  "", "10","20");
	/* ���α� END*/

	if(!db.executeArray()){
		u.jsError("���忡 ���� �Ͽ����ϴ�.");
		return;
	}
	
	u.jsAlertReplace("�����Ͽ����ϴ�.","contract_msign_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_msign_modify");
p.setVar("menu_cd","000059");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000059", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("change_cont", Integer.parseInt(cont_chasu)>0);
p.setVar("cont", cont);
p.setLoop("contSub", contSub);
p.setVar("template", template);
p.setLoop("sign_template", signTemplate);
p.setLoop("agreeTemplate", agreeTemplate);
p.setVar("btnSend", btnSend);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("warr", warr);
p.setLoop("rfile", rfile);
p.setVar("view_div_rfile", u.inArray(template_cd,  new String[]{"2019183","2019211","2019227","2019230","2020179","2020196"})?"":"none"); 
p.setVar("efile_yn", cont.getString("efile_yn").equals("Y"));//���� ���� ���� ��뿩��
p.setLoop("efile", efile);
p.setLoop("code_warr", u.arr2loop(code_warr));
p.setLoop("code_change_gubun", u.arr2loop(code_change_gubun));
p.setVar("detail_person", _member_no.equals("20121000046") ? true : false );   // �ķ�Ʈ���� ����� �������� ǥ��
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.setVar("warr_yn", template.getString("warr_yn").equals("")||template.getString("warr_yn").equals("Y"));
p.setVar("show_cont_user_no", !bAutoContUserNo);
p.display(out);
%>