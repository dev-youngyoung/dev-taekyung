<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
	Security	security	=	new	Security();

	String template_cd = u.request("template_cd");
	String bid_no = u.request("bid_no");
	String bid_deg = u.request("bid_deg");
	String supp_member_no = u.request("supp_member_no");
	if(template_cd.equals("")){
		u.jsError("정상적인 경로로 접근 하세요.");
		return;
	}

	CodeDao codeDao = new CodeDao("tcb_comcode");
	String[] code_warr = codeDao.getCodeArray("M007");

	DataObject memberDao = new DataObject("tcb_member");
	DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
	if(!member.next()){
		u.jsError("사용자 정보가 존재 하지 않습니다.");
		return;
	}

	DataSet cont = new DataSet();
	cont.addRow();
	cont.put("view_project", u.inArray(_member_no, new String[]{"20180203437","20180800860","20160401012"}));
	cont.put("btn_select_project", true);


// 서식정보 조회
	DataObject templateDao = new DataObject("tcb_cont_template");
	DataSet template= templateDao.find(" status > 0 and template_cd ='"+template_cd+"'");
	if(!template.next()){
	}

// 추가 서식정보 조회
	DataObject templateSubDao = new DataObject("tcb_cont_template_sub");
	DataSet templateSub= templateSubDao.find("template_cd ='"+template_cd+"'", "*", "sub_seq");
	while(templateSub.next()){
		templateSub.put("hidden", u.inArray(templateSub.getString("gubun"), new String[]{"20","30"}) );
		if(templateSub.getString("option_yn").equals("A")) // 자동 생성해야 하는 양식
			templateSub.put("option_yn", false);

	}

// 서명정보 조회
	DataObject signTemplateDao = new DataObject("tcb_cont_sign_template");
	DataSet signTemplate = signTemplateDao.find(" template_cd = '"+template_cd+"'","*","sign_seq asc");
	String default_sign_seq = "";
	while(signTemplate.next()){
		if(signTemplate.getString("cust_type").equals("01"))   // cust_type -  01:갑, 02:을, 00:연대보증      member_type - 01:작성업체, 02:수신업체
			default_sign_seq = signTemplate.getString("sign_seq");
	}

// 내부 결재정보 조회
	DataObject agreeTemplateDao = new DataObject("tcb_agree_template");
	DataSet agreeTemplate= agreeTemplateDao.find("template_cd ='"+template_cd+"'", "*", "agree_seq");
	if(agreeTemplate.size()>0){
		// 사용자 저장된 결재정보
		DataObject agreeUserDao = new DataObject("tcb_agree_user");
		DataSet agreeUser= agreeUserDao.find("template_cd ='"+template_cd+"' and user_id = '"+auth.getString("_USER_ID")+"'", "*", "agree_seq");
		if(agreeUser.size()>0){
			agreeTemplate = agreeUser;
		}
	}
	String	 agree_name_tag	=	"";
	while(agreeTemplate.next()){
		agree_name_tag	=	agreeTemplate.getString("agree_name");
		agree_name_tag	=	agree_name_tag.replaceAll("<br/>","\\\\n");
		agree_name_tag	=	agree_name_tag.replaceAll("<br>","\\\\n");
		agreeTemplate.put("agree_name_tag",agree_name_tag);
		agreeTemplate.put("is_cust", agreeTemplate.getString("agree_cd").equals("0"));
		agreeTemplate.put("agree_person_id", agreeTemplate.getString("agree_cd").equals("0")?"-":agreeTemplate.getString("agree_person_id"));
	}

	DataObject attCfileDao = new DataObject("tcb_att_cfile");
	DataSet cfile = attCfileDao.find("template_cd = '"+template_cd+"' and member_no = '"+_member_no+"' ");
	while(cfile.next()){
		cfile.put("cfile_seq", cfile.getString("file_seq"));
		cfile.put("auto", true);
		cfile.put("auto_class", "caution-text");
		cfile.put("auto_str",cfile.getString("auto_type").equals("1")?"자동첨부":"필수첨부");
		cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
		cfile.put("doc_name_readonly", "readonly");
		cfile.put("modfiy_file", false);
		cfile.put("btn_name", "다운로드");
		cfile.put("down_script","filedown('file.path.bcont_template','"+cfile.getString("file_path")+cfile.getString("file_name")+"','"+cfile.getString("doc_name")+"."+cfile.getString("file_ext")+"')");
	}



