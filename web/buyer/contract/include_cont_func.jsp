<%!

/*갑사 후불 결제 정보 입력*/
public DataSet setSenderContPay(DB db, String cont_no, String cont_chasu){
	DataSet result = new DataSet();
	result.addRow();
	//결제 검증
	//요금 정보 조회
	DataObject contDao = new DataObject("tcb_contmaster");
	DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
	if(!cont.next()){
		result.put("succ_yn","N");
		result.put("err_msg","계약정보가 없습니다.");
		return result;
	}

	DataObject useInfoDao = new DataObject("tcb_useinfo");
	DataSet useInfo = useInfoDao.find("member_no = '"+cont.getString("member_no")+"' and useseq = (select max(useseq) from tcb_useinfo where member_no = '"+cont.getString("member_no")+"' )");
	if(!useInfo.next()){
		result.put("succ_yn","N");
		result.put("err_msg","요금제 정보가 없습니다.");
	    return result;
	}
	
	// 후불인 경우
	if(useInfo.getString("paytypecd").equals("50")){
		DataObject payDao = new DataObject("tcb_pay");
		int iPayAmount = 0;  //결제 금액
		int iVatAmount = 0;
		int iCustNum = 1;
		String payContName = cont.getString("cont_name");
		
		if(useInfo.getString("order_write_type").equals("Y")) { // 수급자마다 결제
			DataObject custDao = new DataObject("tcb_cust");
			iCustNum = custDao.getOneInt("select count(*) from tcb_cust where cont_no = '"+cont.getString("cont_no")+"' and cont_chasu = '"+cont.getString("cont_chasu")+"' and sign_seq < 10 and member_no <> '"+cont.getString("member_no")+"'");
		}
		
		DataObject useinfoaddDao = new DataObject("tcb_useinfo_add");
		DataSet useInfoAdd = useinfoaddDao.find("template_cd='"+cont.getString("template_cd")+"' and member_no='"+cont.getString("member_no")+"'");
		
		// 후불인데 양식별로 요금 부과할게 있다면
		if(useInfoAdd.next()) {
			iPayAmount = useInfoAdd.getInt("recpmoneyamt") * iCustNum;
			if(useInfoAdd.getString("insteadyn").equals("Y")){  // 수급업체꺼 대납일 경우
				iPayAmount += useInfoAdd.getInt("suppmoneyamt");
				payContName += "(대납포함)";
			}
		}else{
			iPayAmount = useInfo.getInt("recpmoneyamt") * iCustNum;
			if(useInfo.getString("insteadyn").equals("Y")){  // 수급업체꺼 대납일 경우
				iPayAmount += useInfo.getInt("suppmoneyamt");
				payContName += "(대납포함)";
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

/*계약서 자동 서명*/
public DataSet contAutoSign(String cont_no , String cont_chasu,  String user_ip) throws Exception{
	DataSet result = new DataSet();
	result.addRow();
	
	String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";
	
	DataObject contDao = new DataObject("tcb_contmaster");
	DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
	if(!cont.next()){
		result.put("succ_yn","N");
		result.put("err_msg", "계약 정보가 없습니다.");
		return result;
	}
	
	if(!cont.getString("status").equals("30")){
		result.put("succ_yn","N");
		result.put("err_msg", "계약서 자동 서명 가능한 상태가 아닙니다.");
		return result;
	}
	
	DataObject custDao = new DataObject("tcb_cust");
	DataSet cust = custDao.find(where+" and member_no = '"+cont.getString("member_no")+"' ");
	if(!cust.next()){
		result.put("succ_yn","N");
		result.put("err_msg", "자동 서명 업체 정보가 없습니다.");
		return result;
	}
	
	if(!cust.getString("sign_date").equals("")){
		result.put("succ_yn","N");
		result.put("err_msg", "이미 서명 되어 있습니다.");
		return result;
	}
	
	String gap_sign_date = custDao.getOne("select max(sign_date) from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_date is not null") ;//이의철 실장님 요청으로 자동서명시간은 거래처 최총서명일시+ 30초
	gap_sign_date = Util.addDate("S", 30, Util.strToDate(gap_sign_date), "yyyyMMddHHmmss");
	
	
	String[] agree_template_cds = {
			"20130500619|2016107"// 위메프 광고계제 계약서 >공인인증서명
			,"20130500619|2019067"// 위메프 광고계제 계약서(특가광고) > 공인인증서명 2016107=>2019067 로 변경됨
			,"20130500619|2019189"// 위메프 광고계제 계약서(특가광고) > 공인인증서명 2016107=>2019067=>2019189 로 변경됨
			,"20130500619|2019188"// 위메프VIP 광고주 합의서
			,"20130500619|2019274"// 위메프VIP 광고주 합의서(사업실)
			,"20130500619|2018147"// 위메프 위수탁 광고게재 계약서
			,"20130500619|2020024"//위메프 광고계약서(특가광고)

			,"20170501348|2018241"// 아워홈 식재 공급계약서 >패드서명
			,"20170501348|2018242"// 아워홈 식재 공급계약서 >공인인증서명
			,"20170501348|2019047" // 아워홈 근로계약서(정사원) > 패드서명
			,"20170501348|2019048" // 아워홈 근로계약서_월급제 > 패드서명
			,"20170501348|2019049" // 아워홈 근로계약서_연봉제 > 패드서명
			,"20170501348|2019060" // 아워홈 근로계약서_월급제(정년) > 패드서명
			,"20170501348|2019061" // 아워홈 근로계약서_연봉제(정년) > 패드서명
			,"20170501348|2019062" // 아워홈 근로계약서_일급제(정년) > 패드서명
			,"20170501348|2019063" // 아워홈 근로계약서_일급제 > 패드서명
			,"20170501348|2019064" // 아워홈 근로계약서_파트(정년) > 패드서명
			,"20170501348|2019065" // 아워홈 근로계약서_파트 > 패드서명

			,"20181002679|2019058"// 경기테크노파크> 근로계약서(일반직) >패드서명
			,"20181002679|2019059"// 경기테크노파크> 연봉계약서 >패드서명
			,"20181002679|2019074"// 경기테크노파크> 근로계약서(계약직) >패드서명

			,"20150500312|2015037"// (주)더블유쇼핑>개별계약서(업무 제휴) > 공인인증서명
			,"20150500312|2015038"// (주)더블유쇼핑>상품판매(개별)계약서 - 비연동 계약서 >공인인증서명
			,"20150500312|2018211"// (주)더블유쇼핑>상품판매(개별)계약서(전체편성) >공인인증서명
			,"20150500312|2019209"// (주)더블유쇼핑>상품판매(개별)계약서(대체편성) >공인인증서명
			,"20150500312|2018211"// (주)더블유쇼핑>상품판매(개별)계약서>공인인증서명
			,"20150500312|2018212"// (주)더블유쇼핑>상품판매(혼합)계약서>공인인증서명
			,"20150500312|2018213"// (주)더블유쇼핑>정액(제휴)계약서>공인인증서명

			,"20151100446|2019028"// 나이스디앤알> 업무도급계약서 >패드서명

			,"20171101813|2019015" //PGM)SK스토아 광고방송 계약서[DB건별]
			,"20171101813|2019016" //PGM)SK스토아 광고방송 계약서[정액방송]
			,"20171101813|2019017" //PGM)SK스토아 판매계약서[혼합수수료]
			,"20171101813|2019018" //PGM)SK스토아 판매계약서[위수탁수수료]
			,"20171101813|2020192" //PGM)SK스토아 판매방송계약서[특약혼합매입]

			,"20160500857|2020020"	//한국전자금융>근로계약서_정규직(운영직)
			,"20160500857|2020021"	//한국전자금융>근로계약서_정규직(일반직)
			,"20160500857|2020022"	//한국전자금융>근로계약서_계약직(일반계약직)
			,"20160500857|2020035"	//한국전자금융>NICE 현금지급기 설치 표준계약서
			,"20160500857|2020159"	//한국전자금융>비밀유지서약서(재직자) 
			
			,"20190101731|2020053" //트리노드 주식회사 근로계약서_3천초과
			,"20190101731|2020124" //트리노드 주식회사 근로계약서_3천이하
			,"20190101731|2020054" //트리노드 주식회사 연봉계약서
			
			,"20180100028|2019112" // PBP파트너즈 근로계약서 
			,"20180100028|2020150" // PBP파트너즈 2020년_도급계약서_신규제빵
			,"20180100028|2020151" // PBP파트너즈 2020년_도급계약서_기존제빵
			,"20180100028|2020152" // PBP파트너즈 2020년_도급계약서_신규카페
			,"20180100028|2020153" // PBP파트너즈 2020년_도급계약서_기존카페
			,"20180100028|2020154" // PBP파트너즈 2020년_점포제조지원약정서  
			};
	
	String[] server_cert_passwd = {
				 "20130500619=>wonder#001"//위메프
				,"20170501348=>ourhome7&&"//아워홈
				,"20151100446=>nicednr1!@#"//나이스디앤알
				,"20181002679=>rudrltp_3010"//경기테크노파크
				,"20150500312=>bs220505^^"//(주)더블유쇼핑
				,"20171101813=>skstoa2018!"// SK스토아
				,"20150700675=>vnemqlf1004!"//CJ푸드빌
				,"20150500269=>daeduck!12"//대덕전자
				,"20160500857=>nice2122.."//한국전자금융
				,"20190101731=>5dnjf7dlf@" // 트리노드 주식회사 
				,"20180100028=>*adel0618*" //PBP파트너즈
			 };
	
	if(!(Util.inArray(cont.getString("member_no")+"|"+cont.getString("template_cd"), agree_template_cds)||cont.getString("cont_etc1").equals("auto_sign"))){
		result.put("succ_yn","N");
		result.put("err_msg", "자동서명 계약대상건이 아닙니다.");
		return result;
	}
	
	Crosscert crosscert = new Crosscert();
	DataSet signInfo = crosscert.serverSign(cont.getString("member_no"), Util.getItem(cont.getString("member_no"), server_cert_passwd), cont.getString("cont_hash"));
	
	if(!signInfo.getString("err").equals("")){
		result.put("succ_yn","N");
		result.put("err_msg", "계약서 서명에 실패하였습니다.");
		return result;
	}
	
	String sign_dn = signInfo.getString("signDn");
	String sign_data = signInfo.getString("signData");
	if(sign_dn.equals("")||sign_data.equals("")){
		result.put("succ_yn","N");
		result.put("err_msg", "전자서명에 필요한 데이터를 찾을 수 없습니다.\\n\\n고객센터로 문의 바랍니다.");
		return result;
	}
	
	
	if (crosscert.chkSignVerify(sign_data).equals("SIGN_ERROR")){
		result.put("succ_yn","N");
		result.put("err_msg", "자동서명 검증에 실패 하였습니다.");
		return result;
	}
	
	if(!crosscert.getDn().equals(sign_dn)){
		result.put("succ_yn","N");
		result.put("err_msg", "자동서명검증의 DN값이 일지 하지 않습니다.");
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
	if(!agree_seq.equals("")){ // 내부 결재 프로세스가 있는 경우. 최종 서명되었더라도 표시
	
	    DataObject agreeDao = new DataObject("tcb_cont_agree");
	    agreeDao.item("ag_md_date", Util.getTimeString());
	    agreeDao.item("r_agree_person_id","SYSTEM");
	    agreeDao.item("r_agree_person_name", "시스템자동서명");
	    db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_seq="+agree_seq),agreeDao.record);
	}

	result = setSenderContPay(db, cont_no, cont_chasu);
	if(!result.getString("succ_yn").equals("Y")){
		return result;
	}

	/* 계약로그 START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  cont.getString("member_no"), "0", "시스템자동서명", user_ip, "전자서명 완료",  "자동서명", "50","10");
	/* 계약로그 END*/
	
	if(!db.executeArray()){
		result.put("succ_yn","N");
		result.put("err_msg", "자동 서명 정보 입력 철에 실패 하엿습니다.");
		return result;
	}
	result.put("succ_yn","Y");
	result.put("err_msg", "");
	return result;
}


%>