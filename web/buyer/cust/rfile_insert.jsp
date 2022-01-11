<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String rfile_member_no = u.request("member_no");

if(rfile_member_no.equals("")){
	u.jsError("정상적인 경로로 접근해 주세요.");
	return;
}

f.uploadDir = Startup.conf.getString("file.path.bcompany")+_member_no;

DataObject dao = new DataObject("tcb_client_rfile");
DataSet ds = dao.find("member_no='"+rfile_member_no+"' and client_no='"+_member_no+"'");


DB db = new DB();
//db.setDebug(out);
String[] rfile_seq = f.getArr("rfile_seq");
int rfile_cnt = rfile_seq == null? 0 : rfile_seq.length;
for(int i = 0 ; i < rfile_cnt ; i++ ){
	dao = new DataObject("tcb_client_rfile");
	dao.item("member_no", rfile_member_no);
	dao.item("rfile_seq", rfile_seq[i]);
	dao.item("client_no", _member_no);
	File file = f.saveFileTime("rfile_"+rfile_seq[i]);
	if(file == null){
		dao.item("file_path", "");
		dao.item("file_name", "");
		dao.item("file_ext", "");
		dao.item("file_size", "");
		dao.item("reg_gubun","");
	}else{
		dao.item("file_path", _member_no+"/");
		dao.item("file_name", file.getName());
		dao.item("file_ext", u.getFileExt(file.getName()));
		dao.item("file_size", file.length());
		dao.item("reg_gubun","");
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
		  "member_no = '"+rfile_member_no+"' "
		+" and client_no = '"+_member_no+"' "
		+" and rfile_seq = '"+rfile_seq[i]+"' ")
		 , dao.record);
	}	
}
if(rfile_cnt> 0 ){
	if(!db.executeArray()){
		u.jsError("파일저장에 실패하였습니다.");
		return;
	}else{
		u.jsAlertReplace("저장하였습니다.",f.get("from_page")+"?"+u.getQueryString());
		return;
	}
}else{
	u.jsError("저장할 내용이 없습니다.");
	return;
}



%>