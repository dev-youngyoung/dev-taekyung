<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String user_id = u.request("user_id").trim(); // 사원번호
String prod_id = u.request("prod_id").trim(); // 종이계약검토요청 자동이동

if (user_id == null || user_id.equals("")) {
	out.print("<script>");
	out.print("    alert('사원번호를 확인할 수 없습니다.');");
	out.print("    history.back();");
	out.print("</script>");
	out.close();
	return;
}

DataObject pDao = new DataObject("tcb_person");
DataSet person = pDao.find("user_id = '" + user_id + "' and status > '0' and use_yn = 'Y' and member_no = '20201000001'");	//회원번호(농심으로 고정)
if (person.next()) {
	DataObject mDao = new DataObject("tcb_member");
	DataSet member = mDao.find("member_no = '" + person.getString("member_no") + "'");
	member.next();
	
	auth.put("_MEMBER_NO", member.getString("member_no")); // 회원번호(농심으로 고정)
	auth.put("_MEMBER_TYPE", member.getString("member_type")); // 과업업체 구분(갑:01/을:02/갑을:03)
	auth.put("_MEMBER_GUBUN", member.getString("member_gubun")); // 회원구분(법인 본사:01/법인 지사:02/개인사업자:03/개인:04)
	auth.put("_VENDCD", member.getString("vendcd")); // 사업자등록번호
	auth.put("_MEMBER_NAME", member.getString("member_name")); // 업체명
	auth.put("_CERT_DN", member.getString("cert_dn")); // 인증서DN
	auth.put("_CERT_END_DATE", u.getTimeString("yyyyMMdd", member.getString("cert_end_date"))); // 인증서만료일
	if (!member.getString("logo_img_path").equals("")) {
		auth.put("_LOGO_IMG_PATH", member.getString("logo_img_path")); // 로고이미지 경로
	}
	auth.put("_PERSON_SEQ", person.getString("person_seq")); // 일련번호
	auth.put("_USER_ID", person.getString("user_id")); // 아이디(사원번호)
	auth.put("_USER_NAME", person.getString("user_name")); // 사용자명
	auth.put("_DEFAULT_YN", person.getString("default_yn").equals("Y") ? "Y" : "N"); // 전체관리자 여부
	auth.put("_USER_LEVEL", person.getString("user_level")); // 전체/부서/일반 구분
	auth.put("_USER_GUBUN", person.getString("user_gubun")); // 본사/지사 여부
	auth.put("_FIELD_SEQ", person.getString("field_seq")); // 부서번호
	auth.put("_DIVISION", person.getString("division")); // 부서명
	auth.put("_AUTH_CD", person.getString("auth_cd")); // 권한코드
	
	// 로그인 로그 저장
	DataObject loginLogDao = new DataObject("tcb_login_log");
	loginLogDao.item("member_no", member.getString("member_no"));
	loginLogDao.item("person_seq", person.getString("person_seq"));
	loginLogDao.item("user_id", person.getString("user_id"));
	loginLogDao.item("login_ip", request.getRemoteAddr());
	loginLogDao.item("login_date", u.getTimeString());
	loginLogDao.item("login_url", request.getRequestURI());
	loginLogDao.insert();
	
	auth.setAuthInfo();
	
	if (prod_id != null && prod_id.equals("000211")) {
		// 종이계약검토요청 플래그가 들어왔으므로 이동
		out.print("<script>");
		out.print("    location.replace('../contract/offcont_template.jsp?prod_id=000211');");
		out.print("</script>");
	} else {
		// 메인화면으로 이동
		out.print("<script>");
		out.print("    location.replace('index2.jsp');");
		out.print("</script>");
	}
} else {
	// 아이디 없음
	out.print("<script>");
	out.print("    alert('일치하는 사원번호가 없습니다.');");
	out.print("    history.back();");
	out.print("</script>");
	out.close();
	return;
}
%>