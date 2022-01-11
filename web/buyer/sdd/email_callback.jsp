<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String email_random = u.request("email_random");
if(cont_no.equals("")||cont_chasu.equals("")||email_random.equals("")){
	return;
}

DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.query("select a.cont_no from tcb_contmaster a, tcb_cont_template b "
			+ "where a.template_cd=b.template_cd "
			+ "and b.send_type='10' "
			+ "and a.cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' ");
if(!cont.next()){
	u.jsAlert("계약정보가 없습니다.");
	return;
}

String where = "cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(where+" and email_random = '"+email_random+"'");
if(!cust.next()){
	u.jsAlert("계약관계자 정보가 없습니다.");
	return;
}

String jumin_no = "";
boolean person_yn = false;
boolean sign_able = false;

if(!cust.getString("jumin_no").equals("")){
	jumin_no = u.aseDec(cust.getString("jumin_no"));
	jumin_no = jumin_no.substring(0,6);
  	person_yn = true;
}else{
	person_yn = false;
}

if(cust.getString("sign_dn").equals("")){
	sign_able = true;
}


if(u.isPost()&&f.validate()){
	String sign_dn = f.get("sign_dn");
	String sign_data = f.get("sign_data");

	Crosscert cert = new Crosscert();
	if (cert.chkSignVerify(sign_data).equals("SIGN_ERROR")){
		u.jsError("서명검증에 실패 하였습니다.");
		return;
	}
	if(!cert.getDn().equals(sign_dn)){
		u.jsError("서명검증 DN값이 일지 하지 않습니다.");
		return;
	}

	u.setCookie("email_contract_recvview", u.aseEnc(cont_no)+"-"+cont_chasu+"-"+email_random, 60*60*24*1);//1일간 쿠키에 인증 했음을 저장
	
	u.redirect("email_contract_recvview.jsp?"+u.getQueryString());
	return;
}

p.setLayout("email_contract");
p.setDebug(out);
p.setBody("sdd.email_callback");
p.setVar("popup_title","비회원 공동도급사 계약");
p.setVar("modify", true);
p.setVar("cust",cust);
p.setVar("person_yn", person_yn);
p.setVar("jumin_no", jumin_no);
p.setVar("sign_able", sign_able);
p.setVar("query", u.getQueryString());
p.setVar("query_encode", URLEncoder.encode(u.getQueryString(), "UTF-8"));
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>