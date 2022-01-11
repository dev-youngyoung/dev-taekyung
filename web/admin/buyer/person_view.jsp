<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

CodeDao code = new CodeDao("tcb_comcode");
String[] code_user_level = code.getCodeArray("M013");

f.addElement("s_user_name",null,null);

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsError("업체정보가 없습니다.");
	return;
}

DataObject personDao = new DataObject("tcb_person a");
DataSet person = personDao.find(
			"member_no = '"+member_no+"' "
			,"person_seq, user_id, (select field_name from tcb_field where member_no=a.member_no and field_seq=a.field_seq) field_name, division, position, user_name, email, hp1,hp2,hp3,tel_num, user_level, default_yn, reg_date, use_yn, status"
			,"person_seq desc"
		);
while(person.next()){
	person.put("user_level", u.getItem(person.getString("user_level"), code_user_level));
	person.put("use_yn",  person.getInt("status")> 0 ? person.getString("use_yn").equals("Y")?"사용":"미사용" :"삭제");
	
}

// 입력수정
if(u.isPost() && f.validate()){

	DB db = new DB();
	
	
	if(!db.executeArray()){
		u.jsError("처리중 오류가 발생 하였습니다");
		return;
	}
	
	u.jsAlertReplace("저장처리 하였습니다.","member_view.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
p.setDebug(out);
p.setBody("buyer.person_view");
p.setVar("menu_cd","000044");
p.setVar("member", member);
p.setLoop("person", person);
p.setVar("chg_passwd", "a"+u.getTimeString("yyyyMMdd")+"?");
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.display(out);
%>