<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="../contract/include_cont_push.jsp" %>
<%

String contstr = u.aseDec(u.request("key"));  // 디코딩
String cont_no = contstr.substring(0,11);
String cont_chasu = contstr.substring(11);

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find(where+" and member_no = "+_member_no+" ");
if(!cont.next()){
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}

String supp_member_no = "";
if(!cont.getString("bid_no").equals("")){
	DataObject custDao = new DataObject("tcb_cust");
	DataSet cust = custDao.find( where + " and sign_seq = '2' " );//을사 회원번호 구하기
	if(!cust.next()){
		u.jsError("계약업체 정보가 존재하지 않습니다.");
	}
	supp_member_no = cust.getString("member_no");
}

if(!cont.getString("status").equals("10")){// 작성중만 삭제 가능
	u.jsError("계약건은 작성중 상태에서만 삭제 가능 합니다.");
	return;
}

DataObject payDao = new DataObject("tcb_pay");
DataSet pay = payDao.find(where);
if(pay.next()){
	u.jsError("해단 계약건으로 진행된 결재내역이 있습니다.\\n\\n계약건을 삭제 할 수 없습니다.");
	return;
}

//계약서 push
if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK스토아, 에스케이브로드밴드일 경우
	DataSet result = contPush_skstoa(cont_no, cont_chasu,"99");//계약완료 push
	if(!result.getString("succ_yn").equals("Y")){
		u.sp(" skstore 계약정보 전송 실패!!!\npage:contract_delete_pop.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		u.mail("nicedocu@nicednr.co.kr","skstore 계약정보 전송 실패!!! ", " skstore 계약정보 전송 실패!!!\npage:contract_delete_pop.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
	}
}

//더블유 쇼핑 삭제 이력 연동으로 인햐여 상태 코드만 00 으로 변경 업체에 줄때는 삭제 코드 98로 decode하여 연동
//아워홈 삭제 이력 연동으로 인햐여 상태 코드만 00 으로 변경 업체에 줄때는 삭제 코드 98로 decode하여 연동
if(u.inArray( _member_no , new String[]{"20150500312","20170501348"})){
	DB db = new DB();
	contDao = new DataObject("tcb_contmaster");
	contDao.item("reg_date",u.getTimeString());
	contDao.item("status", "00");
	db.setCommand(contDao.getUpdateQuery(where), contDao.record);
	/* 계약로그 START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 삭제",  "", "00", "10");
	/* 계약로그 END*/
	if(!db.executeArray()){
		u.jsError("삭제처리에 실패 하였습니다.");
		return;
	}
	
}else{
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
	DataObject custDao = new DataObject("tcb_cust");
	DataObject contSignDao = new DataObject("tcb_cont_sign");
	DataObject contAgreeDao = new DataObject("tcb_cont_agree");
	DataObject contAddDao = new DataObject("tcb_cont_add");
	DataObject contLogDao = new DataObject("tcb_cont_log");
	contDao = new DataObject("tcb_contmaster");
	
	DB db = new DB();
	//db.setDebug(out);
	db.setCommand(shareDao.getDeleteQuery(where) ,null);
	db.setCommand(custSignImgDao.getDeleteQuery(where) ,null);
	db.setCommand(contSubDao.getDeleteQuery(where),null);
	db.setCommand(efileDao.getDeleteQuery(where),null);
	db.setCommand(rfileCustDao.getDeleteQuery(where),null);
	db.setCommand(rfileDao.getDeleteQuery(where),null);
	db.setCommand(cfileDao.getDeleteQuery(where),null);
	db.setCommand(StampDao.getDeleteQuery(where),null);
	db.setCommand(warrDao.getDeleteQuery(where),null);
	db.setCommand(emailDao.getDeleteQuery(where),null);
	db.setCommand(custDao.getDeleteQuery(where),null);
	db.setCommand(contSignDao.getDeleteQuery(where),null);
	db.setCommand(contAgreeDao.getDeleteQuery(where),null);
	db.setCommand(contLogDao.getDeleteQuery(where),null);
	db.setCommand(contAddDao.getDeleteQuery(where),null);
	db.setCommand(contDao.getDeleteQuery(where),null);
	if((!cont.getString("bid_no").equals(""))&&!cont.getString("bid_deg").equals("")){
	db.setCommand(
			       " update tcb_bid_supp set cont_no = null          "
	              +"  where main_member_no = '"+_member_no+"'        "
	              +"    and bid_no = '"+cont.getString("bid_no")+"' "
	              +"    and bid_deg = '"+cont.getString("bid_deg")+"'"
	              +"    and member_no = '"+supp_member_no+"'         "
	              +"    and cont_no = '"+cont_no+"' 				 "
	               ,null);
	}
	if(!db.executeArray()){
		u.jsError("삭제처리에 실패 하였습니다.");
		return;
	}
}

u.jsErrClose("삭제 처리 하였습니다.");	
%>
