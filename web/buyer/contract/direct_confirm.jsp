<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu", "0");
String agree_seq = u.request("agree_seq");
if (cont_no.equals("") || cont_chasu.equals("") || agree_seq.equals("")) {
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'";
ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(where + " and member_no = " + _member_no);
if (!cont.next()) {
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}

DB db = new DB();

contDao = new ContractDao();
contDao.item("status", "50");
db.setCommand(contDao.getUpdateQuery("cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'"), contDao.record);

if (!agree_seq.equals("")) { // 내부 결재 프로세스가 있는 경우. 최종 서명되었더라도 표시
	DataObject agreeDao = new DataObject("tcb_cont_agree");
	agreeDao.item("ag_md_date", u.getTimeString());
	agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
	agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
	db.setCommand( agreeDao.getUpdateQuery("cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' and agree_seq = " + agree_seq), agreeDao.record);
}

/* 계약로그 START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no, String.valueOf(cont_chasu), auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 완료", "", "50", "10");
/* 계약로그 END*/

if (!db.executeArray()) {
	u.jsError("완료 처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("계약이 완료 되었습니다.\\n\\n완료된 계약건은 계약완료>완료된계약에서 확인 하실 수 있습니다.", "contract_send_list.jsp?" + u.getQueryString());
return;
%>