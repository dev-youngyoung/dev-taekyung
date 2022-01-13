<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
f.addElement("vendcd1", null, "hname:'사업자번호', required:'Y', fixbyte:'3'");
f.addElement("vendcd2", null, "hname:'사업자번호', required:'Y', fixbyte:'2'");
f.addElement("vendcd3", null, "hname:'사업자번호', required:'Y', fixbyte:'5'");
f.addElement("user_id", null, "hname:'아이디', required:'Y'");
f.addElement("user_name", null, "hname:'사용자 이름', required:'Y'");
f.addElement("email", null, "hname:'사용자 이메일', required:'Y'");

if(u.isPost() && f.validate())
{
    String vendcd = f.get("vendcd1")+f.get("vendcd2")+f.get("vendcd3");
	DataObject memberDao = new DataObject("tcb_member");
	DataSet member = memberDao.find(" vendcd = '"+vendcd+"' and status in ('01','03') ");
	if(!member.next()){
		u.jsError("해당 사업자 등록 번호로 검색 된 업체정보가 없습니다.");
		return;
	}

	DataObject personDao = new DataObject("tcb_person");
	DataSet person = personDao.find(" member_no = '"+member.getString("member_no")+"' and user_id='"+f.get("user_id")+"' and user_name='"+f.get("user_name")+"' and email = '"+f.get("email")+"'");
	if(!person.next()){
		u.jsError("등록하신 정보로 검색된 담당자 정보가 없습니다.");
		return;
	}

	if(person.getString("member_no").equals("20190300995")){//지니뮤직은 자동로그인만 사용
		u.jsError("지니뮤직은 자동로그인만 사용가능합니다.");
		return;
	}

	String passwd = "p"+u.strpad(u.getRandInt(0,999999)+"",6,"0")+"!";

	person.put("member_name", member.getString("member_name"));
	person.put("passwd",passwd);

	personDao.item("passwd",u.sha256(passwd));
	if(!personDao.update(" member_no = '"+person.getString("member_no")+"' and person_seq = '"+person.getString("person_seq")+"' ")){
		u.jsError("임시비밀번호 발급처리에 실패 하엿습니다.");
		return;
	}

	p.setVar("server_name", request.getServerName());
	p.setVar("return_url", "/web/buyer/");
	p.setVar("person", person);
	String mail_body = p.fetch("../html/mail/find_pw_mail.html");
	u.mail(person.getString("email"), "[나이스다큐] 계정정보 안내", mail_body );

	u.jsAlertReplace("메일이 발송 되었습니다.", "/web/buyer/main/index.jsp");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("member.find_pw");
p.setVar("menu_cd","000129");
p.setVar("form_script",f.getScript());
p.display(out);
%>