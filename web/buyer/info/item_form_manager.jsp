<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_item_form = {"01=>DEPTH2[�з�->��Ī]","02=>DEPTH3[��з�->�ߺз�->��Ī]","03=>DEPTH4[��з�->�ߺз�->�Һз�->��Ī]"};

boolean bInsert = true;
String item_form_cd_10 = "";	// ����������ı⺻��_��ǰ
String item_form_cd_20 = "";	// ����������ı⺻��_����
String item_form_cd_30 = "";	// ����������ı⺻��_�뿪
String build_item_yn = "";		// ���� �и� ����

DataObject itemformDao = new DataObject("tcb_bid_item_form_default");
DataSet itemform = itemformDao.find(" member_no = '"+_member_no+"' ");

if(itemform.next()){
	item_form_cd_10 = itemform.getString("item_form_cd_10");
	item_form_cd_20 = itemform.getString("item_form_cd_20");
	item_form_cd_30 = itemform.getString("item_form_cd_30");
	build_item_yn = itemform.getString("build_item_yn");
	bInsert = false;
}

f.addElement("item_form_cd_10", item_form_cd_10, "hname:'����������ı⺻��_��ǰ'");
f.addElement("item_form_cd_20", item_form_cd_20, "hname:'����������ı⺻��_����'");
f.addElement("item_form_cd_30", item_form_cd_30, "hname:'����������ı⺻��_�뿪'");
f.addElement("build_item_yn", build_item_yn, "hname:'����и�����'" );

if(u.isPost()&& f.validate()){
	itemformDao.item("item_form_cd_10", f.get("item_form_cd_10"));
	itemformDao.item("item_form_cd_20", f.get("item_form_cd_20"));
	itemformDao.item("item_form_cd_30", f.get("item_form_cd_30"));
	itemformDao.item("build_item_yn", f.get("build_item_yn"));

	if(bInsert)
	{
		itemformDao.item("member_no", _member_no);
		if(!itemformDao.insert()){
			u.jsError("���忡 �����Ͽ����ϴ�.");
			return;
		}
	} else {
		if(!itemformDao.update("member_no = '"+_member_no+"' ")){
			u.jsError("���忡 �����Ͽ����ϴ�.");
			return;
		}
	}
	u.jsAlertReplace("���� �Ͽ����ϴ�.", "./item_form_manager.jsp");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.item_form_manager");
p.setVar("menu_cd","000114");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000114", "btn_auth").equals("10"));
p.setLoop("code_item_form", u.arr2loop(code_item_form));
p.setVar("form_script", f.getScript());
p.display(out);
%>