<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_allow_ext = {"pdf=>PDF","jpg,jpeg,pdf,png,gif=>이미지파일","xls,xlsx=>엑셀","doc,docx=>워드","hwp=>한글"};
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



DataObject rfileDao = new DataObject("tcb_rfile_template");
DataSet rfile = rfileDao.find(" template_cd = '"+ template_cd+"' and member_no = '"+ member_no +"' and reg_type = '10' ");
while(rfile.next()){
	rfile.put("checked", rfile.getString("attch_yn").equals("Y")?"checked":"");
	DataSet code_allow = u.arr2loop(code_allow_ext);
	while(code_allow.next()){
		code_allow.put("selected", code_allow.getString("id").equals(rfile.getString("allow_ext"))?"selected":"");
	}
	rfile.put(".code_allow", code_allow);
}
f.uploadDir=Startup.conf.getString("file.path.bcont_template")+template_cd+"/"+member_no;
f.maxPostSize= 10*1024;

f.addElement("member_no", member_no, "hname:'대상업체', required:'Y'");
if(u.isPost()&&f.validate()){
	
	DB db = new DB();
	
	db.setCommand("delete from tcb_rfile_template where template_cd = '"+template_cd+"' and member_no = '"+member_no+"' and reg_type = '10'", null);

	int base_seq = rfileDao.getOneInt("select nvl(max(rfile_seq),0)+1 rfile_seq from tcb_rfile_template where template_cd = '"+template_cd+"' and member_no = '"+member_no+"' and reg_type <> '10'");
	
	String[] attch_yn = f.getArr("attch_yn");
	String[] rfile_doc_name = f.getArr("rfile_doc_name");
	String[] allow_ext = f.getArr("allow_ext");
	int doc_cnt = rfile_doc_name==null?0:rfile_doc_name.length;
	for(int i = 0 ; i < doc_cnt; i ++){
		rfileDao = new DataObject("tcb_rfile_template");
		rfileDao.item("template_cd",template_cd);
		rfileDao.item("member_no", member_no);
		rfileDao.item("rfile_seq", base_seq+i);
		rfileDao.item("doc_name", rfile_doc_name[i]);
		rfileDao.item("attch_yn", attch_yn[i].equals("Y")?"Y":"N");
		rfileDao.item("reg_type", "10");
		rfileDao.item("allow_ext", allow_ext[i]);
		db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);
	}
	
	if(!db.executeArray()){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	
	u.jsAlertReplace("저장하였습니다.", "cont_template_rfile.jsp?"+u.getQueryString());
	return;
}



p.setLayout("blank");
//p.setDebug(out);
p.setBody("buyer.cont_template_rfile");
p.setLoop("member", member);
p.setVar("first_member_no", first_member_no);
p.setVar("template", template);
p.setLoop("rfile", rfile);
p.setLoop("code_allow_ext", u.arr2loop(code_allow_ext));
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.setVar("form_script",f.getScript());
p.display(out);
%>