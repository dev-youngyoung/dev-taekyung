<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

//https가 이닌경우 https로변경
if(request.getServerName().endsWith("www.nicedocu.com")&&!request.isSecure()){
	u.redirect(request.getRequestURL().toString().replaceAll("http://", "https://")+"?"+u.getQueryString());
	return;
}

u.sp("------------email_msign_callback.jsp access------------");
u.sp();


String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String email_random = u.request("email_random");
if(cont_no.equals("")||cont_chasu.equals("")||email_random.equals("")){
	return;
}
boolean sign_able = false;

f.addElement("member_name",null, "hname:'이름', required:'Y'");
f.addElement("birth_date", null, "hname:'생년월일', required:'Y', fixbyte:'8'");
f.addElement("hp", null, "hname:'휴대폰번호', required:'Y'");

DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.query("select a.status, a.cont_no, a.cont_chasu, a.cont_name, c.member_name, c.user_name, c.tel_num from tcb_contmaster a, tcb_cont_template b, tcb_cust c "
			+ "where a.template_cd=b.template_cd "
			+ "and a.cont_no=c.cont_no "
			+ "and a.cont_chasu=c.cont_chasu "
			+ "and a.member_no=c.member_no "
			+ "and b.send_type='20' "
			+ "and a.cont_no='"+cont_no+"' and a.cont_chasu='"+cont_chasu+"' ");
if(!cont.next()){
	u.jsAlert("계약정보가 없습니다.");
	return;
}
cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));

if(!u.inArray( cont.getString("status"), new String[]{"20","21","30","40","41","50"})){
	u.jsAlert("계약조회가 가능한 상태가 아닙니다.");
	return;
}


String where = "cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(where+" and email_random = '"+email_random+"'");
if(!cust.next()){
	u.jsAlert("계약관계자 정보가 없습니다.");
	return;
} else {
    cust.put("email_random", email_random);
	if(!cust.getString("jumin_no").equals("")) {
		String jumin_no = u.aseDec(cust.getString("jumin_no"));
		if(jumin_no.length() > 8)
			jumin_no = jumin_no.substring(0,8);

		cust.put("jumin_no", jumin_no);

		if(cont.getString("status").equals("20") && cust.getString("sign_dn").equals("")){
			sign_able = true;
		}
	}
	if(!cust.getString("boss_birth_date").equals("")) {
		if(cont.getString("status").equals("20") && cust.getString("sign_dn").equals("")){
			sign_able = true;
		}
	}
}

p.setLayout("email_msign_contract");
p.setDebug(out);
p.setBody("sdd.email_msign_callback");
p.setVar("cont", cont);
p.setVar("cust", cust);
p.setVar("sign_able", sign_able);
p.setVar("form_script", f.getScript());
p.display(out);
%>