<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String seq = u.request("seq");
if(cont_no.equals("")||cont_chasu.equals("")||seq.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject shareDao = new DataObject("tcb_share");
DataSet share = shareDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and seq = '"+seq+"' ");
if(!share.next()){
	u.jsError("공람 정보가 없습니다.");
	return;
}

if(!share.getString("status").equals("10")){
	u.jsError("삭제 가능한 상태가 아닙니다.");
	return;
}

shareDao.item("status","-1");
if(!shareDao.update("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and seq = '"+seq+"' ")){
	u.jsError("처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("삭제처리 하였습니다.", "ifm_cont_share.jsp?"+u.getQueryString("seq"));

%>