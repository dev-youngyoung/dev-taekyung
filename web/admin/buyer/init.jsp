<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ include file="../init.jsp" %>
<%
// ������ ȸ����ȣ���� üũ
if (!auth.isValid() || auth.getString("_ADMIN_ID").equals("")) {
	out.println("<script type=\"text/javascript\">");
	out.println("  alert('�߸��� �����Դϴ�.\\n');");
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