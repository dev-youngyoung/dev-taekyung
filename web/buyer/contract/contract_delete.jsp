<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="nicelib.groupware.*"%>
<%@ include file="../contract/include_cont_push.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu", "0");
if (cont_no.equals("") || cont_chasu.equals("")) {
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'";
DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find(where + " and member_no = " + _member_no + " ");
if (!cont.next()) {
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}

String del_status = "10";
String del_mst = "작성중";
String link = "contract_writing_list.jsp?";
if ("Y".equals(cont.getString("subscription_yn"))) {
	del_status = "30";
	del_mst = "신청중";
	link = "subscription_list.jsp?";
}

if (!cont.getString("status").equals(del_status)) {// 작성중(subscription : 신청중)만 삭제 가능
	u.jsError("계약건은 " + del_mst + " 상태에서만 삭제 가능 합니다.");
	return;
}

/* 기존에 계약 삭제시에는 정말 데이터를 삭제 함, 혹시 몰라서 주석으로 남겨둠.
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(where + " and cfile_seq = 1");
if (cfile.next()) {
	if (!Startup.conf.getString("file.path.bcont_pdf").equals("") && !cfile.getString("file_path").equals("") && !cfile.getString("file_name").equals("")) {
		//System.out.println("DELETE FILE : " + Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name"));
		//u.delFile(Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name"));
	}
}

DataObject custSignImgDao = new DataObject("tcb_cust_sign_img"); // 계약서명이미지정보
DataObject contSubDao = new DataObject("tcb_cont_sub"); // 계약부가서식
DataObject rfileCustDao = new DataObject("tcb_rfile_cust"); // 계약구비서류파일정보
DataObject rfileDao = new DataObject("tcb_rfile"); // 계약구비서류정보
cfileDao = new DataObject("tcb_cfile"); // 계약서류
DataObject StampDao = new DataObject("tcb_stamp"); // 계약인지세정보
DataObject warrDao = new DataObject("tcb_warr"); // 계약보증정보
DataObject emailDao = new DataObject("tcb_cont_email"); // 계약이메일전송이력
DataObject custDao = new DataObject("tcb_cust"); // 계약관계업체정보
DataObject contSignDao = new DataObject("tcb_cont_sign"); // 계약관계설정정보
DataObject contAgreeDao = new DataObject("tcb_cont_agree"); // 계약결제라인정보
DataObject contAddDao = new DataObject("tcb_cont_add"); // 계약DB화컬럼정보
DataObject contLogDao = new DataObject("tcb_cont_log"); // 계약진행로그
contDao = new DataObject("tcb_contmaster"); // 계약정보

DB db = new DB();
//db.setDebug(out);
db.setCommand(custSignImgDao.getDeleteQuery(where), null);
db.setCommand(contSubDao.getDeleteQuery(where), null);
db.setCommand(rfileCustDao.getDeleteQuery(where), null);
db.setCommand(rfileDao.getDeleteQuery(where), null);
db.setCommand(cfileDao.getDeleteQuery(where), null);
db.setCommand(StampDao.getDeleteQuery(where), null);
db.setCommand(warrDao.getDeleteQuery(where), null);
db.setCommand(emailDao.getDeleteQuery(where), null);
db.setCommand(custDao.getDeleteQuery(where), null);
db.setCommand(contSignDao.getDeleteQuery(where), null);
db.setCommand(contAgreeDao.getDeleteQuery(where), null);
db.setCommand(contAddDao.getDeleteQuery(where), null);
db.setCommand(contLogDao.getDeleteQuery(where), null);
db.setCommand(contDao.getDeleteQuery(where), null);
*/

/* 우리 시스템의 삭제는 계약삭제이므로 그룹웨어에 기안 삭제는 전송하지 않는다.
boolean sendResult = true;
// 결재사용인 경우
if (cont.getString("appr_yn").equals("Y")) {
	if (!u.inArray(cont.getString("appr_status"), new String[]{"10"})) {
		DataSet approvalInfo = new DataSet();
		approvalInfo.addRow();
		approvalInfo.put("userID", auth.getString("_USER_ID"));
		approvalInfo.put("userName", auth.getString("_USER_NAME"));
		approvalInfo.put("jobID", Config.getApprovalDocumentType(););
		approvalInfo.put("contNo", cont_no);
		approvalInfo.put("contChasu", cont_chasu);
		approvalInfo.put("docID", cont_no);
		ApprovalSender approvalSender = new ApprovalSender();
		sendResult = approvalSender.sendApprovalDelete(approvalInfo);
	} else {
		sendResult = false;
	}
}

if (sendResult) {
	contDao = new DataObject("tcb_contmaster"); // 계약정보
	contDao.item("status", "10"); // 재기안이 가능하도록 상신대기(10)으로
	if (!contDao.update(where + " and member_no = " + _member_no + " ")) {
		u.jsError("삭제처리에 실패 하였습니다.");
		return;
	}
} */

contDao = new DataObject("tcb_contmaster"); // 계약정보
contDao.item("status", "95");
if (!contDao.update(where + " and member_no = " + _member_no + " ")) {
	u.jsError("삭제처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("삭제 처리 하였습니다.", link + u.getQueryString("cont_no,cont_chasu,template_cd"));
%>