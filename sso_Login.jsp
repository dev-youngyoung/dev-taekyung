<%@ page contentType="text/html; charset=UTF-8" %> <%@ include file="./web/buyer/init.jsp" %>
<%@ page import="com.rathontech.common.crypt.*" %>
<%@ page import="java.net.URLDecoder" %>
<%
String value = request.getHeader("Cookie");
String SM = null;
String getSsoUserId = null;
if (value != null && value.indexOf(";") != -1 ) {
	String[] tC = value.split("; ");
	for (int i=tC.length-1; i>=0; i--) {
		String[] x = tC[i].split("=");
		if ("SMSESSION".equals(x[0])) {
			SM = x[1];
			break;
		}
	}
}

if (SM != null && !SM.equals("LOGGEDOFF")) {
	Cookie[] ck = null;
	ck = request.getCookies();

	if (ck != null) {
		int ckfind = -1;

		for (int i=0; i<ck.length; i++) {
			if (ck[i].getName().equals("SMOFC")) {
				ckfind = i;
				break;
			}
		}

		if (ckfind != -1 && ck[ckfind].getValue() != null && ck[ckfind].getValue() != "") {
			String ckimport = ck[ckfind].getValue();
			CaCrypt	cry	= new CaCrypt();
			String devalue = cry.extractValue(ckimport);
			String[] OFC = devalue.split(";");
			for (int x = OFC.length -1; x >= 0 ; x--) {
				String[] cksp = OFC[x].split("=");
				if (cksp[0].equals("emp_no")) {
					getSsoUserId = cksp[1];
					break;
			   	}
			}
		} else {
			response.sendRedirect("http://sso.nsgportal.net:8000/redirectlogin/ns/ns_appl20201012.jsp");
		}
	}
} else {
	response.sendRedirect("http://sso.nsgportal.net:8000/redirectlogin/ns/ns_appl20201012.jsp");
}

if (getSsoUserId == null || getSsoUserId.equals("")) {
	out.print("<script>");
	out.print("    alert('사원번호를 확인할 수 없습니다.');");
	out.print("    location.replace('http://sso.nsgportal.net:8000/redirectlogin/ns/ns_appl20201012.jsp');");
	out.print("</script>");
	out.close();
	return;
}

DataObject pDao = new DataObject("tcb_person");
DataSet person = pDao.find("user_id = '" + getSsoUserId + "' and status > '0' and use_yn = 'Y' and member_no = '20201000001'");	//회원번호(농심으로 고정)
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

	// 메인화면으로 이동
	out.print("<script>");
	out.print("    location.replace('/web/buyer/main/index2.jsp');");
	out.print("</script>");
} else {
	// 아이디 없음
	out.print("<script>");
	out.print("    alert('일치하는 사원번호가 없습니다.');");
	out.print("    location.replace('http://sso.nsgportal.net:8000/redirectlogin/ns/ns_appl20201012.jsp');");
	out.print("</script>");
	out.close();
	return;
}
%>