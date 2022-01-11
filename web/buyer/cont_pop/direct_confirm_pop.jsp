<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ include file="../contract/include_cont_push.jsp" %>
<%

String vcd = u.request("vcd");
String key = u.request("key");
String cert = u.request("cert");

String contstr = u.aseDec(key);  // 디코딩
if(contstr.length() != 12)
{
	out.print("No Permission!!");
	return;
}
String cont_no = contstr.substring(0,11);
String cont_chasu = contstr.substring(11);

String template_cd = u.request("template_cd");

String agree_seq = u.request("agree_seq");
if(cont_no.equals("")||cont_chasu.equals("")||agree_seq.equals("")){
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


DB db = new DB();

contDao = new ContractDao();
contDao.item("status", "50");
db.setCommand(contDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), contDao.record);

if(!agree_seq.equals("")) // 내부 결재 프로세스가 있는 경우. 최종 서명되었더라도 표시
{
	DataObject agreeDao = new DataObject("tcb_cont_agree");
	agreeDao.item("ag_md_date", u.getTimeString());
	agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
	agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
	db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_seq="+agree_seq),agreeDao.record);
}

if(u.inArray(cont.getString("template_cd"), new String[]{"2015109"}))  // 원료확약서, 올리브네트웍스 행사참여요청서(2016.4월부터 확인안하고 바로 업체 서명하면 결제)
{
//	status = "50";  // 서명완료
	int iPayAmount = 2000;
	int iVatAmount = iPayAmount/10;
	iPayAmount = iPayAmount+iVatAmount;

	db.setCommand("delete from tcb_pay where cont_no = '"+cont_no+"' and cont_chasu="+cont_chasu, null);

	//tcb_pay insert
	DataObject payDao = new DataObject("tcb_pay");
	payDao.item("cont_no", cont_no);
	payDao.item("cont_chasu", cont_chasu);
	payDao.item("member_no", _member_no);
	payDao.item("cont_name", cont.getString("cont_name")+"(대납)");
	payDao.item("pay_amount", iPayAmount);
	payDao.item("pay_type", "05");
	payDao.item("accept_date", u.getTimeString());
	payDao.item("receit_type","0");
	db.setCommand(payDao.getInsertQuery(), payDao.record);

	//tcb_cust update
	DataObject custPayDao = new DataObject("tcb_cust");
	custPayDao.item("pay_yn", "Y");
	db.setCommand(custPayDao.getUpdateQuery("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no= '"+_member_no+"' "),custPayDao.record);
}


/* 계약로그 START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 완료",  "", "50", "10");
/* 계약로그 END*/

if(!db.executeArray()){
	u.jsError("완료 처리에 실패 하였습니다.");
	return;
}

//계약서 push
if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK스토아, 에스케이브로드밴드일 경우
	DataSet result = contPush_skstoa(cont_no, cont_chasu);//계약완료 push
	if(!result.getString("succ_yn").equals("Y")){
		u.sp(" skstore 계약정보 전송 실패!!!\npage:direct_confirm_pop.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		u.mail("nicedocu@nicednr.co.kr","skstore 계약정보 전송 실패!!! ", " skstore 계약정보 전송 실패!!!\npage:direct_confirm_pop.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
	}
}

u.jsErrClose("계약이 완료 되었습니다.\\n\\n완료된 계약건은 계약완료>완료된계약에서 확인 하실 수 있습니다.");
return;
%>