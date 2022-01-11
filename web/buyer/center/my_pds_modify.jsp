<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%@ include file="../chk_login.jsp" %>
<%
f.uploadDir=Startup.conf.getString("file.path.bcont_pds")+_member_no;
f.maxPostSize= 10*1024;

String seq = u.request("seq");
if(seq.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

DataObject pdsDao = new DataObject("tcb_member_pds a");
//pdsDao.setDebug(out);
DataSet pds = pdsDao.find(" member_no = '"+_member_no+"' and seq = '"+seq+"' "
		," a.* "
				+" ,(select user_name "
				+"     from tcb_person "
				+"    where member_no = a.member_no "
				+"      and user_id = a.reg_id) reg_name");
if(!pds.next()){
	u.jsError("정보가 존재 하지 않습니다.");
	return;
}
pds.put("reg_date", u.getTimeString("yyyy-MM-dd", pds.getString("reg_date")));


DataObject fileDao = new DataObject("tcb_member_pds_file");
DataSet fds = fileDao.find("member_no = '"+_member_no+"' and seq = '"+seq+"' ");

for(int i = 1 ; i <= 3 ; i++){
	if(!fds.next()){
		fds.addRow();
		fds.put("member_no","");
		fds.put("seq",i);
		fds.put("file_seq","");
		fds.put("doc_name","");
		fds.put("file_path","");
		fds.put("file_name","");
		fds.put("file_ext","");
		fds.put("file_size","");
		fds.put("file_size_str","");
	}else{
		fds.put("seq",i);
		fds.put("file_size_str", u.getFileSize(fds.getLong("file_size")));
	}
}


f.addElement("title", pds.getString("title") , "hname:'제목', required:'Y', maxbyte:'100'");
f.addElement("_contents", null, "hname:'내용', required:'Y'"); 

if(u.isPost()&&f.validate()){
	//글내용
	DB db = new DB();

	DataObject dao = new DataObject("tcb_member_pds");
	dao.item("title", f.get("title"));  
    dao.item("contents", new String(Base64Coder.decode(f.get("contents")),"UTF-8"));   
	dao.item("reg_id", auth.getString("_USER_ID"));
	dao.item("reg_date", u.getTimeString());
	db.setCommand(dao.getUpdateQuery(" member_no = '"+_member_no+"' and seq = '"+seq+"'"), dao.record);

	db.setCommand("delete from tcb_member_pds_file where member_no = '"+_member_no+"' and seq='"+seq+"' ", null);
	//파일
	for(int i = 1 ; i <= 3; i ++){
		//저장파일
		File file = f.saveFileTime("file_pds_"+i);
		if(file != null){
			String file_name = file.getName();
			DataObject fdao = new DataObject("tcb_member_pds_file");
			fdao.item("member_no", _member_no);
			fdao.item("seq", seq);
			fdao.item("file_seq", i);
			fdao.item("doc_name", f.get("doc_name_"+i));
			fdao.item("file_path",_member_no+"/");
			fdao.item("file_name",file_name);
			fdao.item("file_ext", u.getFileExt(file_name));
			fdao.item("file_size", file.length());
			db.setCommand(fdao.getInsertQuery(),fdao.record);
		}
		//기존파일
		if(!f.get("file_name_"+i).equals("")){
			DataObject fdao = new DataObject("tcb_member_pds_file");
			fdao.item("member_no", _member_no);
			fdao.item("seq", seq);
			fdao.item("file_seq", i);
			fdao.item("doc_name", f.get("doc_name_"+i));
			fdao.item("file_path",_member_no+"/");
			fdao.item("file_name",f.get("file_name_"+i));
			fdao.item("file_ext", f.get("file_ext_"+i));
			fdao.item("file_size", f.get("file_size_"+i));
			db.setCommand(fdao.getInsertQuery(),fdao.record);
		}
	}

	if(!db.executeArray()){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("정상 처리하였습니다.","my_pds_list.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
p.setDebug(out);
p.setBody("center.my_pds_modify");
p.setVar("menu_cd","000123");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000123", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setVar("pds", pds);
p.setLoop("fds", fds);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("seq"));
p.setVar("form_script",f.getScript());
p.display(out);
%>