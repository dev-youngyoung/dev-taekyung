<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
//NH���� ���� ���� ��Ͼ�ü ��û ���� ������
String noti_seq = u.request("noti_seq");
String gubun = u.request("gubun");
if(noti_seq.equals("")|| gubun.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject notiDao = new DataObject("tcb_recruit_noti");
DataSet noti = notiDao.find("member_no = '20160901598' and noti_seq = '"+noti_seq+"' ");
if(!noti.next()){
	u.jsError("���� ������ �����ϴ�.");
	return;
}
noti.put("display_req", gubun.equals("req")?"":"none");
noti.put("display_evaluate", gubun.equals("evaluate")?"":"none");

if(u.isPost()&&f.validate()){
	
	
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_nhqv_template_view");
p.setVar("popup_title", gubun.equals("req")?"��Ͼ�ü��û��":"��Ͼ�ü �ɻ� ��ǥ");
p.setVar("noti", noti);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>