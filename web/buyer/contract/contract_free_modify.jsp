<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

//서비스 이용 기간 체크
DataObject useinfoDao = new DataObject("tcb_useinfo");
DataSet useinfo = useinfoDao.find("member_no='"+_member_no+"' and usestartday <='"+u.getTimeString("yyyyMMdd")+"' and useendday>='"+u.getTimeString("yyyyMMdd")+"' ");
if( !useinfo.next() )
{
	u.jsError("서비스 이용기간이 종료 되었습니다.\\n\\n나이스다큐 고객센터[02-788-9097]에 문의하세요.");
	return;
}

Security	security	=	new	Security();
String fileDir = "";

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_vat_type = {"1=>VAT별도","2=>VAT포함","3=>VAT미선택"};

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("사용자 정보가 존재 하지 않습니다.");
	return;
}

//사용자 계약번호 자동 설정 여부
boolean bAutoContUserNo = u.inArray(_member_no, new String[]{"20130500019","20121203661","20130400011","20130400010","20130400009","20130400008"}); // 그루폰, 한국쓰리엠
// 카카오는 자유서식에서 추가 정보를 입력할 수 있는 기능이 있음
boolean bIsKakao = u.inArray(_member_no, new String[]{"20130900194","20181201176"});
//테크로스 워터앤에너지,테크로스환경서비스 는 자유서식에서 vat 포함여부 기능
boolean bIsTechcross = u.inArray(_member_no, new String[]{"20160401012","20180203437"});


ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
	" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' "
	," tcb_contmaster.* "
	 +" ,(select max(user_name) from tcb_person where member_no = tcb_contmaster.member_no and user_id = tcb_contmaster.reg_id ) writer_name "
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
if(_member_no.equals("20150600110"))//티알엔 조회 URL
	cont.put("cont_url", "http://"+request.getServerName()+"/web/buyer/contract/cin.jsp?key="+u.aseEnc(cont_no+cont_chasu));

//프로젝트관리 사용시 //하이엔텍 사용 
if(!cont.getString("project_seq").equals("")){
	cont.put("view_project", true);
	DataObject projectDao = new DataObject("tcb_project");
	DataSet project  = projectDao.find(" member_no = '"+_member_no+"' and project_seq = '"+cont.getString("project_seq")+"' ");
	if(project.next()){
		cont.put("project_name", project.getString("project_name"));
		cont.put("project_cd", project.getString("project_cd"));
		cont.put("btn_select_project", cont_chasu.equals("0"));//최초 계약인 경우만 선택 가능 하도록 한다.
	}
}


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
while(agreeTemplate.next()){
    agreeTemplate.put("cont_no", u.aseEnc(agreeTemplate.getString("cont_no")));
    agreeTemplate.put("is_cust", agreeTemplate.getString("agree_cd").equals("0"));
	if(agreeTemplate.getString("agree_seq").equals("1")){  
		btnSend = agreeTemplate.getString("agree_cd").equals("0");// 다음 결재 순서자가 거래처면 전송 가능	
	}
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

// 구비서류 조회
DataObject rfileDao = new DataObject("tcb_rfile");
//rfileDao.setDebug(out);
DataSet rfile = rfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","*", "rfile_seq asc");
while(rfile.next()){
    rfile.put("cont_no", u.aseEnc(rfile.getString("cont_no")));
	rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
}

f.addElement("cont_name", cont.getString("cont_name"), "hname:'계약명', required:'Y'");
f.addElement("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")), "hname:'계약일자', required:'Y'");
f.addElement("cont_userno", cont.getString("cont_userno"), "hname:'계약번호', maxbyte:'40'");
f.addElement("cont_sdate", u.getTimeString("yyyy-MM-dd",cont.getString("cont_sdate")), "hname:'계약기간'");
f.addElement("cont_edate", u.getTimeString("yyyy-MM-dd",cont.getString("cont_edate")), "hname:'계약기간'");
if(!cont.getString("cont_total").equals("")){
	f.addElement("cont_total", u.numberFormat(cont.getDouble("cont_total"), 0), "hname:'계약금액'");
	if(bIsTechcross){
		f.addElement("cont_etc2", cont.getString("cont_etc2"), "hname:'VAT유형', required:'Y'");
	} 
}else{
	f.addElement("cont_total", null, "hname:'계약금액'");
	if(bIsTechcross){
		f.addElement("cont_etc2", null, "hname:'VAT유형'");
	} 
}
if(!member.getString("src_depth").equals(""))
	f.addElement("src_cd", cont.getString("src_cd"), "hname:'소싱그룹'");

if(bIsKakao) {
	f.addElement("cont_etc1", cont.getString("cont_etc1"), "hname:'수익쉐어', maxbyte:'255'");
	f.addElement("cont_etc2", cont.getString("cont_etc2"), "hname:'양도/종료'");
	f.addElement("cont_etc3", cont.getString("cont_etc3"), "hname:'기타사항', maxbyte:'255'");
}  


if(!member.getString("src_depth").equals(""))
	f.addElement("src_cd", null, "hname:'소싱그룹'");

if(useinfo.getString("stampyn").equals("Y")){
	f.addElement("stamp_type", cont.getString("stamp_type"), "hname:'인지세 납부 대상', required:'Y'");
}

