<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String gubun = u.request("gubun");
if(cont_no.equals("")||cont_chasu.equals("")||gubun.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
ContractDao contDao = new ContractDao("tcb_contmaster");
DataSet cont = contDao.find(where);
if(!cont.next()){
	u.jsError("������ ���� ���� �ʽ��ϴ�.");
	return;
}

DB db = new DB();

if(gubun.equals("hide")){
	contDao = new ContractDao("tcb_contmaster");
	contDao.item("status","00");
	db.setCommand(contDao.getUpdateQuery(where), contDao.record);
}else
if(gubun.equals("finish")){
	contDao = new ContractDao("tcb_contmaster");
	contDao.item("status","50");
	db.setCommand(contDao.getUpdateQuery(where), contDao.record);
}else
if(gubun.equals("writing")){
	
	DataObject contSubDao = new DataObject("tcb_cont_sub");
	DataSet contSub = contSubDao.find(where,"*", " sub_seq asc");
	
	//��ü����
	DataObject emailDao = new DataObject("tcb_cont_email");		// �̸���
	DataObject rfileCustDao = new DataObject("tcb_rfile_cust");	// ��ü���񼭷�
	DataObject custDao = new DataObject("tcb_cust");			// ����ü

	contDao.item("status", "10");
	if(!cont.getString("org_cont_html").equals("")){
		contDao.item("cont_html", cont.getString("org_cont_html"));
	}
	db.setCommand(contDao.getUpdateQuery(where), contDao.record);
	
	while(contSub.next()){
		if(!contSub.getString("org_cont_sub_html").equals("")){
			contSubDao = new DataObject("tcb_cont_sub");
			contSubDao.item("cont_sub_html", contSub.getString("org_cont_sub_html"));
			db.setCommand(contSubDao.getUpdateQuery(where+ " and sub_seq = '"+contSub.getString("sub_seq")+"' "), contSubDao.record);
		}
	}
	
	db.setCommand(emailDao.getDeleteQuery(where),null);
	db.setCommand(rfileCustDao.getDeleteQuery(where+" and member_no <> (select member_no from tcb_contmaster where "+where+" )"),null);

	custDao.item("sign_dn","");
	custDao.item("sign_data","");
	custDao.item("sign_date","");
	db.setCommand(custDao.getUpdateQuery(where), custDao.record);
	
	db.setCommand("delete from tcb_cust_sign_img where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
}

if(!db.executeArray()){
	u.jsError("����ó���� ���� �Ͽ����ϴ�.");
	return;
}
u.jsAlertReplace("ó�� �Ͽ����ϴ�.","contract_list.jsp?"+u.getQueryString("cont_no,cont_chasu,gubun"));
return;
%>