<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ include file="../contract/include_cont_func.jsp" %>
<%@page import="org.jsoup.Jsoup"%>
<%@page import="org.jsoup.nodes.Document"%>
<%@page import="org.jsoup.nodes.Element"%>
<%
String cont_no = u.aseDec(f.get("cont_no"));
String cont_chasu = f.get("cont_chasu","0");
String _member_no = f.get("sign_member_no");
String sign_dn = f.get("sign_dn");//본인인증 CI
String sign_data = f.get("sign_data");//본인인증 문자열
String email_random = u.request("email_random");
if(cont_no.equals("")||cont_chasu.equals("")||_member_no.equals("")||sign_dn.equals("")||sign_data.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}


ContractDao contDao = new ContractDao("tcb_contmaster");
DataSet cont = contDao.query("select a.* from tcb_contmaster a, tcb_cont_template b "
		+ "where a.template_cd=b.template_cd "
		+ "and a.status in ('20','30','40','41') "
		+ "and b.send_type='20' "
		+ "and a.cont_no='"+cont_no+"' and a.cont_chasu='"+cont_chasu+"' ");
if(!cont.next()){
	u.jsError("계약정보가 존재 하지 않습니다.");
	return;
}

DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template = templateDao.find(" status > 0 and template_cd ='"+cont.getString("template_cd")+"'");
if(!template.next()){
	u.jsError("계약서 양식이 존재 하지 않습니다.");
	return;
}

DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(" cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' and member_no = '"+_member_no+"' " );
if(!cust.next()){
	u.jsError("서명 관계자가 아닙니다.");
	return;
}

DataObject contEmailDao = new DataObject("tcb_cont_email");
DataSet contEmail = contEmailDao.find(" cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' and member_no = '"+_member_no+"' ");

//본인확인 정보
DataSet identify = u.json2Dataset(new String(Base64Coder.decode(f.get("sign_data")), "UTF-8"));
if(!identify.next()){
}
  

