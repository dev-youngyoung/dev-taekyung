<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String seq = u.request("seq");
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

DataObject calcPersonDao = new DataObject("tcb_calc_person");
DataSet calcPerson = calcPersonDao.find(" member_no = '"+member_no+"' and seq = '"+seq+"' ");
if(!calcPerson.next()){
	u.jsErrClose("정산담당자 정보가 없습니다.");
	return;
}

DataObject calcMonthDao = new DataObject("tcb_calc_month");
if(calcMonthDao.findCount(" member_no = '"+member_no+"'  and calc_person_seq = '"+seq+"' ") > 0 ){
	u.jsErrClose("해당 담당자로 정산된 건이 있어 삭제 할 수 없습니다.");
	return;
}

calcPersonDao = new DataObject("tcb_calc_person");
if(!calcPersonDao.delete(" member_no = '"+member_no+"' and seq = '"+seq+"' ")) {
	u.jsError("삭제 처리에 실패 하엿습니다.");
	return;
}
out.println("<script>");
out.println("opener.location.reload();");
out.println("alert('삭제 처리 되었습니다.');");
out.println("self.close();");
out.println("</script>");
return;



%>