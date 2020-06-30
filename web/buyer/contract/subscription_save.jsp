<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%!
	public static String cutString(String str, int len) throws Exception {
		try  {
			byte[] by = str.getBytes("KSC5601");
			if(by.length <= len) return str;
			int count = 0;
			for(int i = 0; i < len; i++) {
				if((by[i] & 0x80) == 0x80) count++;
			}
			if((by[len - 1] & 0x80) == 0x80 && (count % 2) == 1) len--;
			len = len - (int)(count / 2);
			return str.substring(0, len);
		} catch(Exception e) {
			return "";
		}
	}
%>
<%
	String[] tcode;
	String _member_no = "";
	String template_cd = "";

	try {

		System.out.println("-- 신청서 저장 시작 --");
		System.out.println("tcode["+u.request("tcode")+"]");
		tcode = u.aseDec(u.request("tcode")).split("\\|");
		_member_no = tcode[0];
		template_cd = tcode[1];
		System.out.println("_member_no["+_member_no+"]");
		System.out.println("template_cd["+template_cd+"]");

		if(_member_no.equals("")||template_cd.equals("")||!u.isPost()){
			u.jsAlert("정상적인 경로로 접근 하세요.");
			return;
		}
	}
	catch(Exception e)
	{
		u.jsAlert("정상적인 경로로 접근 하세요.");
		return;
	}

//서식정보 조회
	DataObject templateDao = new DataObject("tcb_cont_template");
	DataSet template= templateDao.find(" status > 0 and template_cd ='"+template_cd+"'");
	if(!template.next()){
		u.jsAlert("정상적인 경로로 접근 하세요.");
		return;
	}

	DataObject signTemplateDao = new DataObject("tcb_cont_sign_template");
	DataSet signTemplate = signTemplateDao.find(" template_cd = '"+template_cd+"'","*","sign_seq asc");
	if(!signTemplate.next()){
		u.jsAlert("정상적인 경로로 접근 하세요.");
		return;
	}

//수신자 정보 조회
	DataObject recvDao = new DataObject("tcb_subscription");
	DataSet recv_user = recvDao.query(
			"	select b.user_id, c.member_no, c.vendcd, c.post_code, c.member_slno, c.address, c.member_name, c.boss_name, c.member_gubun"
					+"	        ,b.user_name, b.email ,b.tel_num, b.hp1, b.hp2,b.hp3, b.field_seq, b.division "
					+"	  from tcb_subscription a "
					+"	       inner join tcb_person b on a.recv_userid=b.user_id "
					+"	       inner join tcb_member c on b.member_no=c.member_no "
					+"	 where a.template_cd = '"+ template_cd +"'"
	);
	if(!recv_user.next()){
		u.jsAlert("접수자 정보가 존재하지 않습니다.");
		return;
	}

