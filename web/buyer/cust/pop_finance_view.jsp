<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String asse_no = u.request("asse_no", "");
if(asse_no.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

DataObject assessmentDao = new DataObject("tcb_assemaster a  inner join tcb_assedetail b on a.asse_no = b.asse_no and b.div_cd = 'S'");
DataSet assessment = assessmentDao.find(" a.asse_no = '"+asse_no+"'", "a.*, b.asse_html, b.asse_subhtml, b.div_cd");
if(!assessment.next()){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_finance_view");
p.setVar("popup_title","�繫��");
p.setVar("assessment", assessment);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>