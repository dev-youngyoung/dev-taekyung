<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../init.jsp" %>
<%
// 관리자 회원번호인지 체크
if (auth.isValid() && auth.getString("_ADMIN_ID").equals("")) {
	out.println("<script type=\"text/javascript\">");
	out.println("  alert('잘못된 접근입니다.\\n');");
	out.println("if(opener!=null){");
	out.println("  opener.location.href='/web/admin/index.jsp';");
	out.println("  self.close();");
	out.println("}else{");
	out.println("  location.href='/web/admin/index.jsp';");
	out.println("}");
	out.println("</script>");
	out.close();
}
%>