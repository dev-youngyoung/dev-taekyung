<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
if(auth.getString("_MEMBER_GUBUN").equals("04")){
	u.redirect("my_info_modify_person.jsp");
	return;
}


CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_user_gubun = codeDao.getCodeArray("M005");
String[] code_user_level  = codeDao.getCodeArray("M013");

DataObject personDao = new DataObject("tcb_person a");
DataSet person = personDao.find(
			 " a.member_no = '"+_member_no+"' " 
			+" and a.person_seq = '"+auth.getString("_PERSON_SEQ")+"' " 
			+" and a.status > 0 " 
			, " a.* "
			+ " ,(select field_name from tcb_field where member_no = a.member_no and field_seq = a.field_seq) field_name "
		);
if(!person.next()){
	u.jsError("����� ������ �����ϴ�.");
	return;
}
person.put("user_level_nm", u.getItem(person.getString("user_level"), code_user_level));
person.put("user_gubun_nm", u.getItem(person.getString("user_gubun"), code_user_gubun));
if(u.inArray(auth.getString("_MEMBER_TYPE"), new String[]{"01","03"})){
	person.put("dept_name", person.getString("field_name"));
}else{
	person.put("dept_name", person.getString("division"));
}


f.addElement("passwd", null, "hname:'��й�ȣ', option:'userpw', match:'passwd2', minbyte:'8', mixbyte:'20'");
f.addElement("user_name", person.getString("user_name"), "hname:'����ڸ�',required:'Y'");
f.addElement("position", person.getString("position"), "hname:'����'");
f.addElement("email", person.getString("email"), "hname:'�̸���', required:'Y',option:'email'");
f.addElement("tel_num", person.getString("tel_num"), "hname:'��ȭ��ȣ', required:'Y'");
f.addElement("fax_num", person.getString("fax_num"), "hname:'�ѽ�'");
f.addElement("hp1", person.getString("hp1"), "hname:'�޴���ȭ', required:'Y'");
f.addElement("hp2", person.getString("hp2"), "hname:'�޴���ȭ', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", person.getString("hp3"), "hname:'�޴���ȭ', required:'Y', minbyte:'4', maxbyte:'4'");

if(u.isPost()&&f.validate()){
	DB db = new DB();
	
	personDao = new DataObject("tcb_person");
	if(!f.get("passwd").equals("")){
		personDao.item("passwd", u.sha256(f.get("passwd")));
		personDao.item("passdate", u.getTimeString());  // ��й�ȣ ����ð� ���
	}
	personDao.item("user_name",f.get("user_name"));
	personDao.item("tel_num",f.get("tel_num"));
	personDao.item("fax_num",f.get("fax_num"));
	personDao.item("hp1",f.get("hp1"));
	personDao.item("hp2",f.get("hp2"));
	personDao.item("hp3",f.get("hp3"));
	personDao.item("email",f.get("email"));
	personDao.item("reg_date", u.getTimeString());
	personDao.item("reg_id", f.get("user_id"));
	personDao.item("position",f.get("position"));
	
	db.setCommand(personDao.getUpdateQuery("member_no = '"+_member_no+"' and person_seq = '"+person.getString("person_seq")+"'"), personDao.record);
	if(!db.executeArray()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �����ͷ� ���� �Ͽ� �ֽʽÿ�.");
		return;
	}
	
	u.jsAlertReplace("���� �Ͽ����ϴ�.", "my_info_modify_comp.jsp?"+u.getQueryString());
	return;
}
p.setLayout("default");
//p.setDebug(out);
p.setBody("info.my_info_modify_comp");
p.setVar("menu_cd","000118");
p.setVar("modify", true);
p.setVar("person", person);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("person_seq"));
p.display(out);
%>