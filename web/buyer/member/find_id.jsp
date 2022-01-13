<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
f.addElement("vendcd1", null, "hname:'사업자번호', required:'Y', maxbyte:'3'");
f.addElement("vendcd2", null, "hname:'사업자번호', required:'Y', maxbyte:'2'");
f.addElement("vendcd3", null, "hname:'사업자번호', required:'Y', maxbyte:'5'");

DataSet person = new DataSet();
if(u.isPost() && f.validate())
{
	String vendcd = f.get("vendcd1")+f.get("vendcd2")+f.get("vendcd3");
	if(vendcd.length() != 10){
		u.jsError("사업자등록 번호를 정확히 입력 하세요.");
		return;
	}
	
	
	String mode = f.get("mode");
	if(mode.equals("1")){
		DataObject personDao = new DataObject("tcb_person");
		//personDao.setDebug(out);
		//위메프가 2개 나온다.
		person = personDao.find(" member_no = (select max(member_no) from tcb_member where vendcd = '"+vendcd+"' and status in ('01','03')) and user_id is not null");
		if(person.size()==0)
		{
			u.jsError("회원으로 등록된 사업자가 아닙니다.\\n사업자등록 번호를 확인하세요.");
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
			u.jsError("메일전송 정보가 부정확 합니다.");
			return;
		}
		DataObject personDao = new DataObject("tcb_person a");
		person = personDao.find(
				" member_no = '"+member_no+"' and person_seq = '"+person_seq+"' "
				,"a.*,(select member_name from tcb_member where member_no = a.member_no) member_name"
		);
		if(!person.next()){
			u.jsError("담당자 정보가 없습니다.");
			return;
		}
		if(person.getString("email").equals("")){
			u.jsError("해당사용자로 등록된 이메일 없습니다.");
			return;
		}

		p.setVar("server_name", request.getServerName());
		p.setVar("return_url", "/web/buyer/");
		p.setVar("person", person);
		String mail_body = p.fetch("../html/mail/find_id_mail.html");
		u.mail(person.getString("email"), "[나이스다큐] 계정정보 안내", mail_body );

		u.jsAlertReplace("메일이 발송 되었습니다.", "/web/buyer/main/index.jsp");
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