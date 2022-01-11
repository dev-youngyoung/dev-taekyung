<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%@ include file="../chk_login.jsp" %>
<%
f.uploadDir=Startup.conf.getString("file.path.bcont_pds")+_member_no;
f.maxPostSize= 10*1024;

f.addElement("title", null, "hname:'제목', required:'Y', maxbyte:'100'");
f.addElement("_contents", null, "hname:'내용', required:'Y'");

if(u.isPost()&&f.validate()){
	//글내용
	DB db = new DB();
	
	DataObject dao = new DataObject("tcb_member_pds");
	int seq = dao.getOneInt("select nvl(max(seq),0)+1 from tcb_member_pds where member_no = '"+_member_no+"' ");
	dao.item("member_no", _member_no);
	dao.item("seq",seq);
	dao.item("title", f.get("title"));
	dao.item("contents", new String(Base64Coder.decode(f.get("contents")),"UTF-8"));   
	dao.item("contents", new String(Base64Coder.decode(f.get("contents")),"UTF-8"));   
	dao.item("reg_id", auth.getString("_USER_ID"));
	dao.item("reg_date", u.getTimeString());
	db.setCommand(dao.getInsertQuery(), dao.record);
	
	//파일
	for(int i = 1 ; i <= 3; i ++){
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
	}
	
	if(!db.executeArray()){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("정상 처리하였습니다.","my_pds_list.jsp?"+u.getQueryString());
	return;	
}

DataSet fds = new DataSet();
for(int i=1; i <=3; i ++){
	fds.addRow();
	fds.put("seq",i);
}

p.setLayout("default");
p.setDebug(out);
p.setBody("center.my_pds_modify");
p.setVar("menu_cd","000123");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000123", "btn_auth").equals("10"));
p.setVar("modify", false);
p.setLoop("fds", fds);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("seq"));
p.setVar("form_script",f.getScript());
p.display(out);
%>