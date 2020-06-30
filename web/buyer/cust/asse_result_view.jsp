<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_kind_cd = { "S=>������", "R=>������"};//"N=>�ű���"
String[] code_div_cd = {"S=>����", "Q=>����"};

String asse_no = u.request("asse_no");
String div_cd = u.request("div_cd");
if(asse_no.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject asseDao = new DataObject("tcb_assemaster");
DataSet asse = asseDao.find("main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"' and status = '30'");
if(!asse.next()){
	u.jsError("�򰡰�ȹ ������ �����ϴ�.");
	return;
}

DataObject detailDao = new DataObject("tcb_assedetail");
DataSet detail = detailDao.find(" asse_no = '"+asse_no+"' and div_cd = '"+div_cd+"' and status = '20'");
if(!detail.next()){
	u.jsError("�򰡻� ������ �����ϴ�.");
	return;
}
detail.put("reg_date", u.getTimeString("yyyy-MM-dd", detail.getString("reg_date")));


if(u.isPost()&&f.validate()){		
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.asse_result_view");
p.setVar("menu_cd","000160");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000160", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setLoop("code_kind_cd", u.arr2loop(code_kind_cd) );
p.setVar("asse", asse);
p.setVar("detail", detail);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("asse_no,div_cd"));
p.display(out);
%>
