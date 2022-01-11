<%@ page contentType="text/html; charset=UTF-8" %>
<%
	String _member_no = "";
	if(!auth.isValid()){
		out.println("<script type=\"text/javascript\">");
		out.println("  alert('오랫동안 이용하지 않아 자동 로그아웃이 되었습니다.');");
		out.println("if(opener!=null){");
		out.println("  opener.location.href='/web/buyer/index.jsp';");
		out.println("  self.close();");
		out.println("}else{");
		out.println("  location.href='/web/buyer/index.jsp';");
		out.println("}");
		out.println("</script>");
		out.close();
		return;
	}
	else {
		_member_no = auth.getString("_MEMBER_NO");
	}
%>