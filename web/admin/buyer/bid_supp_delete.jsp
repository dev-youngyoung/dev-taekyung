<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String main_member_no = u.request("main_member_no");
String bid_no = u.request("bid_no");
String bid_deg = u.request("bid_deg");
String member_no = u.request("member_no");
if(main_member_no.equals("")||bid_no.equals("")||bid_deg.equals("")||member_no.equals("")){
	u.jsErrClose("�������� ��� �����ϼ���.");
	return;
}

String where = "main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"'";
DataObject bidDao = new DataObject("tcb_bid_master");
//bidDao.setDebug(out);
DataSet bid = bidDao.find(where);
if(!bid.next()){
	u.jsError("���������� �����ϴ�.");
	return;
}

DataObject suppSubDao = new DataObject("tcb_bid_supp_sub");
DataSet suppSubDs = suppSubDao.find(where+" and member_no='"+member_no+"' ");
if(suppSubDs.next()) {
	u.jsError("������ �� ���� ��ü�Դϴ�. ���������� ������ �ּ���.");
	return;
}

DB db = new DB();
DataObject bidSkillEstmFileDao = new DataObject("tcb_bid_skill_estm_file");
DataObject bidEstmFileDao = new DataObject("tcb_bid_estm_file");
DataObject suppitemDao = new DataObject("tcb_bid_suppitem");
DataObject suppDao = new DataObject("tcb_bid_supp");
db.setCommand(bidSkillEstmFileDao.getDeleteQuery(where+" and member_no='"+member_no+"' "),null);
db.setCommand(bidEstmFileDao.getDeleteQuery(where+" and member_no='"+member_no+"' "),null);
db.setCommand(suppitemDao.getDeleteQuery(where+" and member_no='"+member_no+"' "),null);
db.setCommand(suppDao.getDeleteQuery(where+" and member_no='"+member_no+"' "),null);
if(!db.executeArray()){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("���� �Ǿ����ϴ�.", "./pop_bid_supp.jsp?"+u.getQueryString());
%>