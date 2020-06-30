<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String main_member_no = u.request("main_member_no");
String bid_no = u.request("bid_no");
String bid_deg = u.request("bid_deg");
String member_no = u.request("member_no");
if(main_member_no.equals("")||bid_no.equals("")||bid_deg.equals("")||member_no.equals("")){
	u.jsErrClose("정상적인 경로 접근하세요.");
	return;
}

String where = "main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"'";
DataObject bidDao = new DataObject("tcb_bid_master");
//bidDao.setDebug(out);
DataSet bid = bidDao.find(where);
if(!bid.next()){
	u.jsError("입찰정보가 없습니다.");
	return;
}

DataObject suppSubDao = new DataObject("tcb_bid_supp");
DataSet suppSubDs = suppSubDao.find(where+" and member_no='"+member_no+"' and pay_yn='Y' ");
if(suppSubDs.next()) {
	u.jsError("이미 결제된 업체입니다. 개발팀으로 문의해 주세요.");
	return;
}

DB db = new DB();
DataObject suppDao = new DataObject("tcb_bid_supp");
suppDao.item("pay_yn", "Y");
db.setCommand(suppDao.getUpdateQuery(where+" and member_no='"+member_no+"' "), suppDao.record);
if(!db.executeArray()){
	u.jsError("처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("입찰 무료처리 되었습니다.", "./pop_bid_supp.jsp?"+u.getQueryString());
%>