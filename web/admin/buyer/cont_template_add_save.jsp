<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String template_cd = u.request("template_cd");
if(template_cd.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject templateDao = new DataObject("tcb_cont_template");
//templateDao.setDebug(out);
DataSet template = templateDao.find("template_cd = '"+template_cd+"'  " );
if(!template.next()){
	u.jsError("��༭�� ������ �����ϴ�.");
	return;
}

if(u.isPost()&&f.validate()){
	
	DB db = new DB();
	
	DataObject tfileDao = null;
	
	db.setCommand("delete from tcb_cont_template_add where template_cd = '"+template_cd+"'", null);
	
	String[] tfile_name_en = f.getArr("tfile_name_en");
	String[] tfile_name_ko = f.getArr("tfile_name_ko");
	String[] mul_yn = f.getArr("mul_yn");
	String[] col_name = f.getArr("col_name");
	int tfile_cnt = tfile_name_en == null ? 0 : tfile_name_en.length;
	
	for(int i = 0 ; i < tfile_cnt ; i++){
		tfileDao = new DataObject("tcb_cont_template_add");
		tfileDao.item("template_cd", template_cd);
		tfileDao.item("seq", i+1);
		tfileDao.item("template_name_en", tfile_name_en[i]);
		tfileDao.item("template_name_ko", tfile_name_ko[i]);
		tfileDao.item("mul_yn", mul_yn[i]);
		tfileDao.item("col_name", col_name[i]);
		db.setCommand(tfileDao.getInsertQuery(), tfileDao.record);
	}
	
	if(!db.executeArray()){
		u.jsError("ó���� ���� �Ͽ����ϴ�.");
		return;
	}
	
	u.jsAlertReplace("ó�� �Ϸ� �Ͽ����ϴ�.", "cont_template_modify.jsp?"+u.getQueryString());
	return;
}

u.jsError("�������� ��η� �����ϼ���.");
return;
%>