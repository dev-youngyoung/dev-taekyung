<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
//메리츠 자동차 제휴 딜러계약 반려 처리 알림 발송후 계약서 삭제 딜러 회원 정보 삭제 처리
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";
DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find(where+" and member_no = "+_member_no+" and template_cd= '2019269' and status = '30'");
if(!cont.next()){
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}

DataObject payDao = new DataObject("tcb_pay");
DataSet pay = payDao.find(where);
if(pay.next()){
	u.jsError("해당 계약건으로 진행된 결재내역이 있습니다.\\n\\n계약건을 삭제 할 수 없습니다.");
	return;
}

DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(where+" and sign_seq = '2' ");
if(!cust.next()){
	u.jsError("거래처 정보가 없습니다.");
	return;
}

String subject = "[나이스다큐]"+auth.getString("_MEMBER_NAME")+" 안내";
String longMessage = "메리츠캐피탈 딜러(판매사원) 업무협약이 불가함을 알려드립니다.\n세부사항은 관할 지점(담당자)에 문의 부탁드립니다.\n감사합니다.\n-나이스다큐";
SmsDao smsDao = new SmsDao();
smsDao.sendLMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), subject, longMessage);

//개인정보 삭제 처리
int chk_cnt = custDao.findCount("member_no = '"+cust.getString("member_no")+"' and cont_no <> '"+cont.getString("cont_no")+"'  ");


//계약삭제 처리 진행
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(where+" and cfile_seq=1");
if(cfile.next()){
	if(!Startup.conf.getString("file.path.bcont_pdf").equals("") && !cfile.getString("file_path").equals("") && !cfile.getString("file_name").equals(""))
	{
		//System.out.println("DELETE FILE : " + Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name"));
		//u.delFile(Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name"));
	}
}

DataObject shareDao = new DataObject("tcb_share");
DataObject custSignImgDao = new DataObject("tcb_cust_sign_img");
DataObject contSubDao = new DataObject("tcb_cont_sub");
DataObject efileDao = new DataObject("tcb_efile");
DataObject rfileCustDao = new DataObject("tcb_rfile_cust");
DataObject rfileDao = new DataObject("tcb_rfile");
cfileDao = new DataObject("tcb_cfile");
DataObject StampDao = new DataObject("tcb_stamp");
DataObject warrDao = new DataObject("tcb_warr");
DataObject emailDao = new DataObject("tcb_cont_email");
custDao = new DataObject("tcb_cust");
DataObject contSignDao = new DataObject("tcb_cont_sign");
DataObject contAgreeDao = new DataObject("tcb_cont_agree");
DataObject contAddDao = new DataObject("tcb_cont_add");
DataObject contLogDao = new DataObject("tcb_cont_log");
contDao = new DataObject("tcb_contmaster");

DB db = new DB(); 
contDao.item("status", "00");
contDao.item("reg_date",   u.getTimeString()); 
db.setCommand(contDao.getUpdateQuery(" cont_no = '"+cont_no+"'"), contDao.record); // APP 연동으로 인해 APP쪽에서 상태코드가 필요하여 삭제-> 상태값 변경으로 변경

/* 계약로그 START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 삭제",  "", "00", "20");
/* 계약로그 END*/
 
//db.setDebug(out); 
if(!db.executeArray()){
	u.jsError("제휴거절 처리에 실패 하였습니다. ");
	return;
}  

u.jsAlertReplace("정상 처리 하였습니다.","contract_send_list.jsp?"+u.getQueryString("cont_no,cont_chasu,template_cd"));

%>