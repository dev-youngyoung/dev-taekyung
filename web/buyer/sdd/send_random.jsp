<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String email_random = u.request("email_random");
if(cont_no.equals("")||cont_chasu.equals("")||email_random.equals("")){
	return;
}

String where = "cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(where+" and email_random = '"+email_random+"'");
if(!cust.next()){
	u.jsAlert("계약관계자 정보가 없습니다.");
	return;
}

SmsDao smsDao= new SmsDao();
RandomString rndStr = new RandomString();
String sRandomString = rndStr.getString(6, "a1");
smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), sRandomString+" 을 입력하시면 됩니다.");
//System.out.println(sRandomString+" 을 입력하시면 됩니다.");

session.setAttribute("_sRandomString", sRandomString);

out.print("<script>");
out.print("alert('인증코드를 전송했습니다.');");
out.print("</script>");
%>