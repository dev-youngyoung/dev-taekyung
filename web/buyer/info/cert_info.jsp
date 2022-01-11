<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
DataObject mdao = new DataObject("tcb_member tm inner join tcb_person tp on tm.member_no=tp.member_no");
//mdao.setDebug(out);
DataSet member = mdao.find(
		  "tm.member_no = '" + _member_no + "' and tp.default_yn='Y'"
		, "tm.member_gubun, tm.member_type, tm.cert_end_date, tp.jumin_no, tm.vendcd");
if (!member.next()) {
	//회원정보 확인 안함 by jun
	//u.jsError("회원정보가 없습니다.");
	//return;
} else {
	if (member.getString("member_gubun").equals("04")) { //개인회원
		Security security = new	Security();
		member.put("jumin_no", security.AESdecrypt(member.getString("jumin_no")).substring(0, 6));
	}
	member.put("cert_end_date", u.getTimeString("yyyy-MM-dd",member.getString("cert_end_date")));
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.cert_info");
p.setVar("menu_cd","000109");
p.setVar("auth_select",_authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), "000108", "btn_auth").equals("10"));
p.setVar("member", member);
p.setVar("isNongshim", member.getString("member_type").equals("01")); // 갑(농심)인 경우
p.setVar("person_yn", member.getString("member_gubun").equals("04")); // 개인인 경우
p.setVar("sys_date", u.getTimeString());
p.setVar("form_script", f.getScript());
p.display(out);
%>