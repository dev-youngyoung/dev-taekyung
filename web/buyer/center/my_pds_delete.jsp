<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%@ include file="../chk_login.jsp" %>
<%
String seq = u.request("seq");
if(seq.equals("")){
	u.jsError("�������� ��η� ������ �ּ���.");
	return;
}

DB db = new DB();
DataObject pdsDao = new DataObject("tcb_member_pds");
DataObject fileDao = new DataObject("tcb_member_pds_file");
DataSet file = fileDao.find("member_no='"+_member_no+"' and seq = '"+seq+"'");

db.setCommand(fileDao.getDeleteQuery("member_no='"+_member_no+"' and seq = '"+seq+"'"),null);
db.setCommand(pdsDao.getDeleteQuery("member_no='"+_member_no+"' and seq = '"+seq+"'"),null);

if(!db.executeArray()){
	u.jsError("����ó���� ���� �Ͽ����ϴ�.");
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