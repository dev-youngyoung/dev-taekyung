<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String template_cd = u.request("template_cd");
if(template_cd.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

boolean user_template = true;

// �������� ��ȸ
DataObject templateDao = new DataObject("tcb_cont_template_user a");
//templateDao.setDebug(out);
DataSet template= templateDao.find("template_cd ='"+template_cd+"' and member_no = '"+_member_no+"'"," a.*,(select template_name from tcb_cont_template where template_cd = a.template_cd) template_name");
if(!template.next()){
	user_template = false;
	templateDao = new DataObject("tcb_cont_template");
	template = templateDao.find(" status> 0 and template_cd ='"+template_cd+"'");
	if(!template.next()){
		u.jsError("��༭�� ������ �����ϴ�.");
		return;
	}
}


if(u.isPost()&&f.validate()){
	templateDao = new DataObject("tcb_cont_template_user");
	//templateDao.setDebug(out);

	templateDao.item("template_html", new String(Base64Coder.decode(f.get("template_html")),"UTF-8"));
	templateDao.item("reg_id", auth.getString("_USER_ID"));
	templateDao.item("reg_date", u.getTimeString());	
	if(user_template){
		if(!templateDao.update("template_cd='"+template_cd+"' and member_no = '"+_member_no+"' ")){
			//u.jsError("���忡 �����Ͽ����ϴ�.");
			return;
		}	
	}else{
		templateDao.item("template_cd", template_cd);
		templateDao.item("member_no", _member_no);
		if(!templateDao.insert()){
			//u.jsError("���忡 �����Ͽ����ϴ�.");
			return;
		}
	}
	u.jsAlertReplace("�����Ͽ����ϴ�.","contract_select_template.jsp");
	return;	
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_setting_template");
p.setVar("menu_cd","000053");
p.setVar("template", template);
p.setVar("form_script", f.getScript());
p.display(out);
%>