// 계좌 체크 (팝업으로 이동)
/*
	String bankName = f.get("c_bankname"); // 은행명
	String bankNo = f.get("c_bankno").trim(); // 계좌번호
	String bankUser = f.get("c_bankuser").trim(); // 예금주명

	if(!bankName.equals("") && !bankNo.equals("") && !bankUser.equals(""))
	{
		String[] bankCode = {"한국은행=>001","산업은행=>002","기업은행=>003","국민은행=>004","하나(외환)은행=>005","수협중앙회=>007","수출입은행=>008","농협중앙회=>011","농협회원조합=>012","우리은행=>020","SC제일은행=>023","한국씨티은행=>027","대구은행=>031","부산은행=>032","광주은행=>034","제주은행=>035","전북은행=>037","경남은행=>039","새마을금고연합회=>045","신협중앙회=>048","상호저축은행=>050","모건스탠리은행=>052","HSBC은행=>054","도이치은행=>055","에이비엔암로은행=>056","제이피모간체이스은행=>057","미즈호코퍼레이트은행=>058","미쓰비시도쿄UFJ은행=>059","BOA=>060","정보통신부 우체국=>071","신용보증기금=>076","기술신용보증기금=>077","하나은행=>081","신한은행=>088","한국주택금융공사=>093","서울보증보험=>094","경찰청=>095","금융결제원=>099","동양종합금융증권=>209","현대증권=>218","미래에셋증권=>230","대우증권=>238","삼성증권=>240","한국투자증권=>243","우리투자증권=>247","교보증권=>261","하이투자증권=>262","에이치엠씨투자증권=>263","키움증권=>264","이트레이드증권=>265","에스케이증권=>266","대신증권=>267","솔로몬투자증권=>268","한화증권=>269","하나대투증권=>270","굿모닝신한증권=>278","동부증권=>279","유진투자증권=>280","메리츠증권=>287","엔에이치투자증권=>289","부국증권=>290","신영증권=>291","엘아이지투자증권=>292"};

		Http hp = new Http();
		hp.setEncoding("euc-kr");
		hp.setUrl("https://web.nicepay.co.kr/api/checkBankAccountAPI.jsp");
		hp.setParam("mid", "nicedocu1m");
		hp.setParam("merchantKey", "Q1h4Zo1gtPrDVGU/6kWxb/4j0oCIAaYJAO35vM/huB4FLWOszTRVTSdxG64kat2QC4qhcpp9zOXTW03xbsovwA==");
		hp.setParam("inAccount", bankNo);

		System.out.println("bankName : " + bankName);
		System.out.println("bankCode : " + u.getItem(bankName, bankCode));

		hp.setParam("inBankCode", u.getItem(bankName, bankCode));
		String ret = hp.sendHTTPS();
		// 성공시 : PG=NICE|respCode=0000|errMsg=정상처리|receiverName=유성훈|NICE=PG|RegDate=20171025
		// 실패시 : PG=NICE|respCode=V454|errMsg=해당계좌오류|receiverName=|NICE=PG|RegDate=20171025

		String[] retArr = ret.split("\\|");
		DataSet retBank = new DataSet();
		retBank.addRow();
		for(int i=0; i<retArr.length; i++) {
			String[] tmp = retArr[i].split("=");
			retBank.put(tmp[0], tmp.length==2 ? tmp[1] : "");
		}
		System.out.println("[respCode]"+retBank.getString("respCode"));
		System.out.println("[receiverName]"+retBank.getString("receiverName"));
		System.out.println("[bankUser]"+cutString(bankUser,16));

		if(!retBank.getString("respCode").equals("0000")) {
			u.jsAlert("계좌 정보가 올바르지 않습니다.["+retBank.getString("errMsg")+"]");
			return;
		}
		if(!cutString(retBank.getString("receiverName"),16).equals(cutString(bankUser,16))) {  // 은행 관계없이 16byte로 통일
			u.jsAlert("계좌의 소유자명이 일치하지 않습니다.");
			return;
		}
	}
*/

//계약서 생성
	ContractDao cont = new ContractDao();

	boolean isModify = false;
	String cont_no = "";
	int cont_chasu = 0;
	String random_no = "";
	if(f.get("cont_no").equals("") && f.get("cont_chasu").equals("") && f.get("random_no").equals("")) {
		cont_no = cont.makeContNo();
		cont_chasu = 0;
		random_no = Util.strpad(u.getRandInt(0,99999)+"",5,"0");
	} else {
		cont_no = f.get("cont_no");
		cont_chasu = f.getInt("cont_chasu");
		random_no = f.get("random_no");
		isModify = true;

		// 신청 후 다시 저장 버튼 눌렀는지 확인(컴퓨터가 느려서 2번 누르시는 분이 있네 ㅜㅜ)
		DataSet chkDuplicate = cont.find("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu, "status");
		if(chkDuplicate.getString("status").equals("30")) {  // 신청중이면 무시
			System.out.println("isDuplicate: 중복 누름 발생");
		    return;
		}
	}

	System.out.println("isModify : " + isModify);
	System.out.println("cont_no : " + cont_no);
	System.out.println("cont_chasu : " + cont_chasu);
	System.out.println("random_no : " + random_no);


	String cont_html_rm_str = "";
	String[] cont_html_rm = f.getArr("cont_html_rm");
	String[] cont_html = f.getArr("cont_html");
	String[] cont_sub_name = f.getArr("cont_sub_name");
	String[] cont_sub_style = f.getArr("cont_sub_style");
	String[] gubun = f.getArr("gubun");
	String[] sub_seq = f.getArr("sub_seq");
	String arrOption_yn[] = new String[cont_html_rm.length];

//decodeing 처리 START
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		cont_html_rm[i] = new String(Base64Coder.decode(cont_html_rm[i]),"UTF-8");
	}
	for(int i = 0 ; i < cont_html.length; i ++){
		cont_html[i] =  new String(Base64Coder.decode(cont_html[i]),"UTF-8");
	}
