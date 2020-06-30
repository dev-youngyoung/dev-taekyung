<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String warr_seq = u.request("warr_seq");
if(cont_no.equals("")||cont_chasu.equals("")||warr_seq.equals("")){
	u.jsErrClose("정상적인 경로로 접근해 주세요.");
	return;
}

ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cont.next()){
	u.jsError("계약정보가 존재하지 않습니다.");
	return;
}

DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and warr_seq = '"+warr_seq+"' ");
if(!warr.next()){
	u.jsError("갱신대상 보증 정보가 없습니다.");
	return;
}

String new_warr_seq = warrDao.getOne("select nvl(max(warr_seq),0)+1 from tcb_warr where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
warrDao = new DataObject("tcb_warr");
warrDao.item("cont_no", cont_no);
warrDao.item("cont_chasu", cont_chasu);
warrDao.item("member_no", "");
warrDao.item("warr_seq", new_warr_seq);
warrDao.item("warr_type", warr.getString("warr_type"));
warrDao.item("etc", warr.getString("etc"));
if(!warrDao.insert()){
	u.jsError("처리에 실패 하였습니다.");
	return;
}
u.jsAlertReplace("갱신된 보증정보를 입력 후 저장 하세요.", "pop_warr_modify.jsp?"+u.getQueryString("warr_seq")+"&warr_seq="+new_warr_seq);

%>