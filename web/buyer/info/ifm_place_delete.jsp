<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String field_seq = u.request("field_seq");
String person_seq = u.request("person_seq");

if(!field_seq.equals("")&&!person_seq.equals("")){
	DataObject dao = new DataObject("tcb_fieldperson");
	dao.setDebug(out);
	if(
	!dao.delete("member_no = '"+_member_no+"' and field_seq = '"+field_seq+"' and person_seq = '"+person_seq+"'")
	){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �����ͷ� ���� �ϼ���.");
		return;
	}
}
u.redirect("ifm_place.jsp?"+u.getQueryString("field_seq"));
return;
%>