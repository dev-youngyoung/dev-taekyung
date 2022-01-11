<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] code_template_type = {"00=>단일서식","10=>최초계약서식","20=>변경계약서식"};
String[] code_doc_type = {"1=>양자서명","2=>전자문서","3=>신청서"};
String template_cd = u.request("template_cd");
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
template.put("template_type_nm", u.getItem(template.getString("template_type"), code_template_type));
template.put("doc_type_nm", template.getString("doc_type").equals("")?"전자계약":u.getItem(template.getString("doc_type"),code_doc_type));
template.put("writer_type_nm", template.getString("writer_type").equals("Y")?"수신업제작성항목있음":"수신업제작성항목없음");
String first_member_no = "";

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
		first_member_no = member.getString("member_no");
	}
}

if(!template.getString("field_seq").equals("")){
	DataObject fieldDao = new DataObject("tcb_field");
	
	String[] arr_field = template.getString("field_seq").split(",");
	String fields = u.join(",", arr_field);
	
	while(member.next()){
		DataSet field = fieldDao.find(" member_no = '"+member.getString("member_no")+"' and field_seq in ("+fields+") ");
		member.put(".field", field);
	}
}

DataObject templateSubDao = new DataObject("tcb_cont_template_sub");
DataSet templateSub = templateSubDao.find(" template_cd = '"+template_cd+"' ");

DataObject agreeTemplateDao = new DataObject("tcb_agree_template");
DataSet agreeTemplate= agreeTemplateDao.find("template_cd ='"+template_cd+"'", "*", "agree_seq");

//추가 연계 관리 항목
DataObject tfileDao = new DataObject("tcb_cont_template_add");
DataSet tfile = tfileDao.find("template_cd = '"+template_cd+"'");
while(tfile.next()){
	tfile.put("tfile_name_en", tfile.getString("template_name_en"));
	tfile.put("tfile_name_ko", tfile.getString("template_name_ko"));
	tfile.put("mul_yn", tfile.getString("mul_yn"));
	tfile.put("col_name", tfile.getString("col_name"));
}



f.addElement("template_name", template.getString("template_name"), "hname:'서식명',required:'Y'");
f.addElement("display_name", template.getString("display_name"), "hname:'표시명'");
f.addElement("use_yn", template.getString("use_yn"), "hname:'사용여부',required:'Y'");
f.addElement("stamp_yn", template.getString("stamp_yn").equals("")?"N":template.getString("stamp_yn"), "hname:'인지세사용여부'");
f.addElement("warr_yn", template.getString("warr_yn"), "hname:'인지세사용여부'");
f.addElement("need_attach_yn", template.getString("need_attach_yn"), "hname:'구비서류필수여부'");
f.addElement("efile_yn",  "".equals(template.getString("efile_yn"))?"N":template.getString("efile_yn"), "hname:'기타첨부사용여부'");
if(u.isPost()&&f.validate()){
	templateDao = new DataObject("tcb_cont_template");
	templateDao.item("template_name", f.get("template_name"));
	templateDao.item("display_name", f.get("display_name"));
	templateDao.item("use_yn", f.get("use_yn"));
	templateDao.item("stamp_yn", f.get("stamp_yn"));
	templateDao.item("warr_yn", f.get("warr_yn"));
	templateDao.item("need_attach_yn", f.get("need_attach_yn"));
	templateDao.item("efile_yn", f.get("efile_yn"));
	if(!templateDao.update("template_cd = '"+template_cd+"' ")){
		u.jsError("저장처리에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장 처리 하였습니다.", "cont_template_modify.jsp?"+u.getQueryString());
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.cont_template_modify");
p.setVar("menu_cd", "000055");
p.setLoop("member", member);
p.setVar("first_member_no", first_member_no);
p.setVar("template", template);
p.setLoop("templateSub", templateSub);
p.setLoop("agreeTemplate", agreeTemplate);
p.setLoop("tfile", tfile);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("template_cd"));
p.setVar("form_script",f.getScript());
p.display(out);
%>