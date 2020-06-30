<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String member_no = u.request("member_no");
String sign_member_no = u.request("sign_member_no");
if(cont_no.equals("")||cont_chasu.equals("")||member_no.equals("")){
	u.jsErrClose("�������� ��η� ������ �ּ���.");
	return;
}

String fileDir = "";

DataObject contDao = new DataObject("tcb_contmaster tm inner join tcb_cust tc on tm.cont_no=tc.cont_no and tm.cont_chasu=tc.cont_chasu");
//contDao.setDebug(out);
DataSet cont = contDao.find("tc.member_no='"+ member_no +"' and tm.cont_no = '"+cont_no+"' and tm.cont_chasu = '"+cont_chasu+"' ", "tm.stamp_type, tc.member_name, tc.vendcd, tm.member_no, tm.status, tm.cont_total");
if(!cont.next()){
	u.jsError("��������� �������� �ʽ��ϴ�.");
	return;
} else {
	cont.put("cont_total", u.numberFormat(cont.getDouble("cont_total"),0));
	cont.put("vendcd", u.getBizNo(cont.getString("vendcd")));
}

DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ", "file_path");
if(!cfile.next()){
	u.jsError("��༭�� ������ġ�� �����ϴ�.");
	return;
}else{
	fileDir = cfile.getString("file_path");
}

DataObject stampDao = new DataObject("tcb_stamp");
DataSet stamp = stampDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+member_no+"' ");
if(!stamp.next()){
	u.jsError("���������� ���� ���� �ʽ��ϴ�.");
	return;
}

stamp.put("issue_date", u.getTimeString("yyyy-MM-dd", stamp.getString("issue_date")));
stamp.put("file_size", u.getFileSize(stamp.getLong("file_size")));

f.addElement("cert_no", stamp.getString("cert_no"), "hname:'����(����)��ȣ', minbyte:'15', maxbyte:'20', required:'Y'");
f.addElement("channel", stamp.getString("channel"), "hname:'�߱�ó', required:'Y'");
f.addElement("issue_date", stamp.getString("issue_date"), "hname:'�߱���', required:'Y'");

// ���ݾ׿� ���� �������� �ڵ����
String stamp_money = stamp.getString("stamp_money");
if(stamp_money.equals("")&&cont.getInt("cont_chasu")==0)// ó�� �Է��� ���/ ���ʰ�ุ �ڵ� ��� NH���� ���� �������� ������� �ڵ������� ȥ���� �ټ� �ִٰ���.20170629
{
	double dCont_total = Double.parseDouble(cont.getString("cont_total").replaceAll(",",""));
	long dStamp_money = 0L;		
	
	//System.out.println("dCont_total : "+dCont_total);
	
	if(dCont_total <= 10000000) // 1000���� ����
		dStamp_money = 0;
	else if(dCont_total > 10000000 && dCont_total <= 30000000) // 1000���� ����
		dStamp_money = 20000;
	else if(dCont_total > 30000000 && dCont_total <= 50000000) // 5000���� ����
		dStamp_money = 40000;
	else if(dCont_total > 50000000 && dCont_total <= 100000000) // 1�� ����
		dStamp_money = 70000;
	else if(dCont_total > 100000000 && dCont_total <= 1000000000) // 10�� ����
		dStamp_money = 150000;
	else if(dCont_total > 1000000000) // 10�� �ʰ�
		dStamp_money = 350000;

	if(cont.getString("stamp_type").equals("3"))
		dStamp_money = dStamp_money / 2;
	
	stamp_money =  Util.numberFormat(dStamp_money,0);
} else {
	stamp.put("stamp_money", Util.numberFormat(stamp.getString("stamp_money")));
}
f.addElement("stamp_money", stamp_money, "hname:'������ ��������', required:'Y', option:'money'");

if(stamp.getString("file_name").equals("")){
	f.addElement("stamp_file", null, "hname:'÷������', required:'Y', allow:'jpg|gif|png|pdf'");
}

if(u.isPost()&&f.validate()){
	f.uploadDir = Startup.conf.getString("file.path.bcont_pdf")+fileDir;
	stampDao.item("cert_no", f.get("cert_no"));
	stampDao.item("stamp_money", f.get("stamp_money").replaceAll(",",""));
	stampDao.item("channel", f.get("channel"));
	stampDao.item("issue_date", f.get("issue_date").replaceAll("-",""));
	
	File attFile = f.saveFileTime("stamp_file");
	if(attFile != null)
	{
		stampDao.item("file_title", f.getFileName("stamp_file"));
		stampDao.item("file_path", fileDir);
		stampDao.item("file_name", attFile.getName());
		stampDao.item("file_ext", u.getFileExt(attFile.getName()));
		stampDao.item("file_size", attFile.length());
	}
	
	if(!stampDao.update(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+member_no+"' ")){
		u.jsError("ó���� ���� �Ͽ����ϴ�.");
		return;
	}
	
	out.print("<script>");
	out.print("alert(\"���� �Ͽ����ϴ�.\");");
	out.print("opener.location.reload();");
	out.print("self.close();");
	out.print("</script>");
	return;
}

boolean btn = false;
if(!cont.getString("status").equals("50")){  // ���Ϸ�
	if(member_no.equals(sign_member_no))
		btn = true;
	else
		btn = false;
}


p.setLayout("popup_email_contract");
p.setDebug(out);
if(stamp.getString("cert_no").equals("")){
	p.setBody("sdd.pop_stamp_modify");
}else{
	p.setBody("sdd.pop_stamp_view");
}
p.setVar("popup_title","������ ����");
p.setVar("btn",btn);
//p.setVar("btn_confirm", stamp.getString("status").equals("20")&&gap_yn&&!stamp.getString("stamp_no").equals(""));
p.setVar("stamp", stamp);
p.setVar("cont", cont);
p.setVar("query", u.getQueryString());
//p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>