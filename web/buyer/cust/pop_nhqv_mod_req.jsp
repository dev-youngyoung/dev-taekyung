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

f.addElement("mod_req_reason", null, "hname:'사유', required:'Y'");

if(u.isPost()&&f.validate()){
	custDao = new DataObject("tcb_recruit_cust");
	custDao.item("mod_req_date", u.getTimeString());
	custDao.item("mod_req_id", auth.getString("_USER_ID"));
	custDao.item("mod_req_reason", f.get("mod_req_reason"));
	custDao.item("status", "30");
	if(!custDao.update(" member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"'  and client_no = '"+client_no+"' ")){
		u.jsError("수정요청 처리에 실패 하였습니다.");
		return;
	}
	
	SmsDao smsDao= new SmsDao();
	smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), "NH투자증권에서 등록업체신청서 정보를 수정 요청 하였습니다.-나이스다큐");
	
	out.println("<script>");
	out.println("alert('수정요청 처리 하였습니다.');");
	out.println("opener.opener.location.reload();");
	out.println("opener.location.reload();");
	out.println("self.close();");
	out.println("</script>");
	
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("cust.pop_nhqv_mod_req");
p.setVar("popup_title", "수정요청");
p.setVar("noti", noti);
p.setVar("cust", cust);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>