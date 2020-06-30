<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.select.*" %>
<%
// 서비스 이용 기간 체크
DataObject useinfoDao = new DataObject("tcb_useinfo");
DataSet useinfo = useinfoDao.find("member_no='"+_member_no+"' and usestartday <='"+u.getTimeString("yyyyMMdd")+"' and useendday>='"+u.getTimeString("yyyyMMdd")+"' ");
if( !useinfo.next() )
{
	u.jsError("서비스 이용기간이 종료 되었습니다.\\n\\n나이스다큐 고객센터[02-788-9097]에 문의하세요.");
	return;
}

Security	security = new	Security();

String template_cd = u.request("template_cd");
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
if(template_cd.equals("")||cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("사용자 정보가 존재하지 않습니다.");
	return;
}

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_change_gubun = codeDao.getCodeArray("M010"," AND code <> '90' ");

// 서식정보 조회
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" status > 0 and template_cd ='"+template_cd+"' and template_type in ('00','20','30')");  // 00: 변경양식=최초양식, 10:변경양식이 별도로 존재하는 최초양식, 20:변경양식, 30:취소양식
if(!template.next()){
}

// 추가 서식정보 조회
DataObject templateSubDao = new DataObject("tcb_cont_template_sub");
DataSet templateSub= templateSubDao.find("template_cd ='"+template_cd+"'");

while(templateSub.next()){
	templateSub.put("hidden", u.inArray(templateSub.getString("gubun"), new String[]{"20","30"}) );
	if(templateSub.getString("option_yn").equals("A")) // 자동 생성해야 하는 양식
		templateSub.put("option_yn", false);
}


//기존계약서 가져 오기
ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet tempCont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' "
								,"tcb_contmaster.* "
							   +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,3) = substr(tcb_contmaster.src_cd,0,3) and depth='1') l_src_nm "
							   +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,6) = substr(tcb_contmaster.src_cd,0,6) and depth='2') m_src_nm "
							   +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and src_cd = tcb_contmaster.src_cd and depth='3') s_src_nm "
								);
if(!tempCont.next()){
}

if(!tempCont.getString("src_cd").equals(""))
tempCont.put("src_nm", tempCont.getString("l_src_nm")+">"+tempCont.getString("m_src_nm")+">"+tempCont.getString("s_src_nm"));
//프로젝트관리 사용시 //하이엔텍 사용 
if(!tempCont.getString("project_seq").equals("")){
	DataObject projectDao = new DataObject("tcb_project");
	DataSet project  = projectDao.find(" member_no = '"+_member_no+"' and project_seq = '"+tempCont.getString("project_seq")+"' ");
	if(project.next()){
		tempCont.put("project_name", project.getString("project_name"));
		tempCont.put("project_cd", project.getString("project_cd"));
	}
}



