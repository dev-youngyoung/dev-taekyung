<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(where+" and member_no = "+_member_no+" and paper_yn = 'Y' ");
if(!cont.next()){
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}
if(!u.inArray(cont.getString("status"),new String[]{"10"})){
	u.jsError("서면계약건은 작성중 상태에서만 작성완료처리 가능합니다.");
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
		payDao.item("cont_name", "(서면계약)" + cont.getString("cont_name"));
		payDao.item("pay_amount", iPayAmount);
		payDao.item("pay_type", "05");
		payDao.item("accept_date", u.getTimeString());
		payDao.item("receit_type","0");
		db.setCommand(payDao.getInsertQuery(), payDao.record);
	}
}

if(!db.executeArray()){
	u.jsError("처리에실패 하였습니다.");
	return;
}


u.jsAlertReplace("서면계약서를 작성완료처리 하였습니다.\\n\\n계약완료>서면계약 메뉴에서 조회 가능합니다.","contract_writing_list.jsp?"+u.getQueryString("cont_no,cont_chasu"));
return;
%>