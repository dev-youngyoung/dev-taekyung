<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String seq = u.request("seq");
if(member_no.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsError("��ü������ �����ϴ�.");
	return;
}

DataObject calcPersonDao = new DataObject("tcb_calc_person");
DataSet calcPerson = calcPersonDao.find(" member_no = '"+member_no+"' and seq = '"+seq+"' ");
if(!calcPerson.next()){
	u.jsErrClose("�������� ������ �����ϴ�.");
	return;
}

DataObject calcMonthDao = new DataObject("tcb_calc_month");
if(calcMonthDao.findCount(" member_no = '"+member_no+"'  and calc_person_seq = '"+seq+"' ") > 0 ){
	u.jsErrClose("�ش� ����ڷ� ����� ���� �־� ���� �� �� �����ϴ�.");
	return;
}

calcPersonDao = new DataObject("tcb_calc_person");
if(!calcPersonDao.delete(" member_no = '"+member_no+"' and seq = '"+seq+"' ")) {
	u.jsError("���� ó���� ���� �Ͽ����ϴ�.");
	return;
}
out.println("<script>");
out.println("opener.location.reload();");
out.println("alert('���� ó�� �Ǿ����ϴ�.');");
out.println("self.close();");
out.println("</script>");
return;



%>