<%@ page contentType="text/html; charset=EUC-KR" %>
<%
	String _member_no = "";
	if(!auth.isValid()){
		out.println("<script type=\"text/javascript\">");
		out.println("  alert('�������� �̿����� �ʾ� �ڵ� �α׾ƿ��� �Ǿ����ϴ�.');");
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