<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
Security	security	=	new	Security();

String template_cd = "";
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("사용자 정보가 존재하지 않습니다.");
	return;
}

// 사용자 계약번호 자동 설정 여부
boolean bAutoContUserNo = u.inArray(_member_no, new String[]{"20130500019","20121203661","20130400011","20130400010","20130400009","20130400008","20140900004"});
boolean bIsKakao = u.inArray(_member_no, new String[]{"20130900194","20181201176"});

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_change_gubun = codeDao.getCodeArray("M010"," AND code <> '90' ");
String[] code_auto_type = {"=>자동생성","1=>자동첨부","2=>필수첨부","3=>내부용"};

String random_no = "";
String cont_userno = "";

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
template_cd = cont.getString("template_cd");
random_no = cont.getString("true_random");
cont_userno = cont.getString("cont_userno");

cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
if(!cont.getString("src_cd").equals(""))
cont.put("src_nm", cont.getString("l_src_nm")+" > "+cont.getString("m_src_nm")+" > "+cont.getString("s_src_nm"));

// 추가 계약서 조회
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

// 서식정보 조회
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" status > 0 and template_cd ='"+cont.getString("template_cd")+"'");
if(!template.next()){
}


DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");

// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq <= 10");  // sign_seq 가 10보다 큰거는 연대보증
if(!cust.next()){
	u.jsError("계약업체 정보가 존재 하지 않습니다.");
	return;
}
while(cust.next()){
    cust.put("cont_no", u.aseEnc(cust.getString("cont_no")));
	if(cust.getString("cust_gubun").equals("02")){
		if(!cust.getString("jumin_no").equals("")){
			cust.put("jumin_no", security.AESdecrypt(cust.getString("jumin_no")));
		}
	}else{
		cust.put("jumin_no", "");
	}

}

//계약서류 조회
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	if(cfile.getString("auto_yn").equals("Y")){

		cfile.put("auto_str", u.getItem(cfile.getString("auto_type"), code_auto_type));
		if(cfile.getString("auto_type").equals("")){
			cfile.put("auto_type","0");
		}

		/*
		if(cfile.getString("auto_type").equals("1")){
			cfile.put("auto_str","자동첨부");
		}
		if(cfile.getString("auto_type").equals("2")){
			cfile.put("auto_str","필수첨부");
		}
		if(cfile.getString("auto_type").equals("")){
			cfile.put("auto_str","자동생성");
			cfile.put("auto_type","0");
		}
		*/
	}else{
		cfile.put("auto_str", "직접첨부");
	}
	cfile.put("auto", cfile.getString("auto_yn").equals("Y"));
	cfile.put("auto_class", cfile.getString("auto_yn").equals("Y")?"caution-text":"");
	cfile.put("file_yn", !cfile.getString("file_name").equals(""));
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	cfile.put("doc_name_readonly", cfile.getString("auto_yn").equals("Y")?"readonly":"");
	cfile.put("modfiy_file", cfile.getString("auto_type").equals("2"));
	if(cfile.getString("file_ext").toLowerCase().equals("pdf")){
		cfile.put("btn_name", "조회(인쇄)");
		cfile.put("down_script","contPdfViewer('"+u.request("cont_no")+"','"+cont_chasu+"','"+cfile.getString("cfile_seq")+"')");
	}else{
		cfile.put("btn_name", "다운로드");
		cfile.put("down_script","filedown('file.path.bcont_pdf','"+cfile.getString("file_path")+cfile.getString("file_name")+"','"+cfile.getString("doc_name")+"."+cfile.getString("file_ext")+"')");
	}
}

//보증정보조회
DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(warr.next()){
    warr.put("cont_no", u.aseEnc(warr.getString("cont_no")));
}


// 구비서류 조회
DataObject rfileDao = new DataObject("tcb_rfile");
//rfileDao.setDebug(out);
DataSet rfile = rfileDao.query(
		 " select a.*, b.file_name, b.file_path, b.file_ext, b.file_size "
		+"   from tcb_rfile a                                            "
		+"   left outer join tcb_rfile_cust b                            "
		+"     on a.cont_no = b.cont_no                                  "
		+"    and a.cont_chasu = b.cont_chasu                            "
		+"    and a.rfile_seq = b.rfile_seq                              "
		+"    and member_no = '"+_member_no+"'                           "
		+"  where a.cont_no = '"+cont_no+"'                              "
		+"    and a.cont_chasu = '"+cont_chasu+"'                        "
		);
