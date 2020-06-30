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
String[] code_comp_cate = codeDao.getCodeArray("M004");
String[] code_comp_mgr = codeDao.getCodeArray("M011");

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsError("��ü ������ �����ϴ�.");
	return;
}

if(!member.getString("vendcd").equals("")) {
    String[] arr_vendcd = u.getBizNo(member.getString("vendcd")).split("-");
    member.put("vendcd1", arr_vendcd[0]);
    member.put("vendcd2", arr_vendcd[1]);
    member.put("vendcd3", arr_vendcd[2]);
}

member.put("cert_end_date", u.getTimeString("yyyy-MM-dd", member.getString("cert_end_date")));
if(member.getString("member_slno").length()==13){
	member.put("member_slno1",member.getString("member_slno").substring(0,6));
	member.put("member_slno2",member.getString("member_slno").substring(6));
}

f.addElement("member_gubun", member.getString("member_gubun"),"hname:'��ü����', required:'Y'");
f.addElement("member_type", member.getString("member_type"),"hname:'ȸ������', required:'Y'");
f.addElement("status", member.getString("status"),"hname:'ȸ������', required:'Y'");
f.addElement("vendcd1", member.getString("vendcd1"),"hname:'����ڵ�Ϲ�ȣ', required:'Y'");
f.addElement("vendcd2", member.getString("vendcd2"),"hname:'����ڵ�Ϲ�ȣ', required:'Y'");
f.addElement("vendcd3", member.getString("vendcd3"),"hname:'����ڵ�Ϲ�ȣ', required:'Y'");
f.addElement("member_slno1", member.getString("member_slno1"), "hnme:'���ι�ȣ',option:'number', minbyte:'6'");
f.addElement("member_slno2", member.getString("member_slno2"), "hnme:'���ι�ȣ',option:'number', minbyte:'7'");
f.addElement("member_name", member.getString("member_name"), "hname:'��ü��',required:'Y'");
f.addElement("boss_name", member.getString("boss_name"), "hname:'��ǥ�ڸ�',required:'Y'");
f.addElement("condition", member.getString("condition"), "hname:'����',required:'Y'");
f.addElement("category", member.getString("category"), "hname:'����', required:'Y'");
f.addElement("post_code", member.getString("post_code"), "hname:'�����ȣ',required:'Y', option:'number'");
f.addElement("address", member.getString("address"), "hname:'�ּ�', required:'Y'");

// �Է¼���
if(u.isPost() && f.validate()){
	DB db = new DB();
	memberDao = new DataObject("tcb_member");
	memberDao.item("vendcd",f.get("vendcd1")+f.get("vendcd2")+f.get("vendcd3"));
	memberDao.item("member_name", f.get("member_name"));
	memberDao.item("member_gubun", f.get("member_gubun"));
	memberDao.item("member_type", f.get("member_type"));
	memberDao.item("boss_name", f.get("boss_name"));
	memberDao.item("post_code", f.get("post_code"));
	memberDao.item("address", f.get("address"));
	memberDao.item("member_slno", f.get("member_slno1")+f.get("member_slno2"));
	memberDao.item("condition", f.get("condition"));
	memberDao.item("category", f.get("category"));
	memberDao.item("status",f.get("status"));
	db.setCommand(memberDao.getUpdateQuery(" member_no = '"+member_no+"' "), memberDao.record);

	if(!db.executeArray()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�");
		return;
	}
	
	u.jsAlertReplace("����ó�� �Ͽ����ϴ�.","member_view.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
p.setDebug(out);
p.setBody("buyer.member_view");
p.setVar("menu_cd","000044");
p.setVar("member", member);
p.setLoop("code_member_type", u.arr2loop(code_member_type));
p.setLoop("code_member_gubun", u.arr2loop(code_member_gubun));
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("code_comp_cate", u.arr2loop(code_comp_cate));
p.setLoop("code_comp_mgr", u.arr2loop(code_comp_mgr));
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.display(out);
%>