<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
f.addElement("vendcd1", null, "hname:'����ڹ�ȣ', required:'Y', maxbyte:'3'");
f.addElement("vendcd2", null, "hname:'����ڹ�ȣ', required:'Y', maxbyte:'2'");
f.addElement("vendcd3", null, "hname:'����ڹ�ȣ', required:'Y', maxbyte:'5'");

DataSet person = new DataSet();
if(u.isPost() && f.validate())
{
	String vendcd = f.get("vendcd1")+f.get("vendcd2")+f.get("vendcd3");
	if(vendcd.length() != 10){
		u.jsError("����ڵ�� ��ȣ�� ��Ȯ�� �Է� �ϼ���.");
		return;
	}
	
	
	String mode = f.get("mode");
	if(mode.equals("1")){
		DataObject personDao = new DataObject("tcb_person");
		//personDao.setDebug(out);
		//�������� 2�� ���´�.
		person = personDao.find(" member_no = (select max(member_no) from tcb_member where vendcd = '"+vendcd+"' and status in ('01','03')) and user_id is not null");
		if(person.size()==0)
		{
			u.jsError("ȸ������ ��ϵ� ����ڰ� �ƴմϴ�.\\n����ڵ�� ��ȣ�� Ȯ���ϼ���.");
			return;
		}
		while(person.next()){
			String user_id = person.getString("user_id");
			
			String secret = "";
			for(int i=3; i<user_id.length()-1;i++)
				secret += "*";
			
			user_id = user_id.substring(0,3)+secret+user_id.substring(user_id.length()-1,user_id.length());
			
			person.put("user_id", user_id);

			String email = person.getString("email");
			
			String[] emailArray = email.split("@");
			 
			if(emailArray[0].length() > 2){ 
				email = emailArray[0].substring(0, 2);  
				for (int i = 2; i < emailArray[0].length()-1; i++) {
					email += "*";
				}
			}else{  
				email = emailArray[0].substring(0, 0);
				for (int i = 0; i < emailArray[0].length()-1; i++) {
					email += "*";
				}
			 }  
			 
			email += emailArray[0].substring(emailArray[0].length()-1, emailArray[0].length()) + "@" + emailArray[1];

			person.put("email", email);
		}
	}else if(mode.equals("2")){
		String member_no = f.get("member_no");
		String person_seq = f.get("person_seq");
		if(member_no.equals("")||person_seq.equals("")){
			u.jsError("�������� ������ ����Ȯ �մϴ�.");
			return;
		}
		DataObject personDao = new DataObject("tcb_person a");
		person = personDao.find(
				" member_no = '"+member_no+"' and person_seq = '"+person_seq+"' "
				,"a.*,(select member_name from tcb_member where member_no = a.member_no) member_name"
		);
		if(!person.next()){
			u.jsError("����� ������ �����ϴ�.");
			return;
		}
		if(person.getString("email").equals("")){
			u.jsError("�ش����ڷ� ��ϵ� �̸��� �����ϴ�.");
			return;
		}

		p.setVar("server_name", request.getServerName());
		p.setVar("return_url", "/web/buyer/");
		p.setVar("person", person);
		String mail_body = p.fetch("../html/mail/find_id_mail.html");
		u.mail(person.getString("email"), "[���̽���ť] �������� �ȳ�", mail_body );

		u.jsAlertReplace("������ �߼� �Ǿ����ϴ�.", "/web/buyer/main/index.jsp");
		return;
	}
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("member.find_id");
p.setVar("menu_cd","000128");
p.setLoop("person", person);
p.setVar("form_script",f.getScript());
p.display(out);
%>