//decodeing 처리 END

	for(int i = 0 ; i < cont_html_rm.length; i ++){
		arrOption_yn[i] = f.get("option_yn_"+i);
	}

	for(int i = 0 ; i < cont_html_rm.length; i ++){
		if(i != 0)
			cont_html_rm_str += "<pd4ml:page.break>";
		if(gubun[i].equals("10")){
			cont_html_rm_str += cont_html_rm[i];
		}
	}
	System.out.println("cont_html_rm.length : " + cont_html_rm.length);


	String cont_userno = "";
	if(_member_no.equals("20120600068")){  // 나이스페이먼츠
		String[] wUserNo = {"2012014=>kspo", "2017331=>nhome", "2018168=>makesoho","2019266=>hspo","2020172=>imweb1","2020173=>imweb2"};

		String sHeader = u.getItem(template_cd, wUserNo)+"-"+u.getTimeString("yyyyMMdd")+"-";
		int pos = sHeader.length();
 
		DataObject tmpDao = new DataObject();
		String userNoSeq = tmpDao.getOne("select nvl(max(to_number(substr(cont_userno,"+(pos+1)+"))),0)+1 from tcb_contmaster where status<>'00' and member_no = '"+_member_no+"' and template_cd = '"+template_cd+"' and substr(cont_userno,0,"+pos+")='"+sHeader+"'");
		if(userNoSeq.equals("")){
			u.jsError("계약번호 생성에 실패 하였습니다.");
			return;
		}
		cont_userno =sHeader+u.strrpad(userNoSeq, 4, "0");
		System.out.println("cont_userno["+cont_userno+"]");
	}


	ArrayList autoFiles = new ArrayList();
	int file_seq = 1;

// 계약서파일 생성
	DataSet pdfInfo = new DataSet();
	pdfInfo.addRow();
	pdfInfo.put("member_no",_member_no);
	pdfInfo.put("cont_no", cont_no);
	pdfInfo.put("cont_chasu", cont_chasu);
	pdfInfo.put("random_no", random_no);
	pdfInfo.put("cont_userno", cont_userno);
	pdfInfo.put("html", cont_html_rm_str);
	pdfInfo.put("doc_type", "3");
	pdfInfo.put("file_seq", file_seq++);

	DataSet pdf = cont.makePdf(pdfInfo);
	if(pdf==null){
		u.jsAlert("계약서 파일 생성에 실패 하였습니다.");
		return;
	}

//자동생성파일 생성
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		if(    gubun[i].equals("20")
				|| gubun[i].equals("50")  // 작성업체만 보고 인쇄하는 양식(서명대상 X)
				|| ( gubun[i].equals("40") && arrOption_yn[i].equals("A") || arrOption_yn[i].equals("Y")) // 자동으로 생성되는 양식 또는 체크된 양식인 경우
				)
		{
			DataSet pdfInfo2 = new DataSet();
			pdfInfo2.addRow();
			pdfInfo2.put("member_no",_member_no);
			pdfInfo2.put("cont_no", cont_no);
			pdfInfo2.put("cont_chasu", cont_chasu);
			pdfInfo2.put("random_no", random_no);
			pdfInfo2.put("cont_userno", cont_userno);
			pdfInfo2.put("html", cont_html_rm[i]);
			pdfInfo2.put("doc_type", template.getString("doc_type"));
			pdfInfo2.put("file_seq", file_seq++);
			DataSet pdf2 = cont.makePdf(pdfInfo2);
			pdf2.put("cont_sub_name", cont_sub_name[i]);
			pdf2.put("gubun", gubun[i]);
			autoFiles.add(pdf2);
		}
	}


	DB db = new DB();
