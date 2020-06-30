<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="include_cont_push.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(where+" and member_no = "+_member_no+" ");
if(!cont.next()){
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}
if(!u.inArray(cont.getString("status"),new String[]{"11","12","20","30","40","41"})){
	u.jsError("계약건은 수정요청/반려 또는 서명요청 상태에서만 전송취소 가능합니다.");
	return;
}


DataObject contSubDao = new DataObject("tcb_cont_sub");
DataSet contSub = contSubDao.find(where,"*", " sub_seq asc");

DB db = new DB();

contDao.item("status","10");
if(!cont.getString("org_cont_html").equals("")){
	contDao.item("cont_html",cont.getString("org_cont_html"));
}
db.setCommand(contDao.getUpdateQuery(where), contDao.record);

while(contSub.next()){
	if(!contSub.getString("org_cont_sub_html").equals("")){
		contSubDao = new DataObject("tcb_cont_sub");
		contSubDao.item("cont_sub_html", contSub.getString("org_cont_sub_html"));
		db.setCommand(contSubDao.getUpdateQuery(where+ " and sub_seq = '"+contSub.getString("sub_seq")+"' "), contSubDao.record);
	}
}


db.setCommand("delete from tcb_cont_email where "+ where, null);

DataObject custDao = new DataObject("tcb_cust");
custDao.item("sign_dn","");
custDao.item("sign_data","");
custDao.item("sign_date","");
db.setCommand(custDao.getUpdateQuery(where),custDao.record);

DataObject agreeDao = new DataObject("tcb_cont_agree");
agreeDao.item("r_agree_person_id","");
agreeDao.item("r_agree_person_name","");
agreeDao.item("ag_md_date","");
agreeDao.item("mod_reason","");
db.setCommand(agreeDao.getUpdateQuery(where),agreeDao.record);

db.setCommand("delete from tcb_rfile_cust where "+ where, null);


if(!cont.getString("sign_types").equals("")){//서명 이미지 삭제
	db.setCommand("delete from tcb_cust_sign_img where "+ where ,null);
}

/* 계약로그 START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 작성중 상태로 변경",  "", "10","10");
/* 계약로그 END*/


if(!db.executeArray()){
	u.jsError("전송 취소 처리에 실패 하였습니다.");
	return;
}

//계약서 push
if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK스토아, 에스케이브로드밴드일 경우
	DataSet result = contPush_skstoa(cont_no, cont_chasu);//계약완료 push
	if(!result.getString("succ_yn").equals("Y")){
		u.sp(" skstore 계약정보 전송 실패!!!\npage:contract_send_cancel.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		u.mail("nicedocu@nicednr.co.kr","skstore 계약정보 전송 실패!!! ", " skstore 계약정보 전송 실패!!!\npage:contract_send_cancel.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
	}
}

u.jsAlertReplace("계약서를 작성중 상태로 변경 처리 하였습니다.\\n\\n임시저장 계약 메뉴로 이동 합니다.","contract_writing_list.jsp?");

return;
%>