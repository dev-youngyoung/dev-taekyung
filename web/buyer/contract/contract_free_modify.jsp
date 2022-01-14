<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ include file="include_contract_free_modify_func.jsp" %> 
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

//서비스 이용 기간 체크
DataObject useinfoDao = new DataObject("tcb_useinfo");
/* DataSet useinfo = useinfoDao.find("member_no='"+_member_no+"' and usestartday <='"+u.getTimeString("yyyyMMdd")+"' and useendday>='"+u.getTimeString("yyyyMMdd")+"' "); */
/* 요금제가 년선납이 아닌 경우 종료일 확인 안함 이종환 - 20210804*/
DataSet useinfo = useinfoDao.find("member_no='"+_member_no+"' and usestartday <='"+u.getTimeString("yyyyMMdd")+"' and nvl(useendday,case when paytypecd != '10' then to_char(sysdate,'YYYYMMDD') end) >='"+u.getTimeString("yyyyMMdd")+"' ");
if( !useinfo.next() )
{
	u.jsError("서비스 이용기간이 종료 되었습니다.\\n\\n나이스다큐 고객센터[02-788-9097]에 문의하세요.");
	return;
}

Security	security	=	new	Security();
String fileDir = "";

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_vat_type = {"1=>VAT별도","2=>VAT포함","3=>VAT미선택"};

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("사용자 정보가 존재 하지 않습니다.");
	return;
}

/* //사용자 계약번호 자동 설정 여부
boolean bAutoContUserNo = u.inArray(_member_no, new String[]{"20130500019","20121203661","20130400011","20130400010","20130400009","20130400008"}); // 그루폰, 한국쓰리엠
// 카카오는 자유서식에서 추가 정보를 입력할 수 있는 기능이 있음
boolean bIsKakao = u.inArray(_member_no, new String[]{"20130900194","20181201176"});
//테크로스 워터앤에너지,테크로스환경서비스 는 자유서식에서 vat 포함여부 기능
boolean bIsTechcross = u.inArray(_member_no, new String[]{"20160401012","20180203437"}); */


ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
	" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' "
	," tcb_contmaster.* "
	 +" ,(select max(user_name) from tcb_person where member_no = tcb_contmaster.member_no and user_id = tcb_contmaster.reg_id ) writer_name "
	 +" ,(select member_name from tcb_member where member_no = mod_req_member_no) mod_req_name "
	 +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,3) = substr(tcb_contmaster.src_cd,0,3) and depth='1') l_src_nm "
     +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,6) = substr(tcb_contmaster.src_cd,0,6) and depth='2') m_src_nm "
     +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and src_cd = tcb_contmaster.src_cd and depth='3') s_src_nm "
);
if(!cont.next()){
	u.jsError("계약정보가 존재 하지 않습니다.");
	return;
}
cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
if(!cont.getString("src_cd").equals(""))
	cont.put("src_nm", cont.getString("l_src_nm")+" > "+cont.getString("m_src_nm")+" > "+cont.getString("s_src_nm"));
if(_member_no.equals("20150600110"))//티알엔 조회 URL
	cont.put("cont_url", "http://"+request.getServerName()+"/web/buyer/contract/cin.jsp?key="+u.aseEnc(cont_no+cont_chasu));

//프로젝트관리 사용시 //하이엔텍 사용 
if(!cont.getString("project_seq").equals("")){
	cont.put("view_project", true);
	DataObject projectDao = new DataObject("tcb_project");
	DataSet project  = projectDao.find(" member_no = '"+_member_no+"' and project_seq = '"+cont.getString("project_seq")+"' ");
	if(project.next()){
		cont.put("project_name", project.getString("project_name"));
		cont.put("project_cd", project.getString("project_cd"));
		cont.put("btn_select_project", cont_chasu.equals("0"));//최초 계약인 경우만 선택 가능 하도록 한다.
	}
}


// 서식정보 조회
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" status > 0 and template_cd ='"+cont.getString("template_cd")+"'");
if(!template.next()){
}

DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");