//db.setDebug(out);

	cont = new ContractDao();
	cont.item("cont_no", cont_no);
	cont.item("cont_chasu", cont_chasu);
	cont.item("member_no", _member_no);
	cont.item("true_random", random_no);
	cont.item("template_cd", template_cd);
	cont.item("cont_userno", cont_userno);
	cont.item("subscription_yn", "Y");
	if(!isModify) { // 반려의 경우 상태값을 바꾸지 않는다.
		cont.item("status", "00"); // 임시저장
	}
	cont.item("reg_date", Util.getTimeString());
	if(isModify)
		db.setCommand(cont.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu), cont.record);
	else
		db.setCommand(cont.getInsertQuery(), cont.record);

	int cfile_seq_real = 1;
	String file_hash = pdf.getString("file_hash");
	f.uploadDir = Startup.conf.getString("file.path.bcont_pdf")+pdf.getString("file_path");
//계약서류 갑지
	DataObject cfileDao = new DataObject("tcb_cfile");
	cfileDao.item("cont_no", cont_no);
	cfileDao.item("cont_chasu", cont_chasu);
	cfileDao.item("doc_name", template.getString("template_name"));
	cfileDao.item("file_path", pdf.getString("file_path"));
	cfileDao.item("file_name", pdf.getString("file_name"));
	cfileDao.item("file_ext", pdf.getString("file_ext"));
	cfileDao.item("file_size", pdf.getString("file_size"));
	cfileDao.item("auto_yn","Y");
	cfileDao.item("auto_type", "");
	if(isModify) {
		db.setCommand(cfileDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu+" and cfile_seq="+cfile_seq_real++), cfileDao.record);
	} else {
		cfileDao.item("cfile_seq", cfile_seq_real++);
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
	}

//자동생성파일
	for(int i=0; i <autoFiles.size(); i ++){
		DataSet temp = (DataSet)autoFiles.get(i);
		cfileDao = new DataObject("tcb_cfile");
		cfileDao.item("cont_no", cont_no);
		cfileDao.item("cont_chasu", cont_chasu);
		cfileDao.item("doc_name", temp.getString("cont_sub_name"));
		cfileDao.item("file_path", temp.getString("file_path"));
		cfileDao.item("file_name", temp.getString("file_name"));
		cfileDao.item("file_ext", temp.getString("file_ext"));
		cfileDao.item("file_size", temp.getString("file_size"));
		cfileDao.item("auto_yn","Y");
		if(temp.getString("gubun").equals("50"))	// 작성업체만 보고 인쇄하는 양식은 서명대상이 아님.  gubun[i].equals("50")
			cfileDao.item("auto_type", "3");	// 공백:자동생성, 1:자동첨부, 2:필수첨부, 3:내부용
		else
		{
			file_hash+="|"+temp.getString("file_hash");
			cfileDao.item("auto_type", "");
		}
		if(isModify) {
			db.setCommand(cfileDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu+" and cfile_seq="+cfile_seq_real++), cfileDao.record);
		} else {
			cfileDao.item("cfile_seq", cfile_seq_real++);
			db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
		}
	}

	if(!db.executeArray()){
		u.jsAlert("신청서 생성에 실패 하였습니다.");
		return;
	}

	System.out.println("file_hash : " + file_hash);
	System.out.println("random_no : " + random_no);

	out.println("<script>");
	out.println("var f = parent.document.forms['form1'];");
	out.println("f['cont_hash'].value='"+file_hash+"';");
	out.println("f['cont_no'].value='"+cont_no+"';");
	out.println("f['cont_chasu'].value='"+cont_chasu+"';");
	out.println("f['random_no'].value='"+random_no+"';");
	out.println("parent.fSign();");
	out.println("</script>");

%>