<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
	String cert_dn 				= u.request("cert_dn");
	String cert_end_date 	= u.request("cert_end_date");

	if(!cert_dn.equals("")&&!cert_end_date.equals(""))
	{
		DataObject member = new DataObject("tcb_member");
		member.item("cert_dn",cert_dn);
		member.item("cert_end_date", cert_end_date);
		if(!member.update("member_no = '"+_member_no+"' ")){
			u.jsError("저장에 실패 하였습니다.");
			return;
		}

		auth.put("_CERT_DN",cert_dn);
		auth.put("_CERT_END_DATE", u.getTimeString("yyyyMMdd",cert_end_date));
		auth.setAuthInfo();
		//u.redirect("indiv_modify.jsp");
		u.jsAlertReplace("인증서가 등록되었습니다.", "./indiv_modify.jsp");
	}
%>