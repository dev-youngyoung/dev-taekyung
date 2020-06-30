<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String main_member_no = u.request("main_member_no");
String bid_no = u.request("bid_no");
String bid_deg = u.request("bid_deg");
if(main_member_no.equals("")||bid_no.equals("")||bid_deg.equals("")){
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

bid.put("str_submit_edate",u.getTimeString("yyyy-MM-dd HH:mm", bid.getString("submit_edate")));
f.addElement("submit_edate", u.getTimeString("yyyy-MM-dd", bid.getString("submit_edate")), "hname:'변경후 입찰서마감일', required:'Y'");
f.addElement("submit_ehh", u.getTimeString("HH", bid.getString("submit_edate")), "hname:'변경후 입찰서마감시간', required:'Y'");
f.addElement("submit_emm", u.getTimeString("mm", bid.getString("submit_edate")), "hname:'변경후 입찰서마감분', required:'Y'");

if(u.isPost()&&f.validate()){
	DB db = new DB();

	String submit_edate = "";
	if(!f.get("submit_edate").equals("")){
		submit_edate = f.get("submit_edate").replaceAll("-","")+f.get("submit_ehh")+f.get("submit_emm")+"59";
	}

	bidDao = new DataObject("tcb_bid_master");
	bidDao.item("submit_edate", submit_edate);
	db.setCommand(bidDao.getUpdateQuery(where), bidDao.record);

	if(!db.executeArray()){
		u.jsError("처리중 오류가 발생 하였습니다.");
		return;
	}
	
	out.println("<script>");
	out.println("alert('마감시간 변경 처리 하였습니다.');");
	out.println("opener.location.reload();");
	out.println("self.close();");
	out.println("</script>");
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("buyer.pop_bid_delay");
p.setVar("popup_title","마감시간 변경");
p.setVar("bid",bid);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());

p.display(out);
%>