<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
	String hp = u.request("hp");

	DataObject dao = new DataObject("tcb_member a");

	StringBuffer sb	= new StringBuffer();
	
	// 현재 가입된 회원인지 CHECK
	sb.append("SELECT TP.USER_NAME, TP.USER_ID, TP.EMAIL, TP.STATUS, TP.MEMBER_NO, TP.PERSON_SEQ \n");
	sb.append("FROM TCB_MEMBER TM, TCB_PERSON TP \n");
	sb.append("WHERE TM.MEMBER_NO = TP.MEMBER_NO \n");
	sb.append("AND TP.HP1||'-'||TP.HP2||'-'||TP.HP3 = '" + hp + "' \n");
	sb.append("AND TM.MEMBER_NO != '20201000001' \n");
	sb.append("AND ROWNUM = 1");
	DataSet ds = dao.query(sb.toString());

%>
	<script>
<%
	if (ds != null && ds.size() > 0) {
		if (ds.next()) {
			if (ds.getString("status").equals("-1")) { // -1:삭제회원, 0:미가입회원, 1:가입회원
%>
				hpChkMsg = "해당 휴대폰번호의 회원은 탈퇴 상태입니다.<br>다시 회원으로 가입하시려면, 고객지원센터에 문의하시기 바랍니다.";
				document.forms['form1']['chk_id'].value = "";
				document.forms['form1']['member_no'].value = "";
				document.forms['form1']['member_name'].value = "";
				document.forms['form1']['user_id'].value = "";
				document.forms['form1']['org_user_id'].value = "";
				document.forms['form1']['person_seq'].value = "";
				document.forms['form1']['email'].value = "";
				document.forms['form1']['hdn_mode'].value = "BREAK";
				document.forms['form1']['user_id'].className = "label";
				document.getElementById("btn_chkid").style.display = "";
				document.forms['form1']['user_id'].readOnly = false;
<%
			} else if (ds.getString("status").equals("1")) {
%>
				hpChkMsg = "이미 가입된 회원입니다.<br>담당자에게 문의해주세요. ";
				document.forms['form1']['chk_id'].value = "";
				document.forms['form1']['member_no'].value = "";
				document.forms['form1']['member_name'].value = "";
				document.forms['form1']['user_id'].value = "";
				document.forms['form1']['org_user_id'].value = "";
				document.forms['form1']['person_seq'].value = "";
				document.forms['form1']['email'].value = "";
				document.forms['form1']['hdn_mode'].value = "JOIN";
				document.forms['form1']['user_id'].className = "label";
				document.getElementById("btn_chkid").style.display = "";
				document.forms['form1']['user_id'].readOnly = false;
<%
			}else if (ds.getString("status").equals("0") || ds.getString("status") == null || ds.getString("status") == ""){
%>				
				hpChkMsg = "등록가능한 신규회원입니다.";
				document.forms['form1']['chk_id'].value = "";
				document.forms['form1']['member_no'].value = "<%=ds.getString("member_no")%>";
				document.forms['form1']['member_name'].value = "<%=ds.getString("user_name")%>";
				document.forms['form1']['user_id'].value = "<%=ds.getString("user_id")%>";
				document.forms['form1']['org_user_id'].value = "<%=ds.getString("user_id")%>";
				document.forms['form1']['person_seq'].value = "<%=ds.getString("person_seq")%>";
				document.forms['form1']['email'].value = "<%=ds.getString("email")%>";
				document.forms['form1']['hdn_mode'].value = "SSO";
				document.forms['form1']['user_id'].className = "label";
				document.getElementById("btn_chkid").style.display = "";
				document.forms['form1']['user_id'].readOnly = true;
<%
			} else {
%>
				hpChkMsg = "고객센터로 문의 하시기 바랍니다.";
				document.forms['form1']['chk_id'].value = "";
				document.forms['form1']['member_no'].value = "";
				document.forms['form1']['member_name'].value = "";
				document.forms['form1']['user_id'].value = "";
				document.forms['form1']['org_user_id'].value = "";
				document.forms['form1']['person_seq'].value = "";
				document.forms['form1']['email'].value = "";
				document.forms['form1']['hdn_mode'].value = "ERROR";
				document.forms['form1']['user_id'].className = "label";
				document.getElementById("btn_chkid").style.display = "";
				document.forms['form1']['user_id'].readOnly = false;
<%
			}
		}
	} else {
%>
		hpChkMsg = "아래 정보 입력 후 회원가입 버튼을 눌러주세요.";
		document.forms['form1']['chk_id'].value = "";
		document.forms['form1']['member_no'].value = "";
		document.forms['form1']['member_name'].value = "";
		document.forms['form1']['user_id'].value = "";
		document.forms['form1']['email'].value = "";
		document.forms['form1']['person_seq'].value = "";
		document.forms['form1']['hdn_mode'].value = "NEW";
		document.forms['form1']['user_id'].className = "label";
		document.getElementById("btn_chkid").style.display = "";
		document.forms['form1']['user_id'].readOnly = false;
<%
	}
%>
		document.getElementById("font_hp_msg").innerHTML = hpChkMsg;
	</script>