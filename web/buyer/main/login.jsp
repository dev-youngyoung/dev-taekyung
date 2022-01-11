<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String sign_data = u.request("sign_data");
String vend_cd = u.request("vend_cd");
String user_id = u.request("user_id").trim();
String passwd = u.request("passwd").trim();

//로그인시도 횟수
int nTryCnt = u.parseInt(u.getCookie("try"));
if (nTryCnt >= 5) {
	out.print("<script>");
	out.print("alert('로그인 5회 실패로 5분동안 로그인할 수 없습니다.\\n\\n5분 후 다시 시도하세요.');");
	out.print("parent.closeLoading();");
	out.print("history.back();");
	out.print("</script>");
	out.close();
	return;
}

DataSet person = new DataSet();
if (sign_data != null && !sign_data.isEmpty()) {
	// 인증서데이터가 넘어오면 인증서정보로 tcb_member를 찾아 해당하는 tcb_person의 seq=1인 데이터를 가져옴
	Crosscert crosscert = new Crosscert();
	crosscert.setEncoding("UTF-8");
	if (crosscert.chkSignVerify(sign_data).equals("SIGN_ERROR")){
		out.print("<script>");
		out.print("alert('서명검증에 실패 하였습니다.');");
		out.print("parent.closeLoading();");
		out.print("</script>");
		out.close();
		return;
	}
	String cert_dn = crosscert.getDn();
	
	DataObject mDao = new DataObject("tcb_member");
	DataSet member = mDao.find("cert_dn = '" + cert_dn + "' and vendcd = '" + vend_cd + "'");
	if (member.next()) {
		if (member.getString("status").equals("00")) {
			out.print("<script>");
			out.print("alert('탈퇴된 회원입니다.\\n\\n고객센터로 문의해 주세요.');");
			out.print("parent.closeLoading();");
			out.print("</script>");
			out.close();
			return;
		}
		if (!member.getString("status").equals("01")) {
			out.print("<script>");
			out.print("alert('정회원으로 등록된 사용자가 아닙니다.\\n\\n고객센터로 문의해 주세요.');");
			out.print("parent.closeLoading();");
			out.print("</script>");
			out.close();
			return;
		}
		
		DataObject pdao = new DataObject("tcb_person");
		person = pdao.find("member_no = '" + member.getString("member_no") + "' and person_seq = '1' and status > '0' and use_yn = 'Y' ");
		
		if (!person.next()) {
			out.print("<script>");
			out.print("alert('사용자정보가 없습니다.\\n\\n고객센터로 문의해 주세요.');");
			out.print("parent.closeLoading();");
			out.print("</script>");
			out.close();
			return;
		}
		
		auth.put("_MEMBER_NO", member.getString("member_no")); // 회원번호(농심으로 고정)
		auth.put("_MEMBER_TYPE", member.getString("member_type")); // 과업업체 구분(갑:01/을:02/갑을:03)
		auth.put("_MEMBER_GUBUN", member.getString("member_gubun")); // 회원구분(법인 본사:01/법인 지사:02/개인사업자:03/개인:04)
		auth.put("_VENDCD", member.getString("vendcd")); // 사업자등록번호
		auth.put("_MEMBER_NAME", member.getString("member_name")); // 업체명
		auth.put("_CERT_DN", member.getString("cert_dn")); // 인증서DN
		auth.put("_CERT_END_DATE", u.getTimeString("yyyyMMdd",member.getString("cert_end_date"))); // 인증서만료일
		if (!member.getString("logo_img_path").equals("")) {
			auth.put("_LOGO_IMG_PATH", member.getString("logo_img_path")); // 로고이미지 경로
		}
		auth.put("_PERSON_SEQ", person.getString("person_seq")); // 일련번호
		auth.put("_USER_ID", person.getString("user_id")); // 아이디
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
		out.print("<script>");
		String passdate_done = u.getCookie("passdate_done");

		//비밀번호 변경일 +3개월 < 현재일자
		if (person.getString("passdate").equals("")) person.put("passdate",person.getString("reg_date"));
		if (Integer.parseInt(u.addDate("M", 3, u.strToDate("yyyyMMddHHmmss", person.getString("passdate")),"yyyyMMdd"))
			< Integer.parseInt(u.getTimeString("yyyyMMdd"))
			&& passdate_done.equals("")) {
			out.print("parent.location.replace('changepass.jsp');");
		} else {
			out.print("parent.location.replace('index2.jsp');");
		}
		out.print("</script>");
		
		u.delCookie("try"); // 로그인시도 횟수 제거
	} else {
		// 인증서에 맞는 member 없음
		nTryCnt++;
		u.setCookie("try", Integer.toString(nTryCnt), 5*60);  // 5분
		out.print("<script>");
		out.print("alert('회사정보가 없습니다.\\n\\n고객센터로 문의해 주세요.');");
		out.print("parent.closeLoading();");
		out.print("</script>");
		out.close();
		return;
	}
} else {
	// 인증서데이터가 없는 경우 기존의 ID/PW로 tcb_person의 데이터를 가져옴
	DataObject pdao = new DataObject("tcb_person");
	person = pdao.find("lower(user_id) = lower('"+user_id+"') and status > '0' and use_yn = 'Y' and member_no != '20201000001'");

	if (person.next()) {
		if (person.getString("passwd").equals(u.md5(passwd)) || person.getString("passwd").equals(u.sha256(passwd))) {
			DataObject mdao = new DataObject("tcb_member");
			DataSet member = mdao.find("member_no = '"+person.getString("member_no")+"' ");
			if (!member.next()) {
				out.print("<script>");
				out.print("alert('회사정보가 없습니다.\\n\\n고객센터로 문의해 주세요.');");
				out.print("parent.closeLoading();");
				out.print("</script>");
				out.close();
				return;
			}
			if (member.getString("status").equals("00")) {
				out.print("<script>");
				out.print("alert('탈퇴된 회원입니다.\\n\\n고객센터로 문의해 주세요.');");
				out.print("parent.closeLoading();");
				out.print("</script>");
				out.close();
				return;
			}
			if (!member.getString("status").equals("01")) {
				out.print("<script>");
				out.print("alert('정회원으로 등록된 사용자가 아닙니다.\\n\\n고객센터로 문의해 주세요.');");
				out.print("parent.closeLoading();");
				out.print("</script>");
				out.close();
				return;
			}
			
			auth.put("_MEMBER_NO", member.getString("member_no")); // 회원번호(농심으로 고정)
			auth.put("_MEMBER_TYPE", member.getString("member_type")); // 과업업체 구분(갑:01/을:02/갑을:03)
			auth.put("_MEMBER_GUBUN", member.getString("member_gubun")); // 회원구분(법인 본사:01/법인 지사:02/개인사업자:03/개인:04)
			auth.put("_VENDCD", member.getString("vendcd")); // 사업자등록번호
			auth.put("_MEMBER_NAME", member.getString("member_name")); // 업체명
			auth.put("_CERT_DN", member.getString("cert_dn")); // 인증서DN
			auth.put("_CERT_END_DATE", u.getTimeString("yyyyMMdd",member.getString("cert_end_date"))); // 인증서만료일
			if (!member.getString("logo_img_path").equals("")) {
				auth.put("_LOGO_IMG_PATH", member.getString("logo_img_path")); // 로고이미지 경로
			}
			auth.put("_PERSON_SEQ", person.getString("person_seq")); // 일련번호
			auth.put("_USER_ID", person.getString("user_id")); // 아이디
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
			out.print("<script>");
			String passdate_done = u.getCookie("passdate_done");

			//비밀번호 변경일 +3개월 < 현재일자
			if (person.getString("passdate").equals("")) person.put("passdate",person.getString("reg_date"));
			if (Integer.parseInt(u.addDate("M", 3, u.strToDate("yyyyMMddHHmmss", person.getString("passdate")),"yyyyMMdd"))
				< Integer.parseInt(u.getTimeString("yyyyMMdd"))
				&& passdate_done.equals("")) {
				out.print("parent.location.replace('changepass.jsp');");
			} else {
				out.print("parent.location.replace('index2.jsp');");
			}
			out.print("</script>");

			u.delCookie("try"); // 로그인시도 횟수 제거
			u.setCookie("pin", Security.AESencrypt(user_id), 60*60*24*30); // 아이디 다음 접속시 자동 표시되도록 쿠키에저장(30일간)
		} else {
			// 비밀번호 불일치
			nTryCnt++;
			u.setCookie("try", Integer.toString(nTryCnt), 5*60);  // 5분
			out.print("<script>");
			out.print("alert('아이디/비밀번호가 일치하지 않습니다.\\n\\n[로그인 실패:"+nTryCnt+"회, 남은 횟수:"+(5-nTryCnt)+"회]');");
			out.print("parent.closeLoading();");
			out.print("</script>");
			out.close();
			return;
		}
	} else {
		// 아이디 없음
		nTryCnt++;
		u.setCookie("try", Integer.toString(nTryCnt), 5*60);  // 5분
		out.print("<script>");
		out.print("alert('아이디/비밀번호가 일치하지 않습니다.\\n\\n[로그인 실패:"+nTryCnt+"회, 남은 횟수:"+(5-nTryCnt)+"회]');");
		out.print("parent.closeLoading();");
		out.print("</script>");
		out.close();
		return;
	}
}
%>