<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ include file="include_cont_func.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}


boolean sign_able = false;
String cust_type = "";// 받는 사람이 갑인 경우 01 을인 경우 02
boolean gap_yn = false;// 로그인한 업체가갑인지 여부 cust_type == "01" 이면 갑이다.
String file_path = "";


CodeDao codeDao = new CodeDao("tcb_comcode");

boolean person_yn = false;
String jumin_no = "";
String pay_yn = "";

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'",
" tcb_contmaster.* "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is not null ) sign_cnt "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null ) unsign_cnt "
+" ,(select member_name from tcb_member where member_no = tcb_contmaster.mod_req_member_no ) mod_req_name "
);
if(!cont.next()){
	u.jsError("계약정보가 존재 하지 않습니다.");
	return;
}
cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
cont.put("cont_date",u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
cont.put("cont_edate",u.getTimeString("yyyy-MM-dd",cont.getString("cont_edate")));
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+cont.getString("member_no")+"' ");
if(!member.next()){
	u.jsError("작성업체 정보가 존재 하지 않습니다.");
	return;
}


DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","*","sign_seq asc");

// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust a");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","a.*, (select cust_type from tcb_cont_sign where cont_no = a.cont_no and cont_chasu=a.cont_chasu and sign_seq = a.sign_seq ) cust_type");
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


//계약서류 조회
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	if(file_path.equals("")){
		file_path = cfile.getString("file_path");
	}
	cfile.put("auto", cfile.getString("auto_yn").equals("Y")?true:false);
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	cfile.put("pdf_yn", cfile.getString("file_ext").toLowerCase().equals("pdf"));
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

// 업체별 구비 서류 조회
String rfile_query =
" select a.*  "
		+"   from tcb_cust a, tcb_cont_sign b "
		+"  where a.cont_no= b.cont_no  "
		+"    and a.cont_chasu = b.cont_chasu "
		+"    and a.sign_seq = b.sign_seq  "
		+"    and a.cont_no = '"+cont_no+"' "
		+"    and a.cont_chasu = '"+cont_chasu+"' "
		+"    and b.cust_type <> '01' ";
//if(!cust_type.equals("01")) rfile_query += " and a.member_no ='"+_member_no+"'";
rfile_query += "order by a.cont_no asc, a.cont_chasu asc, a.sign_seq asc";


DataObject rfileDao = new DataObject();
//rfileDao.setDebug(out);
DataSet rfile_cust = rfileDao.query(rfile_query);

while(rfile_cust.next()){
   
	rfile_cust.put("cont_no", u.aseEnc(rfile_cust.getString("cont_no")));
	rfile_cust.put("attch_area", rfile_cust.getString("member_no").equals(_member_no));

	//rfileDao.setDebug(out);
	DataSet rfile = rfileDao.query(
	 "  select a.attch_yn, a.doc_name, a.rfile_seq, b.file_path, b.file_name, b.file_ext, file_size "
	+"    from tcb_rfile a  "
	+"    left outer join  tcb_rfile_cust b "
	+"      on a.cont_no = b.cont_no  "
	+"     and a.rfile_seq = b.rfile_seq  "
	+"     and a.cont_chasu = b. cont_chasu "
	+"     and b.member_no = '"+rfile_cust.getString("member_no")+"' "
	+"   where  a.cont_no = '"+cont_no+"'  "
	+"     and a.cont_chasu = '"+cont_chasu+"' "
	);
	while(rfile.next()){
		rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
		rfile.put("file_size", u.getFileSize(rfile.getLong("file_size")));
	}
	rfile_cust.put(".rfile",rfile);
}

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
				status = "30";  // 서명대기
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
	
	// sms 및 메일 발송 처리
	if (sms) {
		if (nagreeCnt > 0) { // 결제 라인 있는 경우
			// 다음 내부 결재 담당자에게 거래처 서명완료 알림.
			DataObject agreeDao = new DataObject("tcb_cont_agree");
			DataSet agree = agreeDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd='2' and length(agree_person_id) > 0","*"," agree_seq asc"); // 파트너 서명후 검토자가 있고 그 검토자가 부서가 아닌 1명인 경우 처음 검토자에게 검토 메일 전송
			if (agree.next()) {
				// 이메일 알림.
				DataObject personDao = new DataObject("tcb_person");
				DataSet agree_person = personDao.find("user_id='"+agree.getString("agree_person_id")+"'");	// 검토자 정보
				if (agree_person.next()) {
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
			// 작성자 email
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

	if(cont.getString("cont_etc1").equals("auto_sign")) {
		DataSet result = contAutoSign(cont_no, cont_chasu, request.getRemoteAddr());
		if(!result.getString("succ_yn").equals("Y")){
			u.sp("계약서 자동서명 실패!!!\npage:contract_free_recvview.jsp\ncont_no:"+cont_no+"-"+cont_chasu);
			u.mail("nicedocu@nicednr.co.kr","계약서 자동서명 실패!!!", " 계약서 자동서명실패!!!\npage:contract_free_recvview.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		}
		status = "50";
	}
	if(status.equals("50")){  // 서명완료
		u.jsAlertReplace("전자서명이 완료 되었습니다.","contend_free_recvview.jsp?"+u.getQueryString());
	}else{
		u.jsAlertReplace("전자서명 처리 되었습니다.","contract_free_recvview.jsp?"+u.getQueryString());
	}
	return;
}
p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_free_recvview");
p.setVar("menu_cd","000061");
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("person_yn", person_yn);
p.setVar("jumin_no", jumin_no);
p.setVar("gap_yn", gap_yn);
p.setVar("cont", cont);
if(u.inArray(cont.getString("status"), new String[]{"20","30"})){
p.setVar("status_name", sign_able?"서명요청":"서명진행중");
}
if(cont.getString("status").equals("40")){
sign_able = false;
p.setVar("status_name", "수정요청");
}
if(cont.getString("status").equals("41")){
	sign_able = true;
	p.setVar("status_name", "반려");
}
p.setVar("sign_able", sign_able);
p.setLoop("sign_template", signTemplate);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("stamp", stamp);
p.setLoop("rfile_cust", rfile_cust);
p.setVar("file_path", file_path);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>