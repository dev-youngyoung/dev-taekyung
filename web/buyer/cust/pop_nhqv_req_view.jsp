<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_status = {"10=>임시저장","20=>신청중","30=>수정요청","31=>수정신청","40=>심사완료","50=>완료"};

//NH투자 증권 전용 등록업체 신청 전용 페이지
String noti_seq = u.request("noti_seq");
String client_no = u.request("client_no");
String gubun = u.request("gubun");
if(noti_seq.equals("")||client_no.equals("")|| gubun.equals("")){
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
	u.jsError("신정정보가 없습니다.");
	return;
}

String[] vendcds = u.getBizNo(cust.getString("vendcd")).split("-"); 
cust.put("vendcd1", vendcds[0]);
cust.put("vendcd2", vendcds[1]);
cust.put("vendcd3", vendcds[2]);
cust.put("status_nm", u.getItem(cust.getString("status"), code_status));
cust.put("display_req", gubun.equals("req")?"":"none");
cust.put("display_evaluate", gubun.equals("evaluate")?"":"none");

cust.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm", cust.getString("mod_req_date")));
if(!cust.getString("mod_req_id").equals("")){
	cust.put("mod_req_name", new DataObject("tcb_person").getOne("select user_name from tcb_person where member_no = '"+_member_no+"' and user_id = '"+cust.getString("mod_req_id")+"' "));
}
cust.put("mod_req_reason", u.nl2br(cust.getString("mod_req_reason")));

if(u.inArray(cust.getString("status"), new String[]{"40","50"}) ){
	cust.put("evaluate_etc", u.nl2br(cust.getString("evaluate_etc")));
}


if(u.isPost()&&f.validate()){
	
	if(!cust.getString("status").equals("20")){
		u.jsError("신청중 상태에서만 심사 완료 처리 가능 합니다.");
		return;
	}
	custDao = new DataObject("tcb_recruit_cust");
	custDao.item("evaluate_etc", f.get("evaluate_etc"));
	custDao.item("req_html", new String(Base64Coder.decode(f.get("req_html")),"UTF-8"));
	custDao.item("evaluate_html", new String(Base64Coder.decode(f.get("evaluate_html")),"UTF-8"));
	custDao.item("tot_point",f.get("tot_point"));
	if(f.get("status").equals("40")){
		custDao.item("status","40");
	}
	if(!custDao.update(" member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"'  and client_no = '"+client_no+"' ")){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	
	out.println("<script>");
	out.println("alert('처리하였습니다.');");
	out.println("opener.location.reload();");
	out.println("location.href='pop_nhqv_req_view.jsp?"+u.getQueryString()+"';");
	out.println("</script>");
	return;
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_nhqv_req_view");
p.setVar("popup_title", gubun.equals("req")?"등록업체신청서":"등록업체 심사 평가표");
p.setVar("noti", noti);
p.setVar("cust", cust);
p.setVar("print_url","pop_nhqv_pdf_viewer.jsp?gubun="+u.aseEnc(gubun)+"&noti_seq="+u.aseEnc(noti_seq)+"&member_no="+u.aseEnc(client_no));
p.setVar("btn_modify_req", gubun.equals("req")&&cust.getString("status").equals("20"));
p.setVar("btn_modify_confirm", gubun.equals("req")&&cust.getString("status").equals("31"));
p.setVar("btn_save", gubun.equals("evaluate")&&u.inArray(cust.getString("status"), new String[]{"10","20","30","31"}));
p.setVar("btn_evaluate", gubun.equals("evaluate")&&cust.getString("status").equals("20"));
p.setVar("view_evaludate_etc", gubun.equals("evaluate"));
p.setVar("exe_convertHtml", gubun.equals("req")||(gubun.equals("evaluate")&&u.inArray(cust.getString("status"), new String[]{"40","50"})));
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>