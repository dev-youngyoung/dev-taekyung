<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String seq = u.request("seq");
if(member_no.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsError("��ü������ �����ϴ�.");
	return;
}

DataObject fieldDao = new DataObject("tcb_field");
DataSet field = fieldDao.find(" member_no = '"+member_no+"' and status > 0 ");
while(field.next()){
}

DataObject calcPersonDao = new DataObject("tcb_calc_person");
DataSet calcPerson = calcPersonDao.find(" member_no = '"+member_no+"' and seq = '"+seq+"' ");
if(!calcPerson.next()){
	u.jsErrClose("�������� ������ �����ϴ�.");
	return;
}

f.addElement("user_name", calcPerson.getString("user_name"), "hname:'����ڸ�', required:'Y'");
f.addElement("tel_num", calcPerson.getString("tel_num"), "hname:'��ȭ��ȣ'");
f.addElement("hp1", calcPerson.getString("hp1"), "hname:'�޴���', required:'Y'");
f.addElement("hp2", calcPerson.getString("hp2"), "hname:'�޴���', required:'Y'");
f.addElement("hp3", calcPerson.getString("hp3"), "hname:'�޴���', required:'Y'");
f.addElement("email", calcPerson.getString("email"), "hname:'�޴���', required:'Y'");

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
		u.jsError("���� ó���� ���� �Ͽ����ϴ�.");
		return;
	}
	out.println("<script>");
	out.println("opener.location.reload();");
	out.println("alert('���� ó�� �Ǿ����ϴ�.');");
	out.println("location.href='pop_calc_person_modify.jsp?"+u.getQueryString()+"';");
	out.println("</script>");
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("buyer.pop_calc_person_modify");
p.setVar("modify", true);
p.setVar("popup_title","�������� ����");
p.setVar("member", member);
p.setVar("calcPerson", calcPerson);
p.setLoop("field", field);
p.setVar("form_script",f.getScript());
p.setVar("query", u.getQueryString());
p.display(out);
%>