if(template.getString("template_type").equals("00")){ // 변경계약서가 최초계약이랑 같은 양식인 경우는 기존 양식을 가져온다.
	if(!tempCont.getString("template_cd").equals("")) // 최초가 자유서식계약이 아닌 경우
		template.put("template_html", tempCont.getString("cont_html"));
} else {
	String beforeVal = "";
	String rowChar = "`";

	// 계약 html 내용
	Document doc = Jsoup.parse(tempCont.getString("cont_html"));

	Elements inputs = doc.select("input");
	String type="";
	for(Element input : inputs)
	{
		type = input.attr("type");

		if(type.equals("") || type.equals("text")) // text
		{
			if(!input.attr("name").equals(""))
				beforeVal += rowChar + input.attr("name") + "↕" +input.attr("value");
		} else if(type.equals("checkbox"))
		{
			if(!input.attr("name").equals(""))
				if(input.outerHtml().toLowerCase().indexOf("checked")>0){//체크 된경우만 추가
					beforeVal += rowChar + input.attr("name") + "↕" +input.attr("value");
				}
		} else if(type.equals("radio"))
		{
			if(!input.attr("name").equals("") && input.hasAttr("checked"))
				beforeVal += rowChar + input.attr("name") + "↕" +input.attr("value");
		}

	}

	Elements selects = doc.select("select");
	for(Element select : selects)
	{
		if(!select.attr("name").equals(""))
		{
			for(Element option : select.children())
			{
				if(option.hasAttr("selected"))
					beforeVal += rowChar + select.attr("name") + "↕" +option.attr("value");
			}
		}
	}

	Elements textareas = doc.select("textarea");
	for(Element textarea : textareas)
	{
		if(!textarea.attr("name").equals(""))
			beforeVal += rowChar + textarea.attr("name") + "↕" +textarea.text();
	}


	// 계약 DB 내용
	beforeVal += rowChar + "db_cont_name" + "↕" +tempCont.getString("cont_name"); // 계약명
	beforeVal += rowChar + "db_supp_tax" + "↕" +tempCont.getString("supp_tax");  // 공급가액
	beforeVal += rowChar + "db_supp_vat" + "↕" +tempCont.getString("supp_vat");  // 부가세
	beforeVal += rowChar + "db_cont_total" + "↕" +tempCont.getString("cont_total");  // 부가세
	beforeVal += rowChar + "db_cont_year" + "↕" +u.getTimeString("yyyy",tempCont.getString("cont_date")); // 계약일자
	beforeVal += rowChar + "db_cont_month" + "↕" +u.getTimeString("MM",tempCont.getString("cont_date")); // 계약일자
	beforeVal += rowChar + "db_cont_day" + "↕" +u.getTimeString("dd",tempCont.getString("cont_date")); // 계약일자
	beforeVal += rowChar + "db_org_cont_chasu" + "↕" + tempCont.getString("cont_chasu"); // 원계약차수
	p.setVar("beforeVal",java.net.URLEncoder.encode(beforeVal,"UTF-8"));  // java에서 인코딩하고 javascript에서 디코딩해야 개행문자들이 제대로 적용
}


//서명서식 조회
DataObject signTemplateDao = new DataObject("tcb_cont_sign_template");
DataSet signTemplate = signTemplateDao.find(" template_cd = '"+template_cd+"'");

// 내부 결재정보 조회
DataObject agreeTemplateDao = new DataObject("tcb_agree_template");
DataSet agreeTemplate= agreeTemplateDao.find("template_cd ='"+template_cd+"'", "*", "agree_seq");
if(agreeTemplate.size()>0){
	// 사용자 저장된 결재정보
	DataObject agreeUserDao = new DataObject("tcb_agree_user");
	DataSet agreeUser= agreeUserDao.find("template_cd ='"+template_cd+"' and user_id = '"+auth.getString("_USER_ID")+"'", "*", "agree_seq");
	if(agreeUser.size()>0){
		agreeTemplate = agreeUser;
	}
}
while(agreeTemplate.next()){
	agreeTemplate.put("is_cust", agreeTemplate.getString("agree_cd").equals("0"));
	agreeTemplate.put("agree_person_id", agreeTemplate.getString("agree_cd").equals("0")?"-":agreeTemplate.getString("agree_person_id"));
}

DataObject attCfileDao = new DataObject("tcb_att_cfile");
DataSet cfile = attCfileDao.find("template_cd = '"+template_cd+"' and member_no = '"+_member_no+"' ");
while(cfile.next()){
	cfile.put("cfile_seq", cfile.getString("file_seq"));
	cfile.put("auto", true);
	cfile.put("auto_class", "caution-text");
	cfile.put("auto_str",cfile.getString("auto_type").equals("1")?"자동첨부":"필수첨부");
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	cfile.put("doc_name_readonly", "readonly");
	cfile.put("modfiy_file", false);
	cfile.put("btn_name", "다운로드");
	cfile.put("down_script","filedown('file.path.bcont_template','"+cfile.getString("file_path")+cfile.getString("file_name")+"','"+cfile.getString("doc_name")+"."+cfile.getString("file_ext")+"')");
}

// 구비서류 조회
DataObject rfileDao = new DataObject("tcb_rfile_template");
//rfileDao.setDebug(out);
DataSet rfile = rfileDao.find("template_cd = '"+template_cd+"' and member_no ='"+_member_no+"'");
while(rfile.next()){
	rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
}


