<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%
// http://dev.nicedocu.com/web/buyer/contract/cin.jsp?key=910031eebfa3a97b52c7d44580bf4d66  개발
// http://www.nicedocu.com/web/buyer/contract/cin.jsp?key=a69b5e466231b9864c44e2ddb7abcef2  리얼
if(!auth.isValid()){
	u.redirect("cin_login.jsp?"+u.getQueryString());
}


String key = u.request("key");
if(key.length() == 0)
{
	u.p("잘못된 접근입니다.[1]");
	return;
}

String contstr = u.aseDec(key);  // 디코딩
if(contstr.length() != 12)
{
	u.p("잘못된 접근입니다.[2]");
	return;
}
String cont_no = contstr.substring(0,11);
String cont_chasu = contstr.substring(11);

DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu="+cont_chasu, "member_no, template_cd, status, sign_types");

if(!cont.next())
{
	u.p("잘못된 접근입니다.[3]");
	return;
}

if(!cont.getString("member_no").equals(auth.getString("_MEMBER_NO")))
{
	u.p("잘못된 접근입니다.[4]");
	return;
}

if(auth.getString("_MEMBER_NO").equals("20150600110")){
	//티알엔은 전체를 다 조회 함.
}else if(!cont.getString("status").equals("50")){
	CodeDao codeDao = new CodeDao("tcb_comcode");
	String[] code_status = codeDao.getCodeArray("M008");
	
	u.p("완료된 계약이 아니므로 조회하실 수 없습니다.<br><br>현재 계약 상태는 <font color='red'>" + u.getItem(cont.getString("status"),code_status) + "</font>입니다.");
	return;
}

if(cont.getString("sign_types").equals("")){
	if(!cont.getString("template_cd").equals("")) {
		if(cont.getString("status").equals("10")) {//작성중
			u.redirect("contract_modify.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // 서식계약
		}else if(cont.getString("status").equals("50")){//완료
			u.redirect("contend_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // 서식계약
		}else{//진행중
			u.redirect("contract_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // 서식계약
		}
	}else {
		if(cont.getString("status").equals("10")) {//작성중
			u.redirect("contract_free_modify.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // 서식계약
		}else if(cont.getString("status").equals("50")){//완료
			u.redirect("contend_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // 서식계약
		}else{//진행중
			u.redirect("contract_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // 서식계약
		}
	}
}else{
	if(cont.getString("status").equals("10")) {//작성중
		u.redirect("contract_msign_modify.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // 서식계약
	}else if(cont.getString("status").equals("50")){//완료
		u.redirect("contend_msign_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // 서식계약
	}else{//진행중
		u.redirect("contract_msign_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // 서식계약
	}
}
%>