<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
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

f.addElement("user_name", null, "hname:'����ڸ�', required:'Y'");
f.addElement("tel_num", null, "hname:'��ȭ��ȣ'");
f.addElement("hp1", null, "hname:'�޴���', required:'Y'");
f.addElement("hp2", null, "hname:'�޴���', required:'Y'");
f.addElement("hp3", null, "hname:'�޴���', required:'Y'");
f.addElement("email", null, "hname:'�޴���', required:'Y'");

if(u.isPost()&&f.validate()){

	DataObject calcPersonDao = new DataObject("tcb_calc_person");
	String seq = calcPersonDao.getOne(" select nvl(max(seq),0)+1 from tcb_calc_person where member_no = '"+member_no+"' ");
	calcPersonDao.item("member_no", member_no);
	calcPersonDao.item("seq", seq);
	calcPersonDao.item("user_name", f.get("user_name"));
	calcPersonDao.item("tel_num", f.get("tel_num"));
	calcPersonDao.item("hp1", f.get("hp1"));
	calcPersonDao.item("hp2", f.get("hp2"));
	calcPersonDao.item("hp3", f.get("hp3"));
	calcPersonDao.item("email", f.get("email"));
	calcPersonDao.item("field_seq", f.get("field_seqs"));
	calcPersonDao.item("status", "10");
	if(!calcPersonDao.insert()) {
		u.jsError("���� ó���� ���� �Ͽ����ϴ�.");
		return;
	}
	out.println("<script>");
	out.println("opener.location.reload();");
	out.println("alert('���� ó�� �Ǿ����ϴ�.');");
	out.println("location.href='pop_calc_person_modify.jsp?member_no="+member_no+"&seq="+seq+"';");
	out.println("</script>");
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("buyer.pop_calc_person_modify");
p.setVar("popup_title","�������� ���");
p.setVar("member", member);
p.setLoop("field", field);
p.setVar("form_script",f.getScript());
p.display(out);
%>