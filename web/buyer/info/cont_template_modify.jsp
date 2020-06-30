<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_allow_ext = {"pdf=>PDF","jpg,jpeg,pdf,png,gif=>이미지파일","xls,xlsx=>엑셀","doc,docx=>워드","hwp=>한글"};

String template_cd = u.request("template_cd");
String version_seq = u.request("version_seq");
if(template_cd.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

f.uploadDir=Startup.conf.getString("file.path.bcont_template")+template_cd+"/"+_member_no;
f.maxPostSize= 10*1024;


DataObject templateDao = new DataObject("tcb_cont_template");
//templateDao.setDebug(out);
DataSet template = templateDao.find(" member_no like '%"+_member_no+"%' and status > '0' and template_cd = '"+template_cd+"'  " );
if(!template.next()){
}
template.put("gubun", template.getString("org_template_cd").equals("")?"최초계약":"변경계약");
if(!template.getString("version_seq").equals("")){
	template.put("template_name", template.getString("template_name")+"_"+template.getString("version_name"));
}

//이력관리 서식의 경우
boolean is_hist_version = false;
DataObject templateHistDao = new DataObject("tcb_cont_template_hist");
DataSet templateHist = new DataSet();
DataSet templateHistTemp = templateHistDao.find("template_cd = '"+template_cd+"'" ,"*","version_seq desc");
if(templateHistTemp.size()>0){
	templateHist.addRow();
	templateHist.put("version_seq",template.getString("version_seq"));
	templateHist.put("version_name",template.getString("version_name"));
	while(templateHistTemp.next()){
		templateHist.addRow();
		templateHist.put("version_seq",templateHistTemp.getString("version_seq"));
		templateHist.put("version_name",templateHistTemp.getString("version_name"));
		if(version_seq.equals(templateHistTemp.getString("version_seq"))){
			is_hist_version = true;
			template.put("version_seq", templateHistTemp.getString("version_seq"));
			template.put("version_name", templateHistTemp.getString("version_name"));
			template.put("template_name", templateHistTemp.getString("template_name")+"_"+templateHistTemp.getString("version_name"));
			template.put("template_html", templateHistTemp.getString("template_html"));
		}
	}
}

DataObject templateSubDao = new DataObject("tcb_cont_template_sub");
DataSet templateSub = null;
if(is_hist_version){
	DataObject templateSubHistDao = new DataObject("tcb_cont_template_sub_hist");
	templateSub = templateSubHistDao.find(" template_cd = '"+template_cd+"' and version_seq = '"+version_seq+"'");
}else{
	templateSub = templateSubDao.find(" template_cd = '"+template_cd+"' ");	
}

while(templateSub.next()){
	if(templateSub.getString("option_yn").equals("A")) // 자동 생성해야 하는 양식
		templateSub.put("option_yn", false);
}

DataObject cfileDao = new DataObject("tcb_att_cfile");
DataSet cfile = cfileDao.find(" template_cd = '"+template_cd+"' and member_no = '"+_member_no+"'");
while(cfile.next()){
	cfile.put("str_file_size", u.getFileSize(cfile.getLong("file_size")));
}

DataObject rfileDao = new DataObject("tcb_rfile_template");
DataSet rfile = rfileDao.find(" template_cd = '"+ template_cd+"' and member_no = '"+ _member_no +"' and reg_type = '10' ");
while(rfile.next()){
	rfile.put("checked", rfile.getString("attch_yn").equals("Y")?"checked":"");
	DataSet code_allow = u.arr2loop(code_allow_ext);
	while(code_allow.next()){
		code_allow.put("selected", code_allow.getString("id").equals(rfile.getString("allow_ext"))?"selected":"");
	}
	rfile.put(".code_allow", code_allow);
}


DataObject efileDao = new DataObject("tcb_efile_template");
DataSet efile = efileDao.find(" template_cd = '"+ template_cd+"' and member_no = '"+ _member_no +"'");
while(efile.next()){
	efile.put("checked", efile.getString("reg_type").equals("10")?"checked":"");
}



f.addElement("use_yn", template.getString("use_yn"), " hname:'양식 사용여부'");
f.addElement("efile_yn", template.getString("efile_yn").equals("Y")?"Y":"N", "hname:'내부관리서류 사용여부'");
f.addElement("tfile_yn", template.getString("tfile_yn").equals("Y")?"Y":"N", "hname:'추가저장 항목관리 사용여부'");
f.addElement("stamp_yn", template.getString("stamp_yn").equals("Y")?"Y":"N", "hname:'인지세 관리 사용여부'");
if(!template.getString("version_seq").equals("")){
	f.addElement("version_seq", version_seq, "hname:'서식버전'");
}

DataObject tfileDao = new DataObject("tcb_cont_template_add");
DataSet tfile = tfileDao.find("template_cd = '"+template_cd+"'");
while(tfile.next()){
	tfile.put("tfile_name_en", tfile.getString("template_name_en"));
	tfile.put("tfile_name_ko", tfile.getString("template_name_ko"));
	tfile.put("mul_yn", tfile.getString("mul_yn"));
	tfile.put("col_name", tfile.getString("col_name"));
}

/**
if(template_cd.equals("2015022")){
f.addElement("tfile_yn", "Y", "hname:'추가저장 항목관리 사용여부'");
}else{
f.addElement("tfile_yn", "N", "hname:'추가저장 항목관리 사용여부'");
}
**/

if(u.isPost()&&f.validate()){

	DB db = new DB();

	templateDao = new DataObject("tcb_cont_template");
	templateDao.item("use_yn", f.get("use_yn"));
	templateDao.item("efile_yn", f.get("efile_yn"));
	//templateDao.item("tfile_yn", f.get("tfile_yn"));
	templateDao.item("stamp_yn", f.get("stamp_yn"));
	db.setCommand(templateDao.getUpdateQuery(" template_cd = '"+template_cd+"' and member_no like '%"+_member_no+"%' "), templateDao.record);


	db.setCommand("delete from tcb_att_cfile where template_cd = '"+template_cd+"' and member_no = '"+_member_no+"' ",null);
	String file_path = template_cd+"/"+_member_no+"/";
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
					cfileDao.item("member_no", _member_no);
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
			cfileDao.item("member_no", _member_no);
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


	db.setCommand("delete from tcb_rfile_template where template_cd = '"+template_cd+"' and member_no = '"+_member_no+"' and reg_type = '10'", null);

	int base_seq = rfileDao.getOneInt("select nvl(max(rfile_seq),0)+1 rfile_seq from tcb_rfile_template where template_cd = '"+template_cd+"' and member_no = '"+_member_no+"' and reg_type <> '10'");

	String[] attch_yn = f.getArr("attch_yn");
	String[] rfile_seq = f.getArr("rfile_seq");
	String[] rfile_doc_name = f.getArr("rfile_doc_name");
	String[] sample_file_name = f.getArr("sample_file_name");
	String[] allow_ext = f.getArr("allow_ext");
	String[] add_type = f.getArr("add_type");
	int doc_cnt = rfile_doc_name==null?0:rfile_doc_name.length;
	for(int i = 0 ; i < doc_cnt; i ++){
		rfileDao = new DataObject("tcb_rfile_template");

		System.out.println("add_type =>" + add_type[i]);
		if(!add_type[i].equals("new")){
		    rfile.first();
		    while(rfile.next()) {
				if(rfile_seq[i].equals(rfile.getString("rfile_seq"))){
					rfileDao.item("template_cd",template_cd);
					rfileDao.item("member_no", _member_no);
					rfileDao.item("rfile_seq", base_seq+i);
					rfileDao.item("doc_name", rfile_doc_name[i]);
					rfileDao.item("attch_yn", attch_yn[i].equals("Y")?"Y":"N");
					rfileDao.item("reg_type", "10");
					rfileDao.item("allow_ext", allow_ext[i]);
					File addFile = f.saveFileTime("rfile_"+rfile_seq[i]);
					if(addFile == null){
						rfileDao.item("sample_file_path", file_path);
						rfileDao.item("sample_file_name", sample_file_name[i]);
					}else{
						rfileDao.item("sample_file_path", file_path);
						rfileDao.item("sample_file_name", addFile.getName());
					}
					db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);
				}
			}
		} else {
			rfileDao.item("template_cd",template_cd);
			rfileDao.item("member_no", _member_no);
			rfileDao.item("rfile_seq", base_seq+i);
			rfileDao.item("doc_name", rfile_doc_name[i]);
			rfileDao.item("attch_yn", attch_yn[i].equals("Y")?"Y":"N");
			rfileDao.item("reg_type", "10");
			rfileDao.item("allow_ext", allow_ext[i]);
			File addFile = f.saveFileTime("rfile_"+rfile_seq[i]);
			if(addFile != null){
				rfileDao.item("sample_file_path", file_path);
				rfileDao.item("sample_file_name", addFile.getName());
			}
			db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);
		}

	}
	
	
	db.setCommand("delete from tcb_efile_template where template_cd = '"+template_cd+"' and member_no = '"+_member_no+"' ", null);
	if(f.get("efile_yn").equals("Y")){
		String[] efile_attach_yn = f.getArr("efile_attach_yn");
		String[] efile_doc_name = f.getArr("efile_doc_name");
		int efile_cnt = efile_doc_name==null?0:efile_doc_name.length;
		for(int i = 0 ; i < efile_cnt; i ++){
			efileDao = new DataObject("tcb_efile_template");
			efileDao.item("template_cd",template_cd);
			efileDao.item("member_no", _member_no);
			efileDao.item("efile_seq", i);
			efileDao.item("reg_type", efile_attach_yn[i].equals("Y")?"10":"20");
			efileDao.item("doc_name", efile_doc_name[i]);
			db.setCommand(efileDao.getInsertQuery(), efileDao.record);
		}
	}
	
	
	db.setCommand("delete from tcb_cont_template_add where template_cd = '"+template_cd+"'", null);
	if(f.getArr("tfile_name_en") != null && f.getArr("tfile_name_en").length >0){
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
	}

	if(!db.executeArray()){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장 하였습니다.", "cont_template_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.cont_template_modify");
p.setVar("menu_cd","000115");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000115", "btn_auth").equals("10"));
p.setVar("template", template);
p.setLoop("templateSub", templateSub);
p.setLoop("templateHist", templateHist);
p.setLoop("cfile", cfile);
p.setLoop("rfile", rfile);
p.setLoop("efile", efile);
p.setLoop("tfile", tfile);
p.setLoop("code_allow_ext", u.arr2loop(code_allow_ext));
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("template_cd"));
p.setVar("form_script",f.getScript());
p.display(out);
%>
