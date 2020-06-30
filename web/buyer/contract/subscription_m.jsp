<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
/*
유효한 URL인지 확인 필요

양식URL은 [갑사 회원번호 + "|" + 양식코드]를 AES 암호화해서 배포, 옵션으로 구글 단축 URL로 감추는 방안도 고려
예 : http://dev.nicedocu.com/web/buyer/contract/subscription_m.jsp?cont_no=98665021c80dec078ad9634ddc4fd3f6&cont_chasu=0

*/
String cont_no = "";
String cont_chasu = "";

try {
	cont_no = u.aseDec(u.request("c"));
	cont_chasu = u.request("s","0");

	if(cont_no.equals("")||cont_chasu.equals("")){
		u.jsError("정상적인 경로로 접근 하세요.");
		return;
	}
}
catch(Exception e) 
{
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}


ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
							" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"
						   ," tcb_contmaster.*"
						   +" ,(select member_name from tcb_member where member_no = mod_req_member_no) mod_req_name "
						   +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,3) = substr(tcb_contmaster.src_cd,0,3) and depth='1') l_src_nm "
						   +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,6) = substr(tcb_contmaster.src_cd,0,6) and depth='2') m_src_nm "
						   +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and src_cd = tcb_contmaster.src_cd and depth='3') s_src_nm "
							);
if(!cont.next()){
	u.jsError("계약정보가 존재 하지 않습니다.");
	return;
}

String _member_no = cont.getString("member_no");
//cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
String template_cd = cont.getString("template_cd");
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));

//서식정보 조회
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" status > 0 and template_cd ='"+template_cd+"'");
if(!template.next()){
}

//추가 계약서 조회
DataObject contSubDao = new DataObject("tcb_cont_sub");
DataSet contSub = contSubDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
int k=1;
while(contSub.next()){
 contSub.put("cont_no", u.aseEnc(contSub.getString("cont_no")));
	contSub.put("hidden", u.inArray(contSub.getString("gubun"),new String[]{"20","30"}));
	contSub.put("template_name", contSub.getString("cont_sub_name"));
	contSub.put("template_cd", template_cd);
	contSub.put("chk", contSub.getString("chk_yn").equals("Y")?"checked":"");

	if(contSub.getString("option_yn").equals("A")) // 자동 생성해야 하는 양식
		contSub.put("option_yn", false);
	else
	{
		if(contSub.getString("option_yn").equals("Y")) // 선택한 양식의 경우 체크 표시해준다.
			f.addElement("option_yn_"+k, "Y", null);
		contSub.put("option_yn", true);
	}
	k++;
}

//서명정보 조회
DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","*","sign_seq asc");


//계약업체 조회
DataObject writerDao = new DataObject("tcb_cust");
DataSet writer = writerDao.find(
		" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no <> '"+_member_no+"' and sign_seq <= 10"
		,"*"
		,"display_seq asc");  // sign_seq 가 10보다 큰거는 연대보증
if(!writer.next()){
	u.jsError("계약업체 정보가 존재 하지 않습니다.");
	return;
}

String chkVendcd = writer.getString("vendcd").substring(3,5);
String mgubun = "";
if( u.inArray(chkVendcd, new String[] {"81","82","83","84","86","87","88"}) ){
	mgubun = "01";
}else if(chkVendcd.equals("85")){
	mgubun = "01"; 
}else{						
	mgubun = "02"; 
}

