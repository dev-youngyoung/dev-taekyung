<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String template_cd = u.request("template_cd");
String member_no = u.request("member_no");
if(template_cd.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject templateDao = new DataObject("tcb_cont_template");
//templateDao.setDebug(out);
DataSet template = templateDao.find("template_cd = '"+template_cd+"'  " );
if(!template.next()){
	u.jsError("계약서식 정보가 없습니다.");
	return;
}

String first_member_no= "";
DataSet member = new DataSet();
if(!template.getString("member_no").equals("")){
	DataObject memberDao = new DataObject("tcb_member");
	String[] arr_member_no = template.getString("member_no").split(",");
	String member_nos = "";
	for(int i = 0 ; i < arr_member_no.length; i++){
		if(!member_nos.equals("")) member_nos+=",";
		member_nos+= "'"+arr_member_no[i]+"'" ;
	}
	member = memberDao.find("member_no in ("+member_nos+") ","member_no, member_name","member_no asc");
	if(member.next()){
		if(member_no.equals("")){
			member_no = member.getString("member_no");
		}
	}
}



DataObject efileDao = new DataObject("tcb_efile_template");
DataSet efile = efileDao.find(" template_cd = '"+ template_cd+"' and member_no = '"+ member_no +"'");
while(efile.next()){
	efile.put("checked", efile.getString("reg_type").equals("10")?"checked":"");
}

f.uploadDir=Startup.conf.getString("file.path.bcont_template")+template_cd+"/"+member_no;
f.maxPostSize= 10*1024;

f.addElement("member_no", member_no, "hname:'대상업체', required:'Y'");
if(u.isPost()&&f.validate()){
	
	DB db = new DB();
	
	db.setCommand("delete from tcb_efile_template where template_cd = '"+template_cd+"' and member_no = '"+member_no+"' ", null);
	String[] efile_attach_yn = f.getArr("efile_attach_yn");
	String[] efile_doc_name = f.getArr("efile_doc_name");
	int efile_cnt = efile_doc_name==null?0:efile_doc_name.length;
	for(int i = 0 ; i < efile_cnt; i ++){
		efileDao = new DataObject("tcb_efile_template");
		efileDao.item("template_cd",template_cd);
		efileDao.item("member_no", member_no);
		efileDao.item("efile_seq", i);
		efileDao.item("reg_type", efile_attach_yn[i].equals("Y")?"10":"20");
		efileDao.item("doc_name", efile_doc_name[i]);
		db.setCommand(efileDao.getInsertQuery(), efileDao.record);
	}

	
	if(!db.executeArray()){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	
	u.jsAlertReplace("저장하였습니다.", "cont_template_efile.jsp?"+u.getQueryString());
	return;
}



p.setLayout("blank");
//p.setDebug(out);
p.setBody("buyer.cont_template_efile");
p.setLoop("member", member);
p.setVar("first_member_no", first_member_no);
p.setVar("template", template);
p.setLoop("efile", efile);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.setVar("form_script",f.getScript());
p.display(out);
%>