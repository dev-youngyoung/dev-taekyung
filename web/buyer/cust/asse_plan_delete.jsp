<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String asse_no = u.request("asse_no");
if(asse_no.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

DataObject asseDao = new DataObject("tcb_assemaster");
DataSet asse = asseDao.find("main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"' and status = '10'");
if(!asse.next()){
	u.jsError("평가계획 정보가 없습니다.");
	return;
}
	
DB db = new DB();
db.setCommand("delete from tcb_assedetail where asse_no = '"+asse_no+"'", null);
db.setCommand("delete from tcb_assemaster where main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"'", null);

if(!db.executeArray()){
	u.jsError("처리중 오류가 발생 하였습니다.");
	return;
}

u.jsAlertReplace("삭제 하였습니다.","asse_plan_list.jsp?"+u.getQueryString("asse_no"));

%>