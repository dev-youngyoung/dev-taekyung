<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsErrClose("�������� ��η� ���� �ϼ���.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsErrClose("ȸ�������� �����ϴ�.");
	return;
}
member.put("member_name", member.getString("member_name").replaceAll("\\(��\\)", "��").replaceAll("�ֽ�ȸ��","��"));

f.addElement("s_member_name", member.getString("member_name"), null);


File stamp_file = new File(Startup.conf.getString("file.path.bcont_proof_stamp") + member_no + "/pdf_stamp_writing.gif");
boolean stamp_file_yn = stamp_file.exists(); 

if (u.isPost()) {
	String binary_data = f.get("stamp_files");
	String[] binary_data_array = binary_data.split("data:image/png;base64,");
	String[] file_names = {"", "pdf_stamp_writing", "pdf_stamp_returned", "pdf_stamp_pending2", "pdf_stamp_pending", "pdf_stamp_issued", "pdf_stamp_completed"};
	//���丮�� �������� �ʴ´ٸ� ����
	File destdir = new File(Startup.conf.getString("file.path.bcont_proof_stamp") + member_no);
	if (!destdir.exists()) {
		destdir.mkdirs();
	}
	for (int i = 1; i < binary_data_array.length; i++) {
		FileOutputStream stream = null;
		byte[] file = Base64Coder.decode(binary_data_array[i]);
		stream = new FileOutputStream(destdir.getPath() + "/" + file_names[i] + ".gif");
		stream.write(file);
		stream.close();
	}

       u.jsAlertReplace("�����Ͽ����ϴ�.", "pop_stamp_modify.jsp?"+u.getQueryString());
       return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("buyer.pop_stamp_modify");
p.setVar("popup_title", "�����̹��� ����/����");
p.setVar("stamp_file_yn", stamp_file_yn);
p.setVar("member", member);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.display(out);
%>