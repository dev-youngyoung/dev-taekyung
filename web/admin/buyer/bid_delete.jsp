<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String main_member_no = u.request("main_member_no");
String bid_no = u.request("bid_no");
String bid_deg = u.request("bid_deg");
if(main_member_no.equals("")||bid_no.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

String where = "main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"' ";

DataObject bidDao = new DataObject("tcb_bid_master");
DataSet bid = bidDao.find(where);
if(!bid.next()){
	u.jsError("입찰 정보가 없습니다.");
	return;
}


DB db = new DB();

/*입찰공람삭제*/
DataObject shareDao = new DataObject("tcb_bid_share");
db.setCommand(shareDao.getDeleteQuery(where), null);

/* 요청 첨부파일(등록평가) 삭제*/
DataObject doTBJEF = new DataObject("tcb_bid_join_estm_file");
db.setCommand(doTBJEF.getDeleteQuery(where),null);

/* 요청파일(등록평가) 삭제*/
DataObject doTBJRF = new DataObject("tcb_bid_join_req_file");
db.setCommand(doTBJRF.getDeleteQuery(where),null);

/* 업체첨부파일(기술평가) 삭제*/
DataObject doTBSEF = new DataObject("tcb_bid_skill_estm_file");
db.setCommand(doTBSEF.getDeleteQuery(where),null);

/* 업체첨부파일 삭제*/
DataObject doTBEF = new DataObject("tcb_bid_estm_file");
db.setCommand(doTBEF.getDeleteQuery(where),null);

/* 업체견적서 삭제 */
DataObject doTBST = new DataObject("tcb_bid_suppitem_term");
db.setCommand(doTBST.getDeleteQuery(where),doTBST.record);

/* 업체견적서 삭제 */
DataObject doTBS = new DataObject("tcb_bid_suppitem");
db.setCommand(doTBS.getDeleteQuery(where),doTBS.record);

/* 대상업체정보 상세 삭제 */
DataObject doTBSuppSub = new DataObject("tcb_bid_supp_sub");
db.setCommand(doTBSuppSub.getDeleteQuery(where),doTBSuppSub.record);

/* 대상업체정보 삭제 */
DataObject doTBSupp = new DataObject("tcb_bid_supp");
db.setCommand(doTBSupp.getDeleteQuery(where),doTBSupp.record);

/* 업체필수제출서류(기술평가) 삭제 */
DataObject doTBSRF = new DataObject("tcb_bid_skill_req_file");
db.setCommand(doTBSRF.getDeleteQuery(where),doTBSRF.record);

/* 업체필수제출서류 삭제 */
DataObject doTBRF = new DataObject("tcb_bid_req_file");
db.setCommand(doTBRF.getDeleteQuery(where),doTBRF.record);

/* 견적내역 삭제 */
DataObject doTBIT = new DataObject("tcb_bid_item_term");
db.setCommand(doTBIT.getDeleteQuery(where),doTBIT.record);

/* 견적내역 삭제 */
DataObject doTBI = new DataObject("tcb_bid_item");
db.setCommand(doTBI.getDeleteQuery(where),doTBI.record);

/* 첨부파일 삭제 */
DataObject doTBF = new DataObject("tcb_bid_file");
db.setCommand(doTBF.getDeleteQuery(where),doTBF.record);

/* 입찰담당자정보 삭제 */
DataObject doTBC = new DataObject("tcb_bid_charge");
db.setCommand(doTBC.getDeleteQuery(where),doTBC.record);

/* 위메프 입찰정보 삭제 */
DataObject doTBIN = new DataObject("tcb_bid_info");
db.setCommand(doTBIN.getDeleteQuery(where),doTBIN.record);

/* 위메프 EMAIL 삭제 */
DataObject doTBE = new DataObject("tcb_bid_email");
db.setCommand(doTBE.getDeleteQuery(where),doTBE.record);

/*복수예가 금액 삭제*/
DataObject doTBMA = new DataObject("tcb_bid_multi_amt");
db.setCommand(doTBMA.getDeleteQuery(where),doTBMA.record);

/*복수예가 정보 삭제*/
DataObject doTBMI = new DataObject("tcb_bid_multi_info");
db.setCommand(doTBMI.getDeleteQuery(where),doTBMI.record);

/*역경매 투찰정보 삭제*/
DataObject doTBSR = new DataObject("tcb_bid_supp_rev");
db.setCommand(doTBSR.getDeleteQuery(where),doTBSR.record);

/* 입찰기본정보 삭제 */
DataObject doTBM = new DataObject("tcb_bid_master");
db.setCommand(doTBM.getDeleteQuery(where),doTBM.record);


if(!db.executeArray()){
	u.jsError("삭제 처리중 오류가 발생 하였습니다.");
	return;
}

u.jsAlertReplace("삭제 하였습니다.", "bid_list.jsp?"+u.getQueryString("main_member_no,bid_no,bid_deg"));
%>