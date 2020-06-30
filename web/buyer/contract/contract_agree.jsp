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
DataSet cont = contDao.find(where+" and member_no = "+_member_no+" ");
if(!cont.next()){
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}
if(!cont.getString("status").equals("10")){// 작성중만 삭제 가능
	u.jsError("계약건은 작성중 상태에서만 검토요청 가능 합니다.");
	return;
}

DB db = new DB();
//db.setDebug(out);

// 업체 전송전 내부 결재건으로 수정
contDao.item("mod_req_date","");
contDao.item("mod_req_reason","");
contDao.item("mod_req_member_no","");
contDao.item("reg_date", u.getTimeString());
contDao.item("status","11");  // 내부 결재 중
db.setCommand( contDao.getUpdateQuery(where), contDao.record);

DataObject agreeDao = new DataObject("tcb_cont_agree");
agreeDao.item("r_agree_person_id","");
agreeDao.item("r_agree_person_name","");
agreeDao.item("ag_md_date","");
agreeDao.item("mod_reason","");
db.setCommand(agreeDao.getUpdateQuery(where),agreeDao.record);

/* 계약로그 START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "검토요청",  "", "11","20");
/* 계약로그 END*/

if(!db.executeArray()){
	u.jsError("검토요청에 실패 하였습니다.");
	return;
}

//DataSet agree = agreeDao.find(where+" and length(r_agree_person_id)=0 and agree_cd='1' and length(agree_person_id) > 0"); // 파트너 서명전 검토자가 있고 그 검토자가 부서가 아닌 1명인 경우 처음 검토자에게 검토 메일 전송
DataSet agree = agreeDao.find(where+" and r_agree_person_id is null and agree_cd='1' and agree_person_id is not null"); // 오라클 변경 건으로 인하여 query 수정 skl 20161205

if(agree.next())
{
	// 이메일 알림.
	String to_member_name = ""; // 계약업체명
	String to_email = "";		// 검토자 이메일

	DataObject custDao = new DataObject("tcb_cust");
	DataSet dsCust = custDao.find("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq=2");	// 업체정보
	while(dsCust.next())
		to_member_name = dsCust.getString("member_name");

	DataObject personDao = new DataObject("tcb_person");
	DataSet dsPerson = personDao.find("user_id='"+agree.getString("agree_person_id")+"'");	// 검토자 정보
	if(dsPerson.next()){
		
		to_email = dsPerson.getString("email");

		//System.out.println("to_member_name : " + to_member_name);
		//System.out.println("to_email : " + to_email);

		p.clear();
		p.setVar("from_user_name", auth.getString("_MEMBER_NAME"));
		p.setVar("cust_name", to_member_name);
		p.setVar("cont_name", cont.getString("cont_name"));
		p.setVar("server_name", request.getServerName());
		p.setVar("cont_day", u.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));
		p.setVar("img_url", webUrl+"/images/email/20110620/");
		p.setVar("ret_url", webUrl+"/web/buyer/");
		u.mail(to_email, "[계약 검토 알림] \"" +  cont.getString("cont_name") + "\" 계약 검토를 요청하였습니다.", p.fetch("mail/cont_agree_req.html"));
		
		SmsDao smsDao= new SmsDao();
		smsDao.sendSMS("buyer", dsPerson.getString("hp1"), dsPerson.getString("hp2"), dsPerson.getString("hp3"), auth.getString("_USER_NAME")+"님이 계약 검토를 요청하였습니다. - 나이스다큐(일반기업용)");
	}

}

u.jsAlertReplace("계약서를 담당자에게 검토요청 하였습니다.\\n\\n진행중인계약 목록에서 전송한 계약건을 확인 할 수 있습니다."
,"contract_writing_list.jsp?"+u.getQueryString("cont_no, cont_chasu"));
%>