<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String noti_seq = u.request("noti_seq");
String client_no = u.request("client_no");
if(noti_seq.equals("")||client_no.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject notiDao = new DataObject("tcb_recruit_noti");
DataSet noti = notiDao.find("member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"' ");
if(!noti.next()){
	u.jsError("공고 정보가 없습니다.");
	return;
}


DataObject custDao = new DataObject("tcb_recruit_cust");
DataSet cust = custDao.find(" member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"'  and client_no = '"+client_no+"' ");
if(!cust.next()){
	u.jsError("신청정보가 없습니다.");
	return;
}

if(!cust.getString("status").equals("31")){
	u.jsError("수정신청 상태에서만 수정확인 처리 가능 합니다.");
	return;
}

custDao = new DataObject("tcb_recruit_cust");
custDao.item("mod_req_date", "");
custDao.item("mod_req_id", "");
custDao.item("mod_req_reason", "");
custDao.item("status", "20");
if(!custDao.update(" member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"'  and client_no = '"+client_no+"' ")){
	u.jsError("수정확인 처리에 실패 하였습니다.");
	return;
}

out.println("<script>");
out.println("alert('수정확인 처리 하였습니다.');");
out.println("opener.location.reload();");
out.println("self.close();");
out.println("</script>");

return;

%>