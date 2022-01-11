<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000120";
String select_auth_cd = _authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "select_auth");

String[] code_cj_division = {"CL1=>CL1","CL2=>CL2","해운항만=>해운항만","포워딩=>포워딩","스텝=>스텝","택배=>택배","구매=>구매","인프라=>인프라"};
boolean isCJT = u.inArray(_member_no, new String[]{"20130400333"}); // CJ대한통운

CodeDao code = new CodeDao("tcb_comcode");
String[] code_user_gubun = code.getCodeArray("M005");
String[] code_user_level = code_user_level = code.getCodeArray("M013", " and code >= '"+auth.getString("_USER_LEVEL")+"' ");

DataObject fieldDao = new DataObject("tcb_field");
DataSet field = null;
if(!auth.getString("_DEFAULT_YN").equals("Y") && select_auth_cd.equals("20")){//부서조회 권한인경우 자기 부서만 조회
	field = fieldDao.find(" status > 0 and member_no = '"+_member_no+"' and ( field_seq = '"+auth.getString("_FIELD_SEQ")+"' or field_seq in ( select field_seq from tcb_auth_field where member_no = '"+_member_no+"' and menu_cd = '"+_menu_cd+"'  and auth_cd = '"+auth.getString("_AUTH_CD")+"' ) )" );
}else{
	field = fieldDao.find(" status > 0  and member_no = '"+_member_no+"'");
}




DataObject authDao = new DataObject("tcb_auth");
DataSet authInfo = authDao.find("member_no = '"+_member_no+"' and status = '10' ","*","auth_cd asc");


boolean btn_dept = false;
DataObject authMenuDao = new DataObject("tcb_auth_menu");
if( auth.getString("_DEFAULT_YN").equals("Y")||authMenuDao.findCount(" member_no = '"+_member_no+"' and auth_cd = '"+auth.getString("_AUTH_CD")+"'  and menu_cd = '000110' and btn_auth = '20' ")>0){
	btn_dept = true;
}


f.addElement("user_id", null, "hname:'아이디', required:'Y', option:'userid', func:'validChkId'");
f.addElement("passwd", null, "hname:'비밀번호',required:'Y', option:'userpw', match:'passwd2', minbyte:'8', mixbyte:'20'");
f.addElement("user_name", null, "hname:'담당자명',required:'Y'");
f.addElement("position", null, "hname:'직위'");
f.addElement("email", null, "hname:'이메일', required:'Y',option:'email'");
f.addElement("tel_num", null, "hname:'전화번호', required:'Y'");
f.addElement("fax_num", null, "hname:'팩스'");
f.addElement("hp1", null, "hname:'휴대전화', required:'Y'");
f.addElement("hp2", null, "hname:'휴대전화', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", null, "hname:'휴대전화', required:'Y', minbyte:'4', maxbyte:'4'");
f.addElement("user_level", "30", "hname:'사용자유형', required:'Y'");
f.addElement("use_yn", "Y", "hname:'사용여부', required:'Y'");
if(isCJT){
	f.addElement("division", "", "hname:'부문', required:'Y'");
}
f.addElement("field_seq", null, "hname:'부서', required:'Y'");
f.addElement("user_gubun", "10", "hname:'사용자구분', requried:'Y'");
f.addElement("auth_cd", null, "hname:'사용자권한', requried:'Y'");


if(u.isPost()&&f.validate()){
	DataObject personDao = new DataObject("tcb_person");
	//personDao.setDebug(out);
	String person_seq = personDao.getOne("select nvl(max(person_seq),0)+1 person_seq from tcb_person where member_no = '"+_member_no+"' ");
	if(person_seq.equals("")){
		u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
		return;
	}

	personDao.item("member_no",_member_no);
	personDao.item("person_seq", person_seq);
	personDao.item("user_id", f.get("user_id"));
	personDao.item("passwd", u.sha256(f.get("passwd")));
	personDao.item("passdate", u.getTimeString());  // 비밀번호 변경시간 기록
	personDao.item("user_name",f.get("user_name"));
	personDao.item("position",f.get("position"));
	if(isCJT){
		personDao.item("division",f.get("division"));
	}
	personDao.item("user_gubun", f.get("user_gubun"));
	personDao.item("field_seq", f.get("field_seq"));
	personDao.item("tel_num",f.get("tel_num"));
	personDao.item("fax_num",f.get("fax_num"));
	personDao.item("hp1",f.get("hp1"));
	personDao.item("hp2",f.get("hp2"));
	personDao.item("hp3",f.get("hp3"));
	personDao.item("email",f.get("email"));
	personDao.item("user_level", f.get("user_level"));
	personDao.item("default_yn", f.get("user_level").equals("10")?"Y":"N");
	personDao.item("use_yn", f.get("use_yn"));
	personDao.item("reg_date", u.getTimeString());
	personDao.item("reg_id", auth.getString("_USER_ID"));
	personDao.item("status","1");
	personDao.item("auth_cd", f.get("auth_cd"));

	DB db = new DB();
	//db.setDebug(out);
	if(auth.getString("_DEFAULT_YN").equals("Y")){
		if(f.get("user_level").equals("10")){
			db.setCommand("update tcb_person set default_yn = 'N', user_level = '30' where member_no='"+_member_no+"' and default_yn = 'Y' ", null);
		}
	}
	db.setCommand(personDao.getInsertQuery(), personDao.record);
	if(!db.executeArray()){
		u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
		return;
	}
	
	u.jsAlertReplace("저장 하였습니다.", "./person_modify.jsp?person_seq="+person_seq);
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.person_modify");
p.setVar("menu_cd",_menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("modify", false);
p.setVar("default_yn", auth.getString("_DEFAULT_YN").equals("Y"));
p.setLoop("code_cj_division", u.arr2loop(code_cj_division));
p.setLoop("code_field", field);
p.setLoop("code_user_level", u.arr2loop(code_user_level));
p.setLoop("code_user_gubun", u.arr2loop(code_user_gubun));
p.setLoop("authInfo", authInfo);
p.setVar("isCJT",isCJT);//CJ대한통운
p.setVar("btn_dept", btn_dept);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("person_seq"));
p.display(out);
%>