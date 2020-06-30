<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_client_type = null;
if(_member_no.equals("20130400091")) // 대보정보통신
	code_client_type = new String[]{"0=>물품 공급사","1=>용역 공급사"};
else if(_member_no.equals("20140300055"))  // 한국유리공업
	code_client_type = new String[]{"0=>공급사","1=>판매(대리)점"};
else if(u.inArray(_member_no, new String[]{"20121200116", "20140101025", "20120200001","20170101031","20170602171"}))  // 한국제지, 신세계, 테스트
	code_client_type = new String[]{"0=>물품","1=>공사","2=>용역"};
else if(_member_no.equals("20121204063"))  // 홈플러스
	code_client_type = new String[]{"0=>물품","1=>공사","2=>용역"};
else if(u.inArray(_member_no, new String[]{"20180203437", "20181002679","20191200612"}))  // 하이엔텍, (재)경기테크노파크, 메트로9호선
	code_client_type = new String[]{};
else // 3M
	code_client_type = new String[]{"0=>공급사","1=>판매(대리)점","2=>공급사/판매(대리)점"};

String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

CodeDao code = new CodeDao("tcb_comcode");
String[] code_member_gubun = code.getCodeArray("M001");

boolean src_view = false;

String member_slno1= "";
String member_slno2= "";
String post_code1 = "";
String post_code2 = "";

DataObject mdao = new DataObject("tcb_member");
//mdao.setDebug(out);
DataSet member = mdao.query(
	 " select a.*								 "
	+"       , b.status client_status            "
	+"       , b.client_reg_date                 "
	+"       , (select user_name                 "
	+"            from tcb_person                "
	+"           where member_no = b.member_no   "
	+"             and user_id = b.reason_id     "
	+"          ) reason_name                    "
	+"       , b.temp_yn						 "
	+"       , b.client_seq						 "
	+"       , b.client_type					 "
	+"   from tcb_member a, tcb_client b         "
	+"  where a.member_no = b.client_no          "
	+"    and b.member_no = '"+_member_no+"'     "
	+"    and b.client_no = '"+member_no+"'      "
);
if(!member.next()){
	u.jsError("회원정보가 없습니다.");
	return;
}
member.put("vendcd", u.getBizNo(member.getString("vendcd")));
member.put("member_gubun_name", u.getItem(member.getString("member_gubun"),code_member_gubun));
if(member.getString("member_slno").length()==13){
	member_slno1= member.getString("member_slno").substring(0,6);
	member_slno2= member.getString("member_slno").substring(6);
	member.put("member_slno", member_slno1+" - "+member_slno2);
}
if(member.getString("post_code").length() == 6){
	post_code1 = member.getString("post_code").substring(0,3);
	post_code2 = member.getString("post_code").substring(3);
	member.put("post_code", post_code1+" - "+ post_code2);
}
member.put("client_reg_date", u.getTimeString("yyyy-MM-dd", member.getString("client_reg_date")));

// 추가서류
DataObject rfileDao = new DataObject();
String rfileQuery = "  select a.attch_yn, a.doc_name, a.rfile_seq, a.allow_ext, b.file_path, b.file_name, b.file_ext, b.file_size, b.member_no "
		+"    from tcb_client_rfile_template a  "
		+"    left outer join  tcb_client_rfile b "
		+"      on a.member_no = b.member_no  "
		+"     and a.rfile_seq = b.rfile_seq  "
		+"     and b.client_no = '"+member_no+"'"
		+"   where a.member_no = '"+_member_no+"'";

//rfileDao.setDebug(out);
DataSet rfile = rfileDao.query(rfileQuery);
while(rfile.next()){
	rfile.put("file_size", u.getFileSize(rfile.getLong("file_size")));
}

DataObject personDao = new DataObject("tcb_person");
DataSet person = personDao.find(" member_no = '"+member_no+"' and status > 0 ", "*"," person_seq asc ");

DataSet src = new DataSet();
if( u.inArray(auth.getString("_MEMBER_TYPE"), new String[]{"01","03"})){
	DataSet login_member = mdao.find(" member_no = '"+_member_no+"' ");
	if(!login_member.next()){
	}
	if(!login_member.getString("src_depth").equals("")){
		src_view = true;
		src = mdao.query(
		 "  select                                                                                                                        "
		+"         (select src_nm from tcb_src_adm where member_no = a.member_no and src_cd = substr(a.src_cd ,0,3)||'000000') l_src_nm   "
		+"       , (select src_nm from tcb_src_adm where member_no = a.member_no and src_cd = substr(a.src_cd ,0,6)||'000') m_src_nm      "
		+"       , (select src_nm from tcb_src_adm where member_no = a.member_no and src_cd = a.src_cd ) s_src_nm                         "
		+"  from tcb_src_member a                                                                                                         "
		+" where member_no = '"+_member_no+"'                                                                                             "
		+"   and src_member_no = '"+member_no+"'                                                                                          "
		);
	}
	while(src.next()){
		if(login_member.getString("src_depth").equals("01")){
			src.put("src_nm", src.getString("l_src_nm"));
		}
		if(login_member.getString("src_depth").equals("02")){
			src.put("src_nm", src.getString("l_src_nm")+">"+src.getString("m_src_nm"));
		}
		if(login_member.getString("src_depth").equals("03")){
			src.put("src_nm", src.getString("l_src_nm")+" > "+src.getString("m_src_nm")+" > "+src.getString("s_src_nm"));
		}
	}
}

f.addElement("client_type", member.getString("client_type"), "hname:'업체유형'");

if(u.isPost()&& f.validate()){

	DataObject clientDao = new DataObject("tcb_client");
	//clientDao.setDebug(out);
	clientDao.item("client_reg_cd", "1");
	clientDao.item("client_type", u.join(",", f.getArr("client_type")));
	if(!clientDao.update(" member_no = '"+_member_no+"' and client_no = '"+member_no+"' ")){
		u.jsError("정식업체 등록에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("정식업체로 등록 하였습니다.", "./tmp_cust_list_type.jsp?"+u.getQueryString("member_no"));
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.tmp_cust_view_type");
p.setVar("menu_cd","000088");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000088", "btn_auth").equals("10"));
p.setVar("member",member);
p.setLoop("code_client_type", u.arr2loop(code_client_type));
p.setLoop("rfile", rfile);
p.setLoop("person", person);
p.setVar("src_view", src_view);
p.setLoop("src", src);
p.setVar("sys_date", u.getTimeString());
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.display(out);
%>