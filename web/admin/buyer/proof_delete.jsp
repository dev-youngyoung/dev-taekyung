<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String proof_no = u.aseDec(u.request("proof_no"));
if(proof_no.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

String where = " proof_no = '"+proof_no+"' ";
ProofDao proofDao = new ProofDao("tcb_proof");
DataSet proof = proofDao.find(where);
if(!proof.next()){
	u.jsError("����������� ���� ���� �ʽ��ϴ�.");
	return;
}

DB db = new DB();
db.setCommand(new DataObject("tcb_proof_cfile").getDeleteQuery(where), null);
db.setCommand(new DataObject("tcb_proof_sign").getDeleteQuery(where), null);
db.setCommand(new DataObject("tcb_proof_cust").getDeleteQuery(where), null);
db.setCommand(new DataObject("tcb_proof").getDeleteQuery(where), null);

if(!db.executeArray()){
	u.jsError("���� ó���� ���� �Ͽ����ϴ�.");
	return;
}


u.jsAlertReplace("���� ó�� �Ͽ����ϴ�.","proof_list.jsp?"+u.getQueryString("proof_no"));
return;
%>