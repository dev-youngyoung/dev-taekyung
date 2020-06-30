<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
if(!u.isPost()) return;
	
Security	security	=	new	Security();

String cont_no = u.aseDec(f.get("cont_no"));
String cont_chasu = f.get("cont_chasu","0");
String seq = f.get("seq");

System.out.println("cont_no : " +cont_no);
System.out.println("cont_chasu : " +cont_chasu);
System.out.println("seq : " +seq);

String cont_html_rm = new String(Base64Coder.decode(f.get("cont_html_rm")),"UTF-8");
String cont_html = new String(Base64Coder.decode(f.get("cont_html")),"UTF-8");

if(cont_no.equals("")||cont_chasu.equals("")||seq.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("����� ������ �������� �ʽ��ϴ�.");
	return;
}


String random_no = "";
String cont_userno = "";

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*");
if(!cont.next()){
	u.jsError("��������� ���� ���� �ʽ��ϴ�.");
	return;
}
random_no = cont.getString("true_random");
cont_userno = cont.getString("cont_userno");

if(u.isPost()){
	//��༭ ����
	DataObject cont_sub = new DataObject("tcb_cont_sub");
	cont_sub.item("cont_sub_html",cont_html);
	if(!cont_sub.update("cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' and sub_seq="+seq)){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. ");
		return;
	}

	// ��༭���� ��ü ����
	DataSet pdfInfo = new DataSet();
	pdfInfo.addRow();
	pdfInfo.put("member_no",_member_no);
	pdfInfo.put("cont_no", cont_no);
	pdfInfo.put("cont_chasu", cont_chasu);
	pdfInfo.put("random_no", random_no);
	pdfInfo.put("cont_userno", cont_userno);
	pdfInfo.put("html", cont_html_rm);
	pdfInfo.put("file_seq", Integer.parseInt(seq)+1);
	DataSet pdf = contDao.makePdf(pdfInfo);
	if(pdf==null){
		u.jsError("��༭ ���忡 ���� �Ͽ����ϴ�.");
		return;
	}

	u.jsAlert("���� �Ͽ����ϴ�.");
	return;
}

%>