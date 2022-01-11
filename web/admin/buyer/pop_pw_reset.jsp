<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String person_seq = u.request("person_seq");

if(member_no.equals("")||person_seq.equals("")){
	u.jsErrClose("정상적인 경로 접근하세요.");
	return;
}

DataObject personDao = new DataObject("tcb_person");

DataSet person = personDao.find(" member_no = '" + member_no + "' and person_seq = '" + person_seq + "' ");
if(!person.next()){
	u.jsError("담당자 정보를 찾을 수 없습니다.");
	return;
}

f.addElement("hp1", person.getString("hp1"), "hname:'핸드폰번호(앞)', required:'Y'");
f.addElement("hp2", person.getString("hp2"), "hname:'핸드폰번호(중간)', required:'Y'");
f.addElement("hp3", person.getString("hp3"), "hname:'핸드폰번호(마지막)', required:'Y'");

p.setVar("pw", "p"+u.strpad(u.getRandInt(0,999999)+"",6,"0")+"!");

if(u.isPost()&&f.validate()){

	String hp1 = f.get("hp1");
	String hp2 = f.get("hp2");
	String hp3 = f.get("hp3");
	String pw = f.get("pw");
	
	personDao.item("passwd", u.sha256(pw));
	
	if(!personDao.update("member_no = '"+member_no+"' and person_seq = '"+person_seq+"'")){
		u.jsError("처리중 오류가 발생 하였습니다.");
		return;
	}
	
	
	if(!"".equals(hp1) && !"".equals(hp2) && !"".equals(hp3)){
		SmsDao smsDao = new SmsDao();
		String sSmsMsg = "[나이스다큐(일반 기업용) 임시 비밀번호 안내]\n" + pw;
		smsDao.sendSMS("buyer", hp1, hp2, hp3, sSmsMsg);
	}

	out.println("<script>");
	out.println("alert('비밀번호 초기화 처리 되었습니다.');");
	out.println("opener.location.reload();");
	out.println("self.close();");
	out.println("</script>");
	return; 
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("buyer.pop_pw_reset");
p.setVar("popup_title","비밀번호 초기화");
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>