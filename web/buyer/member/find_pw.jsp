<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
f.addElement("vendcd1", null, "hname:'����ڹ�ȣ', required:'Y', fixbyte:'3'");
f.addElement("vendcd2", null, "hname:'����ڹ�ȣ', required:'Y', fixbyte:'2'");
f.addElement("vendcd3", null, "hname:'����ڹ�ȣ', required:'Y', fixbyte:'5'");
f.addElement("user_id", null, "hname:'���̵�', required:'Y'");
f.addElement("user_name", null, "hname:'����� �̸�', required:'Y'");
f.addElement("email", null, "hname:'����� �̸���', required:'Y'");

if(u.isPost() && f.validate())
{
    String vendcd = f.get("vendcd1")+f.get("vendcd2")+f.get("vendcd3");
	DataObject memberDao = new DataObject("tcb_member");
	DataSet member = memberDao.find(" vendcd = '"+vendcd+"' and status in ('01','03') ");
	if(!member.next()){
		u.jsError("�ش� ����� ��� ��ȣ�� �˻� �� ��ü������ �����ϴ�.");
		return;
	}

	DataObject personDao = new DataObject("tcb_person");
	DataSet person = personDao.find(" member_no = '"+member.getString("member_no")+"' and user_id='"+f.get("user_id")+"' and user_name='"+f.get("user_name")+"' and email = '"+f.get("email")+"'");
	if(!person.next()){
		u.jsError("����Ͻ� ������ �˻��� ����� ������ �����ϴ�.");
		return;
	}

	if(person.getString("member_no").equals("20190300995")){//���Ϲ����� �ڵ��α��θ� ���
		u.jsError("���Ϲ����� �ڵ��α��θ� ��밡���մϴ�.");
		return;
	}

	String passwd = "p"+u.strpad(u.getRandInt(0,999999)+"",6,"0")+"!";

	person.put("member_name", member.getString("member_name"));
	person.put("passwd",passwd);

	personDao.item("passwd",u.sha256(passwd));
	if(!personDao.update(" member_no = '"+person.getString("member_no")+"' and person_seq = '"+person.getString("person_seq")+"' ")){
		u.jsError("�ӽú�й�ȣ �߱�ó���� ���� �Ͽ����ϴ�.");
		return;
	}

	p.setVar("server_name", request.getServerName());
	p.setVar("return_url", "/web/buyer/");
	p.setVar("person", person);
	String mail_body = p.fetch("../html/mail/find_pw_mail.html");
	u.mail(person.getString("email"), "[���̽���ť] �������� �ȳ�", mail_body );

	u.jsAlertReplace("������ �߼� �Ǿ����ϴ�.", "/web/buyer/main/index.jsp");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("member.find_pw");
p.setVar("menu_cd","000129");
p.setVar("form_script",f.getScript());
p.display(out);
%>