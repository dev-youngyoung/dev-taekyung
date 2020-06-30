<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_field_gubun = {"01=>�μ�","02=>����"};

String id = u.request("id");
if(id.equals("")){
	//u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}


DataObject fieldDao = new DataObject("tcb_field");
DataSet field = fieldDao.find(" status > 0 and member_no="+_member_no+" and field_seq="+id);
if(!field.next()){
	u.jsError("�μ�/���� ������ �����ϴ�.");
	return;
}

f.addElement("field_gubun", field.getString("field_gubun"), "hname:'����'");
f.addElement("field_name", field.getString("field_name"), "hname:'�μ�/������', required:'Y'");
f.addElement("boss_name", field.getString("boss_name"), "hname:'��ǥ�ڸ�'");
f.addElement("telnum", field.getString("telnum"), "hname:'��ȭ��ȣ'");
f.addElement("post_code", field.getString("post_code"), "hname:'�����ȣ', option:'number'");
f.addElement("address", field.getString("address"), "hname:'�ּ�'");
f.addElement("use_yn", field.getString("use_yn"), "hname:'��뿩��', required:'Y'");


// �Է¼���
if(u.isPost() && f.validate())
{
	fieldDao = new DataObject("tcb_field");

	fieldDao.item("member_no", _member_no);
	fieldDao.item("field_seq", id);
	fieldDao.item("field_name", f.get("field_name"));
	if(f.get("field_gubun").equals("02")){
		fieldDao.item("post_code", f.get("post_code"));
		fieldDao.item("address", f.get("address"));
		fieldDao.item("telnum", f.get("telnum"));
		fieldDao.item("boss_name", f.get("boss_name"));
	}
	fieldDao.item("use_yn", f.get("use_yn"));
	fieldDao.item("field_gubun", f.get("field_gubun"));
	if(!fieldDao.update("member_no='"+_member_no+"' and field_seq="+id)){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �����ͷ� ���� �Ͽ� �ֽʽÿ�.");
		return;
	}

	u.jsAlertReplace("���� �Ǿ����ϴ�.", "./place_modify.jsp?"+u.getQueryString());
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("info.place_modify");
p.setVar("menu_cd","000110");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000110", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setVar("field", field);
p.setLoop("code_field_gubun",u.arr2loop(code_field_gubun));
p.setVar("list_query",u.getQueryString("id"));	// ����Ʈ�� ���ư���
p.setVar("query",u.getQueryString());			// ����
p.setVar("form_script", f.getScript());
p.display(out);
%>