<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_noti_status = {"10=>������","20=>�����Ϸ�"};
String[] code_cust_status = {"10=>�ӽ�����","20=>��û��","30=>������û","31=>������û","40=>�ɻ�Ϸ�","50=>�Ϸ�"};
String noti_seq = u.request("noti_seq");
if(noti_seq.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}


DataObject notiDao = new DataObject("tcb_recruit_noti");
DataSet noti = notiDao.find("member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"' ");
if(!noti.next()){
	u.jsError("���� ������ �����ϴ�.");
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
	cust.put("succ_tag", cust.getString("succ_yn").equals("Y")?"<font color='red'><b>��</b></font>":"");
	
}

p.setVar("title", noti.getString("title"));
p.setLoop("list", cust);
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("��û��ü��Ȳ.xls".getBytes("KSC5601"),"8859_1") + "\"");
out.println(p.fetch("../html/cust/nhqv_recruit_cust_excel.html"));
return;


%>