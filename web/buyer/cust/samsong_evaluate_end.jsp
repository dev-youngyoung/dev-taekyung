<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="java.net.URLDecoder" %>
<%
String yyyymm = u.request("yyyymm");

DataObject evaluateDao = new DataObject("tcb_samsong_evaluate");
DataSet evaluate = evaluateDao.find("yyyymm = '"+yyyymm+"' ");
if(!evaluate.next()){
	u.jsError("삭제 대상 건이 없습니다.");
	return;
}

if(evaluate.getString("status").equals("status")){
	u.jsError("작성중 상태에서만 확정 가능 합니다.");
	return;
}


DB db = new DB();

evaluateDao.item("status","20");
evaluateDao.item("mod_date", u.getTimeString());
evaluateDao.item("mod_id", auth.getString("_USER_ID"));
evaluateDao.item("status", "20");


if(!evaluateDao.update("yyyymm='"+yyyymm+"'")){
	u.jsError("확정 처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("확정처리 하였습니다.", "./samsong_evaluate_view.jsp?"+u.getQueryString());



%>