while(rfile.next()){
    rfile.put("cont_no", u.aseEnc(rfile.getString("cont_no")));
	rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
	if(!rfile.getString("file_name").equals(""))
	rfile.put("str_file_size", u.getFileSize(rfile.getLong("file_size")));

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


f.addElement("cont_name", cont.getString("cont_name"), "hname:'계약명', required:'Y'");
if(!template.getString("person_yn").equals("Y")){
	f.addElement("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")), "hname:'계약일자', required:'Y'");
}else{
	f.addElement("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")), "hname:'계약일자'");
}
f.addElement("cont_userno", cont.getString("cont_userno"), "hname:'계약번호', maxbyte:'40'");
if(Integer.parseInt(cont_chasu)>0)
f.addElement("change_gubun", cont.getString("change_gubun"), "hname:'계약구분', required:'Y'");
if(!member.getString("src_depth").equals(""))
f.addElement("src_cd", cont.getString("src_cd"), "hname:'소싱그룹'");

if(bIsKakao) {
	f.addElement("cont_etc1", cont.getString("cont_etc1"), "hname:'수익쉐어', maxbyte:'255'");
	f.addElement("cont_etc2", cont.getString("cont_etc2"), "hname:'양도/종료'");
	f.addElement("cont_etc3", cont.getString("cont_etc3"), "hname:'기타사항', maxbyte:'255'");
}

if(u.isPost()&&f.validate()){
	//계약서 저장
	contDao = new ContractDao();

	String cont_html_rm_str = "";
	String[] cont_html_rm = f.getArr("cont_html_rm");
	String[] cont_html = f.getArr("cont_html");
	String[] cont_sub_name = f.getArr("cont_sub_name");
	String[] cont_sub_style = f.getArr("cont_sub_style");
	String[] gubun = f.getArr("gubun");
	String[] sub_seq = f.getArr("sub_seq");

	//decodeing 처리 START
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		cont_html_rm[i] = new String(Base64Coder.decode(cont_html_rm[i]),"UTF-8");
	}
	for(int i = 0 ; i < cont_html.length; i ++){
		cont_html[i] =  new String(Base64Coder.decode(cont_html[i]),"UTF-8");
	}
	//decodeing 처리 END	
	
	String arrOption_yn[] = new String[cont_html_rm.length];

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
	pdfInfo.put("file_seq", file_seq++);
	DataSet pdf = contDao.makePdf(pdfInfo);
	if(pdf==null){
		u.jsError("계약서 파일 생성에 실패 하였습니다.");
		return;
	}

	//자동생성파일 생성
	for(int i = 0 ; i < cont_html_rm.length; i++){
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
			pdfInfo2.put("file_seq", file_seq++);
			DataSet pdf2 = contDao.makePdf(pdfInfo2);
			pdf2.put("cont_sub_name", cont_sub_name[i]);
			pdf2.put("gubun", gubun[i]);
			autoFiles.add(pdf2);
		}
	}
	if(u.request("hash_yn").equals("Y")){
		String file_hash = pdf.getString("file_hash");
		for(int i=0; i <autoFiles.size(); i ++){
			DataSet temp = (DataSet)autoFiles.get(i);
			if(temp.getString("gubun").equals("50")){	// 작성업체만 보고 인쇄하는 양식은 서명대상이 아님.  gubun[i].equals("50")
			}else{
				file_hash+="|"+temp.getString("file_hash");
			}
		}
		cfile.first();
		while(cfile.next()){
			if(!cfile.getString("auto_yn").equals("Y")){
				file_hash +="|"+contDao.getHash("file.path.bcont_pdf",cfile.getString("file_path")+cfile.getString("file_name"));
			}
		}
		
		ContractDao cont2 = new ContractDao();
		cont2.item("cont_hash", file_hash);
		cont2.update("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
	}
	

	u.jsAlertReplace("저장하였습니다.","contract_pdf_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_modify");
p.setVar("menu_cd","000059");
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("change_cont", Integer.parseInt(cont_chasu)>0);
p.setVar("cont", cont);
p.setLoop("contSub", contSub);
p.setVar("template", template);
p.setLoop("sign_template", signTemplate);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("warr", warr);
p.setLoop("rfile", rfile);
p.setLoop("code_warr", u.arr2loop(code_warr));
p.setLoop("code_change_gubun", u.arr2loop(code_change_gubun));
p.setVar("detail_person", auth.getString("_MEMBER_NO").equals("20121000046") ? true : false );   // 파렛트폴은 담당자 세부정보 표시
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>