<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsError("업체정보가 없습니다.");
	return;
}

DataObject useInfoDao = new DataObject("tcb_useinfo");
DataSet useInfo = useInfoDao.find("member_no = '"+member_no+"' ");
if(!useInfo.next()){
	u.jsError("이용정보가 없습니다.");
	return;
}

if(!useInfoDao.delete(" member_no = '"+member_no+"' ")){
	u.jsError("삭제처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("삭제처리 하였습니다.", "pay_comp_list.jsp?"+u.getQueryString("member_no"));
%>