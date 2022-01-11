<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String seq = u.request("seq");
if(member_no.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsError("업체정보가 없습니다.");
	return;
}

DataObject fieldDao = new DataObject("tcb_field");
DataSet field = fieldDao.find(" member_no = '"+member_no+"' and status > 0 ");
while(field.next()){
}

DataObject calcPersonDao = new DataObject("tcb_calc_person");
DataSet calcPerson = calcPersonDao.find(" member_no = '"+member_no+"' and seq = '"+seq+"' ");
if(!calcPerson.next()){
	u.jsErrClose("정산담당자 정보가 없습니다.");
	return;
}

f.addElement("user_name", calcPerson.getString("user_name"), "hname:'담당자명', required:'Y'");
f.addElement("tel_num", calcPerson.getString("tel_num"), "hname:'전화번호'");
f.addElement("hp1", calcPerson.getString("hp1"), "hname:'휴대폰', required:'Y'");
f.addElement("hp2", calcPerson.getString("hp2"), "hname:'휴대폰', required:'Y'");
f.addElement("hp3", calcPerson.getString("hp3"), "hname:'휴대폰', required:'Y'");
f.addElement("email", calcPerson.getString("email"), "hname:'휴대폰', required:'Y'");

if(u.isPost()&&f.validate()){
	calcPersonDao = new DataObject("tcb_calc_person");
	calcPersonDao.item("user_name", f.get("user_name"));
	calcPersonDao.item("tel_num", f.get("tel_num"));
	calcPersonDao.item("hp1", f.get("hp1"));
	calcPersonDao.item("hp2", f.get("hp2"));
	calcPersonDao.item("hp3", f.get("hp3"));
	calcPersonDao.item("email", f.get("email"));
	calcPersonDao.item("field_seq", f.get("field_seqs"));
	if(!calcPersonDao.update(" member_no = '"+member_no+"' and seq = '"+seq+"' ")) {
		u.jsError("저장 처리에 실패 하엿습니다.");
		return;
	}
	out.println("<script>");
	out.println("opener.location.reload();");
	out.println("alert('저장 처리 되었습니다.');");
	out.println("location.href='pop_calc_person_modify.jsp?"+u.getQueryString()+"';");
	out.println("</script>");
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("buyer.pop_calc_person_modify");
p.setVar("modify", true);
p.setVar("popup_title","정산담당자 수정");
p.setVar("member", member);
p.setVar("calcPerson", calcPerson);
p.setLoop("field", field);
p.setVar("form_script",f.getScript());
p.setVar("query", u.getQueryString());
p.display(out);
%>