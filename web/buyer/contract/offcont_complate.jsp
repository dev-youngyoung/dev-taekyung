<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(where+" and member_no = "+_member_no+" and paper_yn = 'Y' ");
if(!cont.next()){
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}
if(!u.inArray(cont.getString("status"),new String[]{"10"})){
	u.jsError("종이계약건은 작성중 상태에서만 작성완료처리 가능합니다.");
	return;
}
//계약서류 조회
String fileDir = "";
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'");
while (cfile.next()) {
  cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	cfile.put("auto", cfile.getString("auto_yn").equals("Y") ? true : false);
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	cfile.put("pdf_yn", cfile.getString("file_ext").toLowerCase().equals("pdf"));

	fileDir = cfile.getString("file_path");
}

DB db = new DB();
//계약서류(cfile) 정보 업데이트를 진행한다.
db.setCommand("delete from tcb_cfile where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' ", null);

f.uploadDir = Startup.conf.getString("file.path.bcont_pdf") + fileDir;
String file_hash = "";
String[] cfile_seq = f.getArr("cfile_seq");
String[] cfile_org_seq = f.getArr("cfile_org_seq");
String[] cfile_doc_name = f.getArr("cfile_doc_name");
int cfile_cnt = (cfile_seq==null) ? 0 : cfile_seq.length;
for (int i=0; i<cfile_cnt; i++) {
	cfileDao = new DataObject("tcb_cfile");
	if (!cfile_seq[i].equals("0")) {
		cfile.first();
		while (cfile.next()) {
			if (cfile_seq[i].equals(cfile.getString("cfile_seq")) && !cfile.getString("auto_yn").equals("Y")) {
				cfileDao.item("cont_no", cont_no);
				cfileDao.item("cont_chasu", cont_chasu);
				cfileDao.item("cfile_seq", i + 1);
				cfileDao.item("doc_name", cfile_doc_name[i]);
				cfileDao.item("file_path", fileDir);
				cfileDao.item("file_name", cfile.getString("file_name"));
				cfileDao.item("file_ext", cfile.getString("file_ext"));
				cfileDao.item("file_size", cfile.getString("file_size"));
				cfileDao.item("auto_yn", "N");
				cfileDao.item("auto_type", "");
				db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
				file_hash += "|" + contDao.getHash("file.path.bcont_pdf", fileDir+cfile.getString("file_name"));
			}
		}
	} else {
		cfileDao.item("cont_no", cont_no);
		cfileDao.item("cont_chasu", cont_chasu);
		cfileDao.item("cfile_seq", cfile_org_seq[i]);
		cfileDao.item("doc_name", cfile_doc_name[i]);
		cfileDao.item("file_path", fileDir);
		File attFile = f.saveFileTime("cfile_" + i);
		if (attFile == null) continue;
		cfileDao.item("file_name", attFile.getName());
		cfileDao.item("file_ext", u.getFileExt(attFile.getName()));
		cfileDao.item("file_size", attFile.length());
		cfileDao.item("auto_yn", "N");
		cfileDao.item("auto_type", "");
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
		file_hash += "|" + contDao.getHash("file.path.bcont_pdf", fileDir+attFile.getName());
	}
}
	
// status 계약완료로 변경
contDao.item("status","50");
db.setCommand(contDao.getUpdateQuery(where), contDao.record);

if(!db.executeArray()){
	u.jsError("처리에실패 하였습니다.");
	return;
}

u.jsAlertReplace("종이계약서를 작성완료처리 하였습니다.\\n\\n계약완료>종이계약 메뉴에서 조회 가능합니다.","contend_offcont_list.jsp?"+u.getQueryString("cont_no,cont_chasu"));
return;
%>