<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String file_path = f.get("efile_path");

String member_no = _member_no;

if(cont_no.equals("")||cont_chasu.equals("")||file_path.equals("")){
	u.jsError("정상적인 경로로 접근해 주세요.");
	return;
}

ContractDao contDao = new ContractDao();
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cont.next()){
	u.jsError("계약정보가 없습니다.");
	return;
}

f.uploadDir = Startup.conf.getString("file.path.bcont_pdf")+file_path;

DataObject efileDao = new DataObject("tcb_efile");
DataSet efile = efileDao.find("cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' ");


DB db = new DB();
//db.setDebug(out);

// 내부관리서류
if(cont.getString("efile_yn").equals("Y")){
	db.setCommand("delete from tcb_efile where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
	String[] efile_seq = f.getArr("efile_seq");
	String[] efile_reg_type = f.getArr("efile_reg_type");
	String[] efile_doc_name = f.getArr("efile_doc_name");
	String[] efile_del_yn = f.getArr("efile_del_yn");
	int efile_cnt = efile_seq == null? 0: efile_seq.length;
	for(int i=0 ; i < efile_cnt; i ++){
		efileDao = new DataObject("tcb_efile");
		efileDao.item("cont_no", cont_no);
		efileDao.item("cont_chasu", cont_chasu);
		efileDao.item("efile_seq", efile_seq[i]);
		efileDao.item("doc_name", efile_doc_name[i]);
		File attfile = f.saveFileTime("efile_"+efile_seq[i]);
		String efile_name = "";
		if(attfile == null){
			if(!efile_del_yn[i].equals("Y")){
				efile.first();
				while(efile.next()){
					if(efile_seq[i].equals(efile.getString("efile_seq"))){
						efileDao.item("efile_seq", i);
						efileDao.item("file_path", file_path);
						efileDao.item("file_name", efile.getString("file_name"));
						efileDao.item("file_ext", efile.getString("file_ext"));
						efileDao.item("file_size", efile.getString("file_size"));
						efileDao.item("reg_date", efile.getString("reg_date"));
						efileDao.item("reg_id", efile.getString("reg_id"));
					}
				}	
			}else{
				efileDao.item("efile_seq", i);
				efileDao.item("file_path", "");
				efileDao.item("file_name", "");
				efileDao.item("file_ext", "");
				efileDao.item("file_size", "");
				efileDao.item("reg_date", efile.getString("reg_date"));
				efileDao.item("reg_id", efile.getString("reg_id"));
			}
			
		}else{
			efileDao.item("efile_seq", i);
			efileDao.item("file_path", file_path);
			efileDao.item("file_name", attfile.getName());
			efileDao.item("file_ext", u.getFileExt(attfile.getName()));
			efileDao.item("file_size", attfile.length());
			efileDao.item("reg_date", u.getTimeString());
			efileDao.item("reg_id", auth.getString("_USER_ID"));
		}
		efileDao.item("reg_type", efile_reg_type[i]);
		db.setCommand(efileDao.getInsertQuery(), efileDao.record);
	}
}

if(!db.executeArray()){
	u.jsError("파일저장에 실패하였습니다.");
	return;
}

u.jsAlertReplace("저장하였습니다.",f.get("from_page")+"?"+u.getQueryString());
return;
%>