//내부 관리 서류 조회
String[] code_reg_type = {"10=><span class='caution-text'>필수첨부</span>","20=>선택첨부","30=>추가첨부"};
DataObject efileDao = new DataObject("tcb_efile");
DataSet efile = new DataSet();
if(tempCont.getString("efile_yn").equals("Y")){
	efile = efileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
	while(efile.next()){
		efile.put("str_reg_type", u.getItem(efile.getString("reg_type"), code_reg_type));
		//efile.put("required", u.inArray(efile.getString("reg_type"), new String[]{"10","30"})?"required='Y'":"");
		efile.put("doc_name_readonly", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"readonly":"");
		efile.put("doc_name_class", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"in_readonly":"label");
		efile.put("del_yn10", efile.getString("reg_type").equals("10")&&!efile.getString("file_name").equals(""));
		efile.put("del_yn20", efile.getString("reg_type").equals("20")&&!efile.getString("file_name").equals(""));
		efile.put("del_yn30", efile.getString("reg_type").equals("30"));
		efile.put("file_size_str", u.getFileSize(efile.getInt("file_size")));
		efile.put("down_script","filedown('file.path.bcont_pdf','"+efile.getString("file_path")+efile.getString("file_name")+"','"+efile.getString("doc_name")+"."+efile.getString("file_ext")+"')");
	}
}




// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", " sign_seq  asc");
while(cust.next()){
	DataSet cust_member = memberDao.find(" member_no = '" + cust.getString("member_no") + "'", "member_name, boss_name, address,member_gubun");
	if(cust_member.next())
	{
		cust.put("member_name", cust_member.getString("member_name"));
		cust.put("boss_name", cust_member.getString("boss_name"));
		cust.put("address", cust_member.getString("address"));
		cust.put("member_gubun",cust_member.getString("member_gubun"));
	}else{
		cust.put("member_gubun","04");//회원 정보에없는 경우는 개인밖에 없다.
	}
	
	if(!cust.getString("jumin_no").equals("")){
		cust.put("jumin_no", security.AESdecrypt(cust.getString("jumin_no")));
	}else{
		cust.put("jumin_no", "");
	}
	cust.put("boss_birth_date", u.getTimeString("yyyy-MM-dd", cust.getString("boss_birth_date")));
}


f.addElement("cont_name",null, "hname:'계약명', required:'Y'");
f.addElement("cont_date", null, "hname:'계약일자', required:'Y'");
f.addElement("cont_userno", null, "hname:'계약번호', maxbyte:'40'");
f.addElement("src_cd", tempCont.getString("src_cd"), "hname:'소싱그룹'");
f.addElement("change_gubun", null, "hname:'계약구분', required:'Y'");

if(template.getString("stamp_yn").equals("Y")){
	f.addElement("stamp_type", null, "hname:'인지세 납부 대상', required:'Y'");
}

