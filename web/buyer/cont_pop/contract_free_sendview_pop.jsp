<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="nicednb.Client" %>
<%
String vcd = u.request("vcd");
String key = u.request("key");
String cert = u.request("cert");

if(vcd.length()!=10) //|| uri.equals("http"))
{
	out.print("No Permission!!");
	return;
}

String contstr = u.aseDec(key);  // 디코딩
if(contstr.length() != 12)
{
	out.print("No Permission!!");
	return;
}

String sClientKey = "";

String member_no = "";

Client cs = new Client();
if(vcd.equals("1168150973")){  // 아이디지털홈쇼핑
	sClientKey = cs.getClientKey("www.idigitalhomeshopping.com");
	member_no = "20150600110";
}else if(vcd.equals("1208755227")){  // 위메프
	sClientKey = cs.getClientKey("www.wemakeprice.com");
	member_no = "20130500619";
}else if(vcd.equals("2118819183")){  // 더블유컨셉코리아
	sClientKey = cs.getClientKey("www.wconcept.co.kr");
	member_no = "20140100706";
}else if(vcd.equals("4928700855")){  // 에스케이브로드밴드
	sClientKey = cs.getClientKey("www.skbroadband.com");
	member_no = "20171101813";
}else if(vcd.equals("1068123810")){  // 소니코리아
	sClientKey = cs.getClientKey("www.sonykorea.com");
	member_no = "20160900378";
	//out.print(sClientKey);
}else if(vcd.equals("1348106363")){  // 대덕전자
	sClientKey = cs.getClientKey("www.daeduck.com");
	member_no = "20150500269";
}else{
	out.print("No Permission!!");
	return;
}


System.out.println("cert : "+cert);
System.out.println("sClientKey : "+sClientKey);

if(!cert.equals(sClientKey))
{
	out.print("Certfication Key Error!!");
	return;
}


String cont_no = contstr.substring(0,11);
String cont_chasu = contstr.substring(11);

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}
	
String file_path = "";

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008");
String[] code_warr = codeDao.getCodeArray("M007");

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("작성업체 정보가 존재 하지 않습니다.");
	return;
}

boolean bIsKakao = u.inArray(_member_no, new String[]{"20130900194"});
boolean gap_yn = false;// 로그인한 업체가갑인지 여부 cust_type == "01" 이면 갑이다.
boolean pay_yn = false;// 로그인한 업체의 결제 여부 (작성중으로 돌릴 경우 기결제 되어 있다.)

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'",
"tcb_contmaster.*"
+" ,(select user_name from tcb_person where user_id = tcb_contmaster.reg_id ) writer_name "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is not null ) sign_cnt "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null ) unsign_cnt "
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
cont.put("cont_edate",u.getTimeString("yyyy-MM-dd",cont.getString("cont_edate")));
cont.put("status_name", u.getItem(cont.getString("status"),code_status));
cont.put("reg_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("reg_date")));
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
if(!cont.getString("src_cd").equals(""))
cont.put("src_nm", cont.getString("l_src_nm")+" > "+cont.getString("m_src_nm")+" > "+cont.getString("s_src_nm"));
if(bIsKakao) {
	if(cont.getString("cont_etc2").equals("on"))
		cont.put("cont_etc2", "▣ 양도 및 종료 계약");
	else
		cont.put("cont_etc2", "□ 양도 및 종료 계약 아님");

	cont.put("cont_etc3", u.nl2br(cont.getString("cont_etc3")));
}

DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","*","sign_seq asc");

// 내부 결재정보 조회
// 현재 진행해야 하는 순서(부서코드 / 아이디)
String now_field_seq = "";
String now_person_id = "";
String last_person_id = ""; // 최종 동의한 사람 id
int now_seq = 0;			// 현재 진행단계 seq
int cust_seq = 0;
int total_seq = 0;
int last_agree_seq = 0;		// 최종 동의한 seq
boolean isReject = false;	// 내부 반려여부
DataObject agreeTemplateDao = new DataObject("tcb_cont_agree");
DataSet agreeTemplate= agreeTemplateDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", "agree_seq");
while(agreeTemplate.next()){
    agreeTemplate.put("cont_no", u.aseEnc(agreeTemplate.getString("cont_no")));
    agreeTemplate.put("is_cust", agreeTemplate.getString("agree_cd").equals("0"));
    agreeTemplate.put("ag_md_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", agreeTemplate.getString("ag_md_date")));
    
    if(!agreeTemplate.getString("r_agree_person_id").equals("")){
    	agreeTemplate.put("agree_status_nm", agreeTemplate.getString("mod_reason").equals("")?"완료":"반려");
    	agreeTemplate.put("css", "is-active");
    	agreeTemplate.put("agree_person_name", agreeTemplate.getString("r_agree_person_name"));
    	last_agree_seq = agreeTemplate.getInt("agree_seq");
    	last_person_id = agreeTemplate.getString("r_agree_person_id");
    }else{
    	if(now_field_seq.equals("")&&now_person_id.equals("")){
    		now_field_seq = agreeTemplate.getString("agree_field_seq");
    		now_person_id = agreeTemplate.getString("agree_person_id");
    		now_seq = agreeTemplate.getInt("agree_seq");
    	}
    	agreeTemplate.put("agree_status_nm", "");
    	agreeTemplate.put("css", "");
    }
    if(!agreeTemplate.getString("mod_reason").equals("")){
    	agreeTemplate.put("agree_status_nm", agreeTemplate.getString("agree_cd").equals("0")?"수정/반려":agreeTemplate.getString("agree_status_nm"));
    	agreeTemplate.put("agree_status_nm", "<font style='color:#0000ff'>"+agreeTemplate.getString("agree_status_nm")+"</font>");
    	agreeTemplate.put("ag_md_date", "<font style='color:#0000ff'>"+agreeTemplate.getString("ag_md_date")+"</font>");
    	if(!agreeTemplate.getString("agree_cd").equals("0")){
	    	p.setVar("isReject", true);
	        p.setVar("mod_reason", agreeTemplate.getString("mod_reason"));
	        isReject = true;
    	}
    }
    
    // 거래처의 seq
    if(agreeTemplate.getString("agree_cd").equals("0"))
        cust_seq = agreeTemplate.getInt("agree_seq");
}

// 만약 반려상태이면 작성자가 수정할 수 있도록 설정.
if(isReject){
    agreeTemplate.first();
    now_field_seq = agreeTemplate.getString("agree_field_seq");
    now_person_id = agreeTemplate.getString("agree_person_id");
    now_seq = agreeTemplate.getInt("agree_seq");
}





// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust a");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","a.*, (select cust_type from tcb_cont_sign where cont_no = a.cont_no and cont_chasu=a.cont_chasu and sign_seq = a.sign_seq ) cust_type");
if(cust.size()<1){
	u.jsError("계약업체 정보가 존재 하지 않습니다.");
	return;
}

while(cust.next()){
    cust.put("cont_no", u.aseEnc(cust.getString("cont_no")));
	if(cust.getString("member_no").equals(_member_no)&&cust.getString("cust_type").equals("01"))gap_yn = true;
	if(cust.getString("member_no").equals(_member_no)&&cust.getString("pay_yn").equals("Y"))pay_yn = true;
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
DataObject stampDao = new DataObject("tcb_stamp ts left join tcb_member tm on ts.member_no=tm.member_no");
DataSet stamp = stampDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "ts.*, tm.member_name, tm.vendcd");
while(stamp.next()){
    stamp.put("cont_no", u.aseEnc(stamp.getString("cont_no")));
    stamp.put("stamp_money", u.numberFormat(stamp.getDouble("stamp_money"), 0));
    stamp.put("issue_date", u.getTimeString("yyyy-MM-dd", stamp.getString("issue_date")));
    stamp.put("vendcd", u.getBizNo(stamp.getString("vendcd")));
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
}

// 업체별 구비 서류 조회
DataObject rfileDao = new DataObject("tcb_rfile");

//custDao.setDebug(out);
DataSet rfile_cust = custDao.query(
 " select a.*  "
+"   from tcb_cust a, tcb_cont_sign b "
+"  where a.cont_no= b.cont_no  "
+"    and a.cont_chasu = b.cont_chasu "
+"    and a.sign_seq = b.sign_seq  "
+"    and a.cont_no = '"+cont_no+"' "
+"    and a.cont_chasu = '"+cont_chasu+"' "
+"    and a.member_no <>'"+_member_no+"'"
);

while(rfile_cust.next()){
	rfile_cust.put("cont_no", u.aseEnc(rfile_cust.getString("cont_no")));
	rfile_cust.put("attch_area", rfile_cust.getString("member_no").equals(_member_no));

	//rfileDao.setDebug(out);
	DataSet rfile = rfileDao.query(
	 "  select a.attch_yn, a.doc_name, a.rfile_seq,b.file_path, b.file_name, b.file_ext, file_size "
	+"    from tcb_rfile a  "
	+"    left outer join  tcb_rfile_cust b "
	+"      on a.cont_no = b.cont_no  "
	+"     and a.cont_chasu = b.cont_chasu "
	+"     and a.rfile_seq = b.rfile_seq "
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
	//결제 검증
	//요금 정보 조회
	DataObject useInfoDao = new DataObject("tcb_useinfo");
	DataSet useInfo = useInfoDao.find("member_no = '"+_member_no+"' and useseq = (select max(useseq) from tcb_useinfo where member_no = '"+_member_no+"' )");
	if(!useInfo.next()){
	    u.jsError("요금제 정보가 없습니다.");
	    return;
	}
	
	if(useInfo.getString("paytypecd").equals("30")){//건별제
		int pay_money = useInfo.getInt("recpmoneyamt");// 결제금액 
		if(useInfo.getString("instedyn").equals("Y")){
			pay_money += useInfo.getInt("suppmoneyamt");
		}
		if(pay_money> 0 ){
			DataObject payDao = new DataObject("tcb_pay");
			DataSet pay = payDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+_member_no+"'  ");
			if(!pay.next()){
				u.jsError("나이스다큐 이용료 결제 정보가 없습니다.\\b\\b결제 여부를 확인 하세요.");
				return;
			}
		}
	}	
	
	//서명 검증
	String sign_dn = f.get("sign_dn");
	String sign_data = f.get("sign_data");
	String agree_seq = f.get("agree_seq");
	Crosscert crosscert = new Crosscert();
	crosscert.setEncoding("UTF-8");
	
	if (crosscert.chkSignVerify(sign_data).equals("SIGN_ERROR")){
		u.jsError("서명검증에 실패 하였습니다.");
		return;
	}
	if(!crosscert.getDn().equals(sign_dn)){
		u.jsError("서명검증이 DN값이 일지 하지 않습니다.");
		return;
	}

	DB db = new DB();
	//db.setDebug(out);
	custDao = new DataObject("tcb_cust");
	custDao.item("sign_dn", sign_dn);
	custDao.item("sign_data", sign_data);
	custDao.item("sign_date", u.getTimeString());
	db.setCommand( custDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+_member_no+"'"),custDao.record);

	contDao = new ContractDao();
	contDao.item("status", "50");
	db.setCommand(contDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), contDao.record);


    
    if(!agree_seq.equals("")){ // 내부 결재 프로세스가 있는 경우. 최종 서명되었더라도 표시
    
        DataObject agreeDao = new DataObject("tcb_cont_agree");
        agreeDao.item("ag_md_date", u.getTimeString());
        agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
        agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
        db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_seq="+agree_seq),agreeDao.record);
    }

    if( u.inArray(auth.getString("_MEMBER_TYPE"), new String[]{"01","03"})&&!pay_yn){//계약 작성 업체이고 결제 안했을경우

        // 후불인 경우
        if(useInfo.getString("paytypecd").equals("50")){
			DataObject payDao = new DataObject("tcb_pay");
			int iPayAmount = 0;  //결제 금액
			int iVatAmount = 0;
			int iCustNum = 1;
			String payContName = cont.getString("cont_name");
			
			if(useInfo.getString("order_write_type").equals("Y")) { // 수급자마다 결제
				iCustNum = custDao.getOneInt("select count(*) from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq < 10 and member_no <> '"+_member_no+"'");
			}
			
			DataObject useinfoaddDao = new DataObject("tcb_useinfo_add");
			DataSet useInfoAdd = useinfoaddDao.find("template_cd='"+cont.getString("template_cd")+"' and member_no='"+_member_no+"'");
			
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
			payDao.item("cont_no", cont_no);
			payDao.item("cont_chasu", cont_chasu);
			payDao.item("member_no", _member_no);
			payDao.item("cont_name", payContName);
			payDao.item("pay_amount", iPayAmount);
			payDao.item("pay_type", "05");
			payDao.item("accept_date", u.getTimeString());
			payDao.item("receit_type","0");
			db.setCommand(payDao.getInsertQuery(), payDao.record);
			
			//tcb_cust update
			custDao = new DataObject("tcb_cust");
			custDao.item("pay_yn", "Y");
			db.setCommand(custDao.getUpdateQuery("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no= '"+_member_no+"' "),custDao.record);
		}
    }

    /* 계약로그 START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자서명 완료",  "", "50","10");
	/* 계약로그 END*/

    if(!db.executeArray()){
        u.jsError("서명 저장에 실패 하였습니다.");
        return;
    }

    // 이메일 알림(계약 상대방 업체).
    String from_member_name = "";
    String to_member_names = "";
    String from_email = "";
    
    //이름 만들기
    cust.first();
    while(cust.next()){
        if(cust.getString("member_no").equals(_member_no)){
            from_member_name = cust.getString("member_name");
            from_email = cust.getString("email");
        }else{
        	if(to_member_names.equals("")) to_member_names="/";
            to_member_names += cust.getString("member_name");
        }
    }
    
    //전송시작
    String rtn_url = "web/buyer/";
    cust.first();
    while(cust.next()){
    	rtn_url = "web/buyer/";
    	if(cust.getString("email").equals("")||cust.getString("member_no").equals(_member_no)) continue;
        p.clear();
        p.setVar("from_member_name", from_member_name);
        p.setVar("to_member_name", to_member_names);
        p.setVar("cont_name", cont.getString("cont_name"));
        p.setVar("cont_date", u.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));
        p.setVar("ret_url", rtn_url);
        u.mail(cust.getString("email"), "[계약 체결 알림] " +  cont.getString("cont_name") + " 계약이 체결 되었습니다.", p.fetch("../html/mail/cont_finish_mail.html"));
    }

    // 내부결제가 있는 경우 이메일로 계약담당자에게 승인알림과 나이스다큐 계약번호 + 계약서PDF링크를 보내준다.
    if(!agree_seq.equals("")){
        if(!cont.getString("reg_id").equals("mns1082074")){ // kt m&s 이은화 대리, 너무 메일이 많이 와서 보내지 않음
            p.clear();
            p.setVar("from_member_name", from_member_name);
            p.setVar("to_member_name", to_member_names);
            p.setVar("cont_name", cont.getString("cont_name"));
            p.setVar("cont_date", u.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));
            p.setVar("ret_url", "web/buyer/");
            p.setVar("copy_url","web/buyer/contract/cin.jsp?key=" + u.aseEnc(cont_no+cont_chasu));
            p.setVar("manage_no", cont_no + "-" + cont_chasu + "-" + cont.getString("true_random"));
            String mail_body =  p.fetch("../html/mail/cont_finish_link_mail.html");
            u.mail(from_email, "[계약 체결 알림] " +  cont.getString("cont_name") + " 계약이 체결 되었습니다.", mail_body);
        }
    }
    
    u.jsErrClose("서명 저장 하였습니다.\\n\\n계약이 완료 되었습니다.\\n\\n완료된 계약건은 계약완료>완료(보낸계약)에서 확인 하실 수 있습니다.");
    return;
}
p.setLayout("popup");
//p.setDebug(out);
p.setBody("cont_pop.contract_free_sendview_pop");
p.setVar("menu_cd","000060");
p.setVar("auth_select", u.request("view_readonly").equals("Y")?true:_authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), "000060", "btn_auth", cont.getString("field_seq")).equals("10"));
p.setVar("popup_title","진행중(보낸계약)");
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("gap_yn",gap_yn);
p.setVar("kakao", bIsKakao);
p.setVar("cont", cont);

if(agreeTemplate.size() > 0)
{
	total_seq = agreeTemplate.size();
/*
	u.p("total_seq : " + total_seq);
	u.p("cust_seq : " + cust_seq);
	u.p("now_seq : " + now_seq);
	u.p("now_field_seq : " + now_field_seq + " / login_field : " + auth.getString("_FIELD_SEQ"));
	u.p("now_person_id : " + now_person_id + " / login_person : " + auth.getString("_USER_ID"));
	u.p("reg_id : " + cont.getString("reg_id"));
*/

	boolean bFieldEqual = false;
	boolean bPersonEqual = false;
	if(now_person_id.equals("")) // 부서원이면 누구나
		bPersonEqual = true;
	else if(now_person_id.equals(auth.getString("_USER_ID"))) // 로그인한 사람과 동일해야만
		bPersonEqual = true;

	if(now_field_seq.equals(auth.getString("_FIELD_SEQ")))	// 로그인한 사람과 같은부서
		bFieldEqual = true;

	/*
	u.p("now_field_seq : " + now_field_seq);
	u.p("_FIELD_SEQ : " + auth.getString("_FIELD_SEQ"));
	u.p("bFieldEqual : " + bFieldEqual);
	u.p("bPersonEqual : " + bPersonEqual);
	*/
	
	if(now_person_id.equals("")?bFieldEqual:bPersonEqual && !u.inArray(cont.getString("status"),new String[]{"41"}))  //41 : 반려
	{

	//u.p("now_seq : " + now_seq);
	//u.p("cust_seq : " + cust_seq);

		if(now_seq == (cust_seq-1)) // 업체에게 전송 직전
		{
			p.setVar("send_able", true);  // 업체에 전송
			p.setVar("towriter_reject_able", true);  // 작성자에게 반려
		}
		else if(now_seq == total_seq)  // 최종 서명자
		{
			if(_member_no.equals("20150500217") && cont.getString("template_cd").equals("2015068"))  // CJ올리브네트웍스 행사참여요청서.
				p.setVar("direct_able", true);	// 서명하지 않고 확인만으로 완료
			else
				p.setVar("sign_able", true);	// 서명
			p.setVar("tocust_reject_able", true);  // 업체에게 반려
			if(_member_no.equals("20171101813"))  // 에스케이브로드밴드
				p.setVar("towriter_reject_able", true);  // 작성자에게 반려			
		}
		else if(now_seq >= (cust_seq+1) && now_seq < total_seq && !cont.getString("status").equals("20") ) // 업체서명 다음이고 서명자가 아닌 검토인 경우 ( 업체서명->검토자(O)->서명자 )
		{
			p.setVar("agree_able", true);   // 검토승인
			p.setVar("tocust_reject_able", true);  // 업체에게 반려
			if(_member_no.equals("20171101813"))  // 에스케이브로드밴드
				p.setVar("towriter_reject_able", true);  // 작성자에게 반려
		}
		else 
		{
			if(cont.getString("status").equals("20")){ 
				p.setVar("agree_able", false);   // 검토승인
			}else{ // 
				p.setVar("agree_able", true);   // 검토승인
				p.setVar("towriter_reject_able", true);  // 작성자에게 반려
			}
		}

	}
	if(now_seq == cust_seq)
		p.setVar("send_cancel", cont.getInt("sign_cnt")==0&&cont.getString("status").equals("20"));// 서명 한 사람 없을경우만 전송 취소 가능

	if(isReject) // 내부반려
	{
		p.setVar("send_able", false);  // 업체에 전송
		if(cont.getString("reg_id").equals(auth.getString("_USER_ID"))) 
		{
			p.setVar("modify_able", true);   // 계약서수정
		}
	}

	if(!isReject && cont.getString("reg_id").equals(auth.getString("_USER_ID")) ) // 내부 반려 아니지만 업체 수정요청이면
		p.setVar("return_able", u.inArray(cont.getString("status"),new String[]{"40"}));// 수정요청이면 수정가능
		//p.setVar("return_able", u.inArray(cont.getString("status"),new String[]{"40","21","30"}));// 수정요청(40),승인대기(21),서명대기(30) 이면 수정가능

	if(!isReject && last_person_id.equals(auth.getString("_USER_ID")) && now_seq != cust_seq)	// 마지막 승인자이고 업체 서명차례가 아니라면 '승인 취소'할 수 있다.
		p.setVar("agree_cancel", true);

	p.setVar("agree_seq", now_seq);
}
else
{

	p.setVar("send_cancel", cont.getInt("sign_cnt")==0&&cont.getString("status").equals("20"));// 서명 한 사람 없을경우만 전송 취소 가능
	p.setVar("return_able", u.inArray(cont.getString("status"),new String[]{"40","30"}));// 수정요청이면 반려가능
	p.setVar("sign_able", cont.getInt("unsign_cnt")==1);// 타사 서명 완료 후 서명 가능
}

p.setVar("file_path", file_path);
p.setLoop("sign_template", signTemplate);
p.setLoop("agreeTemplate", agreeTemplate);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("warr", warr);
p.setLoop("stamp", stamp);
p.setLoop("rfile_cust", rfile_cust);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>