//내부 결재정보 조회
boolean btnSend = true;
DataObject agreeTemplateDao = new DataObject("tcb_cont_agree");
DataSet agreeTemplate= agreeTemplateDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", "agree_seq");
while(agreeTemplate.next()){
    agreeTemplate.put("cont_no", u.aseEnc(agreeTemplate.getString("cont_no")));
    agreeTemplate.put("is_cust", agreeTemplate.getString("agree_cd").equals("0"));
	if(agreeTemplate.getString("agree_seq").equals("1")){  
		btnSend = agreeTemplate.getString("agree_cd").equals("0");// 다음 결재 순서자가 거래처면 전송 가능	
	}
}


// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
if(!cust.next()){
	u.jsError("계약업체 정보가 존재 하지 않습니다.");
	return;
}
while(cust.next()){
    cust.put("cont_no", u.aseEnc(cust.getString("cont_no")));
	if(cust.getString("cust_gubun").equals("02")){
		cust.put("jumin_no", security.AESdecrypt(cust.getString("jumin_no")));
	}else{
		cust.put("jumin_no", "");
	}
}

//계약서류 조회
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	cfile.put("auto", cfile.getString("auto_yn").equals("Y")?true:false);
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	cfile.put("pdf_yn", cfile.getString("file_ext").toLowerCase().equals("pdf"));
	fileDir = cfile.getString("file_path");
}
/*
if(fileDir.equals("")){
	u.jsError("계약서류저장 경로가 없습니다.");
	return;
}
*/
//보증정보조회
DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");

// 구비서류 조회
DataObject rfileDao = new DataObject("tcb_rfile");
//rfileDao.setDebug(out);
DataSet rfile = rfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","*", "rfile_seq asc");
while(rfile.next()){
    rfile.put("cont_no", u.aseEnc(rfile.getString("cont_no")));
	rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
}

/* 내부관리서류조회 */
String[] code_reg_type = {"10=><span class='caution-text'>필수첨부</span>","20=>선택첨부","30=>추가첨부"};
DataObject efileDao = new DataObject("tcb_efile");
DataSet efile = efileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
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

f.addElement("cont_name", cont.getString("cont_name"), "hname:'계약명', required:'Y'");
f.addElement("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")), "hname:'계약일자', required:'Y'");
f.addElement("cont_userno", cont.getString("cont_userno"), "hname:'계약번호', maxbyte:'40'");
f.addElement("cont_sdate", u.getTimeString("yyyy-MM-dd",cont.getString("cont_sdate")), "hname:'계약기간'");
f.addElement("cont_edate", u.getTimeString("yyyy-MM-dd",cont.getString("cont_edate")), "hname:'계약기간'");
if(!cont.getString("cont_total").equals("")){
	f.addElement("cont_total", u.numberFormat(cont.getDouble("cont_total"), 0), "hname:'계약금액'");
}else{
	f.addElement("cont_total", null, "hname:'계약금액'");
}
if(!member.getString("src_depth").equals(""))
	f.addElement("src_cd", cont.getString("src_cd"), "hname:'소싱그룹'");

if(!member.getString("src_depth").equals(""))
	f.addElement("src_cd", null, "hname:'소싱그룹'");

if(useinfo.getString("stampyn").equals("Y")){
	f.addElement("stamp_type", cont.getString("stamp_type"), "hname:'인지세 납부 대상', required:'Y'");
}

if(u.isPost()&&f.validate()){
	/************************************************************************************
		계약정보 저장 include 파일로 분리 20211014 이종환
		자유서식계약 : include_contract_free_modify_func.jsp 			method -> _saveFreeContract
	************************************************************************************/	
	Map<String,String> rtnMap	=	_saveFreeContract(response, request, u, f,_member_no, auth);
	if("SUCC".equals(rtnMap.get("code")))
	{
		u.jsAlertReplace(rtnMap.get("msg"),rtnMap.get("url"));
		return;
	}else
	{
		u.jsError(rtnMap.get("msg"));
		return;
	}
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_free_modify");
p.setVar("menu_cd","000059");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000059", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("cont", cont);
p.setVar("template", template);
p.setLoop("sign_template", signTemplate);
p.setLoop("agreeTemplate", agreeTemplate);
p.setVar("btnSend", btnSend);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("warr", warr);
p.setLoop("rfile", rfile);
p.setLoop("efile", efile);
p.setLoop("code_warr", u.arr2loop(code_warr));
p.setLoop("code_vat_type", u.arr2loop(code_vat_type));  
p.setVar("stamp_yn", useinfo.getString("stampyn").equals("Y")?true:false);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>
