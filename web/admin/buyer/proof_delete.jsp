<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String proof_no = u.aseDec(u.request("proof_no"));
if(proof_no.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " proof_no = '"+proof_no+"' ";
ProofDao proofDao = new ProofDao("tcb_proof");
DataSet proof = proofDao.find(where);
if(!proof.next()){
	u.jsError("실적증명건이 존재 하지 않습니다.");
	return;
}

DB db = new DB();
db.setCommand(new DataObject("tcb_proof_cfile").getDeleteQuery(where), null);
db.setCommand(new DataObject("tcb_proof_sign").getDeleteQuery(where), null);
db.setCommand(new DataObject("tcb_proof_cust").getDeleteQuery(where), null);
db.setCommand(new DataObject("tcb_proof").getDeleteQuery(where), null);

if(!db.executeArray()){
	u.jsError("삭제 처리에 실패 하였습니다.");
	return;
}


u.jsAlertReplace("삭제 처리 하였습니다.","proof_list.jsp?"+u.getQueryString("proof_no"));
return;
%>