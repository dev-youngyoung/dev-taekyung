<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String person_seq = u.request("person_seq");
CodeDao code = new CodeDao("tcb_comcode");
String[] code_user_gubun = code.getCodeArray("M005");
String[] code_user_level = code_user_level = code.getCodeArray("M013"," and code in ('10','30') and code >= '"+auth.getString("_USER_LEVEL")+"' ");

DataObject personDao = new DataObject("tcb_person");
//pdao.setDebug(out);
DataSet person = personDao.find(" member_no = '"+_member_no+"' and person_seq = '"+person_seq+"' and status > 0 ");
if(!person.next()){
	u.jsError("����� ������ �����ϴ�.");
	return;
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
f.addElement("user_level", person.getString("user_level"), "hname:'���������', required:'Y'");
f.addElement("use_yn", person.getString("use_yn"), "hname:'��뿩��', required:'Y'");
f.addElement("division", person.getString("division"), "hname:'�μ�', required:'Y'");

if(u.isPost()&&f.validate()){
	personDao = new DataObject("tcb_person");
	if(!f.get("passwd").equals("")){
		personDao.item("passwd", u.sha256(f.get("passwd")));
		personDao.item("passdate", u.getTimeString());  // ��й�ȣ ����ð� ���
	}
	personDao.item("user_name",f.get("user_name"));
	personDao.item("position",f.get("position"));
	personDao.item("division",f.get("division"));
	personDao.item("tel_num",f.get("tel_num"));
	personDao.item("fax_num",f.get("fax_num"));
	personDao.item("hp1",f.get("hp1"));
	personDao.item("hp2",f.get("hp2"));
	personDao.item("hp3",f.get("hp3"));
	personDao.item("email",f.get("email"));
	personDao.item("user_level", f.get("user_level"));
	personDao.item("default_yn", f.get("user_level").equals("10")?"Y":"N");
	personDao.item("use_yn", f.get("use_yn"));
	personDao.item("reg_date", u.getTimeString());
	personDao.item("reg_id", f.get("user_id"));

	DB db = new DB();
	if(auth.getString("_DEFAULT_YN").equals("Y")){
		if(f.get("user_level").equals("10")){
			db.setCommand("update tcb_person set default_yn = 'N', user_level = '30'  where member_no ='"+_member_no+"' and user_id = '"+auth.getString("_USER_ID")+"'", null);
		}
	}
	db.setCommand(personDao.getUpdateQuery("member_no = '"+_member_no+"' and person_seq = '"+person_seq+"'"), personDao.record);
	if(!db.executeArray()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �����ͷ� ���� �Ͽ� �ֽʽÿ�.");
		return;
	}

	// �α����� ����� ���� �����
	if(!f.get("user_level").equals("")&&person_seq.equals(auth.getString("_PERSON_SEQ"))&&!f.get("user_level").equals(auth.getString("_USER_LEVEL"))){
		auth.delAuthInfo();
		u.jsAlertReplace("���� �Ͽ����ϴ�.\\n\\n���Ѻ������� �α׾ƿ� �˴ϴ�.\\n\\n�α��� �� ����ϼ���.", "/web/buyer/main/index.jsp");
		return;
	}

	// �ٸ� ������� ������ ���� ���ӽ�
	if((!person_seq.equals(auth.getString("_PERSON_SEQ")))&&f.get("user_level").equals("10")){
		auth.delAuthInfo();
		u.jsAlertReplace("���� �Ͽ����ϴ�.\\n\\n���Ѻ������� �α׾ƿ� �˴ϴ�.\\n\\n�α��� �� ����ϼ���.", "/web/buyer/main/index.jsp");
		return;
	}

	u.jsAlertReplace("���� �Ͽ����ϴ�.", "./client_person_modify.jsp?"+u.getQueryString());
	return;
}
p.setLayout("default");
//p.setDebug(out);
p.setBody("info.client_person_modify");
p.setVar("menu_cd","000120");
p.setVar("modify", true);
p.setVar("person", person);
p.setVar("default_yn", auth.getString("_DEFAULT_YN").equals("Y"));
p.setVar("btn_del", !person_seq.equals(auth.getString("_PERSON_SEQ")));//�ڽ��� ���� ���ϵ��� ���� ��ư ����
p.setLoop("code_user_level", u.arr2loop(code_user_level));
p.setLoop("code_user_gubun", u.arr2loop(code_user_gubun));
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("person_seq"));
p.display(out);
%>