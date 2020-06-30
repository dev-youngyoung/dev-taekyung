<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%@ include file="../chk_login.jsp" %>
<%

String sServerName = request.getServerName();
String sUrl = "./changepass.jsp";

if(u.request("passdate_done").equals("Y")){
	Cookie cookie = new Cookie("passdate_done", u.getTimeString());
	cookie.setMaxAge(60*60*24*14); // ��ȿ�Ⱓ �Ѵ�
	response.addCookie(cookie);    // ��Ű�� ���信 �߰�����
	u.redirect("./index2.jsp");
	return;
}

f.addElement("now_passwd", null, "hname:'���� ��й�ȣ', required:'Y'");
f.addElement("passwd", null, "hname:'��й�ȣ', required:'Y', option:'userpw', match:'passwd2', minbyte:'8', mixbyte:'20'");

if(u.isPost()&&f.validate()){
	DataObject personDao = new DataObject("tcb_person");
	DataSet person = personDao.find("member_no = '"+_member_no+"' and person_seq = '"+auth.getString("_PERSON_SEQ")+"' ");
	if(!person.next()){
	}
	
	if( !u.sha256(f.get("now_passwd")).equals(person.getString("passwd")) ){
		u.jsError("���� ��й�ȣ�� ��ġ ���� �ʽ��ϴ�.\\n\\n������� ��й�ȣ�� Ȯ���� �ּ���.");
		return;
	}
	
	personDao = new DataObject("tcb_person");
	personDao.item("passwd", u.sha256(f.get("passwd")));
	personDao.item("passdate", u.getTimeString());
	if(!personDao.update(" member_no = '"+_member_no+"' and person_seq = '"+auth.getString("_PERSON_SEQ")+"' ")){
		u.jsError("����ó���� ���� �Ͽ����ϴ�.");
		return;
	}
	u.jsAlertReplace("��й�ȣ�� �����Ͽ����ϴ�.", "http://"+sServerName+"/web/buyer/main/index2.jsp");
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