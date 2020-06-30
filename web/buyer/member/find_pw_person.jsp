<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
f.addElement("user_id", null, "hname:'���̵�', required:'Y'");
f.addElement("user_name", null, "hname:'�̸�', required:'Y'");
f.addElement("jumin_no", null, "hname:'�������', required:'Y', fixbyte:'6'");
f.addElement("hp1", null, "hname:'�޴���ȭ', required:'Y', fixbyte:'3'");
f.addElement("hp2", null, "hname:'�޴���ȭ', required:'Y', fixbyte:'4'");
f.addElement("hp3", null, "hname:'�޴���ȭ', required:'Y', fixbyte:'4'");
f.addElement("email", null, "hname:'�̸���', required:'Y'");

if (u.isPost() && f.validate()) {

	if (f.get("jumin_no").length() != 6) {
		u.jsError("��������� ��Ȯ�� �Է� �ϼ���.");
		return;
	}

	String hp = f.get("hp1") + f.get("hp2") + f.get("hp3");
	if (hp.length() != 11) {
		u.jsError("�޴���ȭ ��ȣ�� ��Ȯ�� �Է� �ϼ���.");
		return;
	}

	DataObject personDao = new DataObject("tcb_person a");
	//personDao.setDebug(out);
	personDao.addJoin("tcb_member b", "INNER", "b.member_gubun = '04' and a.member_no = b.member_no");
	DataSet person = personDao.find(" a.user_id='" + f.get("user_id") + "' and a.user_name='" + f.get("user_name") + "' and a.email = '" + f.get("email") +
			"' and a.hp1 = '" + f.get("hp1") + "' and a.hp2 = '" + f.get("hp2") + "' and a.hp3 = '" + f.get("hp3") + "' ", "a.*", "a.reg_date desc");

	if (!person.next()) {
		u.jsError("����Ͻ� ������ �˻��� ����� ������ �����ϴ�.");
		return;
	}

	if ("".equals(person.getString("jumin_no"))) {
		u.jsError("����Ͻ� ������ �˻��� ����� ������ �����ϴ�.");
		return;
	}

	Security security = new	Security();
	String jumin_no = security.AESdecrypt(person.getString("jumin_no"));
	jumin_no = jumin_no.substring(0,6);

	if (!jumin_no.equals(f.get("jumin_no"))) {
		u.jsError("����Ͻ� ������ �˻��� ����� ������ �����ϴ�.");
		return;
	}

	String passwd = "p"+u.strpad(u.getRandInt(0,999999)+"",6,"0")+"!";
	person.put("passwd",passwd);
	personDao.item("passwd",u.sha256(passwd));

	if(!personDao.update(" member_no = '" + person.getString("member_no") + "' and person_seq = '" + person.getString("person_seq") + "' ")){
		u.jsError("�ӽú�й�ȣ �߱�ó���� ���� �Ͽ����ϴ�.");
		return;
	}

	p.setVar("server_name", request.getServerName());
	p.setVar("return_url", "/web/buyer/");
	p.setVar("person", person);
	String mail_body = p.fetch("../html/mail/find_pw_person_mail.html");
	u.mail(person.getString("email"), "[���̽���ť] �������� �ȳ�", mail_body );

	u.jsAlertReplace("������ �߼� �Ǿ����ϴ�.", "/web/buyer/main/index.jsp");
	return;
}

	p.setLayout("default");
//p.setDebug(out);
	p.setBody("member.find_pw_person");
	p.setVar("menu_cd","000129");
	p.setVar("form_script",f.getScript());
	p.display(out);
%>