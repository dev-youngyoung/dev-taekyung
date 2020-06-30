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
	u.jsError("작성중 상태에서만 석제 가능 합니다.");
	return;
}

DataObject bidDao = new DataObject("tcb_bid_master");
if(bidDao.findCount("main_member_no = '20121203450' and yyyymm='"+yyyymm+"'")>0){
	u.jsError("해당정보로 평가진행된 입찰건이 있습니다.");
	 return;
	
}

DB db = new DB();
db.setCommand("delete from tcb_samsong_evaluate_supp where yyyymm='"+yyyymm+"' ", null);
db.setCommand("delete from tcb_samsong_evaluate where yyyymm='"+yyyymm+"' ", null);
if(!db.executeArray()){
	u.jsError("삭제 처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("삭제처리 하였습니다.", "./samsong_evaluate_list.jsp?"+u.getQueryString("yyyymm,mode"));



%>