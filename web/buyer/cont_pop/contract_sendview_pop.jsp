<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ include file="../contract/include_cont_push.jsp" %>
<%
String[] server_cert_member = {"20171101813"};//에스케이스토아
String[] server_cert_passwd = {"20171101813=>skstoa2018!"}; 
boolean serverSign = u.inArray(_member_no, server_cert_member); 

String key = u.request("key");

String contstr = u.aseDec(key);  // 디코딩
if(contstr.length() != 12)
{
	out.print("No Permission!!");
	return;
}
String cont_no = contstr.substring(0,11);
String cont_chasu = contstr.substring(11);

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

String file_path = "";
boolean gap_yn = false;// 로그인한 업체가갑인지 여부 cust_type == "01" 이면 갑이다.
boolean pay_yn = false;// 로그인한 업체의 결제 여부 (작성중으로 돌릴 경우 기결제 되어 있다.)

boolean bIsKakao = u.inArray(_member_no, new String[]{"20130900194"});
DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("사용자 정보가 존재하지 않습니다.");
	return;
}


CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_change_gubun = codeDao.getCodeArray("M010");
String[] code_auto_type = {"=>자동생성","1=>자동첨부","2=>필수첨부","3=>내부용"};

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and status in ('11','12','20','21','30','40','41') ",
 "tcb_contmaster.*"
