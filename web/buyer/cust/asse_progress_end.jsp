<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String asse_no = u.request("asse_no");
String div_cd = u.request("div_cd");
if(asse_no.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject asseDao = new DataObject("tcb_assemaster");
DataSet asse = asseDao.find("main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"' and status = '20'");
if(!asse.next()){
	u.jsError("평가계획 정보가 없습니다.");
	return;
}

DataObject detailDao = new DataObject("tcb_assedetail");
DataSet detail = detailDao.find(" asse_no = '"+asse_no+"' and div_cd = '"+div_cd+"'");
if(!detail.next()){
	u.jsError("평가상세 정보가 없습니다.");
	return;
}

if(!detail.getString("status").equals("10")){
	u.jsError("작성중 상태에서만 평가 완료 처리 가능 합니다.");
	return;
}

String msg = "처리 완료하였습니다.";

DB db = new DB();

detailDao = new DataObject("tcb_assedetail");
detailDao.item("status","20");
detailDao.item("reg_date",u.getTimeString());
db.setCommand(detailDao.getUpdateQuery("asse_no = '"+asse_no+"' and div_cd = '"+div_cd+"' "), detailDao.record);

if(detailDao.findCount("asse_no = '"+asse_no+"' and status = '10'  and div_cd <> '"+div_cd+"' ")<1){
	asseDao.item("status","30");
	db.setCommand(asseDao.getUpdateQuery("main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"'"), asseDao.record);
	msg += "\\n\\n평가완료 메뉴에서 조회 가능합니다.";
}

if(!db.executeArray()){
	u.jsError("처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace(msg, "./asse_progress_list.jsp?"+u.getQueryString("asse_no"));
%>
