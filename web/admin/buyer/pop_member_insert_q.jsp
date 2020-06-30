<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%		

	String	sMemberNo = u.request("member_no");
	
	DataObject doClient = new DataObject();
	DataSet dsClient = doClient.query(
				   "select * "
				+  "from tcb_member tm, tcb_person tp "
				+  "where tm.member_no = tp.member_no AND default_yn = 'Y' AND tm.member_no in (select client_no from tcb_client where member_no='" + sMemberNo + "') "
				+  "order by tm.member_no desc"
			);
	
	out.print(u.loop2json(dsClient));
		
%>