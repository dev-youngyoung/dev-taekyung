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


/* boolean isTemplate = false;// 우형 2021283
boolean isNeedTax = false;// 인지세가 있어야만 계약서 서명 가능
boolean isNeedWarr = false;// 보증서류가 있어야만 계약서 서명 가능 */
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
				+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,3) = substr(tcb_contmaster.src_cd,0,3) and depth='1') l_src_nm "
				+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,6) = substr(tcb_contmaster.src_cd,0,6) and depth='2') m_src_nm "
				+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and src_cd = tcb_contmaster.src_cd and depth='3') s_src_nm "
);
if(!cont.next()){
	u.jsError("계약정보가 존재 하지 않습니다.!!");
	return;
}

cont.put("dong_pop", "20120500023".equals(cont.getString("member_no"))?true:false);	// 2019.07.01시행된 동희오토 수수료 안내 팝업
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
DataSet contSub = contSubDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and (gubun not in ('40','10') or (gubun = '40' and option_yn in ('A','Y')) or (gubun = '10' and option_yn in ('A','Y'))) and gubun <> '50' ");

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
boolean cust_chain_mobile_signed = true;
DataSet cust_chain = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq > 10","a.*");
while(cust_chain.next()){
	cust_chain.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust_chain.getString("sign_date")));

	if(cust_chain.getString("sign_type").equals("20") && cust_chain.getString("sign_date").equals("")) {
		cust_chain_mobile_signed = false;
	}
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
	//warr.put("cred", warr.getString("warr_type").equals("80"));
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
	
	/* if(warr.getString("warr_type").equals("공사대급지급보증")){
		//warr.put("warr_write_value", false);
		if(warr.getString("warr_no").equals("")){   // 보증서류 미등록시
			warr.put("warr_write_value", false);
		}else{										// 보증서류 등록시 
			warr.put("warr_write_value", true); 
		}
	} */
	
	
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
	
	
	//결제검증
	DataObject useInfoDao = new DataObject("tcb_useinfo");
	DataSet useInfo = useInfoDao.find("member_no = '"+cont.getString("member_no")+"'");
	if(!useInfo.next()){
		u.jsError("계약서 발신자의 요금제 정보가 없습니다. 고객센터[02-788-9097]에 문의하세요.");
		return;
	}
	
	
	if(!pay_yn.equals("Y")){
		int supp_pay_amount = useInfo.getInt("suppmoneyamt");
		String  insteadyn = useInfo.getString("insteadyn");
		DataObject useInfoAddDao = new DataObject("tcb_useinfo_add");
		DataSet useInfoAdd = useInfoAddDao.find(" member_no = '"+cont.getString("member_no") +"' and template_cd = '"+cont.getString("template_cd")+ "'");
		
		if(useInfoAdd.next()){
			supp_pay_amount = useInfoAdd.getInt("suppmoneyamt");
			insteadyn = useInfoAdd.getString("insteadyn");
		}
		
		if(!insteadyn.equals("Y")&&supp_pay_amount>0){//대납이 아니고 결제금액이 0보다 크면
			DataObject payDao = new DataObject("tcb_pay");
			DataSet pay = payDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no  = '"+_member_no+"' ");
			if(!pay.next()){
				u.jsError("나이스다큐 이용료 결제 정보가 없습니다.\\b\\b결제 여부를 확인 하세요.");
				return;
			}
		}
	}
	
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
	/* Kakao_SmsDao kakao_smsDao= new Kakao_SmsDao(); */  
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
		
		//완료인 경우 결제 정보 입력
		if(status.equals("50")){//완료인 경우 결제정보 입력

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
						mailInfo.put("cust_name", auth.getString("_MEMBER_NAME"));
						mailInfo.put("cont_name", cont.getString("cont_name"));
						mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
						p.setVar("info", mailInfo);
						p.setVar("server_name", request.getServerName());
						p.setVar("return_url", "web/buyer/");
						String mail_body = p.fetch("../html/mail/cont_send_mail.html");
						  
						if(cont.getString("member_no").equals("20150600110") && !cont.getString("template_cd").equals("2020228")){ //티알엔은 작성자에게 무조건 알림  
							//String email_reg = custDao.getOne("select email from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"'  ");
							DataSet cust_1 = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"'  "); 
							p.clear();
							DataSet mailInfo1 = new DataSet();
							mailInfo1.addRow();
							mailInfo1.put("cust_name", auth.getString("_MEMBER_NAME"));
							mailInfo1.put("cont_name", cont.getString("cont_name"));
							mailInfo1.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
							p.setVar("info", mailInfo1);
							p.setVar("server_name", request.getServerName());
							p.setVar("return_url", "web/buyer/");	   
							while(cust_1.next()){
								u.mail(cust_1.getString("email"), "[계약 서명 알림] \"" +  auth.getString("_MEMBER_NAME") + "\" 업체가 전자계약서 서명을 완료하였습니다.", p.fetch("mail/cont_cust_sign.html")); 
						     	smsDao.sendSMS("buyer", cust_1.getString("hp1"), cust_1.getString("hp2"), cust_1.getString("hp3"), auth.getString("_MEMBER_NAME")+" 에서 전자계약서 서명완료 - 나이스다큐(일반기업용)");
							} 
						}else{
							u.mail(agree_person.getString("email"), "[계약 서명 알림] \"" +  auth.getString("_MEMBER_NAME") + "\" 업체가 전자계약서 서명을 완료하였습니다.", p.fetch("mail/cont_cust_sign.html"));
							System.out.println(">>>>>>" + agree_person.getString("hp1")+ agree_person.getString("hp2")+ agree_person.getString("hp3"));
							  
							String param =agree_person.getString("user_name")+ "#;"+  auth.getString("_MEMBER_NAME") + "#;" + auth.getString("_MEMBER_NAME")+ "#;"+  cont.getString("cont_name") +  "#;"+ u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")) + "#;";  
						    if(nagreeCnt > 1){ //결재선이 2명 이상일때
								/* kakao_smsDao.sendKkoLMS_2(param, "#;" ,"Y" ,"ufit_2021022410325025563515372" ,"S" ,  agree_person.getString("hp1") , agree_person.getString("hp2"), agree_person.getString("hp3"),"","","" ,"AT")  ;  // "y" 로 하면 알림톡 안감... */							
							}else{ //1명만 남았을때 
								/* kakao_smsDao.sendKkoLMS_2(param, "#;" ,"Y" ,"ufit_2021021814585826670467055" ,"S" ,  agree_person.getString("hp1") , agree_person.getString("hp2"), agree_person.getString("hp3"),"","","" ,"AT")  ;  // */ 
							}	
							 
						} 
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
					mailInfo.put("cust_name", auth.getString("_MEMBER_NAME"));
					mailInfo.put("cont_name", cont.getString("cont_name"));
					mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
					p.setVar("info", mailInfo);
					p.setVar("server_name", request.getServerName());
					p.setVar("return_url", "web/buyer/");
					String mail_body = p.fetch("../html/mail/cont_send_mail.html");
					u.mail(email, "[계약 서명 알림] \"" +  auth.getString("_MEMBER_NAME") + "\" 업체가 전자계약서 서명을 완료하였습니다.", p.fetch("mail/cont_cust_sign.html"));
				}
			}
			// sms 전송
			cust.first(); 
			while(cust.next()){
				if(cust.getString("member_no").equals(cont.getString("member_no"))){  
					String param =cust.getString("user_name") + "#;"+  auth.getString("_MEMBER_NAME")+ "#;"+  auth.getString("_MEMBER_NAME") + "#;" + cont.getString("cont_name") +  "#;"+ u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")) + "#;";   
					/* kakao_smsDao.sendKkoLMS_2(param, "#;" ,"Y" ,"ufit_2021021814585826670467055" ,"S" ,  cust.getString("hp1") , cust.getString("hp2"), cust.getString("hp3"),"","","" ,"AT")  ; */ 
				 }
			}
		}
	}


	//계약서 push
	if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK스토아, 에스케이브로드밴드일 경우
		DataSet result = contPush_skstoa(cont_no, cont_chasu);//계약완료 push
		if(!result.getString("succ_yn").equals("Y")){
			u.sp(" skstore 계약정보 전송 실패!!!\npage:contract_recvview.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
			u.mail("nicedou@nicednr.co.kr","skstore 계약정보 전송 실패!!! ", " skstore 계약정보 전송 실패!!!\npage:contract_recvview.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		}
	}

	if(u.inArray(cont.getString("member_no"), new String[]{"20180101078","20180101074","20181200231","20181201402"})) {  // 얼리페이 (유한회사 피아이솔루션즈, 유한회사 퍼스트에프에스, 유한회사 얼리페이), 유한외사 위커머스
		DataSet result = contPush_earlypay(cont_no, cont_chasu);
		if(!result.getString("succ_yn").equals("Y")){
			u.sp(" 얼리페이 계약정보 전송 실패!!!\npage:contract_recvview.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
			u.mail("nicedocu@nicednr.co.kr","얼리페이 계약정보 전송 실패!!! ", " 얼리페이 계약정보 전송 실패!!!\npage:contract_recvview.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		}
	}
	
	//계약서 push (티알엔)
	/* if(u.inArray(cont.getString("template_cd"), new String[]{"2021390","2018227","2017120","2019382","2021093","2021110","2018263","2021408","2021406","2021391"}) && cont.getString("member_no").equals("20150600110")){	//임시 
		//if(u.inArray(cont.getString("member_no"), new String[]{"20150600110"})) {  //티알엔
			DataSet result = contPush_trn(cont_no, cont_chasu,cont.getString("template_cd"));//계약완료 push
			if(!result.getString("succ_yn").equals("Y")){
				u.sp(" trn 계약정보 전송 실패!!!\npage:contract_recvview.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
				u.mail("nicedocu@nicednr.co.kr","trn 계약정보 전송 실패!!! ", " trn 계약정보 전송 실패!!!\npage:contract_recvview.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
			}
		//}
	} */

	//계약서 자동 서명
	String[] arr_auto_sign = {
			 "20130500619|2016107"//위메프 광고계제 계약서
			,"20130500619|2019067"//위메프 광고계제 계약서(특가광고)2016107=>2019067 로 변경됨
			,"20130500619|2019189"//위메프 광고계제 계약서(특가광고)2016107=>2019067=>2019189 로 변경됨
			,"20130500619|2020024"//위메프 광고계약서(특가광고)
			,"20130500619|2019188"// 위메프VIP 광고주 합의서
			,"20130500619|2019274"// 위메프VIP 광고주 합의서(사업실)
			,"20130500619|2018147"// 위메프 위수탁 광고게재 계약서
			,"20170501348|2018241"// 아워홈 식재 공급계약서 >패드서명
			,"20170501348|2018242"// 아워홈 식재 공급계약서 >공인인증서명
			,"20181002679|2019058"// 경기테크노파크> 근로계약서(일반직)
			,"20181002679|2019059"// 경기테크노파크> 연봉계약서
			,"20181002679|2019074"// 경기테크노파크> 근로계약서(계약직)
			,"20150500312|2015037"// (주)더블유쇼핑>개별계약서(업무 제휴)
			,"20150500312|2015038"// (주)더블유쇼핑>상품판매(개별)계약서 - 비연동 계약서 >공인인증서명
			,"20150500312|2018211"// (주)더블유쇼핑>상품판매(개별)계약서(전체편성) >공인인증서명
			,"20150500312|2019209"// (주)더블유쇼핑>상품판매(개별)계약서(대체편성) >공인인증서명
			,"20150500312|2018211"// (주)더블유쇼핑>상품판매(개별)계약서 >공인인증서명
			,"20150500312|2018212"// (주)더블유쇼핑>상품판매(혼합)계약서 >공인인증서명
			,"20150500312|2018213"// (주)더블유쇼핑>정액(제휴)계약서 >공인인증서명
			,"20171101813|2019015" //PGM)SK스토아 광고방송 계약서[DB건별]
			,"20171101813|2019016" //PGM)SK스토아 광고방송 계약서[정액방송]
			,"20171101813|2019017" //PGM)SK스토아 판매계약서[혼합수수료]
			,"20171101813|2019018" //PGM)SK스토아 판매계약서[위수탁수수료]
			,"20171101813|2020192" //PGM)SK스토아 판매방송계약서[특약혼합매입]
			,"20190101731|2020053" //트리노드 주식회사 근로계약서_3천초과
			,"20190101731|2020124" //트리노드 주식회사 근로계약서_3천이하
			,"20190101731|2020054" //트리노드 주식회사 연봉계약서
			,"20190101731|2021244" //트리노드 주식회사 근로계약 변경합의서
			
			,"20180100028|2019112" // PBP파트너즈 근로계약서 
			,"20180100028|2020150" // PBP파트너즈 2020년_도급계약서_신규제빵 
			,"20180100028|2020151" // PBP파트너즈 2020년_도급계약서_기존제빵
			,"20180100028|2020152" // PBP파트너즈 2020년_도급계약서_신규카페
			,"20180100028|2020153" // PBP파트너즈 2020년_도급계약서_기존카페
			,"20180100028|2020154" // PBP파트너즈 2020년_점포제조지원약정서
			,"20180100028|2021380" // PBP파트너즈 특별연장근로 동의서 
			
			,"20200712105|2020278" //(주)한진중공업 건설부문 근로계약서_정규직 
			
			,"20150600110|2017121" //티알엔>거래기본계약서(정보연동)
			,"20150600110|2017120" //티알엔>정률 상품공급계약서(정보연동)
			,"20150600110|2018227" //티알엔>정률 상품공급계약서(수기)
			,"20150600110|2018217" //티알엔>정액 상품공급계약서(수기)
			,"20150600110|2018218" //티알엔>콜베이스 상품공급계약서(수기)
			,"20150600110|2017261" //티알엔>쇼핑엔티 상품공급계약서(직매입_업체창고_수기)
			,"20150600110|2017262" //티알엔>쇼핑엔티 상품공급계약서(직매입_자사창고_수기)
			,"20150600110|2018263" //티알엔>광고비계약서
			,"20150600110|2019081" //티알엔>프로모션 합의서 
			,"20150600110|2019144" //티알엔>방송비(무형상품) 정산 확인서
			,"20150600110|2019186" //티알엔>부속합의서
			,"20150600110|2020155" //티알엔>부속합의서(지게와 작대기)
			,"20150600110|2020190" //티알엔>PB상품 납품조건 변경합의서
			,"20150600110|2020191" //티알엔>PB상품계약서
			,"20150600110|2019382" //티알엔>정률 상품공급계약서(정보연동) 
			,"20150600110|2020402" //티알엔>PB상품계약서(위탁보관) 기본조건
			,"20150600110|2020270" //티알엔>상표사용 계약서
			,"20150600110|2021014" //티알엔>추가 콘텐츠제작비 분담서
			,"20150600110|2021093" //티알엔>혼합 상품공급계약서 		
			,"20150600110|2021110" //티알엔>혼합 상품공급계약서(정보연동)
			,"20150600110|2021232" //티알엔>거래기본계약서(일괄)
			,"20150600110|2021408" //티알엔>혼합상품공급계약서(정보연동)_자동
			
			,"20130700376|2020390" //웅진식품>대리점계약서
			,"20130700376|2020391" //웅진식품>대리점계약서(특약)
			,"20130700376|2020392" //웅진식품>대리점계약서(농협전문) 
			,"20130700376|2020393" //웅진식품>물품공급계약서(특판_기타)
			,"20130700376|2021004" //웅진식품>월 마감정산서 확인서(인증서서명)
			,"20130700376|2021005" //웅진식품>월 마감정산서 확인서(자필서명)
			,"20130700376|2021006" //웅진식품>수출제품 공급계약서  
			,"20130700376|2021086" //웅진식품>물품공급계약서(특판_기타)
			,"20130700376|2021089" //웅진식품>물품공급계약서(특판_FC,자필서명)
			,"20130700376|2021095" //웅진식품>대리점계약서(특약,자필서서명)
			,"20130700376|2021148" //웅진식품>대리점계약서(자필서명) 
			,"20130700376|2021147" //웅진식품>월 마감정산서 확인서(인증서서명,개인범용)  
			,"20130700376|2021233" //웅진식품>계약서(갑지)(인증서서명,개인범용)  
			,"20130700376|2021234" //웅진식품>계약서(갑지)(자필서명)  
			,"20130700376|2021235" //웅진식품>계약해지 합의서(인증서서명,개인범용)  
			,"20130700376|2021236" //웅진식품>계약해지 합의서(자필서명)  
			,"20130700376|2021348" //웅진식품>수출공급계약서(Local, 자필서명)
			,"20130700376|2021347" //웅진식품>대리점계약서(농협전문, 자필서명)
			
			,"20181201176|2020394" //카카오커머스>발주서  
			,"20181201176|2021127" //카카오커머스>발주서 (SAP)  
			,"20181201176|2021163" //카카오커머스>발주서 (톡별 부가세 포함)
			,"20181201176|2021081" //카카오커머스>카카오커머스 발주서 (메이커스 부문_간이,개인)
			,"20181201176|2021082" //카카오커머스>카카오커머스 발주서 (메이커스 부문_일반)
			,"20181201176|2021103" //카카오커머스>납품 및 검수확인서 (메이커스)
			,"20181201176|2021277" //카카오커머스>[커머스] 선물하기 표준거래계약서 위수탁(자동연장)
            ,"20181201176|2021279" //카카오커머스>[커머스] 선물하기 표준계약서 위수탁(단기계약)
			
			,"20130900194|2020394" //카카오>발주서
			,"20130900194|2021127" //카카오>발주서 (SAP)   
			,"20130900194|2021163" //카카오>발주서 (톡별 부가세 포함)
			,"20130900194|2021081" //카카오>카카오커머스 발주서 (메이커스 부문_간이,개인)
			,"20130900194|2021082" //카카오>카카오커머스 발주서 (메이커스 부문_일반)
			,"20130900194|2021103" //카카오>납품 및 검수확인서 (메이커스)
			,"20130900194|2019171" //카카오>재고자산보유확인서
			,"20130900194|2019170" //카카오>재고자산보유확인서
			,"20130900194|2021277" //카카오>[커머스] 선물하기 표준거래계약서 위수탁(자동연장) 
            ,"20130900194|2021279" //카카오>[커머스] 선물하기 표준계약서 위수탁(단기계약)
            ,"20130900194|2021410" //카카오>[메이커스] 카카오 발주서(개인)
			
			,"20190300598|2021051" // 우아한형제들>2021 우아한 리텐션 프로그램 (WRP)
		 };
	
	if(u.inArray(cont.getString("member_no")+"|"+cont.getString("template_cd"), arr_auto_sign)|| cont.getString("cont_etc1").equals("auto_sign")) {
		System.out.println(">>>>>>자동서명" );
 
		if(cust_chain.size()>0) { //연대보증이 있다면   
			 if(status.equals("30")){ //작성자만 서명 안했다면 
		    	DataSet result = contAutoSign(cont_no, cont_chasu, request.getRemoteAddr());
				if(!result.getString("succ_yn").equals("Y")){
					u.sp("계약서 자동서명 실패1!!!\npage:contract_recvview.jsp\ncont_no:"+cont_no+"-"+cont_chasu);
					u.mail("nicedocu@nicednr.co.kr","계약서 자동서명 실패1!!!", " 계약서 자동서명실패1!!!\npage:contract_recvview.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
				}else{
					status = "50";
				}
				
		    } 
		}else{
			DataSet result = contAutoSign(cont_no, cont_chasu, request.getRemoteAddr());
			if(!result.getString("succ_yn").equals("Y")){
				u.sp("계약서 자동서명 실패!!!\npage:contract_recvview.jsp\ncont_no:"+cont_no+"-"+cont_chasu);
				u.mail("nicedocu@nicednr.co.kr","계약서 자동서명 실패!!!", " 계약서 자동서명실패!!!\npage:contract_recvview.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
			}else{
				status = "50";
			} 
		}
		 
		//자동서명 계약서완료 push
		if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK스토아, 에스케이브로드밴드일 경우
			DataSet push_result = contPush_skstoa(cont_no, cont_chasu);//계약완료 push
			if(!push_result.getString("succ_yn").equals("Y")){
				u.sp(" skstore 계약정보 전송 실패(자동서명)!!!\npage:contract_recvview.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
				u.mail("nicedocu@nicednr.co.kr","skstore 계약정보 전송 실패!!! ", " skstore 계약정보 전송 실패!!!\npage:contract_recvview.jsp\ncont_no: "+ cont_no +"-"+ cont_chasu);
			}
		}
	}

	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>status : " + status);
	if(status.equals("50")){  // 서명완료
		u.jsAlertReplace("전자서명이 완료 되었습니다.","contend_recvview.jsp?"+u.getQueryString());
	}else{
		u.jsAlertReplace("전자서명 처리 되었습니다.","contract_recvview.jsp?"+u.getQueryString());
	}

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
			u.inArray(cont.getString("template_cd"), new String[]{"2015010","2015025","2015141","2016064","2020051","2021149","2021150"})
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
		,"20200200287"//푸디스트
		,"20130700376"//웅진식품
		,"20210222377"//소드원대부
		,"20120700020"//테스트07
		,"20190800293"//베네핏대부 
		,"20130900194"//카카오 
		,"20130800733"//조에티스 
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
if(cust_chain.size()>0) {
	p.setLoop("cust_chain", cust_chain);
}
p.setVar("cust_chain_mobile_signed", cust_chain_mobile_signed);
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
p.display(out);
%>