// 구비서류 조회
	DataObject rfileDao = new DataObject("tcb_rfile_template");
//rfileDao.setDebug(out);
	DataSet rfile = rfileDao.find("template_cd = '"+template_cd+"' and member_no ='"+_member_no+"'", "*"," rfile_seq asc");
	while(rfile.next()){
		rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
		if(rfile.getString("reg_type").equals("10")){
			rfile.put("attch_disabled_btn",rfile.getString("attch_yn").equals("Y")?"disabled":"");
			rfile.put("attch_disabled",rfile.getString("attch_yn").equals("Y")?"disabled":"");
			rfile.put("doc_name_class", "in_readonly");
			rfile.put("doc_name_readonly", "readonly");
			rfile.put("del_btn_yn", false);
		}else{
			rfile.put("attch_disabled_btn", "");
			rfile.put("attch_disabled","");
			rfile.put("doc_name_class", "");
			rfile.put("doc_name_readonly", "");
			rfile.put("del_btn_yn", true);
		}
	}


//내부 관리 서류 조회
	String[] code_reg_type = {"10=><span class='caution-text'>필수첨부</span>","20=>선택첨부","30=>추가첨부"};
	DataObject efileDao = new DataObject("tcb_efile_template");
	DataSet efile = new DataSet();
	if(template.getString("efile_yn").equals("Y")){
		efile = efileDao.find(" template_cd = '"+template_cd+"' and member_no = '"+_member_no+"' ");
		while(efile.next()){
			efile.put("str_reg_type", u.getItem(efile.getString("reg_type"), code_reg_type));
			efile.put("required", u.inArray(efile.getString("reg_type"), new String[]{"10","30"})?"required='Y'":"");
			efile.put("doc_name_readonly", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"readonly":"");
			efile.put("doc_name_class", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"in_readonly":"label");
		}
	}