if(u.isPost()&&f.validate()){
	//계약서 저장
	ContractDao cont = new ContractDao();

	cont_chasu = String.valueOf(Integer.parseInt(cont_chasu)+1);

	String random_no = u.strpad(u.getRandInt(0,99999)+"",5,"0");
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
		if(gubun[i].equals("10")&&u.inArray(f.get("option_yn_"+i), new String[]{"A","Y"})){
			cont_html_rm_str += cont_html_rm[i];
		}
	}

	ArrayList autoFiles = new ArrayList();

	String cont_userno = f.get("cont_userno");

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
	pdfInfo.put("file_seq", file_seq++);
	DataSet pdf = cont.makePdf(pdfInfo);
	if(pdf==null){
		u.jsError("계약서 파일 생성에 실패 하였습니다.");
		return;
	}
	//자동생성파일 생성
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		if(gubun[i].equals("10")) continue;
		if(    gubun[i].equals("20")
			|| ( gubun[i].equals("40") && (arrOption_yn[i].equals("A") || arrOption_yn[i].equals("Y"))) // 자동으로 생성되는 양식 또는 체크된 양식인 경우
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
				pdfInfo2.put("file_seq", file_seq++);
				DataSet pdf2 = cont.makePdf(pdfInfo2);
				pdf2.put("cont_sub_name", cont_sub_name[i]);
				autoFiles.add(pdf2);
		}
	}

	//계약기간구하기
	String cont_sdate = f.get("cont_sdate").replaceAll("-","");
	String cont_edate = f.get("cont_edate").replaceAll("-","");;
	if(!f.get("cont_syear").equals("")&&!f.get("cont_smonth").equals("")&&!f.get("cont_sday").equals("")){
		cont_sdate = u.strrpad(f.get("cont_syear"),4,"0")+u.strrpad(f.get("cont_smonth"),2,"0")+u.strrpad(f.get("cont_sday"),2,"0");
	}
	if(!f.get("cont_eyear").equals("")&&!f.get("cont_emonth").equals("")&&!f.get("cont_eday").equals("")){
		cont_edate = u.strrpad(f.get("cont_eyear"),4,"0")+u.strrpad(f.get("cont_emonth"),2,"0")+u.strrpad(f.get("cont_eday"),2,"0");
	}else if(!f.get("cont_term").equals("")){
		Date date = u.addDate("D", -1, u.strToDate("yyyy-MM-dd",f.get("cont_date")));
		cont_sdate = f.get("cont_date").replaceAll("-", "");
		cont_edate = u.addDate("Y",Integer.parseInt(f.get("cont_term")),date,"yyyyMMdd");
	}else if(!f.get("cont_term_month").equals("")){
		Date date = u.addDate("D", -1, u.strToDate("yyyy-MM-dd",f.get("cont_date")));
		cont_sdate = f.get("cont_date").replaceAll("-", "");
		cont_edate = u.addDate("M",Integer.parseInt(f.get("cont_term_month")),date,"yyyyMMdd");
	}

	DB db = new DB();
	//db.setDebug(out);
	cont = new ContractDao();
	cont.item("cont_no", cont_no);
	cont.item("cont_chasu", cont_chasu);
	cont.item("member_no", _member_no);
	cont.item("field_seq", auth.getString("_FIELD_SEQ"));
	cont.item("template_cd", f.get("template_cd"));
	cont.item("cont_name", f.get("cont_name"));
	cont.item("cont_date", f.get("cont_date").replaceAll("-",""));
	cont.item("cont_sdate", cont_sdate);
	cont.item("cont_edate", cont_edate);
	cont.item("supp_tax", f.get("supp_tax").replaceAll(",",""));
	cont.item("supp_taxfree", f.get("supp_taxfree").replaceAll(",",""));
	cont.item("supp_vat", f.get("supp_vat").replaceAll(",",""));
	cont.item("cont_total", f.get("cont_total").replaceAll(",",""));
	cont.item("cont_userno", cont_userno);
	cont.item("cont_html", cont_html[0]);
	cont.item("org_cont_html", cont_html[0]);
	cont.item("reg_date", u.getTimeString());
	cont.item("true_random", random_no);
	cont.item("reg_id", auth.getString("_USER_ID"));
	cont.item("status", "10");
	cont.item("change_gubun", f.get("change_gubun"));
	cont.item("bid_kind_cd", tempCont.getString("bid_kind_cd"));
	cont.item("src_cd", tempCont.getString("src_cd"));
	cont.item("stamp_type", f.get("stamp_type"));
	if(template.getString("efile_yn").equals("Y")){
		cont.item("efile_yn", "Y");
	}
	cont.item("sign_types", template.getString("sign_types"));
	cont.item("project_seq", tempCont.getString("project_seq"));
	db.setCommand(cont.getInsertQuery(), cont.record);

	for(int i = 1 ; i < cont_html.length; i++) {
		DataObject cont_sub = new DataObject("tcb_cont_sub");
		cont_sub.item("cont_no", cont_no);
		cont_sub.item("cont_chasu", cont_chasu);
		cont_sub.item("sub_seq", i);
		cont_sub.item("cont_sub_html",cont_html[i]);
		cont_sub.item("org_cont_sub_html",cont_html[i]);
		cont_sub.item("cont_sub_name",cont_sub_name[i]);
		cont_sub.item("cont_sub_style",cont_sub_style[i]);
		cont_sub.item("gubun", gubun[i]);
		cont_sub.item("option_yn",arrOption_yn[i]);
		db.setCommand(cont_sub.getInsertQuery(), cont_sub.record);
	}


	// 서명 서식 저장
	String[] sign_seq = f.getArr("sign_seq");
	String[] signer_name = f.getArr("signer_name");
	String[] signer_max = f.getArr("signer_max");
	String[] member_type = f.getArr("member_type");
	String[] cust_type  = f.getArr("cust_type");
	for(int i = 0 ; i < sign_seq.length; i ++){
		DataObject cont_sign = new DataObject("tcb_cont_sign");
		cont_sign.item("cont_no",cont_no);
		cont_sign.item("cont_chasu",cont_chasu);
		cont_sign.item("sign_seq", sign_seq[i]);
		cont_sign.item("signer_name", signer_name[i]);
		cont_sign.item("signer_max", signer_max[i]);
		cont_sign.item("member_type", member_type[i]);// 01:나이스와 계약한 업체 02:나이스 미계약업체
		cont_sign.item("cust_type", cust_type[i]);// 01:갑 02:을
		db.setCommand(cont_sign.getInsertQuery(), cont_sign.record);
	}

	// 내부 결재 서식 저장
	String agree_field_seqs = "";
	String agree_person_ids = "";
	String[] agree_seq = f.getArr("agree_seq");
	int agree_cnt = agree_seq == null? 0: agree_seq.length;
	if(agree_cnt > 0)
	{
		db.setCommand("delete from tcb_cont_agree where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
		db.setCommand("delete from tcb_agree_user where template_cd = '"+template_cd+"' and user_id = '"+auth.getString("_USER_ID")+"' ",null);

		String[] agree_name = f.getArr("agree_name");
		String[] agree_field_seq = f.getArr("agree_field_seq");
		String[] agree_person_name = f.getArr("agree_person_name");
		String[] agree_person_id = f.getArr("agree_person_id");
		String[] agree_cd = f.getArr("agree_cd");
		for(int i = 0 ; i < agree_cnt; i ++){
			DataObject cont_agree = new DataObject("tcb_cont_agree");
			cont_agree.item("cont_no",cont_no);
			cont_agree.item("cont_chasu",cont_chasu);
			cont_agree.item("agree_seq", agree_seq[i]);
			cont_agree.item("agree_name", agree_name[i]);
			cont_agree.item("agree_field_seq", agree_field_seq[i]);
			cont_agree.item("agree_person_name", agree_person_name[i]);
			cont_agree.item("agree_person_id", agree_person_id[i]);
			cont_agree.item("agree_cd", agree_cd[i]);	// 결재구분코드(0:업체서명전, 1:업체서명후)
			db.setCommand(cont_agree.getInsertQuery(), cont_agree.record);
			agree_field_seqs += agree_field_seq[i] + "|";
			agree_person_ids += agree_person_id[i] + "|";

			// 본인 결재 라인에 저장
			DataObject cont_agree_user = new DataObject("tcb_agree_user");
			cont_agree_user.item("template_cd", template_cd);
			cont_agree_user.item("user_id", auth.getString("_USER_ID"));
			cont_agree_user.item("agree_seq", agree_seq[i]);
			cont_agree_user.item("agree_name", agree_name[i]);
			cont_agree_user.item("agree_field_seq", agree_field_seq[i]);
			cont_agree_user.item("agree_person_name", agree_person_name[i]);
			cont_agree_user.item("agree_person_id", agree_person_id[i]);
			cont_agree_user.item("agree_cd", agree_cd[i]);	// 결재구분코드(0:업체서명전, 1:업체서명후)
			db.setCommand(cont_agree_user.getInsertQuery(), cont_agree_user.record);
		}
	}

	// 업체 저장
	String[] member_no = f.getArr("member_no");
	String[] cust_sign_seq = f.getArr("cust_sign_seq");
	String[] vendcd = f.getArr("vendcd");
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
	String[] jumin_no = f.getArr("jumin_no");
	String[] member_gubun = f.getArr("member_gubun");  // 01:법인(본사), 02:법인(지사), 03:개인사업자
	String[] cust_gubun = f.getArr("cust_gubun");
	String[] cust_detail_code = f.getArr("cust_detail_code");
	String[] boss_birth_date = f.getArr("boss_birth_date");
	String[] boss_gender = f.getArr("boss_gender");
	int member_cnt = member_no == null? 0: member_no.length;
	for(int i = 0 ; i < member_cnt; i ++){
		signTemplate.first();
		while(signTemplate.next()){
			if(signTemplate.getString("sign_seq").equals(cust_sign_seq[i])){
				break;
			}
		}
		custDao = new DataObject("tcb_cust");
		custDao.item("cont_no", cont_no);
		custDao.item("cont_chasu",cont_chasu);
		custDao.item("member_no",member_no[i]);
		custDao.item("sign_seq", cust_sign_seq[i]);
		custDao.item("cust_gubun", cust_gubun[i]);//01:사업자 02:개인
		custDao.item("vendcd", vendcd[i].replaceAll("-",""));
		if(cust_gubun[i].equals("02")&&!jumin_no[i].equals("")){
			custDao.item("jumin_no", security.AESencrypt(jumin_no[i].replaceAll("-","")));
		}
		if(member_gubun[i].equals("03")&&!jumin_no[i].equals("")){  // 개인사업자이지만 생년월일이 있는 경우
			custDao.item("jumin_no", security.AESencrypt(jumin_no[i].replaceAll("-","")));
		}
		custDao.item("member_name", member_name[i]);
		custDao.item("boss_name", boss_name[i]);
		custDao.item("post_code", post_code[i].replaceAll("-",""));
		custDao.item("address", address[i]);
		custDao.item("tel_num", tel_num[i]);
		custDao.item("member_slno", member_slno[i].replaceAll("-",""));
		custDao.item("user_name", user_name[i]);
		custDao.item("hp1", hp1[i]);
		custDao.item("hp2", hp2[i]);
		custDao.item("hp3", hp3[i]);
		custDao.item("email", email[i]);
		custDao.item("display_seq", i);
		custDao.item("cust_detail_code", cust_detail_code[i]);
		custDao.item("boss_birth_date", boss_birth_date[i].replaceAll("-", ""));
		custDao.item("boss_gender", boss_gender[i]);
		if(signTemplate.getString("pay_yn").equals("Y")){
			custDao.item("pay_yn","Y");
		}

		if(member_no[i]==null || member_no[i].equals("")) {
			custDao.item("member_no", Util.strrpad(""+i, 11, "0"));
			custDao.item("boss_name", member_name[i]);
		 	custDao.item("user_name", member_name[i]);
		}

		db.setCommand(custDao.getInsertQuery(), custDao.record);
	}

	db.setCommand(
			 " update tcb_cust "
			+"    set list_cust_yn = decode(display_seq, (select min(display_seq)  from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no <> '"+_member_no+"' ),'Y') "
			+"  where cont_no = '"+cont_no+"' "
			+"    and cont_chasu = '"+cont_chasu+"' "	 
					,null);
	
	int cfile_seq_real = 1;
	String file_hash = pdf.getString("file_hash");
	f.uploadDir = Startup.conf.getString("file.path.bcont_pdf")+pdf.getString("file_path");
	//계약서류 갑지
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
		if(temp.getString("gubun").equals("50"))	// 작성업체만 보고 인쇄하는 양식은 서명대상이 아님.  gubun[i].equals("50")
			cfileDao.item("auto_type", "3");	// 공백:자동생성, 1:자동첨부, 2:필수첨부, 3:내부용
		else
		{
			file_hash+="|"+temp.getString("file_hash");
			cfileDao.item("auto_type", "");
		}
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
	}

	String[] cfile_seq = f.getArr("cfile_seq");
	String[] cfile_doc_name = f.getArr("cfile_doc_name");
	String[] cfile_auto_type = f.getArr("cfile_auto_type");
	int cfile_cnt = cfile_doc_name==null? 0 : cfile_doc_name.length;
	for(int i = 0 ;i < cfile_cnt; i ++){
		String cfile_name = "";
		cfileDao = new DataObject("tcb_cfile");
		cfileDao.item("cont_no", cont_no);
		cfileDao.item("cont_chasu", cont_chasu);
		cfileDao.item("cfile_seq",cfile_seq_real++);
		cfileDao.item("doc_name", cfile_doc_name[i]);
		cfileDao.item("file_path", pdf.getString("file_path"));
		File attfile = f.saveFileTime("cfile_"+cfile_seq[i]);
		if(attfile == null){
			cfile.first();
			while(cfile.next()){
				if(cfile.getString("cfile_seq").equals(cfile_seq[i])){
					cfileDao.item("file_name", cfile.getString("file_name"));
					cfileDao.item("file_ext", cfile.getString("file_ext"));
					cfileDao.item("file_size", cfile.getString("file_size"));
					String sourceFile = Startup.conf.getString("file.path.bcont_template")+template_cd+"/"+_member_no+"/"+cfile.getString("file_name");
					String targetFile = Startup.conf.getString("file.path.bcont_pdf")+pdf.getString("file_path")+cfile.getString("file_name");
					u.copyFile(sourceFile, targetFile);
					cfile_name = cfile.getString("file_name");
				}
			}
		}else{
			cfileDao.item("file_name", attfile.getName());
			cfileDao.item("file_ext", u.getFileExt(attfile.getName()));
			cfileDao.item("file_size", attfile.length());
			cfile_name = attfile.getName();
		}
		if(cfile_name.equals("")){
			u.jsError("저장에 실패 하였습니다.");
			return;
		}
		cfileDao.item("auto_yn",cfile_auto_type[i].equals("")?"N":"Y");
		cfileDao.item("auto_type", cfile_auto_type[i]);
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
		file_hash +="|"+cont.getHash("file.path.bcont_pdf",pdf.getString("file_path")+cfile_name);
	}

	//보증서
	String[] warr_type = f.getArr("warr_type");
	String[] warr_etc = f.getArr("warr_etc");
	int warr_cnt = warr_type== null? 0: warr_type.length;
	for(int i = 0 ; i < warr_cnt; i ++){
		DataObject warrDao = new DataObject("tcb_warr");
		warrDao.item("cont_no", cont_no);
		warrDao.item("cont_chasu", cont_chasu);
		warrDao.item("member_no", "");
		warrDao.item("warr_seq", i);
		warrDao.item("warr_type", warr_type[i]);
		warrDao.item("etc", warr_etc[i]);
		db.setCommand(warrDao.getInsertQuery(), warrDao.record);
	}

	//구비서류
	String[] attch_yn = f.getArr("attch_yn");
	String[] rfile_doc_name = f.getArr("rfile_doc_name");
	int rfile_cnt = rfile_doc_name == null? 0: rfile_doc_name.length;
	for(int i=0 ; i < rfile_cnt; i ++){
		rfileDao = new DataObject("tcb_rfile");
		rfileDao.item("cont_no", cont_no);
		rfileDao.item("cont_chasu", cont_chasu);
		rfileDao.item("rfile_seq", i+1);
		rfileDao.item("attch_yn", attch_yn[i].equals("Y")?"Y":"N");
		rfileDao.item("doc_name", rfile_doc_name[i]);
		db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);
	}
	
	
	// 내부관리서류
	if(template.getString("efile_yn").equals("Y")){
		db.setCommand("delete from tcb_efile where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
		String[] efile_seq = f.getArr("efile_seq");
		String[] efile_reg_type = f.getArr("efile_reg_type");
		String[] efile_doc_name = f.getArr("efile_doc_name");
		String[] efile_del_yn = f.getArr("efile_del_yn");
		int efile_cnt = efile_seq == null? 0: efile_seq.length;
		for(int i=0 ; i < efile_cnt; i ++){
			efileDao = new DataObject("tcb_efile");
			efileDao.item("cont_no", cont_no);
			efileDao.item("cont_chasu", cont_chasu);
			efileDao.item("efile_seq", efile_seq[i]);
			efileDao.item("doc_name", efile_doc_name[i]);
			File attfile = f.saveFileTime("efile_"+efile_seq[i]);
			String efile_name = "";
			if(attfile == null){
				if(!efile_del_yn[i].equals("Y")){
					efile.first();
					while(efile.next()){
						if(efile_seq[i].equals(efile.getString("efile_seq"))){
							efileDao.item("file_path", pdf.getString("file_path"));
							efileDao.item("file_name", efile.getString("file_name"));
							efileDao.item("file_ext", efile.getString("file_ext"));
							efileDao.item("file_size", efile.getString("file_size"));
							efileDao.item("reg_date", efile.getString("reg_date"));
							efileDao.item("reg_id", efile.getString("reg_id"));
						}
					}	
				}else{
					efileDao.item("file_path", "");
					efileDao.item("file_name", "");
					efileDao.item("file_ext", "");
					efileDao.item("file_size", "");
					efileDao.item("reg_date", efile.getString("reg_date"));
					efileDao.item("reg_id", efile.getString("reg_id"));
				}
				
			}else{
				efileDao.item("file_path", pdf.getString("file_path"));
				efileDao.item("file_name", attfile.getName());
				efileDao.item("file_ext", u.getFileExt(attfile.getName()));
				efileDao.item("file_size", attfile.length());
				efileDao.item("reg_date", u.getTimeString());
				efileDao.item("reg_id", auth.getString("_USER_ID"));
			}
			efileDao.item("reg_type", efile_reg_type[i]);
			db.setCommand(efileDao.getInsertQuery(), efileDao.record);
		}
	}
	
	
	
	// 인지세
	if(template.getString("stamp_yn").equals("Y")){
		int nStampType = f.getInt("stamp_type");
		for(int i = 0 ; i < member_cnt; i ++){
			if(nStampType==0) break;  // 해당 사항 없음
			if(nStampType==1 && i==1) continue; // 원사업자 납부
			if(nStampType==2 && i==0) continue; // 수급사업자 납부
			
			DataObject stampDao = new DataObject("tcb_stamp");
			stampDao.item("cont_no", cont_no);
			stampDao.item("cont_chasu", cont_chasu);
			stampDao.item("member_no", member_no[i]);
			db.setCommand(stampDao.getInsertQuery(), stampDao.record);
		}
	}	
	
	ContractDao cont2 = new ContractDao();
	cont2.item("cont_hash", file_hash);
	if(agree_cnt > 0)
	{
		cont2.item("agree_field_seqs", agree_field_seqs);
		cont2.item("agree_person_ids", agree_person_ids);
	}
	db.setCommand(cont2.getUpdateQuery("cont_no= '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), cont2.record);


	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장하였습니다.\\n\\n임시저장계약 메뉴로 이동합니다.","contract_writing_list.jsp?");
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_msign_chang_insert");
p.setVar("menu_cd","000058");
p.setVar("modify", false);
p.setVar("member", member);
p.setVar("template", template);
p.setLoop("templateSub", templateSub);
p.setLoop("sign_template", signTemplate);
p.setLoop("agreeTemplate", agreeTemplate);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("rfile", rfile);
p.setVar("efile_yn", template.getString("efile_yn").equals("Y"));//내부 관리 서류 사용여부
p.setLoop("efile", efile);
p.setLoop("code_warr", u.arr2loop(code_warr));
p.setLoop("code_change_gubun", u.arr2loop(code_change_gubun));
p.setVar("tempCont", tempCont);
p.setVar("form_script", f.getScript());
p.setVar("warr_yn", template.getString("warr_yn").equals("")||template.getString("warr_yn").equals("Y"));
p.setVar("view_project", !tempCont.getString("project_seq").equals(""));//하이엔텍
p.setVar("query", u.getQueryString());
p.display(out);
%>