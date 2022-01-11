<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="nicelib.groupware.*"%>
<%@ include file="../contract/include_cont_push.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu", "0");
if (cont_no.equals("") || cont_chasu.equals("")) {
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'";
DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find(where + " and member_no = " + _member_no + " ");
if (!cont.next()) {
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}
String link = "contend_offcont_list.jsp?";

contDao = new DataObject("tcb_contmaster"); // 계약정보
contDao.item("status", "95");
if (!contDao.update(where + " and member_no = " + _member_no + " ")) {
	u.jsError("삭제처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("삭제 처리 하였습니다.", link + u.getQueryString("cont_no,cont_chasu,template_cd"));
%>