<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsErrClose("�������� ��η� ���� �ϼ���.");
	return;
}

DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu, "cont_etc1");
if(!cont.next()) {
	u.jsErrClose("�������� ��η� ���� �ϼ���.");
	return;
}

f.addElement("cont_etc1", cont.getString("cont_etc1"), "hname:'������Ʈ �ڵ�', required:'Y'");


//u.p("cust_detail_code : "+ cust.getString("cust_detail_code"));

if(u.isPost()&&f.validate()){
	DB db = new DB();

	//DataObject custDao2 = new DataObject("tcb_cust");

	contDao.item("cont_etc1", f.get("cont_etc1"));
	if(!contDao.update("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu)){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. ");
		return;
	} else {
		u.jsAlert("ó�� �Ǿ����ϴ�.");
	}

	out.println("<script language=\"javascript\" >");
	out.println("parent.location.reload();");
	out.println("</script>");

	return;
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("contract.pop_project_cd");
p.setVar("popup_title","�ڵ� ����");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>