f.addElement("vendcd", writer.getString("vendcd"), "hname:'사업자번호', required:'Y'");
f.addElement("vendcd1", writer.getString("vendcd").substring(0,3), "hname:'사업자번호', required:'Y'");
f.addElement("vendcd2", writer.getString("vendcd").substring(3,5), "hname:'사업자번호', required:'Y'");
f.addElement("vendcd3", writer.getString("vendcd").substring(5), "hname:'사업자번호', required:'Y'");
f.addElement("member_name", writer.getString("member_name"), "hname:'회사명', required:'Y'");
f.addElement("boss_name", writer.getString("boss_name"), "hname:'대표자명', required:'Y'");
f.addElement("post_code", writer.getString("post_code"), "required:'Y'");
String member_slno1 = "";
String member_slno2 = "";
if(!writer.getString("member_slno").equals("")) {
	member_slno1 = writer.getString("member_slno").substring(0,6);
	member_slno2 = writer.getString("member_slno").substring(6);
}
f.addElement("slno1", member_slno1, "hname:'법인등록번호 앞자리', fixbyte:6, maxlength:6");
f.addElement("slno2", member_slno2, "hname:'법인등록번호 뒷자리', fixbyte:7, maxlength:7");
String birthday = "";
if(!writer.getString("jumin_no").equals("")){
	birthday = u.aseDec(writer.getString("jumin_no"));
}
if(mgubun.equals("01")) { // 법인
	f.addElement("birthday", birthday, "hname:'생년월일', fixbyte:6, maxlength:6");
} else {
	f.addElement("birthday", birthday, "hname:'생년월일', required:'Y', fixbyte:6, maxlength:6");
}
f.addElement("address", writer.getString("address"), "hname:'사업장 주소', required:'Y'");
f.addElement("user_name", writer.getString("user_name"), "hname:'신청자명', required:'Y'");
f.addElement("hp1", writer.getString("hp1"), "hname:'휴대폰번호 앞자리', required:'Y', fixbyte:3, option:'number'");
f.addElement("hp2", writer.getString("hp2"), "hname:'휴대폰번호 중간자리', required:'Y', minbyte:3, maxlength:4, option:'number'");
f.addElement("hp3", writer.getString("hp3"), "hname:'휴대폰번호 뒷자리', required:'Y', fixbyte:4, option:'number'");
f.addElement("tel_num", writer.getString("tel_num"), "hname:'신청자 전화번호', required:'Y'");
f.addElement("email", writer.getString("email"), "hname:'신청자 이메일', required:'Y', option:'email'");


//구비서류 조회
DataObject rfileDao = new DataObject("tcb_rfile");
//rfileDao.setDebug(out);
DataSet rfile = rfileDao.query(
		 " select a.*, b.file_name, b.file_path, b.file_ext, b.file_size "
		+"   from tcb_rfile a                                            "
		+"   left outer join tcb_rfile_cust b                            "
		+"     on a.cont_no = b.cont_no                                  "
		+"    and a.cont_chasu = b.cont_chasu                            "
		+"    and a.rfile_seq = b.rfile_seq                              "
		+"    and member_no = '"+writer.getString("member_no")+"'                           "
		+"  where a.cont_no = '"+cont_no+"'                              "
		+"    and a.cont_chasu = '"+cont_chasu+"'                        "
		);
while(rfile.next()){
 rfile.put("cont_no", u.aseEnc(rfile.getString("cont_no")));
	rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
	if(!rfile.getString("file_name").equals(""))
	rfile.put("file_size", u.getFileSize(rfile.getLong("file_size")));

	if(rfile.getString("reg_type").equals("10")){
		rfile.put("attch_disabled","disabled");
		rfile.put("doc_name_class", "in_readonly");
		rfile.put("doc_name_readonly", "readonly");
		rfile.put("del_btn_yn", false);
	}else{
		rfile.put("attch_disabled","");
		rfile.put("doc_name_class", "label");
		rfile.put("doc_name_readonly", "");
		rfile.put("del_btn_yn", true);
	}
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
	u.jsError("접수자 정보가 존재하지 않습니다.");
	return;
}


