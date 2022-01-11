<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String id = u.request("id");
String mode = u.request("mode");

if(id.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

DataObject dao = new DataObject("tcb_board");

// 첨부파일 삭제
DataSet ds = dao.find("board_id=" + id + " and category = 'noti'");
if(!ds.next()){
	u.jsError("해당 개시물이 없습니다.");
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
		u.jsError("처리중 오류가 발생 하였습니다. ");
		return;
	}

	u.jsAlertReplace("파일이 삭제 되었습니다.", "./noti_modify.jsp?"+u.getQueryString("mode"));
}
else	// 게시물 삭제
{
	if(!dao.delete("board_id="+id)){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}

	u.jsAlertReplace("삭제 되었습니다.", "./noti_list.jsp?"+u.getQueryString("id"));
}

%>