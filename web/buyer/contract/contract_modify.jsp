<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ include file="include_contract_modify_func.jsp" %>
<%
Security	security	=	new	Security();

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
String template_cd = u.request("template_cd");
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

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_change_gubun = codeDao.getCodeArray("M010"," AND code <> '90' ");
String[] code_auto_type = {"=>자동생성","1=>자동첨부","2=>필수첨부","3=>내부용"};

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
							" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'and status = '10'"
						   ," tcb_contmaster.*"
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
template_cd = cont.getString("template_cd");
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
cont.put("cont_userno", cont.getString("cont_userno"));
cont.put("view_project", !cont.getString("project_seq").equals(""));
cont.put("btn_select_project", true);
if(!cont.getString("src_cd").equals(""))
	cont.put("src_nm", cont.getString("l_src_nm")+" > "+cont.getString("m_src_nm")+" > "+cont.getString("s_src_nm"));
if(_member_no.equals("20150600110"))//티알엔 조회 URL
	cont.put("cont_url", "http://"+request.getServerName()+"/web/buyer/contract/cin.jsp?key="+u.aseEnc(cont_no+cont_chasu));
 
// 모바일 서식 일때 강제 변경
if(!cont.getString("sign_types").equals("")){ 
	u.redirect("contract_msign_modify.jsp?"+u.getQueryString());
}

if(!cont.getString("project_seq").equals("")){
	DataObject projectDao = new DataObject("tcb_project");
	DataSet project  = projectDao.find(" member_no = '"+_member_no+"' and project_seq = '"+cont.getString("project_seq")+"' ");
	if(project.next()){
		cont.put("project_name", project.getString("project_name"));
		cont.put("project_cd", project.getString("project_cd"));
	}
}

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
DataSet template= templateDao.find(" template_cd ='"+template_cd+"'");
if(!template.next()){
}

// 내부 결재정보 조회
boolean btnSend = true;
DataObject agreeTemplateDao = new DataObject("tcb_cont_agree");
DataSet agreeTemplate= agreeTemplateDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", "agree_seq");
String	agree_name_tag	=	"";
while(agreeTemplate.next()){
    agreeTemplate.put("cont_no", u.aseEnc(agreeTemplate.getString("cont_no")));
    agreeTemplate.put("is_cust", agreeTemplate.getString("agree_cd").equals("0"));
	if(agreeTemplate.getString("agree_seq").equals("1")){  
		btnSend = agreeTemplate.getString("agree_cd").equals("0");// 다음 결재 순서자가 거래처면 전송 가능	
	}
	agree_name_tag	=	agreeTemplate.getString("agree_name");
	agree_name_tag	=	agree_name_tag.replaceAll("<br/>","\\\\n");
	agree_name_tag	=	agree_name_tag.replaceAll("<br>","\\\\n");
	agreeTemplate.put("agree_name_tag", agree_name_tag);
}


DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","*","sign_seq asc");

// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(
		" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq <= 10"
		,"*"
		,"display_seq asc");  // sign_seq 가 10보다 큰거는 연대보증
if(!cust.next()){
	u.jsError("계약업체 정보가 존재 하지 않습니다.");
	return;
}
while(cust.next()){
    cust.put("cont_no", u.aseEnc(cust.getString("cont_no")));
	//if(cust.getString("cust_gubun").equals("02")){
		
	DataSet cust_member = memberDao.find(" member_no = '" + cust.getString("member_no") + "'", "member_name, boss_name, address,member_gubun");
	if(cust_member.next())
	{
		cust.put("member_gubun",cust_member.getString("member_gubun"));
	}
		
	if(!cust.getString("jumin_no").equals("")){
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
	if(cfile.getString("auto_yn").equals("Y")){

		cfile.put("auto_str", u.getItem(cfile.getString("auto_type"), code_auto_type));
		if(cfile.getString("auto_type").equals("")){
			cfile.put("auto_type","0");
		}
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
		+"  order by a.rfile_seq asc                                     "
		);
while(rfile.next()){
    rfile.put("cont_no", u.aseEnc(rfile.getString("cont_no")));
	rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
	if(!rfile.getString("file_name").equals(""))
	rfile.put("str_file_size", u.getFileSize(rfile.getLong("file_size")));

	if(rfile.getString("reg_type").equals("10")){
		rfile.put("attch_disabled_btn",rfile.getString("attch_yn").equals("Y")?"disabled":"");
		// 버그현상 수정하였으나,  18.11.15 이의철팀장님 요청으로 인해 버그상태로 원복함 (미필수->필수 선택 가능하며, 이때 필수 해제시 '해제사유'입력해야함.)
		rfile.put("attch_disabled",rfile.getString("attch_yn").equals("Y")?"disabled":"");
		rfile.put("doc_name_class", "in_readonly");
		rfile.put("doc_name_readonly", "readonly");
		rfile.put("del_btn_yn", false);
	}else{
		rfile.put("attch_disabled_btn", "");
		rfile.put("attch_disabled","");
		rfile.put("doc_name_class", "");
		rfile.put("doc_name_readonly", "");
		rfile.put("del_btn_yn", true);
	}
}


//내부 관리 서류 조회
String[] code_reg_type = {"10=><span class='caution-text'>필수첨부</span>","20=>선택첨부","30=>추가첨부"};
DataObject efileDao = new DataObject("tcb_efile");
DataSet efile = new DataSet();
if(cont.getString("efile_yn").equals("Y")){
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

f.addElement("cont_name", cont.getString("cont_name"), "hname:'계약명', required:'Y'");
f.addElement("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")), "hname:'계약일자', required:'Y'");
f.addElement("cont_userno", cont.getString("cont_userno"), "hname:'계약번호', maxbyte:'40'");
if(Integer.parseInt(cont_chasu)>0)
	f.addElement("change_gubun", cont.getString("change_gubun"), "hname:'계약구분', required:'Y'");
if(!member.getString("src_depth").equals(""))
	f.addElement("src_cd", cont.getString("src_cd"), "hname:'소싱그룹'");


if(template.getString("stamp_yn").equals("Y")){
	f.addElement("stamp_type", cont.getString("stamp_type"), "hname:'인지세 납부 대상', required:'Y'");
}


if(u.isPost()&&f.validate()){
	/************************************************************************************
		계약정보 저장 include 파일로 분리 20211014 이종환
		인증서서명계약 : include_contract_modify_func.jsp 			method -> _saveContract
	************************************************************************************/	
	Map<String,String> rtnMap	=	_saveContract(response, request, u, f,_member_no, auth);
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
p.setBody("contract.contract_modify");
p.setVar("menu_cd","000059");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000059", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("change_cont", Integer.parseInt(cont_chasu)>0);
p.setVar("cont", cont);
p.setLoop("contSub", contSub);
p.setVar("template", template);
p.setLoop("sign_template", signTemplate);
p.setLoop("agreeTemplate", agreeTemplate);
p.setVar("btnSend", btnSend);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("warr", warr);
p.setLoop("rfile", rfile);
p.setVar("efile_yn", cont.getString("efile_yn").equals("Y"));//내부 관리 서류 사용여부
p.setLoop("efile", efile);
p.setLoop("code_warr", u.arr2loop(code_warr));
p.setLoop("code_change_gubun", u.arr2loop(code_change_gubun));
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());


p.setVar("warr_yn", template.getString("warr_yn").equals("")||template.getString("warr_yn").equals("Y"));
p.display(out);
%>