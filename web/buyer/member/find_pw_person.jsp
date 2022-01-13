<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
f.addElement("user_id", null, "hname:'아이디', required:'Y'");
f.addElement("user_name", null, "hname:'이름', required:'Y'");
f.addElement("jumin_no", null, "hname:'생년월일', required:'Y', fixbyte:'6'");
f.addElement("hp1", null, "hname:'휴대전화', required:'Y', fixbyte:'3'");
f.addElement("hp2", null, "hname:'휴대전화', required:'Y', fixbyte:'4'");
f.addElement("hp3", null, "hname:'휴대전화', required:'Y', fixbyte:'4'");
f.addElement("email", null, "hname:'이메일', required:'Y'");

if (u.isPost() && f.validate()) {

	if (f.get("jumin_no").length() != 6) {
		u.jsError("생년월일을 정확히 입력 하세요.");
		return;
	}

	String hp = f.get("hp1") + f.get("hp2") + f.get("hp3");
	if (hp.length() != 11) {
		u.jsError("휴대전화 번호를 정확히 입력 하세요.");
		return;
	}

	DataObject personDao = new DataObject("tcb_person a");
	//personDao.setDebug(out);
	personDao.addJoin("tcb_member b", "INNER", "b.member_gubun = '04' and a.member_no = b.member_no");
	DataSet person = personDao.find(" a.user_id='" + f.get("user_id") + "' and a.user_name='" + f.get("user_name") + "' and a.email = '" + f.get("email") +
			"' and a.hp1 = '" + f.get("hp1") + "' and a.hp2 = '" + f.get("hp2") + "' and a.hp3 = '" + f.get("hp3") + "' ", "a.*", "a.reg_date desc");

	if (!person.next()) {
		u.jsError("등록하신 정보로 검색된 사용자 정보가 없습니다.");
		return;
	}

	if ("".equals(person.getString("jumin_no"))) {
		u.jsError("등록하신 정보로 검색된 사용자 정보가 없습니다.");
		return;
	}

	Security security = new	Security();
	String jumin_no = security.AESdecrypt(person.getString("jumin_no"));
	jumin_no = jumin_no.substring(0,6);

	if (!jumin_no.equals(f.get("jumin_no"))) {
		u.jsError("등록하신 정보로 검색된 사용자 정보가 없습니다.");
		return;
	}

	String passwd = "p"+u.strpad(u.getRandInt(0,999999)+"",6,"0")+"!";
	person.put("passwd",passwd);
	personDao.item("passwd",u.sha256(passwd));

	if(!personDao.update(" member_no = '" + person.getString("member_no") + "' and person_seq = '" + person.getString("person_seq") + "' ")){
		u.jsError("임시비밀번호 발급처리에 실패 하엿습니다.");
		return;
	}

	p.setVar("server_name", request.getServerName());
	p.setVar("return_url", "/web/buyer/");
	p.setVar("person", person);
	String mail_body = p.fetch("../html/mail/find_pw_person_mail.html");
	u.mail(person.getString("email"), "[나이스다큐] 계정정보 안내", mail_body );

	u.jsAlertReplace("메일이 발송 되었습니다.", "/web/buyer/main/index.jsp");
	return;
}

	p.setLayout("default");
//p.setDebug(out);
	p.setBody("member.find_pw_person");
	p.setVar("menu_cd","000129");
	p.setVar("form_script",f.getScript());
	p.display(out);
%>