<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="include_cont_push.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
String agree_seq = u.request("agree_seq");
if(cont_no.equals("")||cont_chasu.equals("")||agree_seq.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(where+" and member_no = '"+_member_no+"' ");
if(!cont.next()){
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}

if(!u.inArray(cont.getString("status"), new String[]{"11","21"})){
	u.jsError("내부 결재 중인 상태에서만 승인이 가능 합니다.");
	return;
}


DB db = new DB();

// 업체 전송전 내부 결재건인지 확인
DataObject agreeDao = new DataObject("tcb_cont_agree");


int nagreeCnt = agreeDao.findCount(where +" and agree_cd = '2' and (length(trim(r_agree_person_id))=0 or r_agree_person_id is null)");  // 업체 서명 후 승인자들 수
if(nagreeCnt==2) // 마지막 1명만 남은 경우 (2로 체크하는 이유는 아직 내부결재 DB에 실제 업데이트 전이라서 임)
{
	contDao.item("mod_req_date","");
	contDao.item("mod_req_member_no","");
	contDao.item("mod_req_reason","");
	contDao.item("status", "30");  // 서명대기
	db.setCommand(contDao.getUpdateQuery(where), contDao.record);
}

agreeDao.item("ag_md_date", u.getTimeString());
agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
db.setCommand(agreeDao.getUpdateQuery(where + " and agree_seq="+agree_seq), agreeDao.record);

/* 계약로그 START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "검토 승인",  "", nagreeCnt==2?"30":cont.getString("status"), "20");
/* 계약로그 END*/

if(!db.executeArray()){
	u.jsError("승인에 실패 하였습니다.");
	return;
}


DataSet agree = agreeDao.find(where +" and (length(trim(r_agree_person_id))=0 or r_agree_person_id is null) and length(trim(agree_person_id)) > 0", "*", "agree_seq", 1); // 검토자가 있고 그 검토자가 부서가 아닌 1명인 경우 다음 검토자에게 메일 전송

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
		if(!dsPerson.getString("user_id").equals("mns1135005")){// ktm&s 서명 담당자 강혜인님 알리 제거  일괄계약 끝나면 제거_20141112
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
			u.mail(to_email, "[계약 검토 알림] \"" +  cont.getString("cont_name") + "\" 계약 검토를 요청하였습니다.", p.fetch("mail/cont_agree_req.html"));
	
			SmsDao smsDao= new SmsDao();
			if(!_member_no.equals("20150500312")) // 더블유쇼핑 제외(문자가 너무 많이 온다함)
			{
				smsDao.sendSMS("buyer", dsPerson.getString("hp1"), dsPerson.getString("hp2"), dsPerson.getString("hp3"), auth.getString("_USER_NAME")+"님이 "+cust_name+" 계약 검토 요청. - 나이스다큐(일반기업용)");
			}
		}
	}

}

//계약서 push
if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK스토아, 에스케이브로드밴드일 경우
	DataSet result = contPush_skstoa(cont_no, cont_chasu);//계약완료 push
	if(!result.getString("succ_yn").equals("Y")){
		u.sp(" skstore 계약정보 전송 실패!!!\npage:contract_confirm.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		u.mail("nicedocu@nicednr.co.kr","skstore 계약정보 전송 실패!!! ", " skstore 계약정보 전송 실패!!!\npage:contract_confirm.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
	}
}


u.jsAlertReplace("계약서를 승인 하였습니다.\\n\\n진행중인계약 목록에서 승인한 계약건을 확인 할 수 있습니다.","contract_send_list.jsp?"+u.getQueryString("cont_no, cont_chasu, agree_seq"));

%>