if(u.isPost()){
	if(!cont.getString("status").equals("20")){//모바일 이양식 다시 보내기 방지
		u.jsError("서명요청 상태에서만 계약서 서명 가능 합니다.");
		return;
	}
	//계약서 저장
	String file_hash = "";
	DataSet imgHash = new DataSet();
	DataSet contHash = new DataSet();

	String[] sign_img_data = f.getArr("sign_img_data");
	String[] sign_object_name = f.getArr("sign_object_name");
	
	DataSet custSignImg = new DataSet();
	for(int i = 0 ; i< sign_img_data.length;i++){
		custSignImg.addRow();
		
		String encode_image = sign_img_data[i].split(",")[1];
		byte[] decode_image = Base64Coder.decode(encode_image);
		String img_hash = contDao.getHash(decode_image);
		 
		custSignImg.put("object_name",sign_object_name[i]);
		custSignImg.put("img_data", sign_img_data[i]);
		custSignImg.put("img_hash", img_hash);
		imgHash.addRow();
		imgHash.put(sign_object_name[i],img_hash);
	}
	
	
	 
	contDao = new ContractDao();

	String cont_html_rm_str = "";
	String[] cont_html_rm = f.getArr("cont_html_rm");
	String[] cont_html = f.getArr("cont_html");
	String[] cont_sub_name = f.getArr("cont_sub_name");
	String[] gubun = f.getArr("gubun");
	String[] sub_seq = f.getArr("sub_seq");
	 
	// 서명 이미지 공백으로 인한 리턴.
	String img_ret =  new String(Base64Coder.decode(cont_html[0]),"UTF-8");
	if(img_ret.contains("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAAAyCAYAAACqNX6+AAAAKklEQVR42u3BAQ0AAADCoPdPbQ43oAAAAAAAAAAAAAAAAAAAAAAAAAD4NE5SAAG30DXzAAAAAElFTkSuQmCC")){
		System.out.println("서명이미지 공백으로 인한 리턴 :" + cont_no);
		u.jsError("계약서 서명 중 오류가 발생하였습니다.\n다시 진행해 주세요.");
		return;
	} 
	
	//decodeing 처리 START
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		cont_html_rm[i] = new String(Base64Coder.decode(cont_html_rm[i]),"UTF-8");
	}
	for(int i = 0 ; i < cont_html.length; i ++){
		cont_html[i] =  new String(Base64Coder.decode(cont_html[i]),"UTF-8");
	}
	//decodeing 처리 END
  	for(int i = 0 ; i < cont_html_rm.length; i ++){
		if(i != 0)
			cont_html_rm_str += "<pd4ml:page.break>";
		if(gubun[i].equals("10")){
			cont_html_rm_str += cont_html_rm[i];
		}
	}
  	
	ArrayList autoFiles = new ArrayList();

	int file_seq = 1;

	// 계약서파일 생성
	DataSet pdfInfo = new DataSet();
	pdfInfo.addRow();
	pdfInfo.put("member_no",cont.getString("member_no"));
	pdfInfo.put("cont_no", cont_no);
	pdfInfo.put("cont_chasu", cont_chasu);
	pdfInfo.put("random_no", cont.getString("true_random"));
	pdfInfo.put("cont_userno", f.get("cont_userno"));
	pdfInfo.put("html", cont_html_rm_str);
	pdfInfo.put("file_seq",file_seq++);
	DataSet pdf = contDao.makePdf(pdfInfo);
	if(pdf==null){
		u.jsError("계약서 파일 생성에 실패 하였습니다.");
		return;
	}
	file_hash = pdf.getString("file_hash");
	
	//자동생성파일 생성
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		if(    gubun[i].equals("20")
				|| ( gubun[i].equals("40") ) // 자동으로 생성되는 양식 또는 체크된 양식인 경우
			  )
		{
			DataSet pdfInfo2 = new DataSet();
			pdfInfo2.addRow();
			pdfInfo2.put("member_no",cont.getString("member_no"));
			pdfInfo2.put("cont_no", cont_no);
			pdfInfo2.put("cont_chasu", cont_chasu);
			pdfInfo2.put("random_no", cont.getString("true_random"));
			pdfInfo2.put("html", cont_html_rm[i]);
			pdfInfo2.put("file_seq", file_seq++);
			DataSet pdf2 = contDao.makePdf(pdfInfo2);
			pdf2.put("cont_sub_name", cont_sub_name[i]);
			autoFiles.add(pdf2);
		}
	}

	DB db = new DB();
	
	DataObject memberDao = new DataObject("tcb_member");
	DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
	if(!member.next()){//회원정보가 없을경우 개인 밖에 없다.
		
		String member_no = "";
		/* 회원정보 입력 START*/
		DataObject memberBossDao = new DataObject("tcb_member_boss");
		DataSet memberBoss = memberBossDao.query(
			   " select b.* "
			  +"   from tcb_member a, tcb_member_boss b "
			  +"  where a.member_no = b.member_no "
			  +"    and a.member_gubun = '04' "
			  +"    and b.boss_ci = '"+identify.getString("sConnInfo")+"' " 
				);
		if(memberBoss.next()){
			member_no = memberBoss.getString("member_no"); 
		}else{
			member_no = memberDao.getOne(
					" SELECT MAX(MEMBER_NO) AS MEMBER_NO FROM( "
				   +	" SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(SUBSTR(member_no, 7)), 0) + 1),5,'0' ) member_no "
				   +	" FROM TCB_MEMBER WHERE  member_no like '" + u.getTimeString("yyyyMM") + "%' "
				   +	" UNION "
				   +	" SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(SUBSTR(member_no, 7)), 0) + 1),5,'0' ) member_no "
				   +	" FROM IF_MMBAT100 WHERE  member_no like '" + u.getTimeString("yyyyMM") + "%' "
				   +")"
			    );	
			
			memberDao.item("member_no", member_no);
			memberDao.item("member_name", cust.getString("member_name"));
			memberDao.item("vendcd", cust.getString("vendcd"));
			memberDao.item("member_gubun", "04");//신규입력은 개인만 한다.
			memberDao.item("member_type", "02");
			memberDao.item("boss_name", cust.getString("boss_name"));
			memberDao.item("post_code", cust.getString("post_code"));
			memberDao.item("address", cust.getString("address"));
			memberDao.item("member_slno", cust.getString("member_slno"));
			memberDao.item("status", "02");
			db.setCommand(memberDao.getInsertQuery(), memberDao.record);
			
			DataObject personDao = new DataObject("tcb_person");
			personDao.item("member_no", member_no);
			personDao.item("person_seq","1");
			personDao.item("user_name", cust.getString("user_name"));
			personDao.item("hp1", cust.getString("hp1"));
			personDao.item("hp2", cust.getString("hp2"));
			personDao.item("hp3", cust.getString("hp3"));
			personDao.item("email", cust.getString("email"));
			personDao.item("default_yn", "Y");
			personDao.item("reg_date", u.getTimeString());
			personDao.item("reg_id", "");
			personDao.item("use_yn", "Y");
			personDao.item("status", "10");
			db.setCommand(personDao.getInsertQuery(), personDao.record);
		}
		
		//email 정보 삭제
		if(contEmail.size()>0){
			db.setCommand("delete from tcb_cont_email where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and  member_no = '"+_member_no+"' ", null);
		}
		
		custDao = new DataObject("tcb_cust");
		custDao.item("member_no", member_no);
		db.setCommand(custDao.getUpdateQuery("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and  member_no = '"+_member_no+"' "), custDao.record);

		DataObject rfileCustDao = new DataObject("tcb_rfile_cust");
		rfileCustDao.item("member_no", member_no);
		db.setCommand(rfileCustDao.getUpdateQuery("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and  member_no = '"+_member_no+"' "), rfileCustDao.record);

		
		contEmail.first();
		while(contEmail.next()){
			contEmail.put("member_no", member_no);
			Hashtable row =contEmail.getRow();
			row.remove("__ord");
			row.remove("__last");
			
			contEmailDao = new DataObject("tcb_cont_email");
			contEmailDao.item(row);
			db.setCommand(contEmailDao.getInsertQuery(), contEmailDao.record);
		}
		
		
		_member_no = member_no;//회원번호 신규 체번 번호로 변경
	}
	
	DataObject memberBossDao = new DataObject("tcb_member_boss");
	DataSet memberBoss = memberBossDao.find("member_no = '"+_member_no+"' ");
	if(!memberBoss.next()){
		memberBossDao.item("member_no", _member_no);
		memberBossDao.item("seq", "1");
		memberBossDao.item("boss_name", cust.getString("boss_name"));
		memberBossDao.item("boss_birth_date", cust.getString("boss_birth_date"));
		memberBossDao.item("boss_gender", identify.getString("sGender").equals("1")?"남":"여");
		memberBossDao.item("boss_hp1", cust.getString("hp1"));
		memberBossDao.item("boss_hp2", cust.getString("hp2"));
		memberBossDao.item("boss_hp3", cust.getString("hp3"));
		memberBossDao.item("boss_email", cust.getString("email"));
		memberBossDao.item("boss_ci", identify.getString("sConnInfo"));
		memberBossDao.item("ci_date", u.getTimeString());
		memberBossDao.item("status","10");
		db.setCommand(memberBossDao.getInsertQuery(), memberBossDao.record);
	}
	
	
	DataObject clientDao = new DataObject("tcb_client");
	if(clientDao.findCount(" member_no = '"+cont.getString("member_no")+"' and client_no = '"+_member_no+"' ")<1){
		int client_seq = clientDao.getOneInt(" select nvl(max(client_seq),0)+1 from tcb_client where member_no='"+cont.getString("member_no")+"' ");
		clientDao.item("member_no", cont.getString("member_no"));
		clientDao.item("client_seq", client_seq);
		clientDao.item("client_no",  _member_no);
		clientDao.item("client_reg_cd", "1");
		clientDao.item("client_reg_date", u.getTimeString());
		db.setCommand(clientDao.getInsertQuery(),clientDao.record);
	}
	
	/* 회원정보 입력 END*/
	
	// 추가계약서 html 수정
	for(int i = 1 ; i < cont_html.length; i++) {
		DataObject cont_sub = new DataObject("tcb_cont_sub");
		cont_sub.item("cont_sub_html",cont_html[i]); 
		db.setCommand(cont_sub.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sub_seq = " + sub_seq[i]), cont_sub.record);
	}
	
	if(cont.getString("template_cd").equals("2019211")){ // 우아한청년들 > 특정 서식에서 "을"이 입력한 값 db화 시키기   
		// 계약서 추가 입력정보 (DB화하여 검색이 필요한 경우)
		DataObject tempaddDao = new DataObject("tcb_cont_template_add"); 
		DataSet tempaddDs = tempaddDao.find("template_cd ='2019211' ");
		db.setCommand("delete from tcb_cont_add where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", null);
		
		if(tempaddDs.size()>0){
			DataObject contaddDao = new DataObject("tcb_cont_add"); // Array가 아닌 데이터는 복수인 데이터.
			contaddDao.item("cont_no", cont_no);
			contaddDao.item("cont_chasu", cont_chasu);
			contaddDao.item("seq", 1);

			while(tempaddDs.next()){
				if(tempaddDs.getString("mul_yn").equals("Y")) { // 복수
					String[] colVals = f.getArr(tempaddDs.getString("template_name_en"));
					String colVal = "";
					for(int i=0; i<colVals.length; i++) {
						colVal += colVals[i] + "|";
					}
					contaddDao.item(tempaddDs.getString("col_name"), colVal);
				} else { // 단수
					contaddDao.item(tempaddDs.getString("col_name"), f.get(tempaddDs.getString("template_name_en")));
				}
				
			}
			db.setCommand(contaddDao.getInsertQuery(), contaddDao.record);
		}
	} 
	
	//계약서류갑지
	int cfile_seq_real = 1;
	db.setCommand("delete from tcb_cfile where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and auto_yn = 'Y' ",null);
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
	cfileDao.item("auto_type","");
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
		cfileDao.item("auto_type","");
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
		file_hash+="|"+temp.getString("file_hash");
	}
	
	DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and auto_yn='N'");
	while(cfile.next()){
		file_hash +="|"+contDao.getHash("file.path.bcont_pdf",cfile.getString("file_path")+cfile.getString("file_name"));
	}

	contHash.addRow();
	contHash.put("file_hash", file_hash);
	contHash.put("img_data", imgHash);
	String cont_hash = u.loop2json(contHash);
	//hash값 base64인코딩
	System.out.println(" --------------email_contract_msign_recvview_save.jsp hash check start---------------------------");
	System.out.println(" cont_no ->  "+cont_no+"-"+cont_chasu);
	System.out.println(" cont_hash ->  "+cont_hash);
	System.out.println(" --------------email_contract_msign_recvview_save.jsp hash check end---------------------------");
	cont_hash = Base64Coder.encodeString(cont_hash);

	
	//TSA요청
	// TODO : 임시로 주석, 확인 후 복원 등 필요함
	/*Tsa tsa = new Tsa();
	DataSet tsa_return = tsa.tsaRequest(cont_hash);

	if(tsa_return!=null) {
		identify.put("user_agent",request.getHeader("User-Agent").toLowerCase());
		identify.put("tsa_gentime", tsa_return.getString("gentime"));
		identify.put("tsa_hashvalue", tsa_return.getString("hashvalue"));
		identify.put("tsa_serialnumber", tsa_return.getString("serialnumber"));
		sign_data = Util.loop2json(identify);
	} else {
		u.jsError("TSA에러");
		return;
	}
	//TSA 이력등록
	IdentifyDao identifyDao = new IdentifyDao();
	identifyDao.setInsert("TSA", cont_no, cont_chasu, _member_no, Util.loop2json(tsa_return), "TSA 요청");*/
	
	// 내부 결제자가 있는 경우
	DataObject agreeDao = new DataObject("tcb_cont_agree");
	int nagreeCnt = agreeDao.findCount(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd = '2'");  // 업체 서명 후 승인자들 수
	
	
	String status = cont.getString("status");
	if(nagreeCnt > 1){
		status = "21";  // 서명자 포함 2명이상이면 승인대기
	}else{
		// B2C 근로자 서명완료 시 status = 50
		status = "50";  // 서명완료
		/* if(template.getString("doc_type").equals("2")){ // 업체서명 후 계약완료
			status = "50";  // 서명완료
		}else{
			status = "30";  // 서명대기
		} */
	}
	
	//계약기간구하기
	String cont_year = f.get("cont_year");
	String cont_month = f.get("cont_month");
	String cont_day = f.get("cont_day");
	String cont_date = "";
	if(cont_year.length()==4 &&!cont_month.equals("")&&!cont_day.equals("")){
		cont_date = cont_year+u.strrpad(cont_month,2,"0")+u.strrpad(cont_day,2,"0");
	}

	// 계약서 html 수정
	contDao = new ContractDao();
	
	contDao = new ContractDao("tcb_contmaster");
	if(!cont_date.equals("")){
		contDao.item("cont_date",cont_date);
		cont.put("cont_date", cont_date);
	}
	contDao.item("cont_hash", cont_hash);
	contDao.item("cont_html", cont_html[0]);
	contDao.item("status", status);
	db.setCommand(contDao.getUpdateQuery("cont_no= '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), contDao.record);

    custDao = new DataObject("tcb_cust");
    custDao.item("sign_dn", sign_dn);
    custDao.item("sign_data", sign_data);
    custDao.item("sign_date", u.getTimeString());
    custDao.item("sign_type", "20");
    db.setCommand(custDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+_member_no+"'"),custDao.record);

    custSignImg.first();
    int sign_img_seq = 1;
	db.setCommand("delete from tcb_cust_sign_img where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+_member_no+"' ",null);
	while(custSignImg.next()){
		DataObject custSignDao = new DataObject("tcb_cust_sign_img");
		custSignDao.item("cont_no", cont_no);
		custSignDao.item("cont_chasu", cont_chasu);
		custSignDao.item("member_no", _member_no);
		custSignDao.item("sign_img_seq", sign_img_seq++);
		custSignDao.item("object_name", custSignImg.getString("object_name"));
		custSignDao.item("img_data", custSignImg.getString("img_data"));
		custSignDao.item("img_hash", custSignImg.getString("img_hash"));
		custSignDao.item("status", "10");
		db.setCommand(custSignDao.getInsertQuery(), custSignDao.record);
	}
	
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
		agreeDao.item("r_agree_person_id", "-");
		agreeDao.item("r_agree_person_name", cust.getString("member_name"));
		db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd = '0' "),agreeDao.record);
	}
	
	/* 계약로그 START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  _member_no, "1", cust.getString("boss_name"), request.getRemoteAddr(), "전자서명 완료",  "", status,"10");
	/* 계약로그 END*/
	
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	
	// sms 및 메일 발송 처리
	SmsDao smsDao = new SmsDao();
	if (nagreeCnt > 0) {
		// 다음 내부 결재 담당자에게 거래처 서명완료 알림.
		agreeDao = new DataObject("tcb_cont_agree");
		DataSet agree = agreeDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_cd='2' and length(agree_person_id) > 0","*"," agree_seq asc"); // 파트너 서명후 검토자가 있고 그 검토자가 부서가 아닌 1명인 경우 처음 검토자에게 검토 메일 전송
		if (agree.next()) {
			// 이메일 알림.
			DataObject personDao = new DataObject("tcb_person");
			DataSet agree_person = personDao.find("user_id='"+agree.getString("agree_person_id")+"'"); // 검토자 정보
			if (agree_person.next()) {
				p.clear();
				DataSet mailInfo = new DataSet();
				mailInfo.addRow();
				mailInfo.put("cust_name", cust.getString("member_name"));
				mailInfo.put("cont_name", cont.getString("cont_name"));
				mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
				p.setVar("info", mailInfo);
				p.setVar("server_name", Config.getWebUrl());
				p.setVar("return_url", "web/buyer/");
				String mail_body = p.fetch("../html/mail/cont_send_mail.html");
				u.mail(agree_person.getString("email"), "[계약 서명 알림] \"" +  cust.getString("member_name") + "\" 업체가 전자계약서 서명을 완료하였습니다.", p.fetch("mail/cont_cust_sign.html"));
				String subject = "농심 전자계약 안내";
				String message = "[전자계약][농심] 전자계약 안내\n"
						+ auth.getString("_MEMBER_NAME") + "에서 전자계약서 서명완료 - 농심 전자계약시스템";
				// smsDao.sendKakaoTalk
				// 서명요청(을>농심)
				smsDao.sendKakaoTalk(agree_person.getString("hp1"), agree_person.getString("hp2"), agree_person.getString("hp3"), "ESC-SD-0003", subject, message, message);
			}
		}
	} else {
		// 작성자 email
		custDao = new DataObject("tcb_cust");
		DataSet cust_gap = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no <> '"+_member_no+"'  ");
		while (cust_gap.next()) {
			if (!cust_gap.getString("email").equals("")) {
				p.clear();
				DataSet mailInfo = new DataSet();
				mailInfo.addRow();
				mailInfo.put("cust_name", cust.getString("member_name"));
				mailInfo.put("cont_name", cont.getString("cont_name"));
				mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
				p.setVar("info", mailInfo);
				p.setVar("server_name", Config.getWebUrl());
				p.setVar("return_url", "web/buyer/");
				String mail_body = p.fetch("../html/mail/cont_send_mail.html");
				u.mail(cust_gap.getString("email"), "[계약 서명 알림] \"" +  cust.getString("member_name") + "\" 업체가 전자계약서 서명을 완료하였습니다.", p.fetch("mail/cont_cust_sign.html"));
			}
			
			String subject = "농심 전자계약 안내";
			String message = "[전자계약][농심] 전자계약 안내\n"
					+ auth.getString("_MEMBER_NAME") + "에서 전자계약서 서명완료 - 농심 전자계약시스템";
			// smsDao.sendKakaoTalk
			// 서명요청(을>농심)
			smsDao.sendKakaoTalk(cust_gap.getString("hp1"), cust_gap.getString("hp2"), cust_gap.getString("hp3"), "ESC-SD-0003", subject, message, message);	
		}
	}
	
    u.jsAlertReplace("계약서에 대해 승인 처리가 완료되었습니다.","email_contract_msign_recvview.jsp?cont_no="+u.aseEnc(cont_no)+"&cont_chasu="+cont_chasu+"&email_random="+email_random);
	return;
}
%>