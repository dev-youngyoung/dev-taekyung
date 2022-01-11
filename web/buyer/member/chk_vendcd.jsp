<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
	String vendcd = u.request("vendcd");

	DataObject dao = new DataObject("tcb_member a");

	StringBuffer sb	= new StringBuffer();
	sb.append("SELECT A.* \n");
	sb.append("     , B.PERSON_SEQ \n");
	sb.append("     , B.USER_ID \n");
	sb.append("     , B.USER_NAME \n");
	sb.append("     , B.POSITION \n");
	sb.append("     , B.EMAIL \n");
	sb.append("     , B.TEL_NUM \n");
	sb.append("     , B.DIVISION \n");
	sb.append("     , B.FAX_NUM \n");
	sb.append("     , B.HP1 \n");
	sb.append("     , B.HP2 \n");
	sb.append("     , B.HP3 \n");
	sb.append("FROM TCB_MEMBER A \n");
	sb.append("LEFT OUTER JOIN TCB_PERSON B ON A.MEMBER_NO = B.MEMBER_NO AND DEFAULT_YN = 'Y' \n");
	sb.append("WHERE A.VENDCD = '" + vendcd + "'");
	sb.append("AND ROWNUM = 1");
	DataSet ds = dao.query(sb.toString());

	String	sVendcd2 = "";
	if (vendcd != null && vendcd.length() == 10) sVendcd2 = vendcd.substring(3,5);
%>
	<script>
		var	sVendMsg = ""; // 사업자중복체크 메세지
		var	sMemberGubunNm = ""; // 사업자구분
		var	sVendcd2 = "<%=sVendcd2%>"; // 사업자번호 4,5자리
		var	sMemberGubun = "";

		if (sVendcd2.length == 2) {
			if (sVendcd2 == "81" ||
				sVendcd2 == "82" ||
				sVendcd2 == "83" ||
				sVendcd2 == "84" ||
				sVendcd2 == "86" ||
				sVendcd2 == "87" ||
				sVendcd2 == "88") {
				sMemberGubunNm = "법인사업자(본사)";
				member_gubun = "01";
			} else if(sVendcd2 == "85") {
				sMemberGubunNm = "법인사업자(지사)";
				member_gubun = "02";
			} else {
				sMemberGubunNm = "개인사업자";
				member_gubun = "03";
			}
		}
		document.forms['form1']['member_gubun'].value = member_gubun;
