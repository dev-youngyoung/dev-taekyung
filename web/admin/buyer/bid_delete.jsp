<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String main_member_no = u.request("main_member_no");
String bid_no = u.request("bid_no");
String bid_deg = u.request("bid_deg");
if(main_member_no.equals("")||bid_no.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

String where = "main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"' ";

DataObject bidDao = new DataObject("tcb_bid_master");
DataSet bid = bidDao.find(where);
if(!bid.next()){
	u.jsError("���� ������ �����ϴ�.");
	return;
}


DB db = new DB();

/*������������*/
DataObject shareDao = new DataObject("tcb_bid_share");
db.setCommand(shareDao.getDeleteQuery(where), null);

/* ��û ÷������(�����) ����*/
DataObject doTBJEF = new DataObject("tcb_bid_join_estm_file");
db.setCommand(doTBJEF.getDeleteQuery(where),null);

/* ��û����(�����) ����*/
DataObject doTBJRF = new DataObject("tcb_bid_join_req_file");
db.setCommand(doTBJRF.getDeleteQuery(where),null);

/* ��ü÷������(�����) ����*/
DataObject doTBSEF = new DataObject("tcb_bid_skill_estm_file");
db.setCommand(doTBSEF.getDeleteQuery(where),null);

/* ��ü÷������ ����*/
DataObject doTBEF = new DataObject("tcb_bid_estm_file");
db.setCommand(doTBEF.getDeleteQuery(where),null);

/* ��ü������ ���� */
DataObject doTBST = new DataObject("tcb_bid_suppitem_term");
db.setCommand(doTBST.getDeleteQuery(where),doTBST.record);

/* ��ü������ ���� */
DataObject doTBS = new DataObject("tcb_bid_suppitem");
db.setCommand(doTBS.getDeleteQuery(where),doTBS.record);

/* ����ü���� �� ���� */
DataObject doTBSuppSub = new DataObject("tcb_bid_supp_sub");
db.setCommand(doTBSuppSub.getDeleteQuery(where),doTBSuppSub.record);

/* ����ü���� ���� */
DataObject doTBSupp = new DataObject("tcb_bid_supp");
db.setCommand(doTBSupp.getDeleteQuery(where),doTBSupp.record);

/* ��ü�ʼ����⼭��(�����) ���� */
DataObject doTBSRF = new DataObject("tcb_bid_skill_req_file");
db.setCommand(doTBSRF.getDeleteQuery(where),doTBSRF.record);

/* ��ü�ʼ����⼭�� ���� */
DataObject doTBRF = new DataObject("tcb_bid_req_file");
db.setCommand(doTBRF.getDeleteQuery(where),doTBRF.record);

/* �������� ���� */
DataObject doTBIT = new DataObject("tcb_bid_item_term");
db.setCommand(doTBIT.getDeleteQuery(where),doTBIT.record);

/* �������� ���� */
DataObject doTBI = new DataObject("tcb_bid_item");
db.setCommand(doTBI.getDeleteQuery(where),doTBI.record);

/* ÷������ ���� */
DataObject doTBF = new DataObject("tcb_bid_file");
db.setCommand(doTBF.getDeleteQuery(where),doTBF.record);

/* ������������� ���� */
DataObject doTBC = new DataObject("tcb_bid_charge");
db.setCommand(doTBC.getDeleteQuery(where),doTBC.record);

/* ������ �������� ���� */
DataObject doTBIN = new DataObject("tcb_bid_info");
db.setCommand(doTBIN.getDeleteQuery(where),doTBIN.record);

/* ������ EMAIL ���� */
DataObject doTBE = new DataObject("tcb_bid_email");
db.setCommand(doTBE.getDeleteQuery(where),doTBE.record);

/*�������� �ݾ� ����*/
DataObject doTBMA = new DataObject("tcb_bid_multi_amt");
db.setCommand(doTBMA.getDeleteQuery(where),doTBMA.record);

/*�������� ���� ����*/
DataObject doTBMI = new DataObject("tcb_bid_multi_info");
db.setCommand(doTBMI.getDeleteQuery(where),doTBMI.record);

/*����� �������� ����*/
DataObject doTBSR = new DataObject("tcb_bid_supp_rev");
db.setCommand(doTBSR.getDeleteQuery(where),doTBSR.record);

/* �����⺻���� ���� */
DataObject doTBM = new DataObject("tcb_bid_master");
db.setCommand(doTBM.getDeleteQuery(where),doTBM.record);


if(!db.executeArray()){
	u.jsError("���� ó���� ������ �߻� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("���� �Ͽ����ϴ�.", "bid_list.jsp?"+u.getQueryString("main_member_no,bid_no,bid_deg"));
%>