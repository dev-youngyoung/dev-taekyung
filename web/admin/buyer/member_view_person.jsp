<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = {"00=>Ż��", "01=>��ȸ��", "02=>��ȸ��", "03=>�簡��"};  // ȸ������
String[] code_member_type = codeDao.getCodeArray("M002");
String[] code_member_gubun = codeDao.getCodeArray("M001");

DataObject memberDao = new DataObject();
DataSet member = memberDao.query(" select a.*, b.jumin_no, b.hp1, b.hp2, b.hp3, b.email, b.tel_num, b.fax_num, b.user_id"
		                        +" from tcb_member a "
		                        +"     ,tcb_person b "
		                        +" where a.member_no = b.member_no "
		                        +" and   a.member_no = '"+ member_no + "'");
if(!member.next()){
	u.jsError("ȸ�� ������ �����ϴ�.");
	return;
}

f.addElement("member_gubun", member.getString("member_gubun"),"hname:'��ü����', required:'Y'");
f.addElement("status", member.getString("status"),"hname:'ȸ������', required:'Y'");
f.addElement("member_type", member.getString("member_type"),"hname:'ȸ������', required:'Y'");
f.addElement("member_name", member.getString("member_name"), "hname:'�̸�',required:'Y'");

Security security = new	Security();

String jumin_no = "";
String gender = "";

if(!"".equals(member.getString("jumin_no"))){
	jumin_no = security.AESdecrypt(member.getString("jumin_no"));
	
	if(jumin_no.length() > 6){
		gender = Util.inArray(jumin_no.substring(6,7), new String[]{"1","3"}) ? "1" : "2";
	}
	
	if(Integer.parseInt(jumin_no.substring(0,2)) > 25)
		jumin_no = "19" + jumin_no.substring(0,2)+"-"+jumin_no.substring(2,4)+"-"+jumin_no.substring(4,6);
	else
		jumin_no = "20" + jumin_no.substring(0,2)+"-"+jumin_no.substring(2,4)+"-"+jumin_no.substring(4,6);
}

f.addElement("jumin_no", u.getTimeString("yyyy-MM-dd", jumin_no), "hname:'�������',required:'Y'");
f.addElement("gender", gender, "hname:'����', required:'Y'");
f.addElement("post_code", member.getString("post_code"), "hname:'�����ȣ',required:'Y', option:'number'");
f.addElement("address", member.getString("address"), "hname:'�ּ�', required:'Y'");
f.addElement("hp1", member.getString("hp1"), "hname:'�޴���ȭ', required:'Y'");
f.addElement("hp2", member.getString("hp2"), "hname:'�޴���ȭ', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", member.getString("hp3"), "hname:'�޴���ȭ', required:'Y', minbyte:'4', maxbyte:'4'");
f.addElement("email", member.getString("email"), "hname:'�̸���', required:'Y'");
f.addElement("tel_num", member.getString("tel_num"), "hname:'��ȭ��ȣ'");
f.addElement("fax_num", member.getString("fax_num"), "hname:'�ѽ���ȣ'");

member.put("cert_end_date", u.getTimeString("yyyy-MM-dd", member.getString("cert_end_date")));

DataObject memberBossDao = new DataObject();
DataSet memberBoss = memberBossDao.query(" select * "
										  +" from tcb_member_boss "
										  +" where member_no  = '"+member_no+"'");
if(memberBoss.next()){
	memberBoss.put("boss_birth_date", u.getTimeString("yyyy-MM-dd", memberBoss.getString("boss_birth_date")));
	memberBoss.put("ci_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", memberBoss.getString("ci_date")));
}

// �Է¼���
if(u.isPost() && f.validate()){

	DB db = new DB();
	
	memberDao = new DataObject("tcb_member");
	
	memberDao.item("member_gubun", f.get("member_gubun"));
	memberDao.item("status",f.get("status"));
	memberDao.item("member_type", f.get("member_type"));
	memberDao.item("member_name", f.get("member_name"));
	memberDao.item("boss_name", f.get("member_name"));
	memberDao.item("post_code", f.get("post_code"));
	memberDao.item("address", f.get("address"));
	
	db.setCommand(memberDao.getUpdateQuery(" member_no = '"+member_no+"' "), memberDao.record);

	DataObject personDao = new DataObject("tcb_person");
	
	personDao.item("user_name", f.get("member_name"));
	personDao.item("jumin_no", security.AESencrypt(f.get("jumin_no").substring(2).replaceAll("-","")+f.get("gender")));
	personDao.item("hp1", f.get("hp1"));
	personDao.item("hp2", f.get("hp2"));
	personDao.item("hp3", f.get("hp3"));
	personDao.item("email", f.get("email"));
	personDao.item("tel_num", f.get("tel_num"));
	personDao.item("fax_num", f.get("fax_num"));
	
	db.setCommand(personDao.getUpdateQuery(" member_no = '"+member_no+"' "), personDao.record);
	
	memberBossDao = new DataObject("tcb_member_boss");
	int cnt = memberBossDao.getOneInt("select count(member_no) from tcb_member_boss where member_no = '"+member_no+"'");
	
	if(cnt == 1){
		
		memberBossDao.item("boss_email", f.get("email") );
		
		db.setCommand(memberBossDao.getUpdateQuery(" member_no = '"+member_no+"' "), memberBossDao.record);
	}
	

	if(!db.executeArray()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�");
		return;
	}
	
	u.jsAlertReplace("����ó�� �Ͽ����ϴ�.","member_view_person.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.member_view_person");
p.setVar("menu_cd","000044");
p.setVar("member", member);
p.setVar("memberBoss", memberBoss);
p.setLoop("code_member_type", u.arr2loop(code_member_type));
p.setLoop("code_member_gubun", u.arr2loop(code_member_gubun));
p.setLoop("code_status", u.arr2loop(code_status));
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.display(out);
%>