<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
String member_no = u.request("member_no");
String seq = u.request("seq");
String vendcd = u.request("vendcd");
if(member_no.equals("")||seq.equals("")||vendcd.equals("")){
	return;
}

DataObject recruitDao = new DataObject("tcb_recruit");
DataSet recruit = recruitDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' ");
if(!recruit.next()){
	u.jsAlert("정상적인 경로로 접근하세요.");
	return;
}

DataObject suppDao = new DataObject("tcb_recruit_supp");
DataSet supp = suppDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' and vendcd = '"+vendcd+"'  ");
if(supp.next()){
	out.println("<script>");
	out.println("alert('이미 등록되 사업자 등록 번호 입니다.\\n\\n 본인확인후 신청내용 수정 가능합니다.');");
	out.println("showPasswd();");
	out.println("</script>");
	return;
}
out.println("<script>");
out.println("document.forms['form1']['chk_vendcd'].value='1';");
out.println("alert('신청 가능한 사업자등록 번호입니다.\\n\\n신청정보를 작성하세요.');");
out.println("setWrite();");
out.println("</script>");
%>