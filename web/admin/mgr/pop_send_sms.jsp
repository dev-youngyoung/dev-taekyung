<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

f.addElement("hp1", u.request("s_hp1"), "hname:'�޴¹�ȣ', required:'Y', fixbyte:'3'");
f.addElement("hp2", u.request("s_hp2"), "hname:'�޴¹�ȣ', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", u.request("s_hp3"), "hname:'�޴¹�ȣ', required:'Y', fixbyte:'4'");
f.addElement("content",null, "hname:'�޼���', required:'Y'");

DataSet ds = null;

if(u.isPost()&&f.validate()){
	
	SmsDao mm = new SmsDao();
	if(!mm.sendSMS("fc", f.get("hp1"), f.get("hp2"), f.get("hp3"), f.get("content"))){
		u.jsError("���ۿ� ���� �Ͽ����ϴ�.");
		return;
	}
	u.jsErrClose("���ۿ� ���� �Ͽ����ϴ�.");
	return;
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("mgr.pop_send_sms");
p.setVar("popup_title","SMS����");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>