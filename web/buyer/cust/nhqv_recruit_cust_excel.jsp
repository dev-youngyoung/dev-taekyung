<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_noti_status = {"10=>모집중","20=>모집완료"};
String[] code_cust_status = {"10=>임시저장","20=>신청중","30=>수정요청","31=>수정신청","40=>심사완료","50=>완료"};
String noti_seq = u.request("noti_seq");
if(noti_seq.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}


DataObject notiDao = new DataObject("tcb_recruit_noti");
DataSet noti = notiDao.find("member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"' ");
if(!noti.next()){
	u.jsError("공고 정보가 없습니다.");
	return;
}
noti.put("req_sdate", u.getTimeString("yyyy-MM-dd", noti.getString("req_sdate")));
noti.put("req_edate", u.getTimeString("yyyy-MM-dd", noti.getString("req_edate")));
noti.put("noti_date", u.getTimeString("yyyy-MM-dd", noti.getString("noti_date")));
noti.put("status_nm", u.getItem(noti.getString("status"), code_noti_status ) );
noti.put("noti_end", noti.getString("status").equals("20"));


DataObject custDao =  new DataObject("tcb_recruit_cust");
DataSet cust = custDao.find("member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"' ","*","src_cd asc, cust_seq asc");
while(cust.next()){
	cust.put("vendcd", u.getBizNo(cust.getString("vendcd")));
	cust.put("status_nm", u.getItem(cust.getString("status"), code_cust_status));
	cust.put("tot_point", u.numberFormat(cust.getString("tot_point")));
	cust.put("succ_tag", cust.getString("succ_yn").equals("Y")?"<font color='red'><b>ν</b></font>":"");
	
}

p.setVar("title", noti.getString("title"));
p.setLoop("list", cust);
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("신청업체현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
out.println(p.fetch("../html/cust/nhqv_recruit_cust_excel.html"));
return;


%>