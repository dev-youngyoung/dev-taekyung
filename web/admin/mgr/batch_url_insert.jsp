<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

if(u.isPost()&&f.validate()){
	 
	DB db = new DB();
	
	DataObject batchTemplateDao = new DataObject("tcb_batch_url");

	String batch_seq = batchTemplateDao.getOne(
		"select nvl(max(batch_seq),0)+1 batch_seq "
	 +  "  from tcb_batch_url where member_no = '"+f.get("member_no")+"'"
	);
	
	DataObject templateDao = new DataObject("tcb_cont_template");
	DataSet template = templateDao.find(" template_cd = '"+f.get("template_cd")+"'" );
	if(!template.next()){
		u.jsError("해당코드의 양식이 존재하지 않습니다.");
		return;
	}
	
	batchTemplateDao.item("batch_seq", batch_seq);
	batchTemplateDao.item("member_no", f.get("member_no"));
	batchTemplateDao.item("template_cd", f.get("template_cd"));
	batchTemplateDao.item("template_name", template.getString("template_name"));
	batchTemplateDao.item("batch_url", f.get("batch_url"));
	batchTemplateDao.item("etc", f.get("etc"));
	batchTemplateDao.item("reg_date", u.getTimeString());
	batchTemplateDao.item("status", "10");
	db.setCommand(batchTemplateDao.getInsertQuery(), batchTemplateDao.record);
	

	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("정상적으로 저장 되었습니다.","./batch_url_list.jsp");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("mgr.batch_url_modify");
p.setVar("menu_cd","000073");
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>