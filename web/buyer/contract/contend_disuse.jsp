<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

String where = "cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";

DataObject contDao = new DataObject("tcb_contmaster");
contDao.setDebug(out);
DataSet cont  = contDao.find(where+" and member_no= '"+_member_no+"' ");
if(!cont.next()){
	//u.jsError(" 계약정보가 존재 하지 않습니다.");
	return;
}

if(!cont.getString("status").equals("50")){
	u.jsError("계약완료 상태에서만 폐기 처리 가능 합니다.");
	return;
}


DB db = new DB();
contDao.item("status","99");
contDao.item("mod_req_date",u.getTimeString());
db.setCommand(contDao.getUpdateQuery(where), contDao.record);

/* 계약로그 START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 폐기",  "", "92","10");
/* 계약로그 END*/

if(!db.executeArray()){
	u.jsError("처리에 실패 하였습니다.");
	return;
}
String callback = "contend_sendview.jsp";
if(!cont.getString("sign_types").equals("")){
	callback = "contend_msign_sendview.jsp";
}

u.jsAlertReplace("계약서 폐기처리 하였습니다.", "./"+callback+"?"+u.getQueryString());

%>