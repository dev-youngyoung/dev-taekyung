<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(f.get("cont_no"));
String cont_chasu = f.get("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and status in ('20','30','40','41')");
if(!cont.next()){
	u.jsError("��������� ���� ���� �ʽ��ϴ�.");
	return;
}


DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template=templateDao.find(" template_cd = '"+cont.getString("template_cd")+"' ");
if(!template.next()){
}


if(u.isPost() ){
	//��༭ ����
	contDao = new ContractDao();
	String file_hash = "";

	String cont_html_rm_str = "";
	String[] cont_html_rm = f.getArr("cont_html_rm");
	String[] cont_html = f.getArr("cont_html");
	String[] cont_sub_name = f.getArr("cont_sub_name");
	String[] cont_sub_style = f.getArr("cont_sub_style");
	String[] gubun = f.getArr("gubun");
	String[] sub_seq = f.getArr("sub_seq");

	//decodeing ó�� START
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		cont_html_rm[i] = new String(Base64Coder.decode(cont_html_rm[i]),"UTF-8");
	}
	for(int i = 0 ; i < cont_html.length; i ++){
		cont_html[i] =  new String(Base64Coder.decode(cont_html[i]),"UTF-8");
	}
	//decodeing ó�� END
	
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		if(i != 0)
			cont_html_rm_str += "<pd4ml:page.break>";
		if(gubun[i].equals("10")){
			cont_html_rm_str += cont_html_rm[i];
		}
	}

	ArrayList autoFiles = new ArrayList();

	int file_seq = 1;


	// ��༭���� ����
	DataSet pdfInfo = new DataSet();
	pdfInfo.addRow();
	pdfInfo.put("member_no", cont.getString("member_no"));
	pdfInfo.put("cont_no", cont_no);
	pdfInfo.put("cont_chasu", cont_chasu);
	pdfInfo.put("random_no", cont.getString("true_random"));
	pdfInfo.put("cont_userno", cont.getString("cont_userno"));
	pdfInfo.put("html", cont_html_rm_str);
	pdfInfo.put("file_seq",file_seq++);
	DataSet pdf = contDao.makePdf(pdfInfo);
	if(pdf==null){
		u.jsError("��༭ ���� ������ ���� �Ͽ����ϴ�.");
		return;
	}
	file_hash = pdf.getString("file_hash");

	//�ڵ��������� ����
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		if(    gubun[i].equals("20")
				|| ( gubun[i].equals("40") ) // �ڵ����� �����Ǵ� ��� �Ǵ� üũ�� ����� ���
			  )
		{
			DataSet pdfInfo2 = new DataSet();
			pdfInfo2.addRow();
			pdfInfo2.put("member_no", cont.getString("member_no"));
			pdfInfo2.put("cont_no", cont_no);
			pdfInfo2.put("cont_chasu", cont_chasu);
			pdfInfo2.put("random_no", cont.getString("true_random"));
			pdfInfo2.put("cont_userno", cont.getString("cont_userno"));
			pdfInfo2.put("html", cont_html_rm[i]);
			pdfInfo2.put("file_seq", file_seq++);
			DataSet pdf2 = contDao.makePdf(pdfInfo2);
			pdf2.put("cont_sub_name", cont_sub_name[i]);
			autoFiles.add(pdf2);
		}
	}

	DB db = new DB();

	// �߰���༭ html ����
	for(int i = 1 ; i < cont_html.length; i++) {
		DataObject cont_sub = new DataObject("tcb_cont_sub");
		cont_sub.item("cont_sub_html",cont_html[i]);
		db.setCommand(cont_sub.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sub_seq = " + sub_seq[i]), cont_sub.record);
	}

	//��༭������
	int cfile_seq_real = 1;
	//�ڵ������ΰ͸� ���� 
	db.setCommand("delete from tcb_cfile where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and auto_yn = 'Y' and auto_type is null ",null);
	DataObject cfileDao = new DataObject("tcb_cfile");
	cfileDao.item("cont_no", cont_no);
	cfileDao.item("cont_chasu", cont_chasu);
	cfileDao.item("cfile_seq", cfile_seq_real++);
	cfileDao.item("doc_name", template.getString("template_name"));
	cfileDao.item("file_path", pdf.getString("file_path"));
	cfileDao.item("file_name", pdf.getString("file_name"));
	cfileDao.item("file_ext", pdf.getString("file_ext"));
	cfileDao.item("file_size", pdf.getString("file_size"));
	cfileDao.item("auto_yn","Y");
	cfileDao.item("auto_type","");
	db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);

	//�ڵ���������
	for(int i=0; i <autoFiles.size(); i ++){
		DataSet temp = (DataSet)autoFiles.get(i);
		cfileDao = new DataObject("tcb_cfile");
		cfileDao.item("cont_no", cont_no);
		cfileDao.item("cont_chasu", cont_chasu);
		cfileDao.item("cfile_seq", cfile_seq_real++);
		cfileDao.item("doc_name", temp.getString("cont_sub_name"));
		cfileDao.item("file_path", temp.getString("file_path"));
		cfileDao.item("file_name", temp.getString("file_name"));
		cfileDao.item("file_ext", temp.getString("file_ext"));
		cfileDao.item("file_size", temp.getString("file_size"));
		cfileDao.item("auto_yn","Y");
		cfileDao.item("auto_type","");
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
		file_hash+="|"+temp.getString("file_hash");
	}


	DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and ( auto_yn='N' or (auto_yn ='Y' and auto_type is not null) )");
	while(cfile.next()){
		file_hash +="|"+contDao.getHash("file.path.bcont_pdf",cfile.getString("file_path")+cfile.getString("file_name"));
	}
	
	//���Ⱓ���ϱ�
	String cont_year = f.get("cont_year");
	String cont_month = f.get("cont_month");
	String cont_day = f.get("cont_day");
	String cont_date = "";
	if(cont_year.length()==4 &&!cont_month.equals("")&&!cont_day.equals("")){
		cont_date = cont_year+u.strrpad(cont_month,2,"0")+u.strrpad(cont_day,2,"0");
	}

	// ��༭ html ����
	contDao = new ContractDao();
	
	if(cont.getString("template_cd").equals("2016132")){
		String cont_sdate = f.get("cont_sdate").replaceAll("-","");
		String cont_edate = f.get("cont_edate").replaceAll("-","");
		if(!f.get("cont_syear").equals("")&&!f.get("cont_smonth").equals("")&&!f.get("cont_sday").equals("")){
			cont_sdate = u.strrpad(f.get("cont_syear"),4,"0")+u.strrpad(f.get("cont_smonth"),2,"0")+u.strrpad(f.get("cont_sday"),2,"0");
		}
		if(!f.get("cont_eyear").equals("")&&!f.get("cont_emonth").equals("")&&!f.get("cont_eday").equals("")){
			cont_edate = u.strrpad(f.get("cont_eyear"),4,"0")+u.strrpad(f.get("cont_emonth"),2,"0")+u.strrpad(f.get("cont_eday"),2,"0");
		}
		contDao.item("cont_sdate", cont_sdate);
		contDao.item("cont_edate", cont_edate);
	}
	
	if(!cont_date.equals("")){
		contDao.item("cont_date",cont_date);
	}
	contDao.item("cont_hash", file_hash);
	contDao.item("cont_html", cont_html[0]);
	db.setCommand(contDao.getUpdateQuery("cont_no= '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), contDao.record);
	
	if(cont.getString("template_cd").equals("2018029")){//�¸������� �̿��༭ ����� ��ǥ�� ������� ����
		Security security = new	Security();
		if(!f.get("birthday").equals("")){
			if(u.inArray(auth.getString("_MEMBER_GUBUN"), new String[]{"03"})){
				DataObject custDao = new DataObject("tcb_cust");
				custDao.item("jumin_no", security.AESencrypt(f.get("birthday")));
				db.setCommand(custDao.getUpdateQuery("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq = '2'"), custDao.record);
			}
		}
	}
	
	if(!db.executeArray()){
		u.jsError("���忡 ���� �Ͽ����ϴ�.");
		return;
	}
	u.jsAlertReplace("�����Ͽ����ϴ�.","contract_recvview.jsp?cont_no="+f.get("cont_no")+"&cont_chasu="+cont_chasu);
	return;
}

%>