<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String member_no = u.request("member_no");
if(cont_no.equals("")||cont_chasu.equals("")||member_no.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
ContractDao contDao = new ContractDao("tcb_contmaster");
DataSet cont = contDao.find(where);
if(!cont.next()){
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}

DB db = new DB();


DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(where + " and member_no = '"+member_no+"' " );
if(!cust.next()){
	u.jsError("무료처리 대상 업체가 없습니다.");
	return;
}
custDao.item("pay_yn","Y");
db.setCommand(custDao.getUpdateQuery(where+" and member_no = '"+member_no+"' "), custDao.record);
	



if(!db.executeArray()){
	u.jsError("처리에 실패 하였습니다.");
	return;
}
u.jsAlertReplace("처리 하였습니다.","contract_list.jsp?"+u.getQueryString("cont_no,cont_chasu,member_no"));
return;
%>