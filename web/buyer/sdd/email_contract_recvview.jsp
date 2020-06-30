<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="../contract/include_cont_func.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
String email_random = u.request("email_random");
if(cont_no.equals("")||cont_chasu.equals("")||email_random.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

//인증 확인 처리
String c_cookei_info = u.getCookie("email_contract_recvview");
u.sp(c_cookei_info);
if(c_cookei_info.split("-").length != 3){
	u.redirect("email_callback.jsp?"+u.getQueryString());
	return;
}
String c_cont_no = u.aseDec(c_cookei_info.split("-")[0]);
String c_cont_chasu = c_cookei_info.split("-")[1];
String c_email_random = c_cookei_info.split("-")[2];
if((!cont_no.equals(c_cont_no))||!cont_chasu.equals(c_cont_chasu)||!email_random.equals(c_email_random)){
	u.redirect("email_callback.jsp?"+u.getQueryString());
	return;
}

boolean sign_able = false;
String cust_type = "";// 받는 사람이 갑인 경우 01 을인 경우 02
boolean gap_yn = false;// 로그인한 업체가갑인지 여부 cust_type == "01" 이면 갑이다.
String file_path = "";

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_change_gubun = codeDao.getCodeArray("M010");

boolean person_yn = false;
String jumin_no = "";

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'  and status in ('20','21','30','40','41','50') ",
"tcb_contmaster.*"
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null  and sign_seq > 10 ) chain_unsign_cnt "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null and sign_seq <= 10 ) unsign_cnt "
+" ,(select member_name from tcb_member where member_no = tcb_contmaster.mod_req_member_no ) mod_req_name "
+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,3) = substr(tcb_contmaster.src_cd,0,3) and depth='1') l_src_nm "
+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,6) = substr(tcb_contmaster.src_cd,0,6) and depth='2') m_src_nm "
+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and src_cd = tcb_contmaster.src_cd and depth='3') s_src_nm "
);
if(!cont.next()){
	u.jsError("계약정보가 존재 하지 않습니다.");
	return;
}


cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
cont.put("cont_date",u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
cont.put("change_gubun_str", u.getItem(cont.getString("change_gubun"), code_change_gubun)+"("+cont_chasu+"차)");
if(!cont.getString("src_cd").equals(""))
cont.put("src_nm", cont.getString("l_src_nm")+" > "+cont.getString("m_src_nm")+" > "+cont.getString("s_src_nm"));



DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+cont.getString("member_no")+"' ");
if(!member.next()){
	u.jsError("작성업체 정보가 존재 하지 않습니다.");
	return;
}


// 추가 계약서 조회
DataObject contSubDao = new DataObject("tcb_cont_sub");
DataSet contSub = contSubDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and (gubun <> '40' or (gubun = '40' and option_yn in ('A','Y')))");

while(contSub.next()){
	contSub.put("hidden", u.inArray(contSub.getString("gubun"), new String[]{"20","30"}));
	contSub.put("template_name", contSub.getString("cont_sub_name"));
	contSub.put("template_cd", cont.getString("template_cd"));
	contSub.put("chk", contSub.getString("chk_yn").equals("Y")?"checked":"");
}

// 서식정보 조회
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" status > 0 and template_cd ='"+cont.getString("template_cd")+"'");
if(template.next()){
	template.put("recv_write", template.getString("writer_type").trim().equals("Y"));
	template.put("need_attach_yn", template.getString("need_attach_yn").trim().equals("Y"));
}

DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","*","sign_seq asc");

// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust a, tcb_member b");
DataSet cust = custDao.find(
		" a.member_no=b.member_no and cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq <= 10"
		,"a.*, b.member_gubun, (select cust_type from tcb_cont_sign where cont_no = a.cont_no and cont_chasu=a.cont_chasu and sign_seq = a.sign_seq) cust_type"
		,"a.display_seq asc"
		);
if(cust.size()<1){
	u.jsError("계약업체 정보가 존재 하지 않습니다.");
	return;
}

