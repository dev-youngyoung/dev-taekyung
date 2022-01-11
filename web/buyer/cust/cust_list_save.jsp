<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] client_no = u.reqArr("client_no");
String returnUrl = u.request("returnUrl");

if(client_no == null){
	u.jsError("정상적인 경로로 접근해 주세요.");
	return;
}

DB db = new DB();
for(int i = 0 ; i < client_no.length; i ++){
	String status = u.request("client_status_"+client_no[i]);
	String temp_yn = u.request("temp_yn_"+client_no[i]);
	DataObject dao = new DataObject("tcb_client");
	dao.item("status", status);
	if(!status.equals("90")){
		dao.item("reason","");
		dao.item("reason_date","");
		dao.item("reason_id","");
	}
	dao.item("temp_yn", temp_yn.equals("Y")?"Y":"");
	db.setCommand(dao.getUpdateQuery("member_no = '"+_member_no+"' and client_no = '"+client_no[i]+"' "), dao.record);
}

if(!db.executeArray()){
	u.jsError("저장에 실패 하였습니다.");
	return;	
}
if(returnUrl!=null && !returnUrl.equals("")) {
	u.redirect(returnUrl+"?"+u.getQueryString("returnUrl"));
} else {
	u.redirect("my_cust_list.jsp?"+u.getQueryString());
}
%>
