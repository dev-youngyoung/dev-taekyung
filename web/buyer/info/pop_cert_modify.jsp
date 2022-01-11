<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String cert_seq = u.request("cert_seq");
System.out.println(u.request("mode"));
if(member_no.equals("") || cert_seq.equals("")) {
	u.jsError("잘못된 접근입니다.");
	return;
}
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_cert = codeDao.getCodeArray("M301");


member_no = u.aseDec(member_no);
DataObject certDao = new DataObject("tcb_cert_add");
DataSet cert = certDao.find(" member_no = '"+member_no+"' and cert_seq = '"+cert_seq+"' ");
if(!cert.next()){
	u.jsError("잘못된 정보입니다.");
	return;
}

cert.put("cert_sdate", u.getTimeString("yyyy-MM-dd", cert.getString("cert_sdate")));
cert.put("cert_edate", u.getTimeString("yyyy-MM-dd", cert.getString("cert_edate")));
cert.put("file_size", u.getFileSize(cert.getLong("file_size")));

f.addElement("cert_name", cert.getString("cert_name"), "hname:'인허가명', required:'Y'");
f.addElement("cert_no", cert.getString("cert_no"), "hname:'등록/허가번호', required:'Y'");
f.addElement("cert_org", cert.getString("cert_org"), "hname:'관련기관', required:'Y'");
f.addElement("cert_sdate", cert.getString("cert_sdate"), "hname:'유효기간'");
f.addElement("cert_edate", cert.getString("cert_edate"), "hname:'유효기간'");

if(u.isPost()&&f.validate()){
	f.uploadDir = Startup.conf.getString("file.path.bcompany")+member_no;
	
	certDao.item("cert_name", f.get("cert_name"));
	certDao.item("cert_no", f.get("cert_no"));
	certDao.item("cert_org", f.get("cert_org"));
	certDao.item("cert_sdate", f.get("cert_sdate").replaceAll("-",""));
	certDao.item("cert_edate", f.get("cert_edate").replaceAll("-",""));
	
	File attFile = f.saveFileTime("cert_file");
	if(attFile != null)
	{
		certDao.item("doc_name", f.getFileName("cert_file"));
		certDao.item("file_path", member_no);
		certDao.item("file_name", attFile.getName());
		certDao.item("file_ext", u.getFileExt(attFile.getName()));
		certDao.item("file_size", attFile.length());
	}
	certDao.item("reg_date", u.getTimeString());
	certDao.item("reg_id", auth.getString("_USER_ID"));

	if(!certDao.update(" member_no = '"+member_no+"' and cert_seq = '"+cert_seq+"' ")){
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
	p.setBody("info.pop_cert_modify");
else
	p.setBody("info.pop_cert_view");

p.setVar("popup_title","인허가 정보");
p.setLoop("code_cert", u.arr2loop(code_cert));
p.setVar("modify", true);
p.setVar("cert", cert);
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>