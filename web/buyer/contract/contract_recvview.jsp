<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ include file="include_cont_func.jsp" %>
<%@ include file="include_cont_push.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}


boolean isNeedTax = false;// 인지세가 있어야만 계약서 서명 가능
boolean isNeedWarr = false;// 보증서류가 있어야만 계약서 서명 가능
boolean sign_able = false;
String cust_type = "";// 받는 사람이 갑인 경우 01 을인 경우 02
boolean gap_yn = false;// 로그인한 업체가갑인지 여부 cust_type == "01" 이면 갑이다.
String file_path = "";
String pay_yn = "";

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_change_gubun = codeDao.getCodeArray("M010");
String[] code_auto_type = {"=>자동생성","1=>자동첨부","2=>필수첨부","3=>내부용"};

boolean person_yn = false;
String jumin_no = "";

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
		" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'  and status in ('20','21','30','40','41') ",
		"tcb_contmaster.*"
				+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null  and sign_seq > 10 ) chain_unsign_cnt "
				+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is not null ) sign_cnt "
				+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null and sign_seq <= 10 ) unsign_cnt "
				+" ,(select member_name from tcb_member where member_no = tcb_contmaster.mod_req_member_no ) mod_req_name "
);
if(!cont.next()){
	u.jsError("계약정보가 존재 하지 않습니다.");
	return;
}

isNeedTax = u.inArray(cont.getString("member_no"), new String[]{"20151101243","20160800950","20191200612"});  // NH개발, 건국유업, 메트로9호선
isNeedWarr = u.inArray(cont.getString("member_no"), new String[]{"20151101243","20191200612"});  // NH개발, 메트로9호선

cont.put("dong_pop", "20120500023".equals(cont.getString("member_no"))?true:false);	// 2019.07.01시행된 동희오토 수수료 안내 팝업
cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
cont.put("cont_date",u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
cont.put("change_gubun_str", u.getItem(cont.getString("change_gubun"), code_change_gubun)+"("+cont_chasu+"차)");



DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+cont.getString("member_no")+"' ");
if(!member.next()){
	u.jsError("작성업체 정보가 존재 하지 않습니다.");
	return;
}


// 추가 계약서 조회
DataObject contSubDao = new DataObject("tcb_cont_sub"); 
DataSet contSub = contSubDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and (gubun not in ('40','10') or (gubun = '40' and option_yn in ('A','Y')) or (gubun = '10' and option_yn in ('A','Y')))");

while(contSub.next()){
	contSub.put("hidden", u.inArray(contSub.getString("gubun"), new String[]{"20","30"}));
	contSub.put("template_name", contSub.getString("cont_sub_name"));
	contSub.put("template_cd", cont.getString("template_cd"));
	contSub.put("chk", contSub.getString("chk_yn").equals("Y")?"checked":"");
}

// 서식정보 조회
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" template_cd ='"+cont.getString("template_cd")+"'");
if(!template.next()){
}
template.put("recv_write", template.getString("writer_type").trim().equals("Y"));// 수신업체 작성 가능 여부
template.put("need_attach_yn", template.getString("need_attach_yn").trim().equals("Y"));// 수신업체 구비서류 필수(경고창이 아닌 진짜)여부

DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","*","sign_seq asc");

// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust a");
DataSet cust = custDao.find(
		" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq <= 10"
		,"a.*, (select cust_type from tcb_cont_sign where cont_no = a.cont_no and cont_chasu=a.cont_chasu and sign_seq = a.sign_seq) cust_type"
		,"a.display_seq asc"
);
if(cust.size()<1){
	u.jsError("계약업체 정보가 존재 하지 않습니다.");
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
        cfile.put("auto_str", u.getItem(cfile.getString("auto_type"), code_auto_type));
        if(cfile.getString("auto_type").equals("")){
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
		rfileQuery = "  select a.attch_yn, a.doc_name, a.rfile_seq, a.allow_ext, a.sample_file_path, a.sample_file_name, b.file_path, b.file_name, b.file_ext, b.file_size, b.member_no "
				+"    from tcb_rfile a  "
				+"    left outer join  tcb_rfile_cust b "
				+"      on a.cont_no = b.cont_no  "
				+"     and a.rfile_seq = b.rfile_seq  "
				+"     and a.cont_chasu = b. cont_chasu "
				+"     and b.member_no in ('"+rfile_cust.getString("member_no")+"' ,'"+cont.getString("member_no")+"')"
				+"   where  a.cont_no = '"+cont_no+"'  "
				+"     and a.cont_chasu = '"+cont_chasu+"' " 
				+"   order by a.rfile_seq asc ";
	}else{
		rfileQuery = "  select a.attch_yn, a.doc_name, a.rfile_seq, a.allow_ext, a.sample_file_path, a.sample_file_name, b.file_path, b.file_name, b.file_ext, b.file_size, b.member_no "
				+"    from tcb_rfile a  "
				+"    left outer join  tcb_rfile_cust b "
				+"      on a.cont_no = b.cont_no  "
				+"     and a.rfile_seq = b.rfile_seq  "
				+"     and a.cont_chasu = b. cont_chasu "
				+"     and b.member_no = '"+rfile_cust.getString("member_no")+"' "
				+"   where  a.cont_no = '"+cont_no+"'  "
				+"     and a.cont_chasu = '"+cont_chasu+"' " 
				+"   order by a.rfile_seq asc ";
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
	if(view_cnt < 1){//전송이후로 내가 로그 정보에 없으면
		logDao = new ContBLogDao();
		logDao.setInsert(cont_no, String.valueOf(cont_chasu), _member_no, auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 조회", "", cont.getString("status"),"20");
	}
}
/* 계약로그 END*/


if(u.isPost()&&f.validate()){
	
	//서명 검증
	String sign_dn = f.get("sign_dn");
	String sign_data = f.get("sign_data");

	Crosscert crosscert = new Crosscert();
	crosscert.setEncoding("UTF-8");
	if (crosscert.chkSignVerify(sign_data).equals("SIGN_ERROR")){
		u.jsError("서명검증에 실패 하였습니다.");
		return;
	}
	if(!crosscert.getDn().equals(sign_dn)){
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

		contDao = new ContractDao();
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
			agreeDao.item("r_agree_person_id", auth.getString("_USER_ID"));
			agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
			db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd = '0' "),agreeDao.record);
			
		}
	}
	
	/* 계약로그 START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자서명 완료",  "", status,"10");
	/* 계약로그 END*/
	
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	
	

	if(cont.getString("template_cd").equals("2016112")){// 해피랜드 약정서는 SMS발송 안함
		sms = false;
	}

	if(u.inArray(cont.getString("template_cd"), new String[] {"2017021","2017023","2017024","2017025","2017048"})){ // 한수테크니컬 연봉계약서는 SMS 발송 안함
		sms = false;
	}

	// sms 및 메일 발송 처리
	if (sms) {
		if (nagreeCnt>0) { // 결제 라인 있는 경우
			// 다음 내부 결재 담당자에게 거래처 서명완료 알림.
			DataObject agreeDao = new DataObject("tcb_cont_agree");
			DataSet agree = agreeDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd='2' and length(agree_person_id) > 0","*"," agree_seq asc"); // 파트너 서명후 검토자가 있고 그 검토자가 부서가 아닌 1명인 경우 처음 검토자에게 검토 메일 전송
			if(agree.next()){
				// 이메일 알림.
				DataObject personDao = new DataObject("tcb_person");
				DataSet agree_person = personDao.find("user_id='"+agree.getString("agree_person_id")+"'");	// 검토자 정보
				if(agree_person.next()){
					p.clear();
					DataSet mailInfo = new DataSet();
					mailInfo.addRow();
					mailInfo.put("cust_name", auth.getString("_MEMBER_NAME"));
					mailInfo.put("cont_name", cont.getString("cont_name"));
					mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
					p.setVar("info", mailInfo);
					p.setVar("server_name", Config.getWebUrl());
					p.setVar("ret_url", "web/buyer/");
					String mail_body = p.fetch("../html/mail/cont_cust_sign.html");
					u.mail(agree_person.getString("email"), "[계약 서명 알림] \"" +  auth.getString("_MEMBER_NAME") + "\" 업체가 전자계약서 서명을 완료하였습니다.", mail_body);
					String subject = "농심 전자계약 안내";
					String message = "[전자계약][농심] 전자계약 안내\n"
							+ auth.getString("_MEMBER_NAME") + "에서 전자계약서 서명완료 - 농심 전자계약시스템";
					// smsDao.sendKakaoTalk
					// 서명요청(을>농심)
					smsDao.sendKakaoTalk(agree_person.getString("hp1"), agree_person.getString("hp2"), agree_person.getString("hp3"), "ESC-SD-0003", subject, message, message);
				}
			}
		} else { // 결제 라인 없는 경우
			if (!template.getString("doc_type").equals("2")) {
				//작성자 email
				custDao = new DataObject("tcb_cust");
				String email = custDao.getOne("select email from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"'  ");
				if (!email.equals("")) {
					p.clear();
					DataSet mailInfo = new DataSet();
					mailInfo.addRow();
					mailInfo.put("cust_name", auth.getString("_MEMBER_NAME"));
					mailInfo.put("cont_name", cont.getString("cont_name"));
					mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
					p.setVar("info", mailInfo);
					p.setVar("server_name", Config.getWebUrl());
					p.setVar("ret_url", "web/buyer/");
					String mail_body = p.fetch("../html/mail/cont_cust_sign.html");
					u.mail(email, "[계약 서명 알림] \"" +  auth.getString("_MEMBER_NAME") + "\" 업체가 전자계약서 서명을 완료하였습니다.", mail_body);
				}
			}
			// sms 전송
			cust.first();
			while (cust.next()) {
				if (cust.getString("member_no").equals(cont.getString("member_no"))) {
					String subject = "농심 전자계약 안내";
					String message = "[전자계약][농심] 전자계약 안내\n"
							+ auth.getString("_MEMBER_NAME") + "에서 전자계약서 서명완료 - 농심 전자계약시스템";
					// smsDao.sendKakaoTalk
					// 서명요청(을>농심)
					smsDao.sendKakaoTalk(cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), "ESC-SD-0003", subject, message, message);
				}
			}
		}
	}

	u.jsAlertReplace("전자서명 처리 되었습니다.","contract_recvview.jsp?"+u.getQueryString());
	return;
}


//ktm&s 개인사업자 개인범용 인증서 서명가능
String boss_birth_day = "";
if(cont.getString("member_no").equals("20140900004")&&auth.getString("_MEMBER_GUBUN").equals("03")&&!cont.getString("template_cd").equals("2019318")){

	JsoupUtil jsoupUtil = new JsoupUtil(cont.getString("cont_html"));

	if(cont.getString("template_cd").equals("2015009")) {  // 중첩적 채무인수 계약서(3자 계약)

		cust.first();
		while(cust.next()){
			if(cust.getString("member_no").equals(_member_no)){
				boss_birth_day = jsoupUtil.getValue("boss_birth_day_"+cust.getString("sign_seq"));
				break;
			}
		}
		System.out.println("sign_seq =>" + cust.getString("sign_seq"));

	} else {
		boss_birth_day = jsoupUtil.getValue("boss_birth_day");
		if(boss_birth_day.equals("")){
			contSub.first();
			while(contSub.next()&&boss_birth_day.equals("")){
				jsoupUtil = new JsoupUtil(contSub.getString("cont_sub_html"));
				boss_birth_day = jsoupUtil.getValue("boss_birth_day");
			}
		}
	}

	if(
			u.inArray(cont.getString("template_cd"), new String[]{"2015010","2015025","2015141","2016064","2020051"})
		|| (cont.getString("template_cd").equals("2014074")&&cont.getString("reg_id").equals("mns1082074"))
	  ){

		// 전체 주민번호 다 받는 경우
		p.setVar("full_jumin_no", true);
		boss_birth_day = "-";
		person_yn = true;

	}else  { 
		if(boss_birth_day.equals("")){  
			u.jsError("대표자 생년월일 정보가 없습니다.\\n\\n고객센터로 문의하세요.");
			return;
		}else{
			jumin_no = u.getTimeString("yyMMdd", boss_birth_day.replaceAll("-", ""));
			person_yn = true;
		}
	}


	// KT m&s 개인사업자지만 사업자범용 가지고 있는 경우 사업자인증서로 서명하게끔 처리
     if(auth.getString("_CERT_DN") != null) person_yn=false;
}

//개인사업자 개인범용인증서 서명
String[] boss_sign_member = {
		 "20130400333"//씨제이대한통운(주)   씨제이대한통운인 경우 개인사업자는 개인범용 인증서 서명시 등록된 인증서 인지 체크 안한다.
		,"20150600357"//(주)좋은사람들
		,"20151101164"//(주)아가방앤컴퍼니
		,"20160600634"//(주)해피랜드에프앤씨
		,"20160600636"//해피랜드코퍼레이션 주식회사
		,"20170100165"//주식회사 좋은책신사고
		,"20170100166"//주식회사 신사고아카데미
		,"20171100251"//제시카블랑
		,"20180500444"//에피원에프에스(주)
		,"20181201176"//(주)카카오커머스
		,"20180902050"//(주)비상에프앤씨
		,"20190300598"//우아한형제들
		,"20121202219"//애경산업
		,"20171100802"//나이스정보통신
		,"20150801187"//알토엔대우
		,"20140900004"//ktm&s
		,"20191101572"//대원강원(주)
		,"20200200487"//데브그루  
		};

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_recvview");
p.setVar("menu_cd","000061");
p.setVar("change_cont", Integer.parseInt(cont_chasu)>0);
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("person_yn", person_yn);
p.setVar("jumin_no", jumin_no);
p.setVar("gap_yn", gap_yn);
p.setVar("cont", cont);
if(u.inArray(cont.getString("status"), new String[]{"20","21","30"})){
	p.setVar("status_name", sign_able?"서명요청":"서명진행중");
}
if(u.inArray(cont.getString("status"), new String[]{"20","41"}) ){
	if(cont.getString("status").equals("20")) {
		p.setVar("mod_req_able", true);
	}
	p.setVar("save_able", cont.getInt("sign_cnt")<1);//서명한 사람이 없는 경우만 저장 가능
}

if(cont.getString("status").equals("40")){
	sign_able = false;
	p.setVar("status_name", "수정요청");
}
if(cont.getString("status").equals("41")){
	sign_able = true;
	p.setVar("status_name", "반려");
}
if(cont.getString("template_cd").equals("2019177")&&cont.getInt("unsign_cnt")==3){
	sign_able = false;
	u.jsAlert("개인 모바일 서명이 진행 후 서명 가능 합니다.");
}
p.setVar("sign_able", sign_able);
p.setVar("template", template);
p.setVar("warr", warr);
p.setLoop("contSub", contSub);
p.setLoop("sign_template", signTemplate);
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
p.setVar("boss_sign_yn",!boss_birth_day.equals("") || (u.inArray(cont.getString("member_no"), boss_sign_member) && person_yn));
p.setVar("sign_title", cont.getString("template_cd").equals("2015068")?"제안서 제출":"전자서명");
p.setVar("isNeedTax",isNeedTax);
p.setVar("isNeedWarr",isNeedWarr);
p.display(out);
%>