// 담당자 정보 조회
	memberDao = new DataObject("tcb_member");
	DataSet cust = memberDao.query(
			"	select a.member_no, a.vendcd, a.post_code, a.member_slno, a.address, a.member_name, a.boss_name, "
					+"	       b.user_name, b.email ,b.tel_num, b.hp1, b.hp2,b.hp3, b.field_seq, b.division, b.position"
					+"	     , (select field_name from tcb_field where member_no = '"+_member_no+"' and field_seq = b.field_seq) as field_name "
					+"	  from tcb_member a, tcb_person b "
					+"	 where a.member_no = b.member_no "
					+"	  and a.member_no = '"+_member_no+"' "
					+"	  and b.person_seq = '"+auth.getString("_PERSON_SEQ")+"'	 "
	);
	if(!cust.next()){
		u.jsError("사용자 정보가 존재 하지 않습니다.");
		return;
	}
	cust.put("sign_seq", default_sign_seq);


	f.addElement("cont_name",null, "hname:'계약명', required:'Y'");
	f.addElement("cont_date", null, "hname:'계약일자', required:'Y'");

	if(template.getString("stamp_yn").equals("Y")){
		f.addElement("stamp_type", null, "hname:'인지세 납부 대상', required:'Y'");
	}

	f.addElement("cont_userno", null, "hname:'계약번호', maxbyte:'40'");


	if(u.isPost()&&f.validate()){

		response.setHeader("Cache-Control", "no-Cache, no-store, must-revalidate");
		//계약서 저장
		ContractDao contDao = new ContractDao();

		String cont_no = contDao.makeContNo();
		int cont_chasu = 0;
		String random_no = u.strpad(u.getRandInt(0,99999)+"",5,"0");

		String cont_html_rm_str = "";
		String[] cont_html_rm = f.getArr("cont_html_rm");
		String[] cont_html = f.getArr("cont_html");
		String[] cont_sub_name = f.getArr("cont_sub_name");
		String[] cont_sub_style = f.getArr("cont_sub_style");
		String[] gubun = f.getArr("gubun");
		String[] sub_seq = f.getArr("sub_seq");
		String arrOption_yn[] = new String[cont_html_rm.length];

		//decodeing 처리 START
		for(int i = 0 ; i < cont_html_rm.length; i ++){
			cont_html_rm[i] = new String(Base64Coder.decode(cont_html_rm[i]),"UTF-8");
		}
		for(int i = 0 ; i < cont_html.length; i ++){
			cont_html[i] =  new String(Base64Coder.decode(cont_html[i]),"UTF-8");
		}
		//decodeing 처리 END

		for(int i = 0 ; i < cont_html_rm.length; i ++){
			arrOption_yn[i] = f.get("option_yn_"+i);
		}

		for(int i = 0 ; i < cont_html_rm.length; i ++){
			if(i != 0)
				cont_html_rm_str += "<pd4ml:page.break>";
			if(gubun[i].equals("10")&&u.inArray(f.get("option_yn_"+i), new String[]{"A","Y"})){
				cont_html_rm_str += cont_html_rm[i];
			}
		}

		ArrayList autoFiles = new ArrayList();

		int file_seq = 1;
		String cont_userno = f.get("cont_userno");


		// 계약서파일 생성
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
			u.jsError("계약서 파일 생성에 실패 하였습니다.");
			return;
		}
		//자동생성파일 생성
		for(int i = 0 ; i < cont_html_rm.length; i ++){
			if(gubun[i].equals("10")) continue;
			if(    gubun[i].equals("20")
					|| gubun[i].equals("50")  // 작성업체만 보고 인쇄하는 양식(서명대상 X)
					|| ( gubun[i].equals("40") && (arrOption_yn[i].equals("A") || arrOption_yn[i].equals("Y")) ) // 자동으로 생성되는 양식 또는 체크된 양식인 경우
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


		//계약기간구하기
		String cont_sdate = f.get("cont_sdate").replaceAll("-","");
		String cont_edate = f.get("cont_edate").replaceAll("-","");
		if(!f.get("cont_syear").equals("")&&!f.get("cont_smonth").equals("")&&!f.get("cont_sday").equals("")){
			cont_sdate = u.strrpad(f.get("cont_syear"),4,"0")+u.strrpad(f.get("cont_smonth"),2,"0")+u.strrpad(f.get("cont_sday"),2,"0");
		}
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
		contDao.item("cont_no", cont_no);
		contDao.item("cont_chasu", cont_chasu);
		contDao.item("member_no", _member_no);
		contDao.item("field_seq", auth.getString("_FIELD_SEQ"));
		contDao.item("template_cd", f.get("template_cd"));
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
		contDao.item("reg_id", auth.getString("_USER_ID"));
		contDao.item("status", "10");
		contDao.item("version_seq", template.getString("version_seq"));
		if(template.getString("efile_yn").equals("Y")){
			contDao.item("efile_yn", "Y");
		}
		if(!bid_no.equals("")&&!bid_deg.equals("")){
			contDao.item("bid_kind_cd", bid.getString("bid_kind_cd"));
			contDao.item("bid_no", bid_no);
			contDao.item("bid_deg", bid_deg);
		}
		contDao.item("src_cd", f.get("src_cd"));
		contDao.item("stamp_type", f.get("stamp_type"));
		contDao.item("project_seq", f.get("project_seq"));
		if(bIsKakao) {
			contDao.item("cont_etc1", f.get("cont_etc1"));
			contDao.item("cont_etc2", f.get("cont_etc2"));
			contDao.item("cont_etc3", f.get("cont_etc3"));
		}
		else if(isCJT) {
			contDao.item("cont_etc1", auth.getString("_DIVISION")); // 작성자의 부문
		}
		else if(!f.get("cont_etc1").equals("")) {
			contDao.item("cont_etc1", f.get("cont_etc1"));
		}

		db.setCommand(contDao.getInsertQuery(), contDao.record);

		for(int i = 1 ; i < cont_html.length; i++) {
			DataObject cont_sub = new DataObject("tcb_cont_sub");
			cont_sub.item("cont_no", cont_no);
			cont_sub.item("cont_chasu", cont_chasu);
			cont_sub.item("sub_seq", i);
			cont_sub.item("cont_sub_html",cont_html[i]);
			cont_sub.item("org_cont_sub_html",cont_html[i]);
			cont_sub.item("cont_sub_name",cont_sub_name[i]);
			cont_sub.item("cont_sub_style",cont_sub_style[i]);
			cont_sub.item("gubun", gubun[i]);
			cont_sub.item("option_yn",arrOption_yn[i]);
			db.setCommand(cont_sub.getInsertQuery(), cont_sub.record);
		}


		// 서명 서식 저장
		String[] sign_seq = f.getArr("sign_seq");
		String[] signer_name = f.getArr("signer_name");
		String[] signer_max = f.getArr("signer_max");
		String[] member_type = f.getArr("member_type");
		String[] cust_type  = f.getArr("cust_type");
		for(int i = 0 ; i < sign_seq.length; i ++){
			DataObject cont_sign = new DataObject("tcb_cont_sign");
			cont_sign.item("cont_no",cont_no);
			cont_sign.item("cont_chasu",cont_chasu);
			cont_sign.item("sign_seq", sign_seq[i]);
			cont_sign.item("signer_name", signer_name[i]);
			cont_sign.item("signer_max", signer_max[i]);
			cont_sign.item("member_type", member_type[i]);// 01:나이스와 계약한 업체 02:나이스 미계약업체
			cont_sign.item("cust_type", cust_type[i]);// 01:갑 02:을
			db.setCommand(cont_sign.getInsertQuery(), cont_sign.record);
		}

		// 내부 결재 서식 저장
		String agree_field_seqs = "";
		String agree_person_ids = "";
		String[] agree_seq = f.getArr("agree_seq");
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
			String	sAgreeName	=	"";
			for(int i = 0 ; i < agree_cnt; i ++){
				sAgreeName	= agree_name[i].replaceAll("(\\\\r\\\\n|\\\\n\\\\r|\\\\r|\\\\n)", "<br/>");

				DataObject cont_agree = new DataObject("tcb_cont_agree");
				cont_agree.item("cont_no",cont_no);
				cont_agree.item("cont_chasu",cont_chasu);
				cont_agree.item("agree_seq", agree_seq[i]);
				cont_agree.item("agree_name", sAgreeName);
				cont_agree.item("agree_field_seq", agree_field_seq[i]);
				cont_agree.item("agree_person_name", agree_person_name[i]);
				cont_agree.item("agree_person_id", agree_person_id[i]);
				cont_agree.item("ag_md_date", "");
				cont_agree.item("mod_reason", "");
				cont_agree.item("r_agree_person_id","");
				cont_agree.item("r_agree_person_name", "");
				cont_agree.item("agree_cd", agree_cd[i]);	// 결재구분코드(0:업체서명전, 1:업체서명후)
				db.setCommand(cont_agree.getInsertQuery(), cont_agree.record);
				if(0==i){
					agree_field_seqs += "|";
				}
				agree_field_seqs += agree_field_seq[i] + "|";
				agree_person_ids += agree_person_id[i] + "|";

				// 본인 결재 라인에 저장
				DataObject cont_agree_user = new DataObject("tcb_agree_user");
				cont_agree_user.item("template_cd", template_cd);
				cont_agree_user.item("user_id", auth.getString("_USER_ID"));
				cont_agree_user.item("agree_seq", agree_seq[i]);
				cont_agree_user.item("agree_name", agree_name[i]);
				cont_agree_user.item("agree_field_seq", agree_field_seq[i]);
				cont_agree_user.item("agree_person_name", agree_person_name[i]);
				cont_agree_user.item("agree_person_id", agree_person_id[i]);
				cont_agree_user.item("agree_cd", agree_cd[i]);	// 결재구분코드(0:업체서명전, 1:업체서명후)
				db.setCommand(cont_agree_user.getInsertQuery(), cont_agree_user.record);
			}
		}

		// 업체 저장
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
		String[] member_gubun = f.getArr("member_gubun");  // 01:법인(본사), 02:법인(지사), 03:개인사업자
		String[] cust_gubun = f.getArr("cust_gubun");
		String[] cust_detail_code = f.getArr("cust_detail_code");
		int member_cnt = member_no == null? 0: member_no.length;
		for(int i = 0 ; i < member_cnt; i ++){
			signTemplate.first();
			while(signTemplate.next()){
				if(signTemplate.getString("sign_seq").equals(cust_sign_seq[i])){
					break;
				}
			}
			DataObject custDao = new DataObject("tcb_cust");
			custDao.item("cont_no", cont_no);
			custDao.item("cont_chasu",cont_chasu);
			custDao.item("member_no",member_no[i]);
			custDao.item("sign_seq", cust_sign_seq[i]);
			custDao.item("cust_gubun", cust_gubun[i]);//01:사업자 02:개인
			custDao.item("vendcd", vendcd[i].replaceAll("-",""));
			if(cust_gubun[i].equals("02")&&!jumin_no[i].equals("")){
				custDao.item("jumin_no", security.AESencrypt(jumin_no[i].replaceAll("-","")));
			}
			if(member_gubun[i].equals("03")&&!jumin_no[i].equals("")){  // 개인사업자이지만 생년월일이 있는 경우
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
			if(signTemplate.getString("pay_yn").equals("Y")){
				custDao.item("pay_yn","Y");
			}
			db.setCommand(custDao.getInsertQuery(), custDao.record);

			// 소싱카테고리를 관리하는 업체고 계약서 작성시 소싱그룹 지정이 되어 있다면 작성시 지정한 소싱 그룹으로 소싱 정보를 입력한다. (단, 소싱 그룹은 1개업체가 여러군데 지정될 수 있으므로 insert만 한다.)
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

		// 연대보증 업체 저장
		for(int i = 1 ; i <= 20; i ++){
			String member_name_y = f.get("op_member_name_"+i);	// 이름

			if(!member_name_y.equals(""))
			{
				String vendcd_y = f.get("op_vendcd_cd1_"+i)+f.get("op_vendcd_cd2_"+i)+f.get("op_vendcd_cd3_"+i);	// 사업자번호
				String birthday_y = f.get("op_birthday_"+i);		// 생년월일
				String gender_y = f.get("op_gender_"+i);			// 성별
				String address_y = f.get("op_address_"+i);			// 주소
				String boss_name_y = f.get("op_boss_name_"+i);		// 대표자명
				String tel_num_y = f.get("op_telnum_"+i);			// 연락처(휴대폰)
				String email_y = f.get("op_email_"+i);				// 이메일

				String sign_type_y = f.get("op_sign_type_"+i);		// 서명타입(10:공인인증서명, 20:휴대폰서명)
				String hp1_y = f.get("op_hp1_"+i);		// 휴대폰
				String hp2_y = f.get("op_hp2_"+i);		// 휴대폰
				String hp3_y = f.get("op_hp3_"+i);		// 휴대폰

				DataObject custDaoA = new DataObject("tcb_cust");
				custDaoA.item("cont_no", cont_no);
				custDaoA.item("cont_chasu", cont_chasu);
				custDaoA.item("member_no", Util.strrpad(""+i, 11, "0")); // 연대보증인은 0 10자리로 시작
				custDaoA.item("sign_seq", 10+i);			// 서명순서 (연대보증인은 10부터 시작)

				custDaoA.item("sign_type", sign_type_y);			// 서명타입(10:공인인증서명, 20:휴대폰서명)
				custDaoA.item("hp1", hp1_y);			// 휴대폰
				custDaoA.item("hp2", hp2_y);			// 휴대폰
				custDaoA.item("hp3", hp3_y);			// 휴대폰


				int boss_gender_yn = 0;
				if(!birthday_y.equals("")){
					System.out.println("gender_y : " + gender_y);
					if(!gender_y.equals("")){
						birthday_y += gender_y;
					}
					if(birthday_y.indexOf("-")>0){  // 2014-12-12 형태
						custDaoA.item("jumin_no", security.AESencrypt(birthday_y.replaceAll("-","").substring(2)));
					}else{ // 741212 형태
						custDaoA.item("jumin_no", security.AESencrypt(birthday_y));
					}
					custDaoA.item("cust_gubun", "02");	// 개인(보증인)

					if(!gender_y.equals("")){
						boss_gender_yn = Integer.parseInt(gender_y) ;
					}

					if(boss_gender_yn < 3) {
						custDaoA.item("boss_birth_date", "19" + birthday_y.substring(0,6));
					} else {
						custDaoA.item("boss_birth_date", "20" + birthday_y.substring(0,6));
					}
					custDaoA.item("boss_gender", gender_y);
				} else {
					custDaoA.item("vendcd", vendcd_y);
					custDaoA.item("cust_gubun", "01");	// 사업자(보증사)
				}
				custDaoA.item("member_name", member_name_y);
				custDaoA.item("boss_name", boss_name_y.equals("")? member_name_y : boss_name_y);
				custDaoA.item("address", address_y);
				custDaoA.item("tel_num", tel_num_y);
				custDaoA.item("user_name", member_name_y);
				custDaoA.item("email", email_y);
				//custDaoA.item("display_seq", i);				// 순서(쓰이지는 않을것 같음)
				db.setCommand(custDaoA.getInsertQuery(), custDaoA.record);
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
		//계약서류 갑지
		DataObject cfileDao = new DataObject("tcb_cfile");
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

		//자동생성파일
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
			if(temp.getString("gubun").equals("50"))	// 작성업체만 보고 인쇄하는 양식은 서명대상이 아님.  gubun[i].equals("50")
				cfileDao.item("auto_type", "3");	// 공백:자동생성, 1:자동첨부, 2:필수첨부, 3:내부용
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
		int cfile_cnt = cfile_doc_name==null? 0 : cfile_doc_name.length;

		System.out.println("cfile_cnt : " + cfile_cnt);
		for(int i = 0 ;i < cfile_cnt; i ++){
			String cfile_name = "";
			cfileDao = new DataObject("tcb_cfile");
			cfileDao.item("cont_no", cont_no);
			cfileDao.item("cont_chasu", cont_chasu);
			cfileDao.item("cfile_seq",cfile_seq_real++);
			cfileDao.item("doc_name", cfile_doc_name[i]);
			cfileDao.item("file_path", pdf.getString("file_path"));
			File attfile = f.saveFileTime("cfile_"+cfile_seq[i]);
			if(attfile == null){
				cfile.first();
				while(cfile.next()){
					if(cfile.getString("cfile_seq").equals(cfile_seq[i])){
						cfileDao.item("file_name", cfile.getString("file_name"));
						cfileDao.item("file_ext", cfile.getString("file_ext"));
						cfileDao.item("file_size", cfile.getString("file_size"));
						String sourceFile = Startup.conf.getString("file.path.bcont_template")+template_cd+"/"+_member_no+"/"+cfile.getString("file_name");
						String targetFile = Startup.conf.getString("file.path.bcont_pdf")+pdf.getString("file_path")+cfile.getString("file_name");
						u.copyFile(sourceFile, targetFile);
						cfile_name = cfile.getString("file_name");
					}
				}
			}else{
				cfileDao.item("file_name", attfile.getName());
				cfileDao.item("file_ext", u.getFileExt(attfile.getName()));
				cfileDao.item("file_size", attfile.length());
				cfile_name = attfile.getName();
			}
			if(cfile_name.equals("")){
				u.jsError("저장에 실패 하였습니다.");
				return;
			}
			cfileDao.item("auto_yn",cfile_auto_type[i].equals("")?"N":"Y");
			cfileDao.item("auto_type", cfile_auto_type[i]);
			db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
			file_hash +="|"+contDao.getHash("file.path.bcont_pdf",pdf.getString("file_path")+cfile_name);
		}

		//보증서
		String[] warr_type = f.getArr("warr_type");
		String[] warr_etc = f.getArr("warr_etc");
		int warr_cnt = warr_type== null? 0: warr_type.length;
		for(int i = 0 ; i < warr_cnt; i ++){
			DataObject warrDao = new DataObject("tcb_warr");
			warrDao.item("cont_no", cont_no);
			warrDao.item("cont_chasu", cont_chasu);
			warrDao.item("member_no", "");
			warrDao.item("warr_seq", i);
			warrDao.item("warr_type", warr_type[i]);
			warrDao.item("etc", warr_etc[i]);
			db.setCommand(warrDao.getInsertQuery(), warrDao.record);
		}

		//구비서류
		DataObject rfile_cust = null;
		String[] rfile_seq = f.getArr("rfile_seq");
		String[] attch_yn = f.getArr("attch_yn");
		String[] rfile_doc_name = f.getArr("rfile_doc_name");
		String[] rfile_attch_type = f.getArr("attch_type");
		String[] reg_type = f.getArr("reg_type");
		String[] allow_ext = f.getArr("allow_ext");
		String[] uncheck_text = f.getArr("uncheck_text");
		String[] sample_file_path = f.getArr("sample_file_path");
		String[] sample_file_name = f.getArr("sample_file_name");
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
			rfileDao.item("uncheck_text", uncheck_text[i]);
			rfileDao.item("sample_file_path", sample_file_path[i]);
			rfileDao.item("sample_file_name", sample_file_name[i]);
			db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);

			if(rfile_attch_type[i].equals("2")){//직접첨부 인경우
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
		}

		// 내부관리서류
		if(template.getString("efile_yn").equals("Y")){
			String[] efile_seq = f.getArr("efile_seq");
			String[] efile_reg_type = f.getArr("efile_reg_type");
			String[] efile_doc_name = f.getArr("efile_doc_name");
			int efile_cnt = efile_seq == null? 0: efile_seq.length;
			for(int i=0 ; i < efile_cnt; i ++){
				efileDao = new DataObject("tcb_efile");
				efileDao.item("cont_no", cont_no);
				efileDao.item("cont_chasu", cont_chasu);
				efileDao.item("efile_seq", efile_seq[i]);
				efileDao.item("doc_name", efile_doc_name[i]);
				File attfile = f.saveFileTime("efile_"+efile_seq[i]);
				if(attfile != null){
					efileDao.item("file_path", pdf.getString("file_path"));
					efileDao.item("file_name", attfile.getName());
					efileDao.item("file_ext", u.getFileExt(attfile.getName()));
					efileDao.item("file_size", attfile.length());
				}
				efileDao.item("reg_type", efile_reg_type[i]);
				efileDao.item("reg_date", u.getTimeString());
				efileDao.item("reg_id", auth.getString("_USER_ID"));
				db.setCommand(efileDao.getInsertQuery(), efileDao.record);
			}
		}

		// 인지세
		if(template.getString("stamp_yn").equals("Y")){
			int nStampType = f.getInt("stamp_type");
			for(int i = 0 ; i < member_cnt; i ++){
				if(nStampType==0) break;  // 해당 사항 없음
				if(nStampType==1 && i==1) continue; // 원사업자 납부
				if(nStampType==2 && i==0) continue; // 수급사업자 납부

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

		if((!bid_no.equals(""))&&!bid_deg.equals("")&&!supp_member_no.equals("")){
			DataObject bidSuppDao = new DataObject("tcb_bid_supp");
			bidSuppDao.item("cont_no", cont_no);
			db.setCommand(bidSuppDao.getUpdateQuery("main_member_no = '"+_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"' and member_no = '"+supp_member_no+"'"),bidSuppDao.record);
		}

		// 계약서 추가 입력정보 (DB화하여 검색이 필요한 경우)
		DataObject tempaddDao = new DataObject("tcb_cont_template_add");
		DataSet tempaddDs = tempaddDao.find("template_cd = '"+template_cd+"'", "template_name_en,col_name,mul_yn");

		if(tempaddDs.size()>0){
			DataObject contaddDao = new DataObject("tcb_cont_add"); // Array가 아닌 데이터는 복수인 데이터.
			contaddDao.item("cont_no", cont_no);
			contaddDao.item("cont_chasu", cont_chasu);
			contaddDao.item("seq", 1);

			while(tempaddDs.next()){
				if(tempaddDs.getString("mul_yn").equals("Y")) { // 복수
					String[] colVals = f.getArr(tempaddDs.getString("template_name_en"));

					System.out.println("template_name_en : " + tempaddDs.getString("template_name_en"));
					System.out.println("colVals.length : " + colVals.length);
					int cnt = colVals == null? 0 : colVals.length;
					String colVal = "";
					for(int i=0; i< cnt ; i++) {
						colVal += colVals[i] + "|";
					}
					contaddDao.item(tempaddDs.getString("col_name"), colVal);
				} else { // 단수
					contaddDao.item(tempaddDs.getString("col_name"), f.get(tempaddDs.getString("template_name_en")));
				}

			}
			db.setCommand(contaddDao.getInsertQuery(), contaddDao.record);
		}

		/* 계약로그 START*/
		ContBLogDao logDao = new ContBLogDao();
		logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 생성",  "", "10","10");
		/* 계약로그 END*/

		if(!db.executeArray()){
			u.jsError("저장에 실패 하였습니다.");
			return;
		}
		u.jsAlertReplace("저장 하였습니다.\\n\\n임시저장계약 메뉴로 이동합니다.","contract_writing_list.jsp?");
		return;
	}

	p.setLayout("default");
//p.setDebug(out);
	p.setBody("contract.contract_modify");
	p.setVar("menu_cd","000053");
	p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000053", "btn_auth").equals("10"));
	p.setVar("modify", false);
	p.setVar("cont", cont);
	p.setVar("member", member);
	p.setVar("template", template);
	p.setLoop("templateSub", templateSub);
	p.setLoop("sign_template", signTemplate);
	p.setLoop("agreeTemplate", agreeTemplate);
	p.setLoop("cust", cust);
	p.setLoop("cfile", cfile);
	p.setLoop("rfile", rfile);
	p.setVar("efile_yn", template.getString("efile_yn").equals("Y"));//내부 관리 서류 사용여부
	p.setLoop("efile", efile);
	p.setLoop("code_warr", u.arr2loop(code_warr));
	p.setVar("bid", bid);
	p.setVar("supp_member_no", supp_member_no);
	p.setVar("form_script", f.getScript());
	p.setVar("warr_yn", template.getString("warr_yn").equals("")||template.getString("warr_yn").equals("Y"));
	p.display(out);
%>