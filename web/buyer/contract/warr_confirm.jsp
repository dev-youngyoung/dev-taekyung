<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String warr_seq = u.request("warr_seq");
if(cont_no.equals("")||cont_chasu.equals("")||warr_seq.equals("")){
	//u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

ContractDao contDao = new ContractDao();
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cont.next()){
	u.jsError("계약정보가 없습니다.");
	return;
} 

DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and warr_seq = '"+warr_seq+"' ");
if(!warr.next()){
	u.jsError("보증정보가 없습니다.");
	return;
}

if(!warr.getString("status").equals("20")){
	u.jsError("보증확인처리 가능한 상태가 아닙니다.");
	return;
}

warrDao.item("status", "30");
if(!warrDao.update("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and warr_seq = '"+warr_seq+"' ")){
	u.jsError("확인처리에 실패 하였습니다.");
	return;
}
out.print("<script>alert('확인처리 하였습니다.');opener.location.reload();self.close();</script>");

%>