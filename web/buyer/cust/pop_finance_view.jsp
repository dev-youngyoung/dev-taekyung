<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%

String asse_no = u.request("asse_no", "");
if(asse_no.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

DataObject assessmentDao = new DataObject("tcb_assemaster a  inner join tcb_assedetail b on a.asse_no = b.asse_no and b.div_cd = 'S'");
DataSet assessment = assessmentDao.find(" a.asse_no = '"+asse_no+"'", "a.*, b.asse_html, b.asse_subhtml, b.div_cd");
if(!assessment.next()){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_finance_view");
p.setVar("popup_title","재무평가");
p.setVar("assessment", assessment);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>