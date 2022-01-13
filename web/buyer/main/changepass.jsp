<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%@ include file="../chk_login.jsp" %>
<%

String sServerName = request.getServerName();
String sUrl = "./changepass.jsp";

if(u.request("passdate_done").equals("Y")){
	Cookie cookie = new Cookie("passdate_done", u.getTimeString());
	cookie.setMaxAge(60*60*24*14); // 유효기간 한달
	response.addCookie(cookie);    // 쿠키를 응답에 추가해줌
	u.redirect("./index2.jsp");
	return;
}

f.addElement("now_passwd", null, "hname:'현재 비밀번호', required:'Y'");
f.addElement("passwd", null, "hname:'비밀번호', required:'Y', option:'userpw', match:'passwd2', minbyte:'8', mixbyte:'20'");

if(u.isPost()&&f.validate()){
	DataObject personDao = new DataObject("tcb_person");
	DataSet person = personDao.find("member_no = '"+_member_no+"' and person_seq = '"+auth.getString("_PERSON_SEQ")+"' ");
	if(!person.next()){
	}
	
	if( !u.sha256(f.get("now_passwd")).equals(person.getString("passwd")) ){
		u.jsError("현재 비밀번호가 일치 하지 않습니다.\\n\\n사용중인 비밀번호를 확인해 주세요.");
		return;
	}
	
	personDao = new DataObject("tcb_person");
	personDao.item("passwd", u.sha256(f.get("passwd")));
	personDao.item("passdate", u.getTimeString());
	if(!personDao.update(" member_no = '"+_member_no+"' and person_seq = '"+auth.getString("_PERSON_SEQ")+"' ")){
		u.jsError("저장처리에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("비밀번호를 저장하였습니다.", "http://"+sServerName+"/web/buyer/main/index2.jsp");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("main.changepass");
p.setVar("action", sUrl);
p.setVar("form_script",f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString());
p.display(out);
%>