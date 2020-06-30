<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String file_path = f.get("rfile_path");
String rfile_member_no = f.get("rfile_member_no");

String member_no = _member_no;
if(!rfile_member_no.equals("")){
	member_no = rfile_member_no; 
}

if(cont_no.equals("")||cont_chasu.equals("")||file_path.equals("")){
	u.jsError("�������� ��η� ������ �ּ���.");
	return;
}

ContractDao contDao = new ContractDao();
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cont.next()){
	u.jsError("��������� �����ϴ�.");
	return;
}

f.uploadDir = Startup.conf.getString("file.path.bcont_pdf")+file_path;

DataObject dao = new DataObject("tcb_rfile_cust");
DataSet ds = dao.find("cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' and member_no = '"+member_no+"' ");


DB db = new DB();
//db.setDebug(out);
String[] rfile_seq = f.getArr("rfile_seq");
int rfile_cnt = rfile_seq == null? 0 : rfile_seq.length;
for(int i = 0 ; i < rfile_cnt ; i++ ){
	dao = new DataObject("tcb_rfile_cust");
	dao.item("cont_no", cont_no);
	dao.item("cont_chasu", cont_chasu);
	dao.item("member_no", member_no);
	dao.item("rfile_seq", rfile_seq[i]);
	File file = f.saveFileTime("rfile_"+rfile_seq[i]);
	if(file == null){
		dao.item("file_path", "");
		dao.item("file_name", "");
		dao.item("file_ext", "");
		dao.item("file_size", "");
		dao.item("reg_gubun","");
	}else{
		dao.item("file_path", file_path);
		dao.item("file_name", file.getName());
		dao.item("file_ext", u.getFileExt(file.getName()));
		dao.item("file_size", file.length());
		dao.item("reg_gubun",cont.getString("member_no").equals(_member_no)?"10":"20");
	}
	
	boolean insert_yn = true;
	ds.first();
	while(ds.next()){
		if(ds.getString("rfile_seq").equals(rfile_seq[i])){
			insert_yn = false;
		}
	}
	
	if(insert_yn){
		db.setCommand(dao.getInsertQuery(), dao.record); 
	}else{
		db.setCommand(
		dao.getUpdateQuery(
		  "     cont_no = '"+cont_no+"' "
		+" and cont_chasu= '"+cont_chasu+"' " 
		+" and member_no = '"+member_no+"' "
		+" and rfile_seq = '"+rfile_seq[i]+"' ")
		 , dao.record);
	}	
}
if(rfile_cnt> 0 ){
	if(!db.executeArray()){
		u.jsError("�������忡 �����Ͽ����ϴ�.");
		return;
	}else{
		u.jsAlertReplace("�����Ͽ����ϴ�.",f.get("from_page")+"?"+u.getQueryString());
		return;
	}
}else{
	u.jsError("������ ������ �����ϴ�.");
	return;
}



%>