if(u.isPost()&&f.validate()){
	//계약서 저장
	contDao = new ContractDao();

	String cont_userno = "";
	if(bAutoContUserNo)  // 그루폰의 경우는 계약관리번호를 사용자 계약번호로 셋팅
		cont_userno = cont_no + "-" + cont_chasu;
	else
		cont_userno = f.get("cont_userno");


	DB db = new DB();
	//db.setDebug(out);
	contDao = new ContractDao();

	contDao.item("member_no", _member_no);
	//contDao.item("field_seq", auth.getString("_FIELD_SEQ"));   -- 최초 작성자 정보가 변경되지 않도록 주석처리
	contDao.item("cont_userno", cont_userno);
	contDao.item("cont_name", f.get("cont_name"));
	contDao.item("cont_date", f.get("cont_date").replaceAll("-",""));
	contDao.item("cont_sdate", f.get("cont_sdate").replaceAll("-",""));
	contDao.item("cont_edate", f.get("cont_edate").replaceAll("-",""));
	contDao.item("cont_total", f.get("cont_total").replaceAll(",", ""));
	contDao.item("cont_html", f.get("cont_html"));
	contDao.item("reg_date", u.getTimeString());
	contDao.item("true_random", u.strpad(u.getRandInt(0,99999)+"",5,"0"));
	// contDao.item("reg_id", auth.getString("_USER_ID"));
	contDao.item("status", "10");
	contDao.item("stamp_type", f.get("stamp_type"));
	contDao.item("src_cd", f.get("src_cd"));
	contDao.item("project_seq", f.get("project_seq"));
	if(bIsKakao) {
		contDao.item("cont_etc1", f.get("cont_etc1"));
		contDao.item("cont_etc2", f.get("cont_etc2"));
		contDao.item("cont_etc3", f.get("cont_etc3"));
	}else if(bIsTechcross){
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
	
	
	// 내부 결재 서식 저장
	String[] agree_seq = f.getArr("agree_seq");
	String agree_field_seqs = "";
	String agree_person_ids = "";
	int agree_cnt = agree_seq == null? 0: agree_seq.length;
	if(agree_cnt > 0)
	{
		db.setCommand("delete from tcb_cont_agree where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
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
			cont_agree.item("agree_cd", agree_cd[i]);	// 결재구분코드(0:업체서명전, 1:업체서명후)
			db.setCommand(cont_agree.getInsertQuery(), cont_agree.record);
			agree_field_seqs += agree_field_seq[i] + "|";
			agree_person_ids += agree_person_id[i] + "|";
		}
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
	int cfile_seq_real = 1;
	int cfile_cnt = cfile_seq==null? 0 : cfile_seq.length;
	for(int i = 0 ;i < cfile_cnt; i ++){
		String cfile_name = "";
		cfileDao = new DataObject("tcb_cfile");
		cfileDao.item("cont_no", cont_no);
		cfileDao.item("cont_chasu", cont_chasu);
		cfileDao.item("cfile_seq", cfile_seq_real++);
		cfileDao.item("doc_name", cfile_doc_name[i]);
		cfileDao.item("file_path", fileDir);
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
			u.jsError("저장에 실패 하였습니다.");
			return;
		}
		cfileDao.item("auto_yn", "N");
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
		file_hash +="|"+contDao.getHash("file.path.bcont_pdf",fileDir+cfile_name);
	}
	
	//보증서
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

	//구비서류
	db.setCommand("delete from tcb_rfile where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
	String[] attch_yn = f.getArr("attch_yn");
	String[] rfile_doc_name = f.getArr("rfile_doc_name");
	int rfile_cnt = rfile_doc_name == null? 0: rfile_doc_name.length;
	for(int i=0 ; i < rfile_cnt; i ++){
		rfileDao = new DataObject("tcb_rfile");
		rfileDao.item("cont_no", cont_no);
		rfileDao.item("cont_chasu", cont_chasu);
		rfileDao.item("rfile_seq", i+1);
		rfileDao.item("attch_yn", attch_yn[i].equals("Y")?"Y":"N");
		rfileDao.item("doc_name", rfile_doc_name[i]);
		db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);
	}

	// 인지세
	if(useinfo.getString("stampyn").equals("Y")){
		db.setCommand("delete from tcb_stamp where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
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
	if(agree_cnt > 0){
		cont2.item("agree_field_seqs", agree_field_seqs);
		cont2.item("agree_person_ids", agree_person_ids);
	}
	db.setCommand(cont2.getUpdateQuery("cont_no= '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), cont2.record);

	/* 계약로그 START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 수정",  "", "10","20");
	/* 계약로그 END*/

	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장 하였습니다.","contract_free_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_free_modify");
p.setVar("menu_cd","000059");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000059", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("cont", cont);
p.setVar("template", template);
p.setLoop("sign_template", signTemplate);
p.setLoop("agreeTemplate", agreeTemplate);
p.setVar("btnSend", btnSend);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("warr", warr);
p.setLoop("rfile", rfile);
p.setLoop("code_warr", u.arr2loop(code_warr));
p.setLoop("code_vat_type", u.arr2loop(code_vat_type));
p.setVar("show_cont_user_no", !bAutoContUserNo);  // 그루폰, 한국쓰리엠의 경우는 계약관리번호를 사용자 계약번호로 셋팅하므로 입력보여지지 않도록
p.setVar("kakao", bIsKakao);  
p.setVar("techcross", bIsTechcross);
p.setVar("stamp_yn", useinfo.getString("stampyn").equals("Y")?true:false);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>
