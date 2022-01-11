<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String warr_seq = u.request("warr_seq");
System.out.println(u.request("mode"));
if(member_no.equals("") || warr_seq.equals("")) {
	u.jsError("잘못된 접근입니다.");
	return;
}
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M301");


member_no = u.aseDec(member_no);
DataObject warrDao = new DataObject("tcb_warr_add");
DataSet warr = warrDao.find(" member_no = '"+member_no+"' and warr_seq = '"+warr_seq+"' ");
if(!warr.next()){
	u.jsError("잘못된 정보입니다.");
	return;
}

warr.put("warr_type_nm", u.getItem(warr.getString("warr_type"), code_warr));
warr.put("warr_amt", u.numberFormat(warr.getDouble("warr_amt"),0));
warr.put("warr_date", u.getTimeString("yyyy-MM-dd", warr.getString("warr_date")));
warr.put("warr_sdate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_sdate")));
warr.put("warr_edate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_edate")));
warr.put("file_size", u.getFileSize(warr.getLong("file_size")));

f.addElement("warr_type", warr.getString("warr_type"), "hname:'보증서종류', required:'Y'");
f.addElement("warr_office", warr.getString("warr_office"), "hname:'발급기관', required:'Y'");
f.addElement("warr_no", warr.getString("warr_no"), "hname:'증권번호', required:'Y'");
f.addElement("warr_sdate", warr.getString("warr_sdate"), "hname:'보증기간', required:'Y'");
f.addElement("warr_edate", warr.getString("warr_edate"), "hname:'보증기간', required:'Y'");
f.addElement("warr_amt", warr.getString("warr_amt"), "hname:'보증금액', required:'Y', option:'money'");
f.addElement("warr_date", warr.getString("warr_date"), "hname:'발급일', required:'Y'");

if(u.isPost()&&f.validate()){
	f.uploadDir = Startup.conf.getString("file.path.bcompany")+member_no;
	
	warrDao.item("warr_office", f.get("warr_office"));
	warrDao.item("warr_no", f.get("warr_no"));
	warrDao.item("warr_sdate", f.get("warr_sdate").replaceAll("-",""));
	warrDao.item("warr_edate", f.get("warr_edate").replaceAll("-",""));
	warrDao.item("warr_amt", f.get("warr_amt").replaceAll(",",""));
	warrDao.item("warr_date", f.get("warr_date").replaceAll("-",""));
	warrDao.item("etc", f.get("etc"));
	
	File attFile = f.saveFileTime("warr_file");
	if(attFile != null)
	{
		warrDao.item("doc_name", f.getFileName("warr_file"));
		warrDao.item("file_path", member_no);
		warrDao.item("file_name", attFile.getName());
		warrDao.item("file_ext", u.getFileExt(attFile.getName()));
		warrDao.item("file_size", attFile.length());
	}
	warrDao.item("reg_date", u.getTimeString());
	warrDao.item("reg_id", auth.getString("_USER_ID"));

	if(!warrDao.update(" member_no = '"+member_no+"' and warr_seq = '"+warr_seq+"' ")){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	
	out.print("<script>");
	out.print("alert(\"처리 하였습니다.\");");
	out.print("opener.location.reload();");
	out.print("self.close();");
	out.print("</script>");
	return;
}

p.setLayout("popup");
p.setDebug(out);
if(member_no.equals(_member_no))
	p.setBody("info.pop_warr_modify");
else
	p.setBody("info.pop_warr_view");

p.setVar("popup_title","보증서 정보");
p.setLoop("code_warr", u.arr2loop(code_warr));
p.setVar("modify", true);
p.setVar("warr", warr);
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>