String _member_no = "";
String _vendcd = "";
String _member_name = "";
String _member_gubun = "";
String _user_name = "";
Security security = new Security();
while(cust.next()){
    cust.put("cont_no", u.aseEnc(cust.getString("cont_no")));
	if(cust.getString("email_random").equals(email_random)){
		_member_no = cust.getString("member_no");
		_vendcd = cust.getString("vendcd");
		_member_name = cust.getString("member_name");
		_member_gubun = cust.getString("member_gubun");
		_user_name = cust.getString("member_gubun");
		if(!cust.getString("jumin_no").equals("")){
		  	jumin_no = security.AESdecrypt(cust.getString("jumin_no"));
			if(jumin_no.length()==7) // 7401031
				jumin_no = jumin_no.substring(0,6);
			person_yn = true;
		}else{
		  	person_yn = false;
		}
		if(!cust.getString("sign_date").equals("")){
			cont.put("sign_complete", "true");
		}
	}

	if(!template.getString("doc_type").equals("2")){//수신만 서명 하는 경우
		cust.put("sign_display", true);
	}else{
		cust.put("sign_display", !cust.getString("sign_seq").equals("1"));
	}

	if(cust.getString("member_no").equals(_member_no)&&cust.getString("cust_type").equals("01"))gap_yn = true;
	cust.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust.getString("sign_date")));
	if(cust.getString("member_no").equals(_member_no)){
		cust_type = cust.getString("cust_type");
		if(cust.getString("sign_dn").equals("")){
			sign_able = true;
		}
	}
}

// 연대보증 업체
DataSet cust_chain = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq > 10","a.*");
while(cust_chain.next()){
	cust_chain.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust_chain.getString("sign_date")));
}

//계약서류 조회
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and (auto_type is null or auto_type <> '3') "); // 작성업체만 보는 계약 파일 제외
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	//if(cfile.getString("cfile_seq").equals("1")&&cfile.getString("auto_yn").equals("Y")){
	if(cfile.getString("cfile_seq").equals("1")){  // 자유서식에서 구비서류 저장시 오류나서 auto_yn 삭제
		file_path = cfile.getString("file_path");
	}
	if(cfile.getString("auto_yn").equals("Y")){
		if(cfile.getString("auto_type").equals("1")){
			cfile.put("auto_str","자동첨부");
		}
		if(cfile.getString("auto_type").equals("2")){
			cfile.put("auto_str","필수첨부");
		}
		if(cfile.getString("auto_type").equals("")){
			cfile.put("auto_str","자동생성");
			cfile.put("auto_type","0");
		}
	}else{
		cfile.put("auto_str", "직접첨부");
	}
	cfile.put("auto_class", cfile.getString("auto_yn").equals("Y")?"caution-text":"");
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	if(cfile.getString("file_ext").toLowerCase().equals("pdf")){
		cfile.put("btn_name", "조회(인쇄)");
		cfile.put("down_script","contPdfViewer('"+u.request("cont_no")+"','"+cont_chasu+"','"+cfile.getString("cfile_seq")+"')");
		cfile.put("auto_str", "<a href=\"javascript:contPdfViewerp('"+u.request("cont_no")+"','"+cont_chasu+"','"+cfile.getString("cfile_seq")+"');\">"+ cfile.getString("auto_str") +"</a>");
	}else{
		cfile.put("btn_name", "다운로드");
		cfile.put("down_script","filedown('file.path.bcont_pdf','"+cfile.getString("file_path")+cfile.getString("file_name")+"','"+cfile.getString("doc_name")+"."+cfile.getString("file_ext")+"')");
	}
}

