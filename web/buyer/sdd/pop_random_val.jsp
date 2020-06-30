<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
if(u.isPost()&&f.validate()) {
    String sRandomString = (String) session.getAttribute("_sRandomString");
    if (sRandomString==null || sRandomString.equals("")) {
        out.print("<script>");
        out.print("alert('인증코드 전송 후 인증을 진행하셔야 합니다.');");
        out.print("</script>");
    } else if(f.get("s_input").equals(sRandomString)) {
        out.print("<script>");
        out.print("parent.document.forms[0]['confirm_random'].value='1';");
        out.print("parent.document.forms[0].submit();");
        out.print("</script>");
        return;
    } else {
        out.print("<script>");
        out.print("alert('인증코드가 일치하지 않습니다.');");
        out.print("</script>");
    }
}
p.setLayout("popup_email_contract");
//p.setDebug(out);
p.setVar("popup_title","나이스다큐 핸드폰 본인인증");
p.setBody("sdd.pop_random_val");
p.setVar("query", u.getQueryString());
p.display(out);
%>