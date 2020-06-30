<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
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

DataObject cfileDao = new DataObject("tcb_att_cfile");
DataSet cfile = cfileDao.find(" template_cd = '"+template_cd+"' and member_no = '"+member_no+"'");
while(cfile.next()){
	cfile.put("str_file_size", u.getFileSize(cfile.getLong("file_size")));
}

f.uploadDir=Startup.conf.getString("file.path.bcont_template")+template_cd+"/"+member_no;
f.maxPostSize= 10*1024;

f.addElement("member_no", member_no, "hname:'대상업체', required:'Y'");
if(u.isPost()&&f.validate()){
	
	DB db = new DB();
	
	db.setCommand("delete from tcb_att_cfile where template_cd = '"+template_cd+"' and member_no = '"+member_no+"' ",null);
	String file_path = template_cd+"/"+member_no+"/";
	String[] file_seq = f.getArr("file_seq");
	String[] doc_name = f.getArr("doc_name");
	String[] att_type = f.getArr("att_type");
	int cnt = file_seq==null? 0 : file_seq.length;
	int seq = 1;
	for(int i = 0 ;i < cnt; i ++){
		cfileDao = new DataObject("tcb_att_cfile");
		if(!att_type[i].equals("new")){
			cfile.first();
			 while(cfile.next()){
			 	if(file_seq[i].equals(cfile.getString("file_seq"))){
			 		cfileDao.item("template_cd", template_cd);
					cfileDao.item("member_no", member_no);
					cfileDao.item("file_seq", seq++);
					cfileDao.item("doc_name", doc_name[i]);
					File attFile = f.saveFileTime("file_"+file_seq[i]);
					if(attFile == null){
						cfileDao.item("file_path", cfile.getString("file_path"));
				 		cfileDao.item("file_name", cfile.getString("file_name"));
						cfileDao.item("file_ext", cfile.getString("file_ext"));
						cfileDao.item("file_size", cfile.getString("file_size"));
						cfileDao.item("auto_type", "2");
					}else{
						cfileDao.item("file_path", file_path);
						cfileDao.item("file_name", attFile.getName());
						cfileDao.item("file_ext", u.getFileExt(attFile.getName()));
						cfileDao.item("file_size", attFile.length());
						cfileDao.item("auto_type", "1");
					}
					db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
			 	}
			 }
		}else{
			cfileDao.item("template_cd", template_cd);
			cfileDao.item("member_no", member_no);
			cfileDao.item("file_seq", seq++);
			cfileDao.item("doc_name", doc_name[i]);
			File attFile = f.saveFileTime("file_"+file_seq[i]);
			if(attFile == null){
				cfileDao.item("file_path", "");
				cfileDao.item("file_name", "");
				cfileDao.item("file_ext", "");
				cfileDao.item("file_size", 0);
				cfileDao.item("auto_type", "2");
			}else{
				cfileDao.item("file_path", file_path);
				cfileDao.item("file_name", attFile.getName());
				cfileDao.item("file_ext", u.getFileExt(attFile.getName()));
				cfileDao.item("file_size", attFile.length());
				cfileDao.item("auto_type", "1");
			}
			db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
		}
	}
	if(!db.executeArray()){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	
	u.jsAlertReplace("저장하였습니다.", "cont_template_cfile.jsp?"+u.getQueryString());
	return;
}



p.setLayout("blank");
//p.setDebug(out);
p.setBody("buyer.cont_template_cfile");
p.setLoop("member", member);
p.setVar("first_member_no", first_member_no);
p.setVar("template", template);
p.setLoop("cfile", cfile);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.setVar("form_script",f.getScript());
p.display(out);
%>