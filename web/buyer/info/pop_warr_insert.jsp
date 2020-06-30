<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M301");

f.addElement("warr_office", null, "hname:'�߱ޱ��', required:'Y'");
f.addElement("warr_no", null, "hname:'���ǹ�ȣ', required:'Y'");
f.addElement("warr_amt", null, "hname:'�����ݾ�', required:'Y', option:'money'");
f.addElement("warr_sdate", null, "hname:'�����Ⱓ', required:'Y'");
f.addElement("warr_edate", null, "hname:'�����Ⱓ', required:'Y'");
f.addElement("warr_date", null, "hname:'�߱���', required:'Y'");
f.addElement("warr_file", null, "hname:'÷������', required:'Y', allow:'jpg|gif|png|pdf'");
f.addElement("etc", null, "hname:'��Ÿ'");

if(u.isPost()&&f.validate()){
	f.uploadDir = Startup.conf.getString("file.path.bcompany")+_member_no;
	
	DataObject warrDao = new DataObject("tcb_warr_add");
	
	String warr_seq = warrDao.getOne(
			"select nvl(max(warr_seq),0)+1 war_seq "+
			"  from tcb_warr_add where member_no = '"+_member_no+"'"
		);	
	
	warrDao.item("member_no", _member_no);
	warrDao.item("warr_seq", warr_seq);
	warrDao.item("warr_type", f.get("warr_type"));
	warrDao.item("warr_office", f.get("warr_office"));
	warrDao.item("warr_no", f.get("warr_no"));
	warrDao.item("warr_amt", f.get("warr_amt").replaceAll(",",""));
	warrDao.item("warr_sdate", f.get("warr_sdate").replaceAll("-",""));
	warrDao.item("warr_edate", f.get("warr_edate").replaceAll("-",""));
	warrDao.item("warr_date", f.get("warr_date").replaceAll("-",""));
	warrDao.item("etc", f.get("etc"));
	
	File attFile = f.saveFileTime("warr_file");
	if(attFile != null)
	{
		warrDao.item("doc_name", f.getFileName("warr_file"));
		warrDao.item("file_path", _member_no+"/");
		warrDao.item("file_name", attFile.getName());
		warrDao.item("file_ext", u.getFileExt(attFile.getName()));
		warrDao.item("file_size", attFile.length());
	}
	warrDao.item("reg_date", u.getTimeString());
	warrDao.item("reg_id", auth.getString("_USER_ID"));

	if(!warrDao.insert()){
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
p.setBody("info.pop_warr_modify");
p.setVar("popup_title","������ ����");
p.setVar("modify", false);
p.setLoop("code_warr", u.arr2loop(code_warr));
p.setVar("form_script",f.getScript());
p.display(out);
%>