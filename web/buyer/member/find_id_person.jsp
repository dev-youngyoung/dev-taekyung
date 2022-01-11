<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
f.addElement("user_name", null, "hname:'이름', required:'Y'");
f.addElement("jumin_no", null, "hname:'생년월일', required:'Y', maxbyte:'6'");
f.addElement("hp1", null, "hname:'휴대전화', required:'Y', maxbyte:'3'");
f.addElement("hp2", null, "hname:'휴대전화', required:'Y', maxbyte:'4'");
f.addElement("hp3", null, "hname:'휴대전화', required:'Y', maxbyte:'5'");

DataSet person = new DataSet();
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
	person = personDao.find(" a.user_name = '" + f.get("user_name") + "' and a.hp1 = '" + f.get("hp1") + "' and a.hp2 = '" + f.get("hp2") + "' and a.hp3 = '" + f.get("hp3") + "'", "a.*", "a.reg_date desc");

	if (!person.next()) {
		u.jsError("회원으로 등록된 사용자가 아닙니다.\\n입력정보를 확인하세요.");
		return;
	}

	if ("".equals(person.getString("jumin_no"))) {
		u.jsError("회원으로 등록된 사용자가 아닙니다.\\n입력정보를 확인하세요.");
		return;
	}

	Security security = new	Security();
	String jumin_no = security.AESdecrypt(person.getString("jumin_no"));
	jumin_no = jumin_no.substring(0,6);

	if (!jumin_no.equals(f.get("jumin_no"))) {
		u.jsError("회원으로 등록된 사용자가 아닙니다.\\n입력정보를 확인하세요.");
		return;
	}

	if ("".equals(person.getString("email"))) {
		u.jsError("해당사용자로 등록된 이메일 없습니다.");
		return;
	}

	p.setVar("server_name", Config.getWebUrl());
	p.setVar("return_url", "/web/buyer/");
	p.setVar("person", person);
	String mail_body = p.fetch("../html/mail/find_id_person_mail.html");
	u.mail(person.getString("email"), "[농심] 계정정보 안내", mail_body );

	String email = person.getString("email");
	String[] emailArray = email.split("@");
	email = emailArray[0].substring(0, 3);
	for (int i = 3; i < emailArray[0].length()-1; i++) email += "*";
	email += emailArray[0].substring(emailArray[0].length()-1, emailArray[0].length()) + "@" + emailArray[1];

	u.jsAlertReplace(email + " 주소로 메일이 발송 되었습니다.", "/web/buyer/main/index.jsp");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("member.find_id_person");
p.setVar("menu_cd","000128");
p.setLoop("person", person);
p.setVar("form_script",f.getScript());
p.display(out);
%>