<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String email_random = u.request("email_random");
if(cont_no.equals("")||cont_chasu.equals("")||email_random.equals("")){
	out.print(false);
	return;
}

String where = "cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(where+" and email_random = '"+email_random+"'");
if(!cust.next()){
	out.print(false);
	return;
}

SmsDao smsDao= new SmsDao();
RandomString rndStr = new RandomString();
String sRandomString = rndStr.getString(6, "1");
try {
	smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), "인증번호: "+sRandomString + " 인증번호를 입력 후 계약서 조회 버튼을 클릭하세요.");
//System.out.println(sRandomString+" 을 입력하시면 됩니다.");
} catch (Exception e) {
	out.print(false);
}
session.setAttribute("_sRandomString", sRandomString);
out.print(true);
%>