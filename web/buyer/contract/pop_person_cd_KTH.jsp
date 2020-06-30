<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String cust_member_no = u.request("cust_member_no");

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsErrClose("�������� ��η� ���� �ϼ���.");
	return;
}

DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu+" and member_no = '" + cust_member_no + "'", "cust_detail_code");
if(!cust.next()) {
	u.jsErrClose("�������� ��η� ���� �ϼ���.");
	return;
}

f.addElement("cust_detail_code", cust.getString("cust_detail_code"), "hname:'�ŷ�ó �ڵ�', required:'Y'");


//u.p("cust_detail_code : "+ cust.getString("cust_detail_code"));

if(u.isPost()&&f.validate()){
	DB db = new DB();

	DataObject custDao2 = new DataObject("tcb_cust");

	custDao2.item("cust_detail_code", f.get("cust_detail_code"));
	db.setCommand(custDao2.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu+" and member_no = '" + cust_member_no + "'"),custDao2.record);
	
	DataObject detailDao = new DataObject("tcb_client_detail");
	String client_seq = detailDao.getOne(" select client_seq from tcb_client where member_no = '"+_member_no+"' and client_no = '"+cust_member_no+"' ");
	detailDao.item("member_no", _member_no);
	detailDao.item("person_seq", "1");
	detailDao.item("client_seq", client_seq);
	detailDao.item("client_detail_seq", "1");
	detailDao.item("cust_detail_code", f.get("cust_detail_code"));
	
	if(detailDao.findCount(" member_no = '"+_member_no+"' and  client_seq = '"+client_seq+"'  ")> 0 ){
		db.setCommand(detailDao.getUpdateQuery("person_seq = '1' and member_no = '"+_member_no+"' and client_seq = '"+client_seq+"'"), detailDao.record);			
	}else{
		db.setCommand(detailDao.getInsertQuery(),detailDao.record);
	}
	
	if(!db.executeArray()){
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
p.setBody("contract.pop_person_cd_KTH");
p.setVar("popup_title","�ŷ�ó �ڵ�");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>