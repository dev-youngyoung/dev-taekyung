<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cert_dn = u.request("cert_dn");
String cert_end_date = u.request("cert_end_date");
String sign_data = u.request("sign_data");
if(cert_dn.equals("")||cert_end_date.equals("")||sign_data.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}


Crosscert crosscert = new Crosscert();
crosscert.setEncoding("UTF-8");
if (crosscert.chkSignVerify(sign_data).equals("SIGN_ERROR")){
	u.jsError("서명검증에 실패 하였습니다.");
	return;
}
if(!crosscert.getDn().equals(cert_dn)){
	u.jsError("서명검증 DN값이 일지 하지 않습니다.");
	return;
}

DataObject member = new DataObject("tcb_member");
member.item("cert_dn",cert_dn);
member.item("cert_end_date", cert_end_date);
if(!member.update("member_no = '"+_member_no+"' ")){
	u.jsError("저장에 실패 하였습니다.");
	return;
}

auth.put("_CERT_DN",cert_dn);
auth.put("_CERT_END_DATE", u.getTimeString("yyyyMMdd",cert_end_date));
auth.setAuthInfo();
u.jsAlertReplace("인증서를 등록 하였습니다.", "cert_info.jsp");
	
%>