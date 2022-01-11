<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
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
	String systemGubn	= "";
	String subject 		= "농심 전자계약 인증번호 안내";
	String message 		= "[전자계약][농심] 인증번호 안내\n"
			+ "[농심] 인증번호 [" + sRandomString + "]를 입력 후 계약서 조회 버튼을 클릭하세요.";
	// smsDao.sendKakaoTalk
	// 인증번호 전송
	
	// 2021.02.02 SMS 로 전환
	//smsDao.sendKakaoTalk(cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), "ESC-SD-0005", subject, message, message);
	smsDao.sendSMS(systemGubn,cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"),message );
	
} catch (Exception e) {
	out.print(false);
}
session.setAttribute("_sRandomString", sRandomString);
out.print(true);
%>