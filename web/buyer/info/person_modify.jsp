<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000120";
String select_auth_cd = _authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "select_auth");

String[] code_cj_division = {"CL1=>CL1","CL2=>CL2","해운항만=>해운항만","포워딩=>포워딩","스텝=>스텝","택배=>택배","구매=>구매","인프라=>인프라"};
boolean isCJT = u.inArray(_member_no, new String[]{"20130400333"}); // CJ대한통운
 
String person_seq = u.aseDec(u.request("person_seq")); 

DataObject fieldDao = new DataObject("tcb_field");
DataSet field = null;
if( !auth.getString("_DEFAULT_YN").equals("Y") && select_auth_cd.equals("20")){//부서조회 권한인경우 자기 부서만 조회
	field = fieldDao.find(" status > 0 and member_no = '"+_member_no+"' and ( field_seq = '"+auth.getString("_FIELD_SEQ")+"' or field_seq in ( select field_seq from tcb_auth_field where member_no = '"+_member_no+"' and menu_cd = '"+_menu_cd+"'  and auth_cd = '"+auth.getString("_AUTH_CD")+"' ) )" );
}else{
	field = fieldDao.find(" status > 0 and member_no = '"+_member_no+"'" );
}

DataObject authDao = new DataObject("tcb_auth");
DataSet authInfo = authDao.find("member_no = '"+_member_no+"' and status = '10' ","*","auth_cd asc");

boolean btn_dept = false;
DataObject authMenuDao = new DataObject("tcb_auth_menu");
if( auth.getString("_DEFAULT_YN").equals("Y")||authMenuDao.findCount(" member_no = '"+_member_no+"' and auth_cd = '"+auth.getString("_AUTH_CD")+"'  and menu_cd = '000110' and btn_auth = '20' ")>0){
	btn_dept = true;
}

CodeDao code = new CodeDao("tcb_comcode");
String[] code_user_gubun = code.getCodeArray("M005");
String[] code_user_level = code.getCodeArray("M013", "and code >= '"+auth.getString("_USER_LEVEL")+"' ");

DataObject personDao = new DataObject("tcb_person");
//pdao.setDebug(out);
DataSet person = personDao.find(" member_no = '"+_member_no+"' and person_seq = '"+person_seq+"' and status > 0 ");
if(!person.next()){
	u.jsError("담당자 정보가 없습니다.");
	return;
}


f.addElement("passwd", null, "hname:'비밀번호', option:'userpw', match:'passwd2', minbyte:'8', mixbyte:'20'");
f.addElement("user_name", person.getString("user_name"), "hname:'담당자명',required:'Y'");
f.addElement("position", person.getString("position"), "hname:'직위'");
f.addElement("email", person.getString("email"), "hname:'이메일', required:'Y',option:'email'");
f.addElement("tel_num", person.getString("tel_num"), "hname:'전화번호', required:'Y'");
f.addElement("fax_num", person.getString("fax_num"), "hname:'팩스'");
f.addElement("hp1", person.getString("hp1"), "hname:'휴대전화', required:'Y'");
f.addElement("hp2", person.getString("hp2"), "hname:'휴대전화', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", person.getString("hp3"), "hname:'휴대전화', required:'Y', minbyte:'4', maxbyte:'4'");
f.addElement("user_level", person.getString("user_level"), "hname:'사용자유형', required:'Y'");
f.addElement("use_yn", person.getString("use_yn"), "hname:'사용여부', required:'Y'");
if(isCJT){
	f.addElement("division", person.getString("division"), "hname:'부문', required:'Y'");
}
f.addElement("field_seq", person.getString("field_seq"), "hname:'부서', required:'Y'");
f.addElement("user_gubun", person.getString("user_gubun"), "hname:'사용자구분', requried:'Y'");
f.addElement("auth_cd", person.getString("auth_cd"), "hname:'부여권한', requried:'Y'");


if(u.isPost()&&f.validate()){
	personDao = new DataObject("tcb_person");
	if(!f.get("passwd").equals("")){
		personDao.item("passwd", u.sha256(f.get("passwd")));
		personDao.item("passdate", u.getTimeString());  // 비밀번호 변경시간 기록
	}
	personDao.item("user_name",f.get("user_name"));
	personDao.item("position",f.get("position"));
	if(isCJT){
		personDao.item("division",f.get("division"));
	}
	personDao.item("tel_num",f.get("tel_num"));
	personDao.item("fax_num",f.get("fax_num"));
	personDao.item("hp1",f.get("hp1"));
	personDao.item("hp2",f.get("hp2"));
	personDao.item("hp3",f.get("hp3"));
	personDao.item("email",f.get("email"));
	personDao.item("field_seq", f.get("field_seq"));
	personDao.item("user_level", f.get("user_level"));
	personDao.item("default_yn", f.get("user_level").equals("10")?"Y":"N");
	personDao.item("user_gubun", f.get("user_gubun"));
	personDao.item("use_yn", f.get("use_yn"));
	personDao.item("reg_date", u.getTimeString());
	personDao.item("reg_id", f.get("user_id"));
	personDao.item("auth_cd", f.get("auth_cd"));

	DB db = new DB();
	if(auth.getString("_DEFAULT_YN").equals("Y")){
		if(f.get("user_level").equals("10")){
			db.setCommand("update tcb_person set default_yn = 'N', user_level = '30'  where member_no ='"+_member_no+"' and user_id = '"+auth.getString("_USER_ID")+"'", null);
		}
	}
	db.setCommand(personDao.getUpdateQuery("member_no = '"+_member_no+"' and person_seq = '"+person_seq+"'"), personDao.record);
	if(!db.executeArray()){
		u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
		return;
	}

	// 다른 사람에게 관리자 권한 위임시
	if((!person_seq.equals(auth.getString("_PERSON_SEQ")))&&f.get("user_level").equals("10")){
		auth.delAuthInfo();
		u.jsAlertReplace("저장 하였습니다.\\n\\n권한변경으로 로그아웃 됩니다.\\n\\n로그인 후 사용하세요.", "/web/buyer/main/index.jsp");
		return;
	}
	u.jsAlertReplace("저장 하였습니다.", "person_modify.jsp?"+u.getQueryString());
	return;
}
p.setLayout("default");
//p.setDebug(out);
p.setBody("info.person_modify");
p.setVar("menu_cd","000120");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000120", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setVar("default_yn", auth.getString("_DEFAULT_YN").equals("Y"));
p.setLoop("code_cj_division", u.arr2loop(code_cj_division));
p.setLoop("code_field", field);
p.setLoop("code_user_level", u.arr2loop(code_user_level));
p.setLoop("code_user_gubun", u.arr2loop(code_user_gubun));
p.setLoop("authInfo", authInfo);
p.setVar("person", person);
p.setVar("btn_del", !person_seq.equals(auth.getString("_PERSON_SEQ")));//자신은 삭제 목하도록 삭제 버튼 제거
p.setVar("btn_dept", btn_dept);// 
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("isCJT",isCJT);//CJ대한통운
p.setVar("list_query", u.getQueryString("person_seq"));
p.display(out);
%>