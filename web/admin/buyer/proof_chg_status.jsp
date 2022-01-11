<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String proof_no = u.aseDec(u.request("proof_no"));
String gubun = u.request("gubun");
if(proof_no.equals("")||gubun.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " proof_no = '"+proof_no+"' ";
ProofDao proofDao = new ProofDao("tcb_proof");
DataSet proof = proofDao.find(where);
if(!proof.next()){
	u.jsError("실적증명 건이 존재 하지 않습니다.");
	return;
}

DB db = new DB();
if(gubun.equals("hide")){
    proofDao = new ProofDao("tcb_proof");
    proofDao.item("status","00");
	db.setCommand(proofDao.getUpdateQuery(where), proofDao.record);
} else if(gubun.equals("writing")){
	//계약정보
    proofDao.item("mod_date","");
    proofDao.item("mod_id","");
    proofDao.item("proof_date","");
    proofDao.item("req_date","");
    proofDao.item("proof_html",proof.getString("org_proof_html"));
    proofDao.item("status","10");
	db.setCommand(proofDao.getUpdateQuery(where), proofDao.record);
	//업체정보
	DataObject custDao = new DataObject("tcb_proof_cust");
	custDao.item("sign_dn","");
	custDao.item("sign_data","");
	custDao.item("sign_date","");
	db.setCommand(custDao.getUpdateQuery(where),custDao.record);
}

if(!db.executeArray()){
	u.jsError("삭제처리에 실패 하였습니다.");
	return;
}
u.jsAlertReplace("처리 하였습니다.","proof_list.jsp?"+u.getQueryString("proof_no"));
return;
%>