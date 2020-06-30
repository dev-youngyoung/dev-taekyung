<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String member_no = u.request("member_no");
String useseq = u.request("useseq");
String template_cd = u.request("template_cd");

if(member_no.equals("") || useseq.equals("") || template_cd.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

DataObject dao = new DataObject("tcb_useinfo_add");
//dao.setDebug(out);
if(!dao.delete("template_cd='"+template_cd+"' and member_no='"+member_no+"' and useseq='"+useseq+"'")){
	u.jsError("처리에 실패 하였습니다.");
	return;
}


u.jsAlertReplace("삭제 되었습니다.", "./pay_useinfo_modify.jsp?"+u.getQueryString("template_cd,useseq"));

%>