<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String batch_seq = u.request("batch_seq"); 
String member_no = u.request("member_no");

DataObject batchTemplateDao = new DataObject("tcb_batch_url");
DataSet batchTemplate = batchTemplateDao.find(" member_no = '"+member_no+"' and batch_seq = "+batch_seq);

if(batchTemplate.next()){
	
}
if(u.isPost()&&f.validate()){
	
	DB db = new DB();
	
	batchTemplateDao.item("batch_seq", batch_seq);
	//batchTemplateDao.item("member_no", f.get("member_no"));
	//batchTemplateDao.item("template_cd", f.get("template_cd"));
	batchTemplateDao.item("batch_url", f.get("batch_url"));
	batchTemplateDao.item("etc", f.get("etc"));
	batchTemplateDao.item("mod_date", u.getTimeString());
	batchTemplateDao.item("status", "10");
	db.setCommand(batchTemplateDao.getUpdateQuery("member_no = '"+member_no+"' and batch_seq = "+batch_seq), batchTemplateDao.record);

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
p.setVar("batch",batchTemplate);
p.setVar("modify",true);
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>