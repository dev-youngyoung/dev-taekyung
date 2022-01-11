<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%@ include file="../chk_login.jsp" %>
<%
String seq = u.request("seq");
if(seq.equals("")){
	u.jsError("정상적인 경로로 접근해 주세요.");
	return;
}

DB db = new DB();
DataObject pdsDao = new DataObject("tcb_member_pds");
DataObject fileDao = new DataObject("tcb_member_pds_file");
DataSet file = fileDao.find("member_no='"+_member_no+"' and seq = '"+seq+"'");

db.setCommand(fileDao.getDeleteQuery("member_no='"+_member_no+"' and seq = '"+seq+"'"),null);
db.setCommand(pdsDao.getDeleteQuery("member_no='"+_member_no+"' and seq = '"+seq+"'"),null);

if(!db.executeArray()){
	u.jsError("삭제처리에 실패 하였습니다.");
	return;
}

while(file.next()){
	String path=Startup.conf.getString("file.path.bcont_pds");
	if(!file.getString("file_path").equals("")&&!file.getString("file_name").equals("")){
		u.delFile(path+file.getString("file_path")+file.getString("file_name"));
	}
}

u.redirect("my_pds_list.jsp?"+u.getQueryString("seq"));
return;
%>