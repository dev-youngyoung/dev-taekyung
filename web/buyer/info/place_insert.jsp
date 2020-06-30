<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_field_gubun = {"01=>�μ�","02=>����"};

f.addElement("field_gubun", null, "hname:'����', required:'Y'");
f.addElement("field_name", null, "hname:'�μ�/������', required:'Y'");
f.addElement("boss_name", null, "hname:'��ǥ�ڸ�'");
f.addElement("telnum", null, "hname:'��ȭ��ȣ'");
f.addElement("post_code1", null, "hname:'�����ȣ', option:'number'");
f.addElement("post_code2", null, "hname:'�����ȣ', option:'number'");
f.addElement("address", null, "hname:'�ּ�'");
f.addElement("use_yn", null, "hname:'��뿩��', required:'Y'");

// �Է¼���
if(u.isPost() && f.validate())
{
	DataObject fieldDao = new DataObject("tcb_field");

	String field_seq = fieldDao.getOne(
			"select nvl(max(field_seq),0)+1 field_seq "+
					"  from tcb_field where member_no = '"+_member_no+"'"
	);

	fieldDao.item("member_no", _member_no);
	fieldDao.item("field_seq", field_seq);
	fieldDao.item("field_name", f.get("field_name"));
	if(f.get("field_gubun").equals("02")){
		fieldDao.item("post_code", f.get("post_code1")+f.get("post_code2"));
		fieldDao.item("address", f.get("address"));
		fieldDao.item("telnum", f.get("telnum"));
		fieldDao.item("boss_name", f.get("boss_name"));
	}
	fieldDao.item("use_yn", f.get("use_yn"));
	fieldDao.item("status","1");
	fieldDao.item("field_gubun", f.get("field_gubun"));
	if(!fieldDao.insert()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �����ͷ� ���� �Ͽ� �ֽʽÿ�.");
		return;
	}

	u.jsAlert("���������� ���� �Ǿ����ϴ�. ");
	u.jsReplace("place_list.jsp");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.place_modify");
p.setVar("menu_cd","000110");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000110", "btn_auth").equals("10"));
p.setVar("modify", false);
p.setLoop("code_field_gubun",u.arr2loop(code_field_gubun));
p.setVar("form_script", f.getScript());
p.display(out);
%>