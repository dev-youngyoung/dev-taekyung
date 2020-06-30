<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
if(!auth.getString("_MEMBER_GUBUN").equals("04")){
	u.redirect("my_info_modify_comp.jsp");
	return;
}


CodeDao codeDao = new CodeDao("tcb_comcode");

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find(" member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("회원정보가 없습니다.");
	return;
}
member.put("cert_end_date", u.getTimeString("yyyy-MM-dd", member.getString("cert_end_date")));

DataObject personDao = new DataObject("tcb_person");
DataSet person = personDao.find(" member_no = '"+_member_no+"' and person_seq = '"+auth.getString("_PERSON_SEQ")+"' " );
if(!person.next()){
	u.jsError("개인 정보가 없습니다.");
	return;
}
Security security = new Security();
String jumin_no = security.AESdecrypt(person.getString("jumin_no"));
if(!jumin_no.equals("")){
	String birth_date = "";
	if(jumin_no.length() > 6){
		person.put("gender", u.inArray(jumin_no.substring(6,7), new String[]{"1","3"}) ? "1" : "2");
	}
	if(Integer.parseInt(jumin_no.substring(0,2)) > 25){
		birth_date = "19"+jumin_no.substring(0, 6);
	}else{
		birth_date = "20"+jumin_no.substring(0, 6);
	}
	person.put("birth_date", birth_date);
}




f.addElement("passwd", null, "hname:'비밀번호', option:'userpw', match:'passwd2', minbyte:'8', mixbyte:'20'");
f.addElement("member_name", member.getString("member_name"), "hname:'이름',required:'Y'");
f.addElement("birth_date", u.getTimeString("yyyy-MM-dd", person.getString("birth_date")), "hname:'생년월일', required:'Y', minbyte:'10', mixbyte:'10'");
f.addElement("gender", person.getString("gender"), "hname:'성별', required:'Y'");
f.addElement("hp1", person.getString("hp1"), "hname:'휴대전화', required:'Y'");
f.addElement("hp2", person.getString("hp2"), "hname:'휴대전화', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", person.getString("hp3"), "hname:'휴대전화', required:'Y', minbyte:'4', maxbyte:'4'");
f.addElement("email", person.getString("email"), "hname:'이메일', required:'Y',option:'email'");
f.addElement("post_code", member.getString("post_code"), "hname:'우편번호',required:'Y', option:'number'");
f.addElement("address", member.getString("address"), "hname:'주소', required:'Y'");
f.addElement("tel_num", person.getString("tel_num"), "hname:'전화번호'");
f.addElement("fax_num", person.getString("fax_num"), "hname:'팩스'");
if(u.isPost()&&f.validate()){
	
	String birth_date = f.get("birth_date").replaceAll("-", "");
	String gender = f.get("gender");
	
	if(Integer.parseInt(f.get("birth_date").substring(0,4)) >= 2000){
		gender = f.get("gender").equals("1") ? "3" : "4";
	} else {
		gender = f.get("gender");
	}
	jumin_no = birth_date.substring(2)+gender;
	
	DB db = new DB();
	
	memberDao = new DataObject("tcb_member");
	memberDao.item("member_name", f.get("member_name"));
	memberDao.item("post_code", f.get("post_code"));
	memberDao.item("address", f.get("address"));
	memberDao.item("reg_date", u.getTimeString());
	memberDao.item("reg_id", auth.getString("_USER_ID"));
	db.setCommand(memberDao.getUpdateQuery(" member_no = '"+_member_no+"' "), memberDao.record);
	
	personDao = new DataObject("tcb_person");
	if(!f.get("passwd").equals("")){
		personDao.item("passwd", u.sha256(f.get("passwd")));
		personDao.item("passdate", u.getTimeString());  // 비밀번호 변경시간 기록
	}
	personDao.item("user_name",f.get("member_name"));
	personDao.item("tel_num",f.get("tel_num"));
	personDao.item("fax_num",f.get("fax_num"));
	personDao.item("hp1",f.get("hp1"));
	personDao.item("hp2",f.get("hp2"));
	personDao.item("hp3",f.get("hp3"));
	personDao.item("email",f.get("email"));
	personDao.item("reg_date", u.getTimeString());
	personDao.item("reg_id", auth.getString("_USER_ID"));
	personDao.item("jumin_no",	security.AESencrypt(jumin_no));
	db.setCommand(personDao.getUpdateQuery("member_no = '"+_member_no+"' and person_seq = '"+person.getString("person_seq")+"'"), personDao.record);
	if(!db.executeArray()){
		u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
		return;
	}
	
	u.jsAlertReplace("저장 하였습니다.", "my_info_modify_person.jsp?"+u.getQueryString());
	return;
}
p.setLayout("default");
//p.setDebug(out);
p.setBody("info.my_info_modify_person");
p.setVar("menu_cd","000118");
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("person", person);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("person_seq"));
p.display(out);
%>