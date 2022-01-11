<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String prod_id = u.request("prod_id").trim();

String temp_seq = u.request("temp_seq");
if (temp_seq.equals("")) {
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

Security security = new	Security();
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_office = codeDao.getCodeArray("C104");
String[] code_vat_type = {"1=>VAT별도", "2=>VAT포함", "3=>VAT미선택"};
 
DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '" + _member_no + "'");
if (!member.next()) {
	u.jsError("사용자 정보가 존재 하지 않습니다.");
	return;
}

DataObject tempDao = new DataObject("tcb_cust_temp");
DataSet cust = tempDao.find(
		  "main_member_no = '" + _member_no + "' and temp_seq = '" + temp_seq + "'"
		, "*"
		, "signer_cd asc, display_seq asc");
if (cust.size() < 1) {
	u.jsError("계약 관계자 정보가 없습니다.");
	return;
}

// 계약 관계 조회
DataSet signTemplate = tempDao.query(
		  "select main_member_no, temp_seq, signer_name, wm_concat(member_no) member_no "
		+ "  from tcb_cust_temp "
		+ " where main_member_no = '" + _member_no + "' "
		+ "   and temp_seq = '" + temp_seq + "' "
		+ " group by main_member_no, temp_seq, signer_name "
		+ " order by max(display_seq) asc");
int t_sign_seq = 1;
while (signTemplate.next()) {
	signTemplate.put("sign_seq", t_sign_seq++);
	signTemplate.put("signer_max", 10);
	signTemplate.put("member_type", signTemplate.getString("member_no").indexOf(_member_no) > -1 ? "01" : "02");
	signTemplate.put("cust_type", signTemplate.getString("member_no").indexOf(_member_no) > -1 ? "01" : "02");
}

while (cust.next()) {
	signTemplate.first();
	while (signTemplate.next()) {
		if (signTemplate.getString("member_no").indexOf(cust.getString("member_no")) > -1) {
			cust.put("sign_seq", signTemplate.getString("sign_seq"));
			break;
		}
	}
}

f.addElement("cont_name",null, "hname:'계약서명', required:'Y'"); // 계약명
f.addElement("cont_date", null, "hname:'계약일자', required:'Y'");
f.addElement("cont_userno", null, "hname:'계약번호', maxbyte:'40'");
f.addElement("cont_sdate", null, "hname:'계약기간'");
f.addElement("cont_edate", null, "hname:'계약기간'");
f.addElement("cont_total", null, "hname:'계약금액'");
//f.addElement("appr_yn", "N", "hname:'전자결재여부', required:'Y'");
f.addElement("stamp_type", "N", "hname:'인지세사용여부', required:'Y'"); 

if (u.isPost() && f.validate()) {
	// 계약서 저장
	ContractDao cont = new ContractDao();
	String cont_no = "";
	String cont_chasu = "";
	
	cont_no = cont.makeContNo("P"); // B2B:B, B2C:C, 자유:F, 종이:P
	cont_chasu = "0";

	String fileDir = Util.getTimeString("yyyy") + "/" + _member_no + "/" + cont_no + "/";

	//String cont_userno = f.get("cont_userno");
	String cont_userno = cont_no;

	DB db = new DB();
	//db.setDebug(out);
	cont = new ContractDao();
	cont.item("cont_no", cont_no);
	cont.item("cont_chasu", cont_chasu);
	cont.item("member_no", _member_no);
	cont.item("field_seq", auth.getString("_FIELD_SEQ"));
	cont.item("cont_name", f.get("cont_name")); // 계약명은 화면에서 자동생성(계약서명 + "-" + 거래처(을)의 사업자번호 or 개인의 이름)
	cont.item("cont_userno", cont_userno);
	cont.item("cont_date", f.get("cont_date").replaceAll("-",""));
	cont.item("cont_sdate", f.get("cont_sdate").replaceAll("-",""));
	cont.item("cont_edate", f.get("cont_edate").replaceAll("-",""));
	cont.item("cont_total", f.get("cont_total").replaceAll(",", ""));
	cont.item("cont_html", "");
	cont.item("reg_date", u.getTimeString());
	cont.item("true_random", u.strpad(u.getRandInt(0,99999) + "", 5, "0"));
	cont.item("reg_id", auth.getString("_USER_ID"));
	if(f.get("menu_cd").equals("000211")){
		cont.item("status", "10");
	}else{
		cont.item("status", "50");
	}
	cont.item("paper_yn", "Y");
	cont.item("stamp_type", f.get("stamp_type"));
	cont.item("appr_yn", f.get("appr_yn"));
	if (f.get("appr_yn").equals("Y")) cont.item("appr_status", "10");
	db.setCommand(cont.getInsertQuery(), cont.record);
 
	// 서명 서식 저장
	String[] sign_seq = f.getArr("sign_seq");
	String[] signer_name = f.getArr("signer_name");
	String[] signer_max = f.getArr("signer_max");
	String[] member_type = f.getArr("member_type");
	String[] cust_type  = f.getArr("cust_type");
	for (int i=0; i<sign_seq.length; i++) {
		DataObject cont_sign = new DataObject("tcb_cont_sign");
		cont_sign.item("cont_no", cont_no);
		cont_sign.item("cont_chasu", cont_chasu);
		cont_sign.item("sign_seq", sign_seq[i]);
		cont_sign.item("signer_name", signer_name[i]);
		cont_sign.item("signer_max", signer_max[i]);
		cont_sign.item("member_type", member_type[i]); // 01:나이스와 계약한 업체 02:나이스 미계약업체
		cont_sign.item("cust_type", cust_type[i]); // 01:갑 02:을
		db.setCommand(cont_sign.getInsertQuery(), cont_sign.record);
	}

	// 업체 저장
	String[] member_no = f.getArr("member_no");
	String[] cust_gubun = f.getArr("cust_gubun");
	String[] cust_sign_seq = f.getArr("cust_sign_seq");
	String[] vendcd = f.getArr("vendcd");
	String[] jumin_no = f.getArr("jumin_no");
	String[] member_name = f.getArr("member_name");
	String[] boss_name = f.getArr("boss_name");
	String[] post_code = f.getArr("post_code");
	String[] address = f.getArr("address");
	String[] tel_num = f.getArr("tel_num");
	String[] member_slno = f.getArr("member_slno");
	String[] user_name = f.getArr("user_name");
	String[] hp1 = f.getArr("hp1");
	String[] hp2 = f.getArr("hp2");
	String[] hp3 = f.getArr("hp3");
	String[] email = f.getArr("email");
	int member_cnt = (member_no == null) ? 0 : member_no.length;
	for (int i=0; i<member_cnt; i++) {
		DataObject custDao = new DataObject("tcb_cust");
		custDao.item("cont_no", cont_no);
		custDao.item("cont_chasu", cont_chasu);
		custDao.item("member_no", member_no[i]);
		custDao.item("sign_seq", cust_sign_seq[i]);
		custDao.item("cust_gubun", cust_gubun[i]); // 01:사업자 02:개인
		custDao.item("vendcd", vendcd[i].replaceAll("-", ""));
		if (cust_gubun[i].equals("02") && !jumin_no[i].equals("")) {
			custDao.item("jumin_no", security.AESencrypt(jumin_no[i].replaceAll("-", "")));
		}
		custDao.item("member_name", member_name[i]);
		custDao.item("boss_name", boss_name[i]);
		custDao.item("post_code", post_code[i].replaceAll("-", ""));
		custDao.item("address", address[i]);
		custDao.item("tel_num", tel_num[i]);
		custDao.item("member_slno", member_slno[i].replaceAll("-", ""));
		custDao.item("user_name", user_name[i]);
		custDao.item("hp1", hp1[i]);
		custDao.item("hp2", hp2[i]);
		custDao.item("hp3", hp3[i]);
		custDao.item("email", email[i]);
		custDao.item("display_seq", i);
		db.setCommand(custDao.getInsertQuery(), custDao.record);
	}
	
	db.setCommand(
			  "update tcb_cust "
			+ "   set list_cust_yn = decode(display_seq, (select min(display_seq) from tcb_cust where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' and member_no <> '" + _member_no + "' ), 'Y') "
			+ " where cont_no = '" + cont_no + "' "
			+ "   and cont_chasu = '" + cont_chasu + "' "
			, null);

	// 계약서류
	f.uploadDir = Startup.conf.getString("file.path.bcont_pdf") + fileDir;
	String file_hash = "";
	String[] cfile_seq = f.getArr("cfile_seq");
	String[] cfile_doc_name = f.getArr("cfile_doc_name");
	int cfile_cnt = (cfile_doc_name == null) ? 0 : cfile_doc_name.length;
	for (int i=0; i<cfile_cnt; i++) {
		DataObject cfileDao = new DataObject("tcb_cfile");
		cfileDao.item("cont_no", cont_no);
		cfileDao.item("cont_chasu", cont_chasu);
		cfileDao.item("cfile_seq", i + 1);
		cfileDao.item("doc_name", cfile_doc_name[i]);
		cfileDao.item("file_path", fileDir);
		File cfile = f.saveFileTime("cfile_" + i);
		if (cfile == null) continue;
		cfileDao.item("file_name", cfile.getName());
		cfileDao.item("file_ext", u.getFileExt(cfile.getName()));
		cfileDao.item("file_size", cfile.length());
		cfileDao.item("auto_yn", "N");
		cfileDao.item("auto_type", "");
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
		file_hash += "|" + cont.getHash("file.path.bcont_pdf", fileDir + cfile.getName());
	}

	// 보증서
	String[] warr_seq = f.getArr("warr_seq");
	String[] warr_type = f.getArr("warr_type");
	String[] warr_office = f.getArr("warr_office");
	String[] warr_no = f.getArr("warr_no");
	String[] warr_amt = f.getArr("warr_amt");
	String[] warr_sdate = f.getArr("warr_sdate");
	String[] warr_edate = f.getArr("warr_edate");
	String[] warr_date = f.getArr("warr_date");
	
	int warr_cnt = (warr_type == null) ? 0 : warr_type.length;
	for (int i=0; i<warr_cnt; i++) {
		DataObject warrDao = new DataObject("tcb_warr");
		warrDao.item("cont_no", cont_no);
		warrDao.item("cont_chasu", cont_chasu);
		warrDao.item("member_no", _member_no);
		warrDao.item("warr_seq", i);
		warrDao.item("warr_type", warr_type[i]);
		warrDao.item("warr_office", warr_office[i]);
		warrDao.item("warr_no", warr_no[i]);
		warrDao.item("warr_amt", warr_amt[i].replaceAll(",", ""));
		warrDao.item("warr_sdate", warr_sdate[i].replaceAll("-", ""));
		warrDao.item("warr_edate", warr_edate[i].replaceAll("-", ""));
		warrDao.item("warr_date", warr_date[i].replaceAll("-", ""));

		File file = f.saveFileTime("warr_file_" + warr_seq[i]);
		warrDao.item("doc_name", f.getFileName("warr_file_" + warr_seq[i]));
		warrDao.item("file_path", fileDir);
		warrDao.item("file_name", file.getName());
		warrDao.item("file_ext", u.getFileExt(file.getName()));
		warrDao.item("file_size", file.length());
		
		warrDao.item("reg_id", auth.getString("_USER_ID"));
		warrDao.item("reg_date", u.getTimeString());
		warrDao.item("status", "30");
		db.setCommand(warrDao.getInsertQuery(), warrDao.record);
	}
	
	// 구비서류
	DataObject rfileDao = null;
	DataObject rfile_cust = null;
	String[] rfile_seq = f.getArr("rfile_seq");
	String[] attch_yn = f.getArr("attch_yn");
	String[] rfile_doc_name = f.getArr("rfile_doc_name");
	String[] rfile_attch_type = f.getArr("attch_type");
	String[] reg_type = f.getArr("reg_type");
	String[] allow_ext = f.getArr("allow_ext");
	int rfile_cnt = (rfile_seq == null) ? 0 : rfile_seq.length;
	for (int i=0; i<rfile_cnt; i++) {
		rfileDao = new DataObject("tcb_rfile");
		rfileDao.item("cont_no", cont_no);
		rfileDao.item("cont_chasu", cont_chasu);
		rfileDao.item("rfile_seq", rfile_seq[i]);
		rfileDao.item("attch_yn", attch_yn[i].equals("Y") ? "Y" : "N");
		rfileDao.item("doc_name", rfile_doc_name[i]);
		rfileDao.item("reg_type", reg_type[i]);
		rfileDao.item("allow_ext", allow_ext[i]);
		db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);
		
		rfile_cust = new DataObject("tcb_rfile_cust");
		rfile_cust.item("cont_no", cont_no);
		rfile_cust.item("cont_chasu", cont_chasu);
		rfile_cust.item("member_no", _member_no);
		rfile_cust.item("rfile_seq", rfile_seq[i]);
		File file = f.saveFileTime("rfile_" + rfile_seq[i]);
		rfile_cust.item("file_path", fileDir);
		rfile_cust.item("file_name", file.getName());
		rfile_cust.item("file_ext", u.getFileExt(file.getName()));
		rfile_cust.item("file_size", file.length());
		rfile_cust.item("reg_gubun", "20");
		db.setCommand(rfile_cust.getInsertQuery(), rfile_cust.record);
	}

	ContractDao cont2 = new ContractDao();
	cont2.item("cont_hash", file_hash);

	db.setCommand(cont2.getUpdateQuery("cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'"), cont2.record);

	if (!db.executeArray()) {
		u.jsError("저장에 실패 하였습니다.");
		return;
	}

	// 임시저장 삭제
	tempDao = new DataObject("tcb_cust_temp");
	tempDao.delete("main_member_no = '" + _member_no + "' and temp_seq = '" + temp_seq + "'");
	if(f.get("menu_cd").equals("000211")){
		u.jsAlertReplace("저장 하였습니다.\\n\\n 임시저장 계약 메뉴로 이동합니다.\\n\\n작성완료처리 후 완료된 계약으로 등록됩니다.", "contract_writing_list.jsp");
	}else{
		u.jsAlertReplace("종이계약서를 작성완료처리 하였습니다.\\n\\n계약완료>종이계약 메뉴에서 조회 가능합니다.","contend_offcont_list.jsp?"+u.getQueryString("cont_no,cont_chasu"));
	}
	return;
}
//계약일자 현재날짜 default
Calendar cal = Calendar.getInstance();
int year = cal.get(Calendar.YEAR);
int month = cal.get(Calendar.MONTH) + 1;
int day = cal.get(Calendar.DAY_OF_MONTH);
String sysDate = year + "-" + String.format("%02d", month)  + "-" + String.format("%02d", day);

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.offcont_modify");
if (prod_id != null && prod_id.equals("000211")) p.setVar("menu_cd", "000211"); // 종이계약검토요청
else p.setVar("menu_cd", "000057"); // 종이계약등록
p.setVar("auth_select", _authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), "000057", "btn_auth").equals("10"));
p.setVar("modify", false);
p.setVar("member", member);
p.setLoop("sign_template", signTemplate);
p.setLoop("cust",cust);
p.setLoop("code_vat_type", u.arr2loop(code_vat_type));
p.setVar("form_script", f.getScript());
p.setVar("sysdate", sysDate);
p.display(out);
%>