if(u.isPost()&&f.validate()){
	response.setHeader("Cache-Control","no-store");  
	response.setHeader("Pragma","no-cache");  
	response.setDateHeader("Expires",0);  
	if (request.getProtocol().equals("HTTP/1.1"))
		response.setHeader("Cache-Control", "no-cache");
	
	//서명 검증
	String sign_dn = f.get("sign_dn");
	String sign_data = f.get("sign_data");
	cont_no = f.get("cont_no");
	cont_chasu = f.get("cont_chasu");
	String cont_hash = f.get("cont_hash");

	Crosscert cert = new Crosscert();
	cert.setEncoding("UTF-8");
	if (cert.chkSignVerify(sign_data).equals("SIGN_ERROR")){
		u.jsError("서명검증에 실패 하였습니다.");
		return;
	}
	if(!cert.getDn().equals(sign_dn)){
		u.jsError("서명검증이 DN값이 일지 하지 않습니다.");
		return;
	}	

	//계약기간구하기
	String cont_sdate = f.get("cont_sdate").replaceAll("-","");
	String cont_edate = f.get("cont_edate").replaceAll("-","");
	if(!f.get("cont_syear").equals("")&&!f.get("cont_smonth").equals("")&&!f.get("cont_sday").equals("")){
		cont_sdate = Util.strrpad(f.get("cont_syear"),4,"0")+Util.strrpad(f.get("cont_smonth"),2,"0")+Util.strrpad(f.get("cont_sday"),2,"0");
	}
	if(!f.get("cont_eyear").equals("")&&!f.get("cont_emonth").equals("")&&!f.get("cont_eday").equals("")){
		cont_edate = Util.strrpad(f.get("cont_eyear"),4,"0")+Util.strrpad(f.get("cont_emonth"),2,"0")+Util.strrpad(f.get("cont_eday"),2,"0");
	}else if(!f.get("cont_term").equals("")){
		Date date = Util.addDate("D", -1, Util.strToDate("yyyy-MM-dd",f.get("cont_date")));
		cont_sdate = f.get("cont_date").replaceAll("-", "");
		cont_edate = Util.addDate("Y",Integer.parseInt(f.get("cont_term")),date,"yyyyMMdd");
	}else if(!f.get("cont_term_month").equals("")){
		Date date = Util.addDate("D", -1, Util.strToDate("yyyy-MM-dd",f.get("cont_date")));
		cont_sdate = f.get("cont_date").replaceAll("-", "");
		cont_edate = Util.addDate("M",Integer.parseInt(f.get("cont_term_month")),date,"yyyyMMdd");
	}
	if(cont_sdate.equals("") && !cont_edate.equals(""))
		cont_sdate = f.get("cont_date").replaceAll("-","");

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
	
	
	DataObject cfileDao = new DataObject("tcb_cfile");
	DataSet cfile = cfileDao.find("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu, "file_path", 1);
	if(!cfile.next()) {
		u.jsError("신청서 정보가 올바르지 않습니다.");
		return;
	}
	f.uploadDir = Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path");
	
	System.out.println("----2---------");
	DB db = new DB();
	//db.setDebug(out);
	contDao = new ContractDao();
	contDao.item("cont_no", cont_no);
	contDao.item("cont_chasu", cont_chasu);
	contDao.item("member_no", _member_no);
	contDao.item("field_seq", recv_user.getString("field_seq"));
	contDao.item("template_cd", template.getString("template_cd"));
	contDao.item("cont_name", template.getString("template_name")+"_"+f.get("member_name"));
	contDao.item("cont_date", Util.getTimeString("yyyyMMdd"));
	contDao.item("cont_sdate", cont_sdate);
	contDao.item("cont_edate", cont_edate);
	contDao.item("supp_tax", f.get("supp_tax").replaceAll(",",""));
	contDao.item("supp_taxfree", f.get("supp_taxfree").replaceAll(",",""));
	contDao.item("supp_vat", f.get("supp_vat").replaceAll(",",""));
	contDao.item("cont_total", f.get("cont_total").replaceAll(",",""));
	contDao.item("cont_hash", cont_hash);
	contDao.item("cont_html", cont_html[0]);
	contDao.item("reg_date", Util.getTimeString());
	contDao.item("true_random", f.get("random_no"));
	contDao.item("reg_id", recv_user.getString("user_id"));
	//cont.item("sign_dn", sign_dn);
	//cont.item("sign_data", sign_data);
	contDao.item("status", "30"); // 신청서 을사 서명 완료
	contDao.item("src_cd", f.get("src_cd"));
	contDao.item("stamp_type", f.get("stamp_type"));
	db.setCommand(contDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu), contDao.record);
	System.out.println("----3---------");

	db.setCommand("delete from tcb_cont_sub where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
	for(int i = 1 ; i < cont_html.length; i++) {
		DataObject cont_sub = new DataObject("tcb_cont_sub");
		cont_sub.item("cont_no", cont_no);
		cont_sub.item("cont_chasu", cont_chasu);
		cont_sub.item("sub_seq", i);
		cont_sub.item("cont_sub_html",cont_html[i]);
		cont_sub.item("cont_sub_name",cont_sub_name[i]);
		cont_sub.item("cont_sub_style",cont_sub_style[i]);
		cont_sub.item("gubun", gubun[i]);
		System.out.println("----3-1---------");
		cont_sub.item("option_yn",arrOption_yn[i]);
		System.out.println("----3-2---------");
		System.out.println("----3-3---------");
		db.setCommand(cont_sub.getInsertQuery(), cont_sub.record);
	}

	System.out.println("----4---------");
	// 서명 서식 저장
	String[] sign_seq = f.getArr("sign_seq");
	String[] signer_name = f.getArr("signer_name");
	String[] signer_max = f.getArr("signer_max");
	String[] member_type = f.getArr("member_type");
	String[] cust_type  = f.getArr("cust_type");
	db.setCommand("delete from tcb_cont_sign where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
	signTemplate.first();
	while(signTemplate.next()){
		DataObject cont_sign = new DataObject("tcb_cont_sign");
		cont_sign.item("cont_no",cont_no);
		cont_sign.item("cont_chasu",cont_chasu);
		cont_sign.item("sign_seq", signTemplate.getString("sign_seq"));
		cont_sign.item("signer_name", signTemplate.getString("signer_name"));
		cont_sign.item("signer_max", signTemplate.getString("signer_max"));
		cont_sign.item("member_type", signTemplate.getString("member_type"));// 01:나이스와 계약한 업체 02:나이스 미계약업체
		cont_sign.item("cust_type", signTemplate.getString("cust_type"));// 01:갑 02:을
		db.setCommand(cont_sign.getInsertQuery(), cont_sign.record);		
	}

	System.out.println("----5---------");
	// 수신업체 정보
	
	DataSet cust = new DataSet();
	cust.addRow();
	cust.put("member_no", recv_user.getString("member_no"));
	cust.put("cust_sign_seq", "1");
	cust.put("vendcd", recv_user.getString("vendcd"));
	cust.put("member_name", recv_user.getString("member_name"));
	cust.put("boss_name", recv_user.getString("boss_name"));
	cust.put("post_code", recv_user.getString("post_code"));
	cust.put("address", recv_user.getString("address"));
	cust.put("tel_num", recv_user.getString("tel_num"));
	cust.put("member_slno", recv_user.getString("member_slno"));
	cust.put("user_name", recv_user.getString("user_name"));
	cust.put("hp1", recv_user.getString("hp1"));
	cust.put("hp2", recv_user.getString("hp2"));
	cust.put("hp3", recv_user.getString("hp3"));
	cust.put("email", recv_user.getString("email"));
	cust.put("birthday", "");
	cust.put("member_gubun", recv_user.getString("member_gubun")); // 01:법인(본사), 02:법인(지사), 03:개인사업자
	cust.put("cust_gubun", "01"); // 01:사업자 02:개인
	cust.put("cust_detail_code", ""); // 업체코드
	
	// 신청서 작성자 정보
	cust.addRow();
	cust.put("member_no", "");
	cust.put("cust_sign_seq", "2");
	cust.put("vendcd", f.get("vendcd").replaceAll("-", ""));
	cust.put("member_name", f.get("member_name"));
	cust.put("boss_name", f.get("boss_name"));
	cust.put("post_code", f.get("post_code").replaceAll("-", ""));
	cust.put("address", f.get("address"));
	cust.put("tel_num", f.get("tel_num"));
	cust.put("member_slno", "");
	cust.put("user_name", f.get("user_name"));
	cust.put("hp1", f.get("hp1"));
	cust.put("hp2", f.get("hp2"));
	cust.put("hp3", f.get("hp3"));
	cust.put("email", f.get("email"));
	cust.put("birthday", f.get("birthday"));

	chkVendcd = f.get("vendcd").substring(3,5);
	if( u.inArray(chkVendcd, new String[] {"81","82","83","84","86","87","88"}) ){
		cust.put("member_gubun", "01");	// 법인사업자(본사)
		cust.put("cust_gubun", "01"); 
	}else if(chkVendcd.equals("85")){
		cust.put("member_gubun", "02");	// 법인사업자(지사)
		cust.put("cust_gubun", "01"); 
	}else{						
		cust.put("member_gubun", "03"); // 개인사업자
		cust.put("cust_gubun", "02"); 
	}
	cust.put("cust_detail_code", ""); // 업체코드

	// 기존 회원인지 체크
	String w_member_no = "";
	DataObject daoWMember = new DataObject("tcb_member");
	DataSet dsWMember = daoWMember.find("vendcd = '"+cust.getString("vendcd")+"'", "member_no");
	if(dsWMember.next()) // 기존 회원
	{
		System.out.println("기존 가입 회원 : " + cust.getString("vendcd"));
		cust.put("member_no", dsWMember.getString("member_no"));
		w_member_no = dsWMember.getString("member_no");
	}

	System.out.println("----6---------");
	//업체정보 저장
	int display_seq = 0;
	//db.setCommand("delete from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
	cust.first();
	System.out.println("----66---------");
	while(cust.next()){
		signTemplate.first();
		while(signTemplate.next()){
			if(signTemplate.getString("sign_seq").equals(cust.getString("cust_sign_seq"))){
				break;
			}
		}
		DataObject custDao = new DataObject("tcb_cust");
		//custDao.item("cont_no", cont_no);
		//custDao.item("cont_chasu",cont_chasu);
		//custDao.item("member_no",cust.getString("member_no"));
		custDao.item("sign_seq", cust.getString("cust_sign_seq"));
		custDao.item("cust_gubun", cust.getString("cust_gubun")); //01:사업자 02:개인
		custDao.item("vendcd", cust.getString("vendcd"));
		if((cust.getString("member_gubun").equals("04") || cust.getString("member_gubun").equals("03")) && !cust.getString("birthday").equals("")){ // 개인 또는 개인사업자이고 생년월일이 있는 경우
			custDao.item("jumin_no", Security.AESencrypt(cust.getString("birthday")));
		}
		System.out.println("----6-1--------");
		custDao.item("member_name", cust.getString("member_name"));
		custDao.item("boss_name", cust.getString("boss_name"));
		custDao.item("post_code", cust.getString("post_code"));
		custDao.item("address", cust.getString("address"));
		custDao.item("tel_num", cust.getString("tel_num"));
		custDao.item("member_slno", cust.getString("member_slno"));
		custDao.item("user_name", cust.getString("user_name"));
		custDao.item("hp1", cust.getString("hp1"));
		custDao.item("hp2", cust.getString("hp2"));
		custDao.item("hp3", cust.getString("hp3"));
		custDao.item("email", cust.getString("email"));
		custDao.item("display_seq", display_seq++);
		custDao.item("cust_detail_code", cust.getString("cust_detail_code"));
		System.out.println("----6-2--------");
		if(cust.getString("member_no").equals(w_member_no)) {
			custDao.item("sign_dn", sign_dn);
			custDao.item("sign_data", sign_data);
			custDao.item("sign_date", Util.getTimeString());
		}
		if(signTemplate.getString("pay_yn").equals("Y")){
			custDao.item("pay_yn","Y");
		}
		db.setCommand(
				custDao.getUpdateQuery(
						"     cont_no = '"+cont_no+"' "
						+" and cont_chasu= '"+cont_chasu+"' "
						+" and member_no = '"+cust.getString("member_no")+"' "
				)
				, custDao.record);
	}
	
	DataObject dao = new DataObject("tcb_rfile_cust");
	DataSet ds = dao.find("cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' and member_no = '"+w_member_no+"' ");

	//구비서류
	DataObject rfile_cust = null;
	String[] rfile_seq = f.getArr("rfile_seq");
	int rfile_cnt = rfile_seq == null? 0: rfile_seq.length;
	for(int i=0 ; i < rfile_cnt; i ++){
		
		rfile_cust = new DataObject("tcb_rfile_cust");
		rfile_cust.item("cont_no", cont_no);
		rfile_cust.item("cont_chasu", cont_chasu);
		rfile_cust.item("member_no", w_member_no);
		rfile_cust.item("rfile_seq", rfile_seq[i]);
		File file = f.saveFileTime("rfile_"+rfile_seq[i]);
		if(file == null){
			rfile_cust.item("file_path", "");
			rfile_cust.item("file_name", "");
			rfile_cust.item("file_ext", "");
			rfile_cust.item("file_size", "");
			rfile_cust.item("reg_gubun", "");
		}else{
			rfile_cust.item("file_path", cfile.getString("file_path"));
			rfile_cust.item("file_name", file.getName());
			rfile_cust.item("file_ext", Util.getFileExt(file.getName()));
			rfile_cust.item("file_size", file.length());
			rfile_cust.item("reg_gubun", "20");
		}
		boolean insert_yn = true;
		ds.first();
		while(ds.next()){
			if(ds.getString("rfile_seq").equals(rfile_seq[i])){
				insert_yn = false;
			}
		}

		if(insert_yn){
			db.setCommand(rfile_cust.getInsertQuery(), rfile_cust.record);
		}else{
			db.setCommand(
					rfile_cust.getUpdateQuery(
							"     cont_no = '"+cont_no+"' "
									+" and cont_chasu= '"+cont_chasu+"' "
									+" and member_no = '"+w_member_no+"' "
									+" and rfile_seq = '"+rfile_seq[i]+"' ")
					, rfile_cust.record);
		}
	}

	if(!db.executeArray()){
		u.jsError("신청서 작성에 실패 하였습니다.");
		return;
	}		
	
	// sms 및 메일 발송 처리
	SmsDao smsDao = new SmsDao();
	cust.first();
	while(cust.next()){
		if(cust.getString("member_no").equals(w_member_no)){
			DataSet mailInfo = new DataSet();
			mailInfo.addRow();
			mailInfo.put("member_name", cust.getString("member_name"));
			mailInfo.put("user_name", cust.getString("user_name"));
			mailInfo.put("template_name", template.getString("template_name"));
			
			p.setVar("server_name", request.getServerName());
			//p.setVar("return_url", "/web/buyer/contract/subscription_v.jsp?c="+u.aseEnc(cont_no));
			p.setVar("return_url", "/web/buyer/contract/subscription_v.jsp?c="+u.aseEnc(cont_no));
			p.setVar("info", mailInfo);
			if(!cust.getString("email").equals("")){
				String mail_body = p.fetch("../html/mail/subscription_ing.html");
				//System.out.println(mail_body);
				u.mail(cust.getString("email"), "[알림] "+template.getString("template_name")+" 신청 완료", mail_body );
			}
			
			// sms 전송 (정상적인 번호만 sms 전송)
			if((!cust.getString("hp2").equals(""))&& !cust.getString("hp1").equals("") && !cust.getString("hp2").equals("")){
				smsDao.sendSMS("buyer",cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), template.getString("template_name")+" 신청 완료");
			}
		} else {
			// sms 전송 (정상적인 번호만 sms 전송)
			if((!cust.getString("hp2").equals(""))&& !cust.getString("hp1").equals("") && !cust.getString("hp2").equals("")){
				smsDao.sendSMS("buyer",cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), template.getString("template_name")+"_"+f.get("member_name")+" 신청 완료-나이스다큐(일반기업용)");
			}
		}
	}
	
	 u.jsReplace("/web/buyer/contract/subscription_e.jsp?c="+u.aseEnc(template_cd));  // 나이스페이먼츠, 나이스정보통신 분리를 위해서 template_cd를 받아서 분리 (완료(html)단에서 문구가 서로 다름) 
	 // u.jsReplace("./subscription_e.jsp");
	//System.out.println("<script>document.location='./subscription_e.jsp';</script>");
	//System.out.println("--end--");
	return;
}


p.setLayout("subscription");
//p.setDebug(out);
p.setBody("contract.subscription");	
p.setVar("modify", true);
p.setVar("readonly", u.inArray(cont.getString("status"),new String[]{"30","50"}));
p.setVar("mgubun", mgubun);
p.setVar("cont", cont);
p.setVar("vendcd", writer.getString("vendcd"));
p.setVar("template", template);
p.setVar("template_name", template.getString("template_name"));
p.setLoop("templateSub", contSub);
p.setLoop("sign_template", signTemplate);
p.setLoop("rfile", rfile);
//p.setLoop("cust", cust);
//p.setLoop("cfile", cfile);
p.setVar("query", u.getQueryString());
p.setVar("form_script", f.getScript());
p.display(out);
%>