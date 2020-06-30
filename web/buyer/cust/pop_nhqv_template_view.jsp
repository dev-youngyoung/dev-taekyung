<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
//NH투자 증권 전용 등록업체 신청 전용 페이지
String noti_seq = u.request("noti_seq");
String gubun = u.request("gubun");
if(noti_seq.equals("")|| gubun.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject notiDao = new DataObject("tcb_recruit_noti");
DataSet noti = notiDao.find("member_no = '20160901598' and noti_seq = '"+noti_seq+"' ");
if(!noti.next()){
	u.jsError("공고 정보가 없습니다.");
	return;
}
noti.put("display_req", gubun.equals("req")?"":"none");
noti.put("display_evaluate", gubun.equals("evaluate")?"":"none");

if(u.isPost()&&f.validate()){
	
	
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_nhqv_template_view");
p.setVar("popup_title", gubun.equals("req")?"등록업체신청서":"등록업체 심사 평가표");
p.setVar("noti", noti);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>