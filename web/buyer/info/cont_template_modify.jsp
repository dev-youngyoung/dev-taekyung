<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
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

f.addElement("use_yn", template.getString("use_yn"), " hname:'양식 사용여부'");
f.addElement("efile_yn", template.getString("efile_yn").equals("Y")?"Y":"N", "hname:'내부관리서류 사용여부'");
f.addElement("appr_yn", template.getString("appr_yn").equals("Y")?"Y":"N", "hname:'전자결재 사용여부'");
f.addElement("stamp_yn", template.getString("stamp_yn").equals("Y")?"Y":"N", "hname:'인지세 관리 사용여부'");
f.addElement("auto_yn", template.getString("auto_yn").equals("Y")?"Y":"N", "hname:'계약자동연장 사용여부'");
if(!template.getString("version_seq").equals("")){
	f.addElement("version_seq", version_seq, "hname:'서식버전'");
}

if(u.isPost()&&f.validate()){

	DB db = new DB();

	templateDao = new DataObject("tcb_cont_template");
	templateDao.item("use_yn", f.get("use_yn"));
	templateDao.item("efile_yn", f.get("efile_yn"));
	templateDao.item("appr_yn", f.get("appr_yn"));
	templateDao.item("stamp_yn", f.get("stamp_yn"));
	templateDao.item("auto_yn", f.get("auto_yn"));
	templateDao.item("template_name", f.get("template_name"));
	db.setCommand(templateDao.getUpdateQuery(" template_cd = '"+template_cd+"' and member_no like '%"+_member_no+"%' "), templateDao.record);

	String file_path = template_cd+"/"+_member_no+"/";

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
p.setLoop("rfile", rfile);
p.setLoop("code_allow_ext", u.arr2loop(code_allow_ext));
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("template_cd"));
p.setVar("form_script",f.getScript());
p.display(out);
%>
