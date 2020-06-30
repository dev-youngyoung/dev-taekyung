<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="include_cont_push.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
String agree_seq = u.request("agree_seq");
int prev_seq = Integer.parseInt(agree_seq)-1;
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

// 승인 정보 취소
DataObject agreeDao = new DataObject("tcb_cont_agree");
agreeDao.item("ag_md_date", "");
agreeDao.item("r_agree_person_id", "");
agreeDao.item("r_agree_person_name", "");
db.setCommand(agreeDao.getUpdateQuery(where + " and agree_seq="+prev_seq), agreeDao.record);

int nagreeCnt = agreeDao.findCount(where +" and agree_cd='2' and agree_seq="+agree_seq);  // 업체 서명 후 승인 취소인 경우 승인대기로 변경
if(nagreeCnt==1)
{
	contDao.item("status", "21");  // 승인대기
	db.setCommand(contDao.getUpdateQuery(where), contDao.record);
}

/* 계약로그 START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "승인취소",  "", nagreeCnt==1?"21":cont.getString("status"),"20");
/* 계약로그 END*/

if(!db.executeArray()){
	u.jsError("승인 취소에 실패 하였습니다.");
	return;
}

DataSet agree = agreeDao.find(where +" and agree_seq = " + agree_seq, "*", "agree_seq", 1); // 다음 동의자에게 취소 알림
if(agree.next())
{
	// 이메일 알림.
	String cust_name = ""; // 계약업체명
	String to_email = "";		// 검토자 이메일

	DataObject custDao = new DataObject("tcb_cust");
	DataSet dsCust = custDao.find(where +" and sign_seq=2");	// 업체정보
	while(dsCust.next())
		cust_name = dsCust.getString("member_name");

	DataObject personDao = new DataObject("tcb_person");
	DataSet dsPerson = personDao.find("user_id='"+agree.getString("agree_person_id")+"'");	// 검토자 정보
	if(dsPerson.next())
	{
		to_email = dsPerson.getString("email");

		System.out.println("cust_name : " + cust_name);
		System.out.println("to_email : " + to_email);
		System.out.println("to_name : " + dsPerson.getString("user_name"));

		p.clear();
		p.setVar("from_user_name", auth.getString("_USER_NAME"));
		p.setVar("cust_name", cust_name);
		p.setVar("cont_name", cont.getString("cont_name"));
		p.setVar("cont_day", u.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));
		p.setVar("img_url", webUrl+"/images/email/20110620/");
		p.setVar("ret_url", webUrl+"/web/buyer/");
		u.mail(to_email, "[승인 취소 알림] \"" +  cont.getString("cont_name") + "\" 계약 승인을 취소 하였습니다.", p.fetch("mail/cont_agree_cancel.html"));
	}

}

//계약서 push
if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK스토아, 에스케이브로드밴드일 경우
	DataSet result = contPush_skstoa(cont_no, cont_chasu);//계약완료 push
	if(!result.getString("succ_yn").equals("Y")){
		u.sp(" skstore 계약정보 전송 실패!!!\npage:contract_agree_cancel.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		u.mail("nicedocu@nicednr.co.kr","skstore 계약정보 전송 실패!!! ", " skstore 계약정보 전송 실패!!!\npage:contract_agree_cancel.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
	}
}

u.jsAlertReplace("승인 취소 하였습니다.\\n\\n진행중인계약 목록에서 계약건을 확인 할 수 있습니다.","contract_send_list.jsp?"+u.getQueryString("cont_no, cont_chasu, agree_seq"));

%>