<%
	if (ds != null && ds.size() > 0) {
		if (ds.next()) {
			// 가입된 정보가 IF_100 테이블에 여러개인지 확인 필요
			sb	= new StringBuffer();
			sb.append("SELECT MEMBER_NO \n");
			sb.append("     , LTRIM(CUST_CODE, '000') AS CUST_CODE \n");
			sb.append("     , COM_NAME \n");
			sb.append("     , BOSS_NAME \n");
			sb.append("     , SITE_ITEM \n");
			sb.append("     , BIZ_TYPE \n");
			sb.append("     , REPLACE(HEAD_OFCE_POST,'-','') AS HEAD_OFCE_POST \n");
			sb.append("     , HEAD_OFCE_ADRS \n");
			sb.append("     , COMM_NO \n");
			sb.append("FROM IF_MMBAT100 \n");
			sb.append("WHERE COMM_NO = '" + vendcd + "'");
			//sb.append("AND ROWNUM = 1");
			DataSet dsMmbat = dao.query(sb.toString());
			if(dsMmbat.size() > 1){
				// popup 호출 후 선택한 사업자가 가입된 멤버인지 check 필요
	%>
				OpenWindows('pop_search_join.jsp?s_vendcd='+<%=vendcd%>,'pop_search_cust', '870','700');
	<%				
			}else{
				if (ds.getString("status").equals("00")) { // 00:탈퇴 01:정회원 02:비회원 03:재가입 (현재 02는 미존재)
	%>
					sVendMsg = "해당 사업자번호는 회원탈퇴 상태입니다.<br>다시 회원으로 가입하시려면, 고객지원센터에 문의하시기 바랍니다.";
					document.forms['form1']['member_slno1'].value = "";
					document.forms['form1']['member_slno2'].value = "";
					document.forms['form1']['member_name'].value = "";
					document.forms['form1']['boss_name'].value = "";
					document.forms['form1']['condition'].value = "";
					document.forms['form1']['category'].value = "";
					document.forms['form1']['post_code'].value = "";
					document.forms['form1']['address'].value = "";
					document.forms['form1']['user_id'].value = "";
					document.forms['form1']['user_name'].value = "";
					document.forms['form1']['position'].value = "";
					document.forms['form1']['email'].value = "";
					document.forms['form1']['tel_num'].value = "";
					document.forms['form1']['division'].value = "";
					document.forms['form1']['fax_num'].value = "";
					document.forms['form1']['hp1'].value = "";
					document.forms['form1']['hp2'].value = "";
					document.forms['form1']['hp3'].value = "";
					document.forms['form1']['hdn_mode'].value = "BREAK";
					document.forms['form1']['hdn_member_no'].value = "";
					document.forms['form1']['hdn_person_seq'].value = "";
					document.forms['form1']['user_id'].readOnly = false;
					document.forms['form1']['user_id'].className = "label";
					document.getElementById("btn_chkid").style.display = "";
					document.forms['form1']['chk_id'].value = "";
	<%
				} else {
					if (ds.getString("status").equals("01") || ds.getString("status").equals("03")) {
						if (dsMmbat.next()) {
	%>
						sVendMsg = "등록가능한 사업자 번호 입니다.<br> 담당자 정보를 입력 후  회원가입 버튼을 눌러주세요.";
						document.forms['form1']['member_slno1'].value = "";
						document.forms['form1']['member_slno2'].value = "";
						document.forms['form1']['member_name'].value = "<%=dsMmbat.getString("com_name")%>";
						document.forms['form1']['boss_name'].value = "<%=dsMmbat.getString("boss_name")%>";
						document.forms['form1']['condition'].value = "<%=dsMmbat.getString("site_item")%>";
						document.forms['form1']['category'].value = "<%=dsMmbat.getString("biz_type")%>";
						document.forms['form1']['post_code'].value = "<%=dsMmbat.getString("head_ofce_post")%>";
						document.forms['form1']['address'].value = "<%=dsMmbat.getString("head_ofce_adrs")%>";
						document.forms['form1']['user_id'].value = "<%=dsMmbat.getString("comm_no")%>";
						document.forms['form1']['user_name'].value = "";
						document.forms['form1']['position'].value = "";
						document.forms['form1']['email'].value = "";
						document.forms['form1']['tel_num'].value = "";
						document.forms['form1']['division'].value = "";
						document.forms['form1']['fax_num'].value = "";
						document.forms['form1']['hp1'].value = "";
						document.forms['form1']['hp2'].value = "";
						document.forms['form1']['hp3'].value = "";
						document.forms['form1']['hdn_mode'].value = "NEW_P";
						document.forms['form1']['hdn_member_no'].value = "<%=dsMmbat.getString("member_no")%>";
						document.forms['form1']['hdn_person_seq'].value = "";
						document.forms['form1']['user_id'].readOnly = false;
						document.forms['form1']['user_id'].className = "label";
						document.getElementById("btn_chkid").style.display = "";
						document.forms['form1']['chk_id'].value = "";
	<%
						}
					} else {
		    			if (ds.getString("status").equals("02")) {
		    				String sMemberSlno1 = "";
		    				String sMemberSlno2 = "";
			    			if (ds.getString("member_slno").length() == 13) {
			    				sMemberSlno1 = ds.getString("member_slno").substring(0,6);
			    				sMemberSlno2 = ds.getString("member_slno").substring(6);
			    			}
	%>
							sVendMsg = "해당 사업자번호는 거래처에서 미리 입력한 정보가 있습니다. 나머지 정보를 입력 후 회원가입 버튼을 눌러주세요.";
							document.forms['form1']['member_slno1'].value = "<%=sMemberSlno1%>";
							document.forms['form1']['member_slno2'].value = "<%=sMemberSlno2%>";
							document.forms['form1']['member_name'].value = "<%=ds.getString("member_name")%>";
							document.forms['form1']['boss_name'].value = "<%=ds.getString("boss_name")%>";
							document.forms['form1']['condition'].value = "<%=ds.getString("condition")%>";
							document.forms['form1']['category'].value = "<%=ds.getString("category")%>";
							document.forms['form1']['post_code'].value = "<%=ds.getString("post_code")%>";
							document.forms['form1']['address'].value = "<%=ds.getString("address")%>";
							document.forms['form1']['user_id'].value = "<%=ds.getString("user_id")%>";
							document.forms['form1']['user_name'].value = "<%=ds.getString("user_name")%>";
							document.forms['form1']['position'].value = "<%=ds.getString("position")%>";
							document.forms['form1']['email'].value = "<%=ds.getString("email")%>";
							document.forms['form1']['tel_num'].value = "<%=ds.getString("tel_num")%>";
							document.forms['form1']['division'].value = "<%=ds.getString("division")%>";
							document.forms['form1']['fax_num'].value = "<%=ds.getString("fax_num")%>";
							document.forms['form1']['hp1'].value = "<%=ds.getString("hp1")%>";
							document.forms['form1']['hp2'].value = "<%=ds.getString("hp2")%>";
							document.forms['form1']['hp3'].value = "<%=ds.getString("hp3")%>";
							document.forms['form1']['hdn_mode'].value = "UPDATE";
							document.forms['form1']['hdn_member_no'].value = "<%=ds.getString("member_no")%>";
							document.forms['form1']['hdn_person_seq'].value = "<%=ds.getString("person_seq")%>";
	<%
							if (ds.getString("user_id") != null && ds.getString("user_id").length() > 0) {
	%>
								document.forms['form1']['user_id'].readOnly = true;
								document.forms['form1']['user_id'].className = "in_readonly";
								document.getElementById("btn_chkid").style.display = "none";
								document.forms['form1']['chk_id'].value = "1";
	<%
							}
						} else {
	%>
							sVendMsg = "고객센터로 문의 하시기 바랍니다.";
							document.forms['form1']['member_slno1'].value = "";
							document.forms['form1']['member_slno2'].value = "";
							document.forms['form1']['member_name'].value = "";
							document.forms['form1']['boss_name'].value = "";
							document.forms['form1']['condition'].value = "";
							document.forms['form1']['category'].value = "";
							document.forms['form1']['post_code'].value = "";
							document.forms['form1']['address'].value = "";
							document.forms['form1']['user_id'].value = "";
							document.forms['form1']['user_name'].value = "";
							document.forms['form1']['position'].value = "";
							document.forms['form1']['email'].value = "";
							document.forms['form1']['tel_num'].value = "";
							document.forms['form1']['division'].value = "";
							document.forms['form1']['fax_num'].value = "";
							document.forms['form1']['hp1'].value = "";
							document.forms['form1']['hp2'].value = "";
							document.forms['form1']['hp3'].value = "";
							document.forms['form1']['hdn_mode'].value = "ERROR";
							document.forms['form1']['hdn_member_no'].value = "";
							document.forms['form1']['hdn_person_seq'].value = "";
							document.forms['form1']['user_id'].readOnly = false;
							document.forms['form1']['user_id'].className = "label";
							document.getElementById("btn_chkid").style.display = "";
							document.forms['form1']['chk_id'].value = "";
	<%
						}
					}
				}	
			}
		}
	} else {
		sb	= new StringBuffer();
		sb.append("SELECT MEMBER_NO \n");
		sb.append("     , LTRIM(CUST_CODE, '000') AS CUST_CODE \n");
		sb.append("     , COM_NAME \n");
		sb.append("     , BOSS_NAME \n");
		sb.append("     , SITE_ITEM \n");
		sb.append("     , BIZ_TYPE \n");
		sb.append("     , REPLACE(HEAD_OFCE_POST,'-','') AS HEAD_OFCE_POST \n");
		sb.append("     , HEAD_OFCE_ADRS \n");
		sb.append("     , COMM_NO \n");
		sb.append("FROM IF_MMBAT100 \n");
		sb.append("WHERE COMM_NO = '" + vendcd + "'");
		//sb.append("AND ROWNUM = 1");
		ds = dao.query(sb.toString());
		
		if (ds != null && ds.size() > 0) {
			if(ds.size() > 1){
				// 사업자번호 팝업 호출
	%>
				OpenWindows('pop_search_join.jsp?s_vendcd='+<%=vendcd%>,'pop_search_cust', '870','700');
	<%				
			}else{
				// 팝업호출 없이 정보 셋팅
				if (ds.next()) {
					if(!ds.getString("member_no").isEmpty() && ds.getString("member_no") != null){
	%>
						sVendMsg = "등록가능한 사업자 번호 입니다.<br> 담당자 정보를 입력 후  회원가입 버튼을 눌러주세요.";
						document.forms['form1']['member_slno1'].value = "";
						document.forms['form1']['member_slno2'].value = "";
						document.forms['form1']['member_name'].value = "<%=ds.getString("com_name")%>";
						document.forms['form1']['boss_name'].value = "<%=ds.getString("boss_name")%>";
						document.forms['form1']['condition'].value = "<%=ds.getString("site_item")%>";
						document.forms['form1']['category'].value = "<%=ds.getString("biz_type")%>";
						document.forms['form1']['post_code'].value = "<%=ds.getString("head_ofce_post")%>";
						document.forms['form1']['address'].value = "<%=ds.getString("head_ofce_adrs")%>";
						document.forms['form1']['user_id'].value = "<%=ds.getString("comm_no")%>";
						document.forms['form1']['user_name'].value = "";
						document.forms['form1']['position'].value = "";
						document.forms['form1']['email'].value = "";
						document.forms['form1']['tel_num'].value = "";
						document.forms['form1']['division'].value = "";
						document.forms['form1']['fax_num'].value = "";
						document.forms['form1']['hp1'].value = "";
						document.forms['form1']['hp2'].value = "";
						document.forms['form1']['hp3'].value = "";
						document.forms['form1']['hdn_mode'].value = "NEW_M";
						document.forms['form1']['hdn_member_no'].value = "<%=ds.getString("member_no")%>";
						document.forms['form1']['hdn_person_seq'].value = "";
						document.forms['form1']['user_id'].readOnly = false;
						document.forms['form1']['user_id'].className = "label";
						document.getElementById("btn_chkid").style.display = "";
						document.forms['form1']['chk_id'].value = "";
	<%
					}else{
	%>
						sVendMsg = "해당 사업자번호의 가입이 불가합니다. 고객센터로 문의 하시기 바랍니다.";
						document.forms['form1']['member_slno1'].value = "";
						document.forms['form1']['member_slno2'].value = "";
						document.forms['form1']['member_name'].value = "";
						document.forms['form1']['boss_name'].value = "";
						document.forms['form1']['condition'].value = "";
						document.forms['form1']['category'].value = "";
						document.forms['form1']['post_code'].value = "";
						document.forms['form1']['address'].value = "";
						document.forms['form1']['user_id'].value = "";
						document.forms['form1']['user_name'].value = "";
						document.forms['form1']['position'].value = "";
						document.forms['form1']['email'].value = "";
						document.forms['form1']['tel_num'].value = "";
						document.forms['form1']['division'].value = "";
						document.forms['form1']['fax_num'].value = "";
						document.forms['form1']['hp1'].value = "";
						document.forms['form1']['hp2'].value = "";
						document.forms['form1']['hp3'].value = "";
						document.forms['form1']['hdn_mode'].value = "ERROR";
						document.forms['form1']['hdn_member_no'].value = "";
						document.forms['form1']['hdn_person_seq'].value = "";
						document.forms['form1']['user_id'].readOnly = false;
						document.forms['form1']['user_id'].className = "label";
						document.getElementById("btn_chkid").style.display = "";
						document.forms['form1']['chk_id'].value = "";
	<%
					}
				}
			}
		}else{
%>
			sVendMsg = "존재하지 않는 사업자입니다. 고객지원센터에 문의하시기 바랍니다.";
			document.forms['form1']['member_slno1'].value = "";
			document.forms['form1']['member_slno2'].value = "";
			document.forms['form1']['member_name'].value = "";
			document.forms['form1']['boss_name'].value = "";
			document.forms['form1']['condition'].value = "";
			document.forms['form1']['category'].value = "";
			document.forms['form1']['post_code'].value = "";
			document.forms['form1']['address'].value = "";
			document.forms['form1']['user_id'].value = "";
			document.forms['form1']['user_name'].value = "";
			document.forms['form1']['position'].value = "";
			document.forms['form1']['email'].value = "";
			document.forms['form1']['tel_num'].value = "";
			document.forms['form1']['division'].value = "";
			document.forms['form1']['fax_num'].value = "";
			document.forms['form1']['hp1'].value = "";
			document.forms['form1']['hp2'].value = "";
			document.forms['form1']['hp3'].value = "";
			document.forms['form1']['hdn_mode'].value = "ERROR";
			document.forms['form1']['hdn_member_no'].value = "";
			document.forms['form1']['hdn_person_seq'].value = "";
			document.forms['form1']['user_id'].readOnly = false;
			document.forms['form1']['user_id'].className = "label";
			document.getElementById("btn_chkid").style.display = "";
			document.forms['form1']['chk_id'].value = "";
<%			
		}
	}
%>
		document.getElementById("font_vendcd_msg").innerHTML = sVendMsg;
		document.getElementById("span_memner_gubun_nm").innerHTML = sMemberGubunNm;
	</script>