//인지세 정보조회
//팀장님 지시 사항 으로 진행중인 경우 수신처 인지세만 나오도록 한다. 20160616 skl
DataObject stampDao = new DataObject("tcb_stamp ts left join tcb_member tm on ts.member_no=tm.member_no");
DataSet stamp = stampDao.find(" ts.cont_no = '"+cont_no+"' and ts.cont_chasu = '"+cont_chasu+"' and ts.member_no = '"+_member_no+"'  ", "ts.*, tm.member_name, tm.vendcd");
while(stamp.next()){
	stamp.put("cont_no", u.aseEnc(stamp.getString("cont_no")));
	stamp.put("stamp_money", u.numberFormat(stamp.getDouble("stamp_money"), 0));
	stamp.put("issue_date", u.getTimeString("yyyy-MM-dd", stamp.getString("issue_date")));
	stamp.put("vendcd", u.getBizNo(stamp.getString("vendcd")));
	stamp.put("recv_stamp", stamp.getString("member_no").equals(_member_no));
}


//보증정보조회
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
	warr.put("warr_seq", warr.getString("warr_seq"));
	
	if(!warr.getString("warr_type").equals("하자이행")){
		if(warr.getString("warr_no").equals("")){   // 보증서류 미등록시
			warr.put("warr_write_value", true);
		}else{										// 보증서류 등록시
			warr.put("warr_write_value", false);
		}
	}else{
		warr.put("warr_write_value", false);
	}
}

// 업체별 구비 서류 조회
DataObject rfileDao = new DataObject("tcb_rfile");


String rfile_query =
" select a.*  "
+"   from tcb_cust a, tcb_cont_sign b "
+"  where a.cont_no= b.cont_no  "
+"    and a.cont_chasu = b.cont_chasu "
+"    and a.sign_seq = b.sign_seq  "
+"    and a.cont_no = '"+cont_no+"' "
+"    and a.cont_chasu = '"+cont_chasu+"' "
+"    and b.cust_type <> '01' ";
if(!cust_type.equals("01")) rfile_query += " and a.member_no ='"+_member_no+"'";
rfile_query += "order by a.cont_no asc, a.cont_chasu asc, a.sign_seq asc";

//custDao.setDebug(out);
DataSet rfile_cust = custDao.query(rfile_query);
while(rfile_cust.next()){
    rfile_cust.put("cont_no", u.aseEnc(rfile_cust.getString("cont_no")));
	rfile_cust.put("attch_area", rfile_cust.getString("member_no").equals(_member_no));

	String rfileQuery = "";
	if(rfile_cust.getString("sign_seq").equals("2")){
		rfileQuery = "  select a.attch_yn, a.doc_name, a.rfile_seq, a.allow_ext, b.file_path, b.file_name, b.file_ext, b.file_size, b.member_no "
				+"    from tcb_rfile a  "
				+"    left outer join  tcb_rfile_cust b "
				+"      on a.cont_no = b.cont_no  "
				+"     and a.rfile_seq = b.rfile_seq  "
				+"     and a.cont_chasu = b. cont_chasu "
				+"     and b.member_no in ('"+rfile_cust.getString("member_no")+"' ,"+cont.getString("member_no")+")"
				+"   where  a.cont_no = '"+cont_no+"'  "
				+"     and a.cont_chasu = '"+cont_chasu+"' " ;
	}else{
		rfileQuery = "  select a.attch_yn, a.doc_name, a.rfile_seq, a.allow_ext, b.file_path, b.file_name, b.file_ext, b.file_size, b.member_no "
				+"    from tcb_rfile a  "
				+"    left outer join  tcb_rfile_cust b "
				+"      on a.cont_no = b.cont_no  "
				+"     and a.rfile_seq = b.rfile_seq  "
				+"     and a.cont_chasu = b. cont_chasu "
				+"     and b.member_no = '"+rfile_cust.getString("member_no")+"' "
				+"   where  a.cont_no = '"+cont_no+"'  "
				+"     and a.cont_chasu = '"+cont_chasu+"' " ;
	}

	//rfileDao.setDebug(out);
	DataSet rfile = rfileDao.query(rfileQuery);
	while(rfile.next()){
		rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
		rfile.put("file_size", u.getFileSize(rfile.getLong("file_size")));
		rfile.put("gap", cont.getString("member_no").equals(rfile.getString("member_no"))&&rfile_cust.getString("sign_seq").equals("2"));
	}
	rfile_cust.put(".rfile",rfile);
}


/* 계약로그 START*/
if(sign_able) {
	ContBLogDao logDao = new ContBLogDao();
	int view_cnt= logDao.findCount(
			 "     cont_no = '"+cont_no+"' "
			+" and cont_chasu = '"+cont_chasu+"' " 
			+" and member_no = '"+_member_no+"' "
			+" and log_seq > (select max(log_seq) from tcb_cont_log where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"' and cont_status = '20' )"
			);
	if(view_cnt < 1){
		/*최종로그가 계약서전송이고 회원번호가 발신업체 회원 번호면 조회 일시 로그 입력*/
		logDao = new ContBLogDao();
		logDao.setInsert(cont_no, String.valueOf(cont_chasu), _member_no, "1", cust.getString("boss_name"), request.getRemoteAddr(), "전자문서 조회", "", cont.getString("status"),"20");
	}
}
/* 계약로그 END*/

if(u.isPost()&&f.validate()){
	//서명 검증
	String sign_dn = f.get("sign_dn");
	String sign_data = f.get("sign_data");

	Crosscert cert = new Crosscert();
	if (cert.chkSignVerify(sign_data).equals("SIGN_ERROR")) {
		u.jsError("서명검증에 실패 하였습니다.");
		return;
	}
	if (!cert.getDn().equals(sign_dn)) {
		u.jsError("서명검증 DN값이 일지 하지 않습니다.");
		return;
	}

	boolean sms = false;
	SmsDao smsDao= new SmsDao();
	int nagreeCnt = 0 ;
	//서명 저장
	DB db = new DB();
	//db.setDebug(out);
	custDao = new DataObject("tcb_cust");
	custDao.item("sign_dn", sign_dn);
	custDao.item("sign_data", sign_data);
	custDao.item("sign_date", u.getTimeString());
	db.setCommand( custDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+_member_no+"'"),custDao.record);

	String status = cont.getString("status");
	if((cont.getInt("unsign_cnt")-1)==1){// 작성자만 계약서를 서명 안한 경우 계약상태를 서명 대기로 변경 한다.
		DataObject agreeDao = new DataObject("tcb_cont_agree");
		nagreeCnt = agreeDao.findCount(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd = '2'");  // 업체 서명 후 승인자들 수
		
		if(cont.getInt("chain_unsign_cnt")==0){// 미서명 연대 보증인 없는 경우
			sms = true;
			if(nagreeCnt > 1){
				status = "21";  // 서명자 포함 2명이상이면 승인대기
			}else{
				if(template.getString("doc_type").equals("2")){ // 업체서명 후 계약완료
					status = "50";  // 서명완료
				}else{
					status = "30";  // 서명대기
				}
			}
		}
		
		//계약기간구하기
		String cont_year = f.get("cont_year");
		String cont_month = f.get("cont_month");
		String cont_day = f.get("cont_day");
		String cont_date = "";
		if(cont_year.length()==4 &&!cont_month.equals("")&&!cont_day.equals("")){
			cont_date = cont_year+u.strrpad(cont_month,2,"0")+u.strrpad(cont_day,2,"0");
		}

		contDao = new ContractDao();
		if(!cont_date.equals("")){
			contDao.item("cont_date",cont_date);
		}
		contDao.item("mod_req_date","");
		contDao.item("mod_req_member_no","");
		contDao.item("mod_req_reason","");
		contDao.item("status", status);
		db.setCommand(contDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' "), contDao.record);

		// 내부 결제자가 있는 경우
		if(nagreeCnt>0){
			// 내부 결재 데이터 중 업체서명 후 데이터 초기화
			agreeDao = new DataObject("tcb_cont_agree");
			agreeDao.item("ag_md_date", "");
			agreeDao.item("mod_reason", "");
			agreeDao.item("r_agree_person_id","");
			agreeDao.item("r_agree_person_name", "");
			db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd = '2' "),agreeDao.record);

			// 내부 결재 데이터 중 업체서명 값 입력
			agreeDao = new DataObject("tcb_cont_agree");
			agreeDao.item("ag_md_date", u.getTimeString());
			agreeDao.item("mod_reason", "");
			agreeDao.item("r_agree_person_id", "");
			agreeDao.item("r_agree_person_name", "");
			db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd = '0' "),agreeDao.record);
		}
	}
	
	//완료인 경우 결제 정보 입력
	if(status.equals("50")){//완료인 경우 결제정보 입력
		DataObject useinfoDao = new DataObject("tcb_useinfo");
		DataSet useInfo = useinfoDao.find("member_no='"+cont.getString("member_no")+"'");

		if(!useInfo.next()){
			u.jsError("작성업체 요금제가 존재 하지 않습니다. 고객센터[02-788-9097]에 문의하세요");
			return;
		}

		// 협력업체 서명시 바로 완료이고 후불이면...  당연히 원사업자가 대납.
		// 후불이 아니면 이미 결제 후 넘어온 사항이니 완료 처리만
		if(useInfo.getString("paytypecd").equals("50")){ // 후불
			DataObject useinfoaddDao = new DataObject("tcb_useinfo_add");
			DataSet useInfoAdd = useinfoaddDao.find("template_cd='"+cont.getString("template_cd")+"' and member_no='"+cont.getString("member_no")+"'");

			String payContName = cont.getString("cont_name");
			int iPayAmount = 0;  //결제 금액
			int iVatAmount = 0;

			// 양식별로 지정된 금액이 있으면 수급업체 금액 + 원사업자 금액
			if ( useInfoAdd.next() ){ // 양식별로 요금 부과할게 있다면
				iPayAmount = useInfoAdd.getInt("recpmoneyamt");
				if(useInfoAdd.getString("insteadyn").equals("Y")){  // 수급업체 대납인경우
					iPayAmount += useInfoAdd.getInt("suppmoneyamt");
					payContName += "(대납포함)";
				}
			}else{ // 없으면 기본설정값 따라감.
				iPayAmount = useInfo.getInt("recpmoneyamt");
				if(useInfo.getString("insteadyn").equals("Y")){  // 수급업체꺼 대납일 경우
					iPayAmount += useInfo.getInt("suppmoneyamt");
					payContName += "(대납포함)";
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
		
	
	/* 계약로그 START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  _member_no, "1", _user_name, request.getRemoteAddr(), "전자서명 완료",  "", status,"10");
	/* 계약로그 END*/
	
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	
	
	// sms 및 메일 발송 처리
	if(sms){
		if(nagreeCnt>0){//결제 라인 있는 경우
			// 다음 내부 결재 담당자에게 거래처 서명완료 알림.
			DataObject agreeDao = new DataObject("tcb_cont_agree");
			DataSet agree = agreeDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd='2' and length(agree_person_id) > 0","*"," agree_seq asc"); // 파트너 서명후 검토자가 있고 그 검토자가 부서가 아닌 1명인 경우 처음 검토자에게 검토 메일 전송
			if(agree.next()){
				// 이메일 알림.

				DataObject personDao = new DataObject("tcb_person");
				DataSet agree_person = personDao.find("user_id='"+agree.getString("agree_person_id")+"'");	// 검토자 정보
				if(agree_person.next()){
					if(!agree_person.getString("email").equals("holic123@ktmns.com")){ // kt m&s 서명자 김연주 사원 안가도록... 너무 많이 오기 때문
						p.clear();
						DataSet mailInfo = new DataSet();
						mailInfo.addRow();
						mailInfo.put("cust_name", _member_name);
						mailInfo.put("cont_name", cont.getString("cont_name"));
						mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
						p.setVar("info", mailInfo);
						p.setVar("server_name", request.getServerName());
						p.setVar("return_url", "web/buyer/");
						String mail_body = p.fetch("../html/mail/cont_send_mail.html");
						u.mail(agree_person.getString("email"), "[계약 서명 알림] \"" +  _member_name + "\" 업체가 전자계약서 서명을 완료하였습니다.", p.fetch("mail/cont_cust_sign.html"));
						smsDao.sendSMS("buyer", agree_person.getString("hp1"), agree_person.getString("hp2"), agree_person.getString("hp3"), _member_name+" 에서 전자계약서 서명완료 - 나이스다큐(일반기업용)");
					}
				}
			}
		}else{//결제 라인 없는 경우
			if(!template.getString("doc_type").equals("2")){
				//작성자 email
				custDao = new DataObject("tcb_cust");
				String email = custDao.getOne("select email from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"'  ");
				if(!email.equals("")){
					p.clear();
					DataSet mailInfo = new DataSet();
					mailInfo.addRow();
					mailInfo.put("cust_name", _member_name);
					mailInfo.put("cont_name", cont.getString("cont_name"));
					mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
					p.setVar("info", mailInfo);
					p.setVar("server_name", request.getServerName());
					p.setVar("return_url", "web/buyer/");
					String mail_body = p.fetch("../html/mail/cont_send_mail.html");
					u.mail(email, "[계약 서명 알림] \"" +  _member_name + "\" 업체가 전자계약서 서명을 완료하였습니다.", p.fetch("mail/cont_cust_sign.html"));
				}
			}
			// sms 전송
			cust.first();
			while(cust.next()){
				if(cust.getString("member_no").equals(cont.getString("member_no"))){
					smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), _member_name+" 에서 전자계약서 서명완료 - 나이스다큐(일반기업용)");
				}
			}
		}
	}

	//계약서 자동서명
	String[] arr_auto_sign = {
			"20170501348|2018242"// 아워홈 식재 공급계약서 >공인인증서명
			};
	if(u.inArray(cont.getString("member_no")+"|"+cont.getString("template_cd"), arr_auto_sign) ) {
		DataSet result = contAutoSign(cont_no, cont_chasu, request.getRemoteAddr());
		if(!result.getString("succ_yn").equals("Y")){
			u.sp("계약서 자동서명 실패!!!\npage:email_contract_recvview.jsp\ncont_no:"+cont_no+"-"+cont_chasu);
			u.mail("nicedocu@nicednr.co.kr","계약서 자동서명 실패!!!", " 계약서 자동서명실패!!!\npage:email_contract_recvview.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		}
	}

	u.jsAlertReplace("전자서명이 완료 되었습니다.","email_contract_recvview.jsp?"+u.getQueryString());
	return;
}

p.setLayout("email_contract");
p.setDebug(out);
p.setBody("sdd.email_contract_recvview");
p.setVar("change_cont", Integer.parseInt(cont_chasu)>0);
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("person_yn", person_yn);
p.setVar("gap_yn", gap_yn);
p.setVar("cont", cont);
if(u.inArray(cont.getString("status"), new String[]{"20","21","30"})){
	p.setVar("status_name", sign_able?"서명요청":"서명진행중");
}
if(cont.getString("status").equals("20")){
	p.setVar("modify_able", true);
}
if(cont.getString("status").equals("40")){
	sign_able = false;
	p.setVar("status_name", "수정요청");
}
if(cont.getString("status").equals("41")){
	sign_able = true;
	p.setVar("status_name", "반려");
}
boolean cont_ing =  u.inArray(cont.getString("status"),new String[]{"20","30","40","41"});
p.setVar("cont_ing", cont_ing);
p.setVar("sign_able", sign_able);
p.setVar("template", template);
p.setVar("warr", warr);
p.setLoop("contSub", contSub);
p.setLoop("sign_template", signTemplate);
p.setVar("jumin_no", jumin_no);
p.setVar("_member_no", _member_no);
p.setVar("_vendcd", _vendcd);
p.setLoop("cust", cust);
if(cust_chain.size()>0) p.setLoop("cust_chain", cust_chain);
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