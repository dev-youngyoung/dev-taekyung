<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

f.addElement("hp1", u.request("s_hp1"), "hname:'받는번호', required:'Y', fixbyte:'3'");
f.addElement("hp2", u.request("s_hp2"), "hname:'받는번호', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", u.request("s_hp3"), "hname:'받는번호', required:'Y', fixbyte:'4'");
f.addElement("content",null, "hname:'메세지', required:'Y'");

DataSet ds = null;

if(u.isPost()&&f.validate()){
	
	SmsDao mm = new SmsDao();
	if(!mm.sendSMS("fc", f.get("hp1"), f.get("hp2"), f.get("hp3"), f.get("content"))){
		u.jsError("전송에 실패 하였습니다.");
		return;
	}
	u.jsErrClose("전송에 성공 하였습니다.");
	return;
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("mgr.pop_send_sms");
p.setVar("popup_title","SMS전송");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>