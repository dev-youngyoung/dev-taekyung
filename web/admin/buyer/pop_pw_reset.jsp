<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String person_seq = u.request("person_seq");

if(member_no.equals("")||person_seq.equals("")){
	u.jsErrClose("�������� ��� �����ϼ���.");
	return;
}

DataObject personDao = new DataObject("tcb_person");

DataSet person = personDao.find(" member_no = '" + member_no + "' and person_seq = '" + person_seq + "' ");
if(!person.next()){
	u.jsError("����� ������ ã�� �� �����ϴ�.");
	return;
}

f.addElement("hp1", person.getString("hp1"), "hname:'�ڵ�����ȣ(��)', required:'Y'");
f.addElement("hp2", person.getString("hp2"), "hname:'�ڵ�����ȣ(�߰�)', required:'Y'");
f.addElement("hp3", person.getString("hp3"), "hname:'�ڵ�����ȣ(������)', required:'Y'");

p.setVar("pw", "p"+u.strpad(u.getRandInt(0,999999)+"",6,"0")+"!");

if(u.isPost()&&f.validate()){

	String hp1 = f.get("hp1");
	String hp2 = f.get("hp2");
	String hp3 = f.get("hp3");
	String pw = f.get("pw");
	
	personDao.item("passwd", u.sha256(pw));
	
	if(!personDao.update("member_no = '"+member_no+"' and person_seq = '"+person_seq+"'")){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�.");
		return;
	}
	
	
	if(!"".equals(hp1) && !"".equals(hp2) && !"".equals(hp3)){
		SmsDao smsDao = new SmsDao();
		String sSmsMsg = "[���̽���ť(�Ϲ� �����) �ӽ� ��й�ȣ �ȳ�]\n" + pw;
		smsDao.sendSMS("buyer", hp1, hp2, hp3, sSmsMsg);
	}

	out.println("<script>");
	out.println("alert('��й�ȣ �ʱ�ȭ ó�� �Ǿ����ϴ�.');");
	out.println("opener.location.reload();");
	out.println("self.close();");
	out.println("</script>");
	return; 
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("buyer.pop_pw_reset");
p.setVar("popup_title","��й�ȣ �ʱ�ȭ");
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>