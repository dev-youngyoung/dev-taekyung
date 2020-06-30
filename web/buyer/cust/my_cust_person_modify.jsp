<%@page import="oracle.jdbc.internal.ClientDataSupport"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

String[] code_status = {"01=>��ȸ��", "02=>��ȸ��"};  // ȸ������

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find(
		 "    member_no = '"+member_no+"' "
		+"and member_gubun = '04' "
		+"and member_no in (select client_no from tcb_client where member_no = '"+_member_no+"' )"
		);
if(!member.next()){
	u.jsError("ȸ�������� �����ϴ�.");
	return;
}
member.put("status_nm", u.getItem(member.getString("status"), code_status));

DataObject personDao = new DataObject("tcb_person");
DataSet person = personDao.find(" member_no = '"+member_no+"' and default_yn = 'Y'");
if(!person.next()){
	u.jsError("ȸ������������ �����ϴ�.");
	return;
}
if(!person.getString("jumin_no").equals("")){
}

Security security =	new	Security();
String jumin_no = u.aseDec(person.getString("jumin_no"));//�������
String gender =""; //����
if(jumin_no.length() == 8){//19120601 1912�� 06�� 01��
	jumin_no = u.getTimeString("yyyy-MM-dd",jumin_no);
	gender = "";
}else
if(jumin_no.length() == 7){//1101011 11��01��01�� 1(��)
	gender = u.inArray(jumin_no.substring(6,7), new String[]{"1","3"})?"(��)":"(��)";
	jumin_no = jumin_no.substring(0,6);
	if(Integer.parseInt(jumin_no.substring(0,2)) > 25){
		jumin_no = u.getTimeString("yyyy-MM-dd","19"+jumin_no);
	}else{
		jumin_no = u.getTimeString("yyyy-MM-dd","20"+jumin_no);
	}
}else
if(jumin_no.length() == 6){
	jumin_no = jumin_no;//110101
	gender = "";
	if(Integer.parseInt(jumin_no.substring(0,2)) > 25){
		jumin_no = u.getTimeString("yyyy-MM-dd","19"+jumin_no);
	}else{
		jumin_no = u.getTimeString("yyyy-MM-dd","20"+jumin_no);
	}
}
member.put("gender", gender);
member.put("birth_date", jumin_no);


DataObject memberBossDao = new DataObject("tcb_member_boss");
DataSet memberBoss = memberBossDao.find(" member_no = '"+member_no+"' ");
if(!memberBoss.next()){
}
if(!memberBoss.getString("boss_birth_date").equals("")){
	member.put("birth_date", u.getTimeString("yyyy-MM-dd", memberBoss.getString("boss_birth_date")));
	member.put("gender", memberBoss.getString("boss_gender").equals("")?"":"("+memberBoss.getString("boss_gender")+")");
}


DataObject clientDao = new DataObject("tcb_client");
DataSet client = clientDao.find(" member_no = '"+_member_no+"' and client_no = '"+member_no+"' ");
if(!client.next()){
}


f.addElement("post_code", member.getString("post_code"), "hname:'�����ȣ', option:'number'");
f.addElement("address", member.getString("address"), "hname:'�ּ�', required:'Y'");
f.addElement("hp1", person.getString("hp1"), "hname:'�޴���ȭ', required:'Y'");
f.addElement("hp2", person.getString("hp2"), "hname:'�޴���ȭ', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", person.getString("hp3"), "hname:'�޴���ȭ', required:'Y', minbyte:'4', maxbyte:'4'");
f.addElement("email", person.getString("email"), "hname:'�̸���', required:'Y',option:'email'");

if(u.isPost()&&f.validate()){
	DB db = new DB();
	
	memberDao = new DataObject("tcb_member");
	memberDao.item("post_code", f.get("post_code"));
	memberDao.item("address", f.get("address"));
	memberDao.item("reg_date", u.getTimeString());
	memberDao.item("reg_id", auth.getString("_USER_ID"));
	db.setCommand(memberDao.getUpdateQuery("member_no = '"+member_no+"' "), memberDao.record);
	
	personDao = new DataObject("tcb_person");
	personDao.item("hp1", f.get("hp1"));
	personDao.item("hp2", f.get("hp2"));
	personDao.item("hp3", f.get("hp3"));
	personDao.item("email", f.get("email"));
	personDao.item("reg_date", u.getTimeString());
	personDao.item("reg_id", auth.getString("_USER_ID"));
	db.setCommand(personDao.getUpdateQuery("member_no = '"+member_no+"' and person_seq = '"+person.getString("person_seq")+"' "), personDao.record);

	if(memberBoss.size()>0){
		memberBossDao = new DataObject("tcb_member_boss");
		memberBossDao.item("boss_hp1", f.get("hp1"));
		memberBossDao.item("boss_hp2", f.get("hp2"));
		memberBossDao.item("boss_hp3", f.get("hp3"));
		memberBossDao.item("boss_email", f.get("email"));
		db.setCommand(memberBossDao.getUpdateQuery("member_no= '"+member_no+"' and seq = '1'"), memberBossDao.record);
	}
	
	if(!db.executeArray()){
		u.jsError("ó���� ���� �Ͽ����ϴ�.");
		return;
	}
	
	u.jsAlertReplace("ó�� �Ͽ����ϴ�.", "my_cust_person_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.my_cust_person_modify");
p.setVar("menu_cd","000087");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000087", "btn_auth").equals("10"));
p.setVar("member", member);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.setVar("form_script",f.getScript());
p.display(out);
%>