+" ,(select user_name from tcb_person where user_id = tcb_contmaster.reg_id ) writer_name "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is not null ) sign_cnt "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null  ) unsign_cnt "
+" ,(select member_name from tcb_member where member_no = tcb_contmaster.mod_req_member_no ) mod_req_name "
);
if(!cont.next()){
	u.jsError("계약정보가 존재 하지 않습니다.");
	return;
}
cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
cont.put("cont_date",u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
cont.put("status_name", u.getItem(cont.getString("status"),code_status));
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
cont.put("reg_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("reg_date")));
cont.put("change_gubun_str", u.getItem(cont.getString("change_gubun"), code_change_gubun) + (_member_no.equals("20150500217") ? "" : "("+cont_chasu+"차)"));
if(bIsKakao) {
	if(cont.getString("cont_etc2").equals("on"))
		cont.put("cont_etc2", "▣ 양도 및 종료 계약");
	else
		cont.put("cont_etc2", "□ 양도 및 종료 계약 아님");

	cont.put("cont_etc3", u.nl2br(cont.getString("cont_etc3")));
}

// 추가 계약서 조회
DataObject contSubDao = new DataObject("tcb_cont_sub");
DataSet contSub = contSubDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and (gubun <> '40' or (gubun = '40' and option_yn in ('A','Y')))");
while(contSub.next()){
    contSub.put("cont_no", u.aseEnc(contSub.getString("cont_no")));
	contSub.put("hidden", u.inArray(contSub.getString("gubun"), new String[]{"20","30"}));
}

// 서식정보 조회
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find("template_cd ='"+cont.getString("template_cd")+"'");
if(!template.next()){
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

//만약 반려상태이면 작성자가 수정할 수 있도록 설정.
if(isReject){
 agreeTemplate.first();
 now_field_seq = agreeTemplate.getString("agree_field_seq");
 now_person_id = agreeTemplate.getString("agree_person_id");
 now_seq = agreeTemplate.getInt("agree_seq");
}

// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust a");
DataSet cust = custDao.find(
        " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq <= 10"
        ,"a.*, (select cust_type from tcb_cont_sign where cont_no = a.cont_no and cont_chasu=a.cont_chasu and sign_seq = a.sign_seq ) cust_type"
        ,"a.display_seq asc"
);
if(cust.size()<1){
    u.jsError("계약업체 정보가 존재 하지 않습니다.");
    return;
}
while(cust.next()){
	
    cust.put("cont_no", u.aseEnc(cust.getString("cont_no")));
    if(cust.getString("member_no").equals(_member_no)&&cust.getString("cust_type").equals("01")) {
        gap_yn = true;
    }
    if(cust.getString("member_no").equals(_member_no)&&cust.getString("pay_yn").equals("Y"))pay_yn = true;
    if(!cust.getString("sign_dn").equals("")) {
        cust.put("sign_str", "서명일시: <b style=color:blue>" + u.getTimeString("yyyy-MM-dd HH:mm:ss", cust.getString("sign_date")) + "</b>");
    } else {
        if(template.getString("doc_type").equals("2") && cust.getString("sign_seq").equals("1")) {
            cust.put("sign_str", "");
        } else {
            cust.put("sign_str", "서명일시: <b style=color:red>미서명</b>");
        }
    }
}


// 연대보증 업체
DataObject custChainDao = new DataObject("tcb_cust");
DataSet cust_chain = custChainDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq > 10","*");
while(cust_chain.next()){
    cust_chain.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust_chain.getString("sign_date")));
}


//계약서류 조회
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
    if(cfile.getString("cfile_seq").equals("1")){
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
                +"    and b.cust_type <> '01' "
                +"  order by a.cont_no asc, a.cont_chasu asc, a.sign_seq asc "
);
while(rfile_cust.next()){
    rfile_cust.put("cont_no", u.aseEnc(rfile_cust.getString("cont_no")));

	String rfile_query = "";
	if(rfile_cust.getString("sign_seq").equals("2")){
		rfile_query =	 "  select a.attch_yn, a.doc_name, a.rfile_seq, a.allow_ext,b.file_path, b.file_name, b.file_ext, b.file_size,  b.member_no"
						+"    from tcb_rfile a  "
						+"    left outer join  tcb_rfile_cust b "
						+"      on a.cont_no = b.cont_no  "
						+"     and a.cont_chasu = b.cont_chasu "
						+"     and a.rfile_seq = b.rfile_seq "
						+"     and b.member_no in ('"+rfile_cust.getString("member_no")+"', '"+cont.getString("member_no")+"'  )"
						+"   where  a.cont_no = '"+cont_no+"'  "
						+"     and a.cont_chasu = '"+cont_chasu+"' " ;
	}else{
		rfile_query =	 "  select a.attch_yn, a.doc_name, a.rfile_seq, a.allow_ext,b.file_path, b.file_name, b.file_ext, b.file_size,  b.member_no"
						+"    from tcb_rfile a  "
						+"    left outer join  tcb_rfile_cust b "
						+"      on a.cont_no = b.cont_no  "
						+"     and a.cont_chasu = b.cont_chasu "
						+"     and a.rfile_seq = b.rfile_seq "
						+"     and b.member_no = '"+rfile_cust.getString("member_no")+"' "
						+"   where  a.cont_no = '"+cont_no+"'  "
						+"     and a.cont_chasu = '"+cont_chasu+"' " ;
	}

	//rfileDao.setDebug(out);
	DataSet rfile = rfileDao.query(rfile_query);
	while(rfile.next()){
		rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
		rfile.put("file_size", u.getFileSize(rfile.getLong("file_size")));
	}
	rfile_cust.put(".rfile",rfile);
}


//내부 관리 서류 조회
String[] code_reg_type = {"10=><span class='caution-text'>필수첨부</span>","20=>선택첨부","30=>추가첨부"};
DataObject efileDao = new DataObject("tcb_efile");
DataSet efile = new DataSet();
if(cont.getString("efile_yn").equals("Y")){
    efile = efileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
    while(efile.next()){
        efile.put("str_reg_type", u.getItem(efile.getString("reg_type"), code_reg_type));
        efile.put("required", u.inArray(efile.getString("reg_type"), new String[]{"10","30"})?"required='Y'":"");
        efile.put("doc_name_readonly", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"readonly":"");
        efile.put("doc_name_class", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"in_readonly":"label");
        efile.put("del_yn10", efile.getString("reg_type").equals("10")&&!efile.getString("file_name").equals(""));
        efile.put("del_yn20", efile.getString("reg_type").equals("20")&&!efile.getString("file_name").equals(""));
        efile.put("del_yn30", efile.getString("reg_type").equals("30"));
        efile.put("file_size_str", u.getFileSize(efile.getInt("file_size")));
        efile.put("down_script","filedown('file.path.bcont_pdf','"+efile.getString("file_path")+efile.getString("file_name")+"','"+efile.getString("doc_name")+"."+efile.getString("file_ext")+"')");
    }
}

if(u.isPost()&&f.validate()){
	
	//서명 검증
	Crosscert crosscert = new Crosscert();
	crosscert.setEncoding("UTF-8");
	
	String sign_dn;
	String sign_data;
	String agree_seq;
	
	if(serverSign){ //서버 서명
		
		int i;
		
		for( i=0; i<server_cert_member.length; i++){
			if(server_cert_member[i].equals(_member_no)){
				break;
			}
		}
		
		//DataSet signDs = crosscert.serverSign(server_cert_member[i], server_cert_passwd[i], f.get("cont_hash"));
		DataSet signDs = crosscert.serverSign(_member_no, u.getItem(_member_no, server_cert_passwd), f.get("cont_hash"));

		if(!"".equals(signDs.getString("err"))){
			u.jsError("계약서 서명에 실패하였습니다.\\n\\n"+signDs.getString("err"));
			return;
		}
		
		sign_dn = signDs.getString("signDn");
		sign_data = signDs.getString("signData");
		
		if("".equals(sign_dn) || "".equals(sign_data)){
			u.jsError("전자서명에 필요한 데이터를 찾을 수 없습니다.\\n\\n관리자에게 문의 바랍니다.");
			return;
		}

	}else{ //클라이언트 서명
		sign_dn = f.get("sign_dn");
		sign_data = f.get("sign_data");
	}

	agree_seq = f.get("agree_seq");

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

	if(cont.getString("change_gubun").equals("90")){
		contDao = new ContractDao();
		contDao.item("status", "91");
		db.setCommand(contDao.getUpdateQuery("cont_no='"+cont_no+"'"), contDao.record);
	}

    
    if(!agree_seq.equals("")){ // 내부 결재 프로세스가 있는 경우. 최종 서명되었더라도 표시
    
        DataObject agreeDao = new DataObject("tcb_cont_agree");
        agreeDao.item("ag_md_date", u.getTimeString());
        agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
        agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
        db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_seq="+agree_seq),agreeDao.record);
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
    	if(template.getString("sign_type").equals("10")){
    		rtn_url = "web/buyer/sdd/email_callback.jsp?cont_no="+u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+cust.getString("email_random");
    	}else{
    		rtn_url = "web/buyer/";
    	}
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

            // LG히타치는 일부 담당자에게도 알림
            if(_member_no.equals("20160401012")) {
                if(!from_email.equals("hyojin94.kim@lge.com"))u.mail("sungjin8969.kim@lge.com", "[계약 체결 알림] " +  cont.getString("cont_name") + " 계약이 체결 되었습니다.", mail_body);  // 김성진 사원
                if(!from_email.equals("yoojin.han@lge.com"))u.mail("yoojin.han@lge.com", "[계약 체결 알림] " +  cont.getString("cont_name") + " 계약이 체결 되었습니다.", mail_body);  // 한유진 부장
            }
        }
    }

	//계약서 push 
	if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK스토아, 에스케이브로드밴드일 경우
		DataSet result = contPush_skstoa(cont_no, cont_chasu);//계약완료 push
		if(!result.getString("succ_yn").equals("Y")){
			u.sp(" skstore 계약정보 전송 실패!!!\npage:contract_send_view_pop.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
			u.mail("nicedocu@nicednr.co.kr","skstore 계약정보 전송 실패!!! ", " skstore 계약정보 전송 실패!!!\npage:contract_send_view_pop.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		}
	}

	u.jsErrClose("서명 저장 하였습니다.\\n\\n계약이 완료 되었습니다.\\n\\n완료된 계약건은 계약완료>완료된계약에서 확인 하실 수 있습니다.");
	return;
}
    
p.setLayout("popup");
//p.setDebug(out);
p.setBody("cont_pop.contract_sendview_pop");
p.setVar("menu_cd","000060");
p.setVar("auth_select",u.request("view_readonly").equals("Y")?true:_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000060", "btn_auth").equals("10"));
p.setVar("popup_title","진행중(보낸계약)");
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("change_cont", Integer.parseInt(cont_chasu)>0);
p.setVar("gap_yn",gap_yn);
p.setVar("cont", cont);
p.setLoop("contSub", contSub);

if(agreeTemplate.size() > 0)
{
	total_seq = agreeTemplate.size();

	boolean bFieldEqual = false;
	boolean bPersonEqual = false;
	if(now_person_id.equals(auth.getString("_USER_ID"))||"Y".equals(auth.getString("_DEFAULT_YN"))) // 로그인한 사람과 동일해야만//전체관리자도 추가 유팀장님지시?//20181206
		bPersonEqual = true;

	if(now_field_seq.equals(auth.getString("_FIELD_SEQ"))||"Y".equals(auth.getString("_DEFAULT_YN")))	// 로그인한 사람과 같은부서
		bFieldEqual = true;

	/* u.p("now_field_seq : " + now_field_seq);
	u.p("now_person_id : " + now_person_id);
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
p.setVar("template", template);
p.setLoop("sign_template", signTemplate);
p.setLoop("agreeTemplate", agreeTemplate);
p.setLoop("cust", cust);
if(cust_chain.size()>0) p.setLoop("cust_chain", cust_chain);
p.setLoop("cfile", cfile);
p.setLoop("warr", warr);
p.setLoop("stamp", stamp);
p.setLoop("rfile_cust", rfile_cust);
p.setLoop("efile", efile);
p.setVar("kakao", bIsKakao);
p.setVar("serverSign", serverSign);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>