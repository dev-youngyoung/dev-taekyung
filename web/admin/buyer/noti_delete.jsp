<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String id = u.request("id");
String mode = u.request("mode");

if(id.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

DataObject dao = new DataObject("tcb_board");

// ÷������ ����
DataSet ds = dao.find("board_id=" + id + " and category = 'noti'");
if(!ds.next()){
	u.jsError("�ش� ���ù��� �����ϴ�.");
	return;
}
u.delFile(Startup.conf.getString("file.path.noti")+ds.getString("file_path")+ds.getString("file_name"));


if(mode.equals("file"))
{
	dao.item("doc_name", "");
	dao.item("file_path", "");
	dao.item("file_name", "");
	dao.item("file_ext", "");
	dao.item("file_size", "");

	if(!dao.update("category='noti' and board_id='"+id+"'")){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. ");
		return;
	}

	u.jsAlertReplace("������ ���� �Ǿ����ϴ�.", "./noti_modify.jsp?"+u.getQueryString("mode"));
}
else	// �Խù� ����
{
	if(!dao.delete("board_id="+id)){
		u.jsError("ó���� ���� �Ͽ����ϴ�.");
		return;
	}

	u.jsAlertReplace("���� �Ǿ����ϴ�.", "./noti_list.jsp?"+u.getQueryString("id"));
}

%>