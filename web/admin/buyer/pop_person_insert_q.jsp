<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
	String	sMemberNo = u.request("member_no");
	
	DataObject doClient = new DataObject("tcb_person tp left join tcb_field tf on tp.member_no=tf.member_no and tp.field_seq=tf.field_seq");
	DataSet dsClient = doClient.find("tp.member_no='" + sMemberNo + "'");
	
	out.print(u.loop2json(dsClient));
%>