<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

Security	security	=	new	Security();
String fileDir = "";

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr_type = codeDao.getCodeArray("M007");
String[] code_office = codeDao.getCodeArray("C104");
String[] code_vat_type = {"1=>VAT별도","2=>VAT포함","3=>VAT미선택"};

//테크로스 워터앤에너지,테크로스환경서비스 는 자유서식에서 vat 포함여부 기능
boolean bIsTechcross = u.inArray(_member_no, new String[]{"20160401012","20180203437"});

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("사용자 정보가 존재 하지 않습니다.");
	return;
}


ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
	" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and paper_yn = 'Y' and status = '10' "
	," tcb_contmaster.* "
	 +" ,(select member_name from tcb_member where member_no = mod_req_member_no) mod_req_name "
	 +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,3) = substr(tcb_contmaster.src_cd,0,3) and depth='1') l_src_nm "
     +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,6) = substr(tcb_contmaster.src_cd,0,6) and depth='2') m_src_nm "
     +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and src_cd = tcb_contmaster.src_cd and depth='3') s_src_nm "
);
if(!cont.next()){
	u.jsError("계약정보가 존재 하지 않습니다.");
	return;
}
cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
if(!cont.getString("src_cd").equals(""))
cont.put("src_nm", cont.getString("l_src_nm")+" > "+cont.getString("m_src_nm")+" > "+cont.getString("s_src_nm"));


// 서식정보 조회
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" status > 0 and template_cd ='"+cont.getString("template_cd")+"'");
if(!template.next()){
}

DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");


//내부 결재정보 조회
boolean btnSend = true;
DataObject agreeTemplateDao = new DataObject("tcb_cont_agree");
DataSet agreeTemplate= agreeTemplateDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", "agree_seq");
if(agreeTemplate.next()){
	if(agreeTemplate.getString("agree_cd").equals("0")){  // 다음 결재 순서자가 거래처면 전송 가능
		btnSend = true;
	}else{
		btnSend = false;
	}
}
agreeTemplate.first();
while(agreeTemplate.next()){
	agreeTemplate.put("cont_no", u.aseEnc(agreeTemplate.getString("cont_no")));	
}


// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
if(!cust.next()){
	u.jsError("계약업체 정보가 존재 하지 않습니다.");
	return;
}
while(cust.next()){
    cust.put("cont_no", u.aseEnc(cust.getString("cont_no")));
	if(cust.getString("cust_gubun").equals("02")){
		cust.put("jumin_no", security.AESdecrypt(cust.getString("jumin_no")));
	}else{
		cust.put("jumin_no", "");
	}
}

//계약서류 조회
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	cfile.put("auto", cfile.getString("auto_yn").equals("Y")?true:false);
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	cfile.put("pdf_yn", cfile.getString("file_ext").toLowerCase().equals("pdf"));
	fileDir = cfile.getString("file_path");
}
/*
if(fileDir.equals("")){
	u.jsError("계약서류저장 경로가 없습니다.");
	return;
}
*/
//보증정보조회
DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(warr.next()){
	warr.put("warr_amt", u.numberFormat(warr.getDouble("warr_amt"),0));
	warr.put("warr_date", u.getTimeString("yyyy-MM-dd", warr.getString("warr_date")));
	warr.put("warr_sdate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_sdate")));
	warr.put("warr_edate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_edate")));
}


//구비서류 조회
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
		);
while(rfile.next()){
 	rfile.put("cont_no", u.aseEnc(rfile.getString("cont_no")));
	rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
	if(!rfile.getString("file_name").equals(""))
	rfile.put("str_file_size", u.getFileSize(rfile.getLong("file_size")));
	rfile.put("attch_disabled","");
	rfile.put("doc_name_class", "label");
	rfile.put("doc_name_readonly", "");
	rfile.put("del_btn_yn", true);
}
 
f.addElement("cont_name", cont.getString("cont_name"), "hname:'계약명', required:'Y'");
f.addElement("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")), "hname:'계약일자', required:'Y'");
f.addElement("cont_userno", cont.getString("cont_userno"), "hname:'계약번호', maxbyte:'40'");
f.addElement("cont_sdate", u.getTimeString("yyyy-MM-dd",cont.getString("cont_sdate")), "hname:'계약기간'");
f.addElement("cont_edate", u.getTimeString("yyyy-MM-dd",cont.getString("cont_edate")), "hname:'계약기간'"); 
 
if(!cont.getString("cont_total").equals("")){
	f.addElement("cont_total", u.numberFormat(cont.getDouble("cont_total"), 0), "hname:'계약금액'");
	if(bIsTechcross){
		f.addElement("cont_etc2", cont.getString("cont_etc2"), "hname:'VAT유형' , required:'Y'");
	}
}else{ 
	f.addElement("cont_total", null, "hname:'계약금액'");
	if(bIsTechcross){
		f.addElement("cont_etc2", null, "hname:'VAT유형'");
	}
}
if(!member.getString("src_depth").equals(""))
	f.addElement("src_cd", cont.getString("src_cd"), "hname:'소싱그룹'");



if(!member.getString("src_depth").equals(""))
f.addElement("src_cd", null, "hname:'소싱그룹'");

if(u.isPost()&&f.validate()){
	//계약서 저장
	contDao = new ContractDao();

	String cont_userno = f.get("cont_userno");
	

	DB db = new DB();
	//db.setDebug(out);
	contDao = new ContractDao();

	contDao.item("member_no", _member_no);
	contDao.item("cont_userno", cont_userno);
	contDao.item("cont_name", f.get("cont_name"));
	contDao.item("cont_date", f.get("cont_date").replaceAll("-",""));
	contDao.item("cont_sdate", f.get("cont_sdate").replaceAll("-",""));
	contDao.item("cont_edate", f.get("cont_edate").replaceAll("-",""));
	contDao.item("cont_total", f.get("cont_total").replaceAll(",", ""));
	contDao.item("cont_html", f.get("cont_html"));
	contDao.item("reg_date", u.getTimeString());
	contDao.item("true_random", u.strpad(u.getRandInt(0,99999)+"",5,"0"));
	contDao.item("status", "10");
	contDao.item("src_cd", f.get("src_cd")); 
	if(bIsTechcross){
	 	contDao.item("cont_etc2", f.get("cont_etc2"));  
	}
	
	db.setCommand(contDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), contDao.record);



	// 서명 서식 저장
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
	
	
	// 업체 저장
	db.setCommand("delete from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
	String[] member_no = f.getArr("member_no");
	String[] cust_gubun = f.getArr("cust_gubun");
	String[] cust_sign_seq = f.getArr("cust_sign_seq");
	String[] vendcd = f.getArr("vendcd");
	String[] jumin_no = f.getArr("jumin_no");
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
	int member_cnt = member_no == null? 0: member_no.length;
	for(int i = 0 ; i < member_cnt; i ++){
		custDao = new DataObject("tcb_cust");
		custDao.item("cont_no", cont_no);
		custDao.item("cont_chasu",cont_chasu);
		custDao.item("member_no",member_no[i]);
		custDao.item("sign_seq", cust_sign_seq[i]);
		custDao.item("cust_gubun", cust_gubun[i]);//01:사업자 02:개인
		custDao.item("vendcd", vendcd[i].replaceAll("-",""));
		if(cust_gubun[i].equals("02")&&!jumin_no[i].equals("")){
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
		cust.first();
		while(cust.next()){
			if(cust.getString("member_no").equals(member_no[i]) && !cust.getString("pay_yn").equals("")){
				custDao.item("pay_yn", cust.getString("pay_yn"));
			}
		}

		db.setCommand(custDao.getInsertQuery(), custDao.record);
	}
	
	db.setCommand(
			 " update tcb_cust "
			+"    set list_cust_yn = decode(display_seq, (select min(display_seq)  from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no <> '"+_member_no+"' ),'Y') "
			+"  where cont_no = '"+cont_no+"' "
			+"    and cont_chasu = '"+cont_chasu+"' "	 
					,null);

	//계약서류
	db.setCommand("delete from tcb_cfile where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);

	f.uploadDir = Startup.conf.getString("file.path.bcont_pdf")+fileDir;
	String file_hash = "";
	String[] cfile_seq = f.getArr("cfile_seq");
	String[] cfile_doc_name = f.getArr("cfile_doc_name");
	int cfile_cnt = cfile_seq==null? 0 : cfile_seq.length;
	for(int i = 0 ;i < cfile_cnt; i ++){
		cfileDao = new DataObject("tcb_cfile");
		if(!cfile_seq[i].equals("0")){
			cfile.first();
			 while(cfile.next()){
			 	if(cfile_seq[i].equals(cfile.getString("cfile_seq"))&&!cfile.getString("auto_yn").equals("Y")){
			 		cfileDao.item("cont_no", cont_no);
					cfileDao.item("cont_chasu", cont_chasu);
					cfileDao.item("cfile_seq",i+1);
					cfileDao.item("doc_name", cfile_doc_name[i]);
					cfileDao.item("file_path", fileDir);
			 		cfileDao.item("file_name", cfile.getString("file_name"));
					cfileDao.item("file_ext", cfile.getString("file_ext"));
					cfileDao.item("file_size", cfile.getString("file_size"));
					cfileDao.item("auto_yn","N");
					cfileDao.item("auto_type", "");
					db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
					file_hash +="|"+contDao.getHash("file.path.bcont_pdf",fileDir+cfile.getString("file_name"));
			 	}
			 }
		}else{
			cfileDao.item("cont_no", cont_no);
			cfileDao.item("cont_chasu", cont_chasu);
			cfileDao.item("cfile_seq",i+2);
			cfileDao.item("doc_name", cfile_doc_name[i]);
			cfileDao.item("file_path", fileDir);
			File attFile = f.saveFileTime("cfile_"+i);
			if(attFile == null){
				continue;
			}
			cfileDao.item("file_name", attFile.getName());
			cfileDao.item("file_ext", u.getFileExt(attFile.getName()));
			cfileDao.item("file_size", attFile.length());
			cfileDao.item("auto_yn","N");
			cfileDao.item("auto_type", "");
			db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
			file_hash +="|"+contDao.getHash("file.path.bcont_pdf",fileDir+attFile.getName());
		}

	}

	//보증서
	db.setCommand("delete from tcb_warr where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
	String[] warr_seq = f.getArr("warr_seq");
	String[] warr_type = f.getArr("warr_type");
	String[] warr_office = f.getArr("warr_office");
	String[] warr_no = f.getArr("warr_no");
	String[] warr_amt = f.getArr("warr_amt");
	String[] warr_sdate = f.getArr("warr_sdate");
	String[] warr_edate = f.getArr("warr_edate");
	String[] warr_date = f.getArr("warr_date");
	
	int warr_cnt = warr_type== null? 0: warr_type.length;
	for(int i = 0 ; i < warr_cnt; i ++){
		warrDao = new DataObject("tcb_warr");
		warrDao.item("cont_no", cont_no);
		warrDao.item("cont_chasu", cont_chasu);
		warrDao.item("member_no", _member_no);
		warrDao.item("warr_seq", i);
		warrDao.item("warr_type", warr_type[i]);
		warrDao.item("warr_office", warr_office[i]);
		warrDao.item("warr_no", warr_no[i]);
		warrDao.item("warr_amt", warr_amt[i].replaceAll(",", ""));
		warrDao.item("warr_sdate", warr_sdate[i].replaceAll("-", ""));
		warrDao.item("warr_edate", warr_edate[i].replaceAll("-", ""));
		warrDao.item("warr_date", warr_date[i].replaceAll("-", ""));

		File file = f.saveFileTime("warr_file_"+warr_seq[i]);
		if(file != null){
			warrDao.item("doc_name", f.getFileName("warr_file_"+warr_seq[i]));
			warrDao.item("file_path", fileDir);
			warrDao.item("file_name", file.getName());
			warrDao.item("file_ext", u.getFileExt(file.getName()));
			warrDao.item("file_size", file.length());
		}else{
			warr.first();
			while(warr.next()){
				if(warr.getString("warr_seq").equals(warr_seq[i])){
					break;
				}
			}
			warrDao.item("doc_name", warr.getString("doc_name"));
			warrDao.item("file_path", warr.getString("file_path"));
			warrDao.item("file_name", warr.getString("file_name"));
			warrDao.item("file_ext", warr.getString("file_ext"));
			warrDao.item("file_size", warr.getString("file_size"));
		}
		
		warrDao.item("reg_id", auth.getString("_USER_ID"));
		warrDao.item("reg_date", u.getTimeString());
		warrDao.item("status", "30");
		db.setCommand(warrDao.getInsertQuery(), warrDao.record);
	}

	//구비서류
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
		
		if(rfile_attch_type[i].equals("2")){//직접첨부 인경우
			rfile_cust = new DataObject("tcb_rfile_cust");
			rfile_cust.item("cont_no", cont_no);
			rfile_cust.item("cont_chasu", cont_chasu);
			rfile_cust.item("member_no", _member_no);
			rfile_cust.item("rfile_seq", rfile_seq[i]);
			File file = f.saveFileTime("rfile_"+rfile_seq[i]);
			rfile_cust.item("file_path", fileDir);
			rfile_cust.item("file_name", file.getName());
			rfile_cust.item("file_ext", u.getFileExt(file.getName()));
			rfile_cust.item("file_size", file.length());
			rfile_cust.item("reg_gubun", "20");
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

	ContractDao cont2 = new ContractDao();
	cont2.item("cont_hash", file_hash);
	db.setCommand(cont2.getUpdateQuery("cont_no= '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), cont2.record);

	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장 하였습니다.","offcont_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.offcont_modify");
p.setVar("menu_cd","000059");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000059", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("cont", cont);
p.setVar("template", template);
p.setLoop("sign_template", signTemplate);
p.setLoop("agreeTemplate", agreeTemplate);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("warr", warr);
p.setLoop("rfile", rfile);
p.setVar("techcross", bIsTechcross);
p.setLoop("code_warr_type", u.arr2loop(code_warr_type));
p.setLoop("code_warr_office", u.arr2loop(code_office));
p.setLoop("code_vat_type", u.arr2loop(code_vat_type));
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>