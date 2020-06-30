<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(where+" and member_no = "+_member_no+" and paper_yn = 'Y' ");
if(!cont.next()){
	u.jsError("������ ���� ���� �ʽ��ϴ�.");
	return;
}
if(!u.inArray(cont.getString("status"),new String[]{"10"})){
	u.jsError("��������� �ۼ��� ���¿����� �ۼ��Ϸ�ó�� �����մϴ�.");
	return;
}

DB db = new DB();
contDao.item("status","50");
db.setCommand(contDao.getUpdateQuery(where), contDao.record);


DataObject useInfoDao = new DataObject("tcb_useinfo");
DataSet useInfo = useInfoDao.find("member_no = '"+_member_no+"' and useseq = (select max(useseq) from tcb_useinfo where member_no = '"+_member_no+"' )");
if(useInfo.next()) {
	int iPayAmount = useInfo.getInt("paper_amt");
	if (iPayAmount > 0) {
		int iVatAmount = iPayAmount/10;
		iPayAmount = iPayAmount + iVatAmount;

		//tcb_pay insert
		DataObject payDao = new DataObject("tcb_pay");
		payDao.item("cont_no", cont_no);
		payDao.item("cont_chasu", cont_chasu);
		payDao.item("member_no", _member_no);
		payDao.item("cont_name", "(������)" + cont.getString("cont_name"));
		payDao.item("pay_amount", iPayAmount);
		payDao.item("pay_type", "05");
		payDao.item("accept_date", u.getTimeString());
		payDao.item("receit_type","0");
		db.setCommand(payDao.getInsertQuery(), payDao.record);
	}
}

if(!db.executeArray()){
	u.jsError("ó�������� �Ͽ����ϴ�.");
	return;
}


u.jsAlertReplace("�����༭�� �ۼ��Ϸ�ó�� �Ͽ����ϴ�.\\n\\n���Ϸ�>������ �޴����� ��ȸ �����մϴ�.","contract_writing_list.jsp?"+u.getQueryString("cont_no,cont_chasu"));
return;
%>