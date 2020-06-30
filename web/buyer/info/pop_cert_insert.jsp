<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_cert = codeDao.getCodeArray("M301");

f.addElement("cert_name", null, "hname:'���㰡��', required:'Y'");
f.addElement("cert_no", null, "hname:'���/�㰡��ȣ', required:'Y'");
f.addElement("cert_org", null, "hname:'���ñ��', required:'Y'");
f.addElement("cert_sdate", null, "hname:'��ȿ�Ⱓ', required:'Y'");
f.addElement("cert_edate", null, "hname:'��ȿ�Ⱓ', required:'Y'");
f.addElement("cert_file", null, "hname:'÷������', required:'Y', allow:'jpg|gif|png|pdf'");
f.addElement("etc", null, "hname:'��Ÿ'");

if(u.isPost()&&f.validate()){
	f.uploadDir = Startup.conf.getString("file.path.bcompany")+_member_no;
	
	DataObject certDao = new DataObject("tcb_cert_add");
	
	String cert_seq = certDao.getOne(
			"select nvl(max(cert_seq),0)+1 cert_seq "+
			"  from tcb_cert_add where member_no = '"+_member_no+"'"
		);	
	
	certDao.item("member_no", _member_no);
	certDao.item("cert_seq", cert_seq);
	certDao.item("cert_name", f.get("cert_name"));
	certDao.item("cert_no", f.get("cert_no"));
	certDao.item("cert_org", f.get("cert_org"));
	certDao.item("cert_sdate", f.get("cert_sdate").replaceAll("-",""));
	certDao.item("cert_edate", f.get("cert_edate").replaceAll("-",""));
	
	File attFile = f.saveFileTime("cert_file");
	if(attFile != null)
	{
		certDao.item("doc_name", f.getFileName("cert_file"));
		certDao.item("file_path", _member_no+"/");
		certDao.item("file_name", attFile.getName());
		certDao.item("file_ext", u.getFileExt(attFile.getName()));
		certDao.item("file_size", attFile.length());
	}
	certDao.item("reg_date", u.getTimeString());
	certDao.item("reg_id", auth.getString("_USER_ID"));

	if(!certDao.insert()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. ");
		return;
	}
	
	out.print("<script>");
	out.print("alert(\"�����Ͽ����ϴ�.\");");
	out.print("opener.location.reload();");
	out.print("self.close();");
	out.print("</script>");
	return;
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("info.pop_cert_modify");
p.setVar("popup_title","���㰡 ����");
p.setVar("modify", false);
p.setLoop("code_cert", u.arr2loop(code_cert));
p.setVar("form_script",f.getScript());
p.display(out);
%>