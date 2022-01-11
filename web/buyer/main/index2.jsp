<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
if (auth.getString("_MEMBER_NO") == null || auth.getString("_MEMBER_NO").equals("")) {
	u.redirect("index.jsp");
	return;
}

int step1 = 0; // 계약작성 갯수
int step2 = 0; // 서명요청 갯수
int step3 = 0; // 서명대기 갯수
int step4 = 0; // 계약완료 갯수
int step5 = 0; // 연장계약 갯수

DataSet sList = new DataSet(); // 계약진행이력(진행중(보낸/받은계약)) 목록
DataSet nList = new DataSet(); // 공지사항 목록

String tLink = ""; // 임시저장계약 링크
String sLink = ""; // 계약진행이력(진행중(보낸/받은계약)) 링크
String eLink = ""; // 계약완료 링크
String nLink = ""; // 공지사항 링크

if (auth.getString("_MEMBER_TYPE").equals("01") || auth.getString("_MEMBER_TYPE").equals("03")) { // 갑사
	// 계약작성(임시저장, status=10) 갯수
	DataObject step1Dao = new DataObject();
	String step1Query = 
			"select count(*) as step1cnt " +
			"  from tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu " +
			" where b.list_cust_yn = 'Y' and a.member_no = '" + auth.getString("_MEMBER_NO") + "' and a.status = '10' ";
	// 조회권한에 따른 where절 추가
	if (!auth.getString("_DEFAULT_YN").equals("Y")) {
		// 10:담당조회  20:부서조회 
		if (_authDao.getAuthMenuInfoB(auth.getString("_MEMBER_NO"), auth.getString("_AUTH_CD"), "000059", "select_auth").equals("10")) {
			step1Query = step1Query + "and a.reg_id = '" + auth.getString("_USER_ID") + "' ";
		}
		if (_authDao.getAuthMenuInfoB(auth.getString("_MEMBER_NO"), auth.getString("_AUTH_CD"), "000059", "select_auth").equals("20")) {
			step1Query = step1Query + "and a.field_seq in ( select field_seq from tcb_field start with member_no = '" + auth.getString("_MEMBER_NO") + "' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq) ";
		}
	}
	DataSet step1Cnt = step1Dao.query(step1Query);
	if (step1Cnt.next()) step1 = step1Cnt.getInt("step1cnt");
	
	// 서명요청(status=20) 갯수
	DataObject step2Dao = new DataObject();
	String step2Query = 
			"select count(*) as step2cnt " +
			"  from tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu " +
			" where b.list_cust_yn = 'Y' and a.member_no = '" + auth.getString("_MEMBER_NO") + "' and a.status = '20' and a.subscription_yn is null ";
	// 조회권한에 따른 where절 추가
	if (!auth.getString("_DEFAULT_YN").equals("Y")) {
		// 10:담당조회  20:부서조회 
		if (_authDao.getAuthMenuInfoB(auth.getString("_MEMBER_NO"), auth.getString("_AUTH_CD"), "000060", "select_auth").equals("10")) {
			step2Query = step2Query + 
					"and ( " +
					"       a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' " +
					"    or a.reg_id = '" + auth.getString("_USER_ID") + "' " +
					"    or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + auth.getString("_MEMBER_NO") + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '000060') " +
				    ") ";
		}
		if (_authDao.getAuthMenuInfoB(auth.getString("_MEMBER_NO"), auth.getString("_AUTH_CD"), "000060", "select_auth").equals("20")) {
			step2Query = step2Query +
					"and ( " +
					"       a.agree_field_seqs like '%|" + auth.getString("_FIELD_SEQ") + "|%' " +
					"    or a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' " + // 결제 라인 조회 권한은 부여된 권한 보다 우선 한다.
					"    or a.field_seq in (select field_seq from tcb_field start with member_no = '" + auth.getString("_MEMBER_NO") + "' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq) " +
					"    or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + auth.getString("_MEMBER_NO") + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '000060') " +
					") ";
		}
	}
	DataSet step2Cnt = step2Dao.query(step2Query);
	if (step2Cnt.next()) step2 = step2Cnt.getInt("step2cnt");
	
	// 서명대기(을 서명완료, status=30) 갯수
	DataObject step3Dao = new DataObject();
	String step3Query = 
			"select count(*) as step3cnt " +
			"  from tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu " +
			" where b.list_cust_yn = 'Y' and a.member_no = '" + auth.getString("_MEMBER_NO") + "' and a.status = '30' and a.subscription_yn is null ";
	// 조회권한에 따른 where절 추가
	if (!auth.getString("_DEFAULT_YN").equals("Y")) {
		// 10:담당조회  20:부서조회 
		if (_authDao.getAuthMenuInfoB(auth.getString("_MEMBER_NO"), auth.getString("_AUTH_CD"), "000060", "select_auth").equals("10")) {
			step3Query = step3Query + 
					"and ( " +
					"       a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' " +
					"    or a.reg_id = '" + auth.getString("_USER_ID") + "' " +
					"    or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + auth.getString("_MEMBER_NO") + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '000060') " +
				    ") ";
		}
		if (_authDao.getAuthMenuInfoB(auth.getString("_MEMBER_NO"), auth.getString("_AUTH_CD"), "000060", "select_auth").equals("20")) {
			step3Query = step3Query +
					"and ( " +
					"       a.agree_field_seqs like '%|" + auth.getString("_FIELD_SEQ") + "|%' " +
					"    or a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' " + // 결제 라인 조회 권한은 부여된 권한 보다 우선 한다.
					"    or a.field_seq in (select field_seq from tcb_field start with member_no = '" + auth.getString("_MEMBER_NO") + "' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq) " +
					"    or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + auth.getString("_MEMBER_NO") + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '000060') " +
					") ";
		}
	}
	DataSet step3Cnt = step3Dao.query(step3Query);
	if (step3Cnt.next()) step3 = step3Cnt.getInt("step3cnt");
	
	// 계약완료(갑/을 서명완료, status=50,91,99) 갯수
	DataObject step4Dao = new DataObject();
	String step4Query = 
			"select count(*) as step4cnt " +
			"  from tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu and a.paper_yn is null " +
			" where b.list_cust_yn = 'Y' and a.member_no = '" + auth.getString("_MEMBER_NO") + "' and a.status in ('50', '91', '99') and a.subscription_yn is null " +
			"   and a.cont_date >= '" + u.getTimeString("yyyyMM") + "01" + "' " +
			"   and a.cont_date <= '" + u.getTimeString("yyyyMMdd") + "' ";
	// 조회권한에 따른 where절 추가
	if (!auth.getString("_DEFAULT_YN").equals("Y")) {
		// 10:담당조회  20:부서조회 
		if (_authDao.getAuthMenuInfoB(auth.getString("_MEMBER_NO"), auth.getString("_AUTH_CD"), "000063", "select_auth").equals("10")) {
			step4Query = step4Query + 
					"and ( " +
					"       a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' " +
				    "    or a.reg_id = '" + auth.getString("_USER_ID") + "' " +
				    "    or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + auth.getString("_MEMBER_NO") + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '000063') " +
			    	") ";
		}
		if (_authDao.getAuthMenuInfoB(auth.getString("_MEMBER_NO"), auth.getString("_AUTH_CD"), "000063", "select_auth").equals("20")) {
			step4Query = step4Query +
					"and ( " +
					"       a.agree_field_seqs like '%|" + auth.getString("_FIELD_SEQ") + "|%' " +
					"    or a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' " + // 결제 라인 조회 권한은 부여된 권한 보다 우선 한다.
					"    or a.field_seq in (select field_seq from tcb_field start with member_no = '" + auth.getString("_MEMBER_NO") + "' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq) " + 
					"    or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + auth.getString("_MEMBER_NO") + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '000063') " +
					") ";
		}
	}
	DataSet step4Cnt = step4Dao.query(step4Query);
	if (step4Cnt.next()) step4 = step4Cnt.getInt("step4cnt");
	
	// 연장계약(계약만료일 45일전 계약완료건수)
	DataObject step5Dao = new DataObject();
	String step5Query = 
			"select count(*) as step5cnt " +
			"  from tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu and a.paper_yn is null " +
			" where b.list_cust_yn = 'Y' and a.member_no = '" + auth.getString("_MEMBER_NO") + "' and a.status in ('50', '91', '99') and a.subscription_yn is null " +
			"   and TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN TO_CHAR((TO_DATE(a.cont_date,'YYYYMMDD') + (INTERVAL '1' YEAR) - 45),'YYYYMMDD') AND TO_CHAR(TO_DATE(a.cont_date,'YYYYMMDD') + (INTERVAL '1' YEAR),'YYYYMMDD')";

	// 조회권한에 따른 where절 추가
	if (!auth.getString("_DEFAULT_YN").equals("Y")) {
		// 10:담당조회  20:부서조회 
		if (_authDao.getAuthMenuInfoB(auth.getString("_MEMBER_NO"), auth.getString("_AUTH_CD"), "000063", "select_auth").equals("10")) {
			step5Query = step5Query + 
					"and ( " +
					"       a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' " +
				    "    or a.reg_id = '" + auth.getString("_USER_ID") + "' " +
				    "    or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + auth.getString("_MEMBER_NO") + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '000063') " +
			    	") ";
		}
		if (_authDao.getAuthMenuInfoB(auth.getString("_MEMBER_NO"), auth.getString("_AUTH_CD"), "000063", "select_auth").equals("20")) {
			step5Query = step5Query +
					"and ( " +
					"       a.agree_field_seqs like '%|" + auth.getString("_FIELD_SEQ") + "|%' " +
					"    or a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' " + // 결제 라인 조회 권한은 부여된 권한 보다 우선 한다.
					"    or a.field_seq in (select field_seq from tcb_field start with member_no = '" + auth.getString("_MEMBER_NO") + "' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq) " + 
					"    or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + auth.getString("_MEMBER_NO") + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '000063') " +
					") ";
		}
	}
	DataSet step5Cnt = step5Dao.query(step5Query);
	if (step5Cnt.next()) step5 = step5Cnt.getInt("step5cnt");
	
	// 계약진행이력(진행중(보낸/받은계약)) 목록
	DataObject sListDao = new DataObject();
	StringBuffer sListSql = new StringBuffer();
	sListSql.append("select cont_name, cont_date, status "); 
	sListSql.append("from ");
	sListSql.append("( ");
	sListSql.append("    select a.cont_name, a.cont_date, a.status ");
	sListSql.append("    from tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu ");
	sListSql.append("    where b.list_cust_yn = 'Y' ");
	sListSql.append("      and a.member_no = '" + auth.getString("_MEMBER_NO") + "' ");
	sListSql.append("      and a.status in ('11', '12', '20', '21', '30', '40', '41') ");
	sListSql.append("      and a.subscription_yn is null "); // 신청서 제외
	if (!auth.getString("_DEFAULT_YN").equals("Y")) { // 조회권한
		// 10:담당조회  20:부서조회 
		if (_authDao.getAuthMenuInfoB(auth.getString("_MEMBER_NO"), auth.getString("_AUTH_CD"), "000060", "select_auth").equals("10")) {
			sListSql.append("      and ( ");
			sListSql.append("          a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' ");
			sListSql.append("          or a.reg_id = '" + auth.getString("_USER_ID") + "' ");
			sListSql.append("          or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + auth.getString("_MEMBER_NO") + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '000060') ");
			sListSql.append("      ) ");
		}
		if (_authDao.getAuthMenuInfoB(auth.getString("_MEMBER_NO"), auth.getString("_AUTH_CD"), "000060", "select_auth").equals("20")) {
			sListSql.append("      and (  ");
			sListSql.append("          a.agree_field_seqs like '%|" + auth.getString("_FIELD_SEQ") + "|%' ");
			sListSql.append("          or a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' "); // 결제 라인 조회 권한은 부여된 권한 보다 우선 한다.
			sListSql.append("          or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + auth.getString("_MEMBER_NO") + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '000060') ");
			sListSql.append("      ) ");
		}
	}
	sListSql.append("    order by a.reg_date desc ");
	sListSql.append(") ");
	sListSql.append("where rownum <= 5");
	sList = sListDao.query(sListSql.toString());
	while (sList.next()) {
		String name = sList.getString("cont_name");
		if (name.length() > 20) {
			sList.put("cont_name_short", name.substring(0, 20) + "...");
			sList.put("tooltip_yn", "Y");
		} else {
			sList.put("cont_name_short", name);
			sList.put("tooltip_yn", "N");
		}
		sList.put("cont_date", u.getTimeString("yyyy-MM-dd", sList.getString("cont_date")));
		String status = sList.getString("status");
		if (status.equals("11")) {
			sList.put("status_name", "검토중");
		} else if (status.equals("12")) {
			sList.put("status_name", "내부반려");
		} else if (status.equals("20")) {
			sList.put("status_name", "서명요청");
		} else if (status.equals("21")) {
			sList.put("status_name", "승인대기");
		} else if (status.equals("30")) {
			sList.put("status_name", "서명대기");
		} else if (status.equals("40")) {
			sList.put("status_name", "수정요청");
		} else if (status.equals("41")) {
			sList.put("status_name", "반려");
		} else {
			sList.put("status_name", "");
		}
	}
	if (sList.size() < 5) {
		for (int i=sList.size(); i<5; i++) {
			sList.addRow();
			sList.put("cont_name", "");
			sList.put("cont_name_short", "");
			sList.put("cont_date", "");
			sList.put("status", "");
			sList.put("status_name", "");
		}
	}
	tLink = "/web/buyer/contract/contract_writing_list.jsp";
	sLink = "/web/buyer/contract/contract_send_list.jsp";
	eLink = "/web/buyer/contract/contend_send_list.jsp";
}

if (auth.getString("_MEMBER_TYPE").equals("02") || auth.getString("_MEMBER_TYPE").equals("03")) { //을사
	// 계약작성(임시저장, status=10) 갯수
	step1 = 0; // 을에는 임시저장이 없음
	DataObject sListDao = new DataObject();
	StringBuffer sListSql = new StringBuffer();
	
	if(auth.getString("_MEMBER_NO").equals("20201000002")){
		// 농심(을) 로그인 시 이름과 휴대폰 번호로 계약 건 노출
		DataObject ssoUserDao = new DataObject("sso_user_info");
		DataSet ssoUser = ssoUserDao.find("user_id = '" + auth.getString("_USER_ID") + "' ");
		if (!ssoUser.next()) {
			u.jsError("사용자 정보가 존재하지 않습니다.");
			return;
		}
		String userName = ssoUser.getString("user_name");
		String celNo = ssoUser.getString("cel_no");
		String celNo1 = celNo.replaceAll("-", "").substring(0, 3);
		String celNo2 = celNo.replaceAll("-", "").substring(3, 7);
		String celNo3 = celNo.replaceAll("-", "").substring(7);
		
		// 서명요청(status=20) 갯수
		DataObject step2Dao = new DataObject();
		String step2Query = 
				"select count(*) as step2cnt " +
				"  from tcb_contmaster a, tcb_cust b, tcb_member c " +
				" where a.cont_no = b.cont_no  and a.cont_chasu = b.cont_chasu and a.member_no <> b.member_no and a.member_no = c.member_no " +
				"   and b.member_no = '" + auth.getString("_MEMBER_NO") + "' and a.status = '20' " +
				"   and b.user_name = '" + userName + "' and b.hp1 = '" + celNo1 + "' and b.hp2 = '" + celNo2 + "' and b.hp3 = '" + celNo3 + "' ";
		DataSet step2Cnt = step2Dao.query(step2Query);
		if (step2Cnt.next()) step2 = step2Cnt.getInt("step2cnt");
		
		// 서명대기(을 서명완료, status=30) 갯수
		DataObject step3Dao = new DataObject();
		String step3Query = 
				"select count(*) as step3cnt " +
				"  from tcb_contmaster a, tcb_cust b, tcb_member c " +
				" where a.cont_no = b.cont_no  and a.cont_chasu = b.cont_chasu and a.member_no <> b.member_no and a.member_no = c.member_no " +
				"   and b.member_no = '" + auth.getString("_MEMBER_NO") + "' and a.status = '30' " +
				"   and b.user_name = '" + userName + "' and b.hp1 = '" + celNo1 + "' and b.hp2 = '" + celNo2 + "' and b.hp3 = '" + celNo3 + "' ";
		DataSet step3Cnt = step3Dao.query(step3Query);
		if (step3Cnt.next()) step3 = step3Cnt.getInt("step3cnt");
		
		// 계약완료(갑/을 서명완료, status=50,91) 갯수
		DataObject step4Dao = new DataObject();
		String step4Query = 
				"select count(*) as step4cnt " +
				"  from tcb_contmaster a, tcb_cust b, tcb_member c " +
				" where a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu and a.member_no <> b.member_no and a.member_no = c.member_no " +
				"   and b.member_no = '" + auth.getString("_MEMBER_NO") + "' and a.status in ('50', '91') " + 
				"   and b.user_name = '" + userName + "' and b.hp1 = '" + celNo1 + "' and b.hp2 = '" + celNo2 + "' and b.hp3 = '" + celNo3 + "' ";
		DataSet step4Cnt = step4Dao.query(step4Query);
		if (step4Cnt.next()) step4 = step4Cnt.getInt("step4cnt");
		
		// 연장계약 갯수
		DataObject step5Dao = new DataObject();
		String step5Query = 
				"select count(*) as step5cnt " +
				"  from tcb_contmaster a, tcb_cust b, tcb_member c " +
				" where a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu and a.member_no <> b.member_no and a.member_no = c.member_no " +
				"   and b.member_no = '" + auth.getString("_MEMBER_NO") + "' and a.status in ('50', '91') " +
				"   and TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN TO_CHAR((TO_DATE(a.cont_date,'YYYYMMDD') + (INTERVAL '1' YEAR) - 45),'YYYYMMDD') AND TO_CHAR(TO_DATE(a.cont_date,'YYYYMMDD') + (INTERVAL '1' YEAR),'YYYYMMDD')" +
				"   and b.user_name = '" + userName + "' and b.hp1 = '" + celNo1 + "' and b.hp2 = '" + celNo2 + "' and b.hp3 = '" + celNo3 + "' ";
		DataSet step5Cnt = step5Dao.query(step5Query);
		if (step5Cnt.next()) step5 = step4Cnt.getInt("step5cnt");
		
		// 계약진행이력(진행중(보낸/받은계약)) 목록
		sListSql.append("select cont_name, cont_date, status, sign_dn "); 
		sListSql.append("from ");
		sListSql.append("( ");
		sListSql.append("    select a.cont_name, a.cont_date, a.status, b.sign_dn ");
		sListSql.append("    from tcb_contmaster a, tcb_cust b, tcb_member c ");
		sListSql.append("    where a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu ");
		sListSql.append("      and a.member_no <> b.member_no ");
		sListSql.append("      and a.member_no = c.member_no ");
		sListSql.append("      and b.member_no = '" + auth.getString("_MEMBER_NO") + "' ");
		sListSql.append("      and a.status in ('20','21','30','40','41') "); // 20:서명요청, 21:을사서명 후 갑검토대상, 30:을사 서명 완료 후 갑서명대상, 40:반려
		sListSql.append("      and b.user_name = '" + userName + "' and b.hp1 = '" + celNo1 + "' and b.hp2 = '" + celNo2 + "' and b.hp3 = '" + celNo3 + "' ");
		sListSql.append("    order by a.cont_date desc, a.cont_no desc ");
		sListSql.append(") ");
		sListSql.append("where rownum <= 5");
	}else{
		// 서명요청(status=20) 갯수
		DataObject step2Dao = new DataObject();
		String step2Query = 
				"select count(*) as step2cnt " +
				"  from tcb_contmaster a, tcb_cust b, tcb_member c " +
				" where a.cont_no = b.cont_no  and a.cont_chasu = b.cont_chasu and a.member_no <> b.member_no and a.member_no = c.member_no " +
				"   and b.member_no = '" + auth.getString("_MEMBER_NO") + "' and a.status = '20' ";
		DataSet step2Cnt = step2Dao.query(step2Query);
		if (step2Cnt.next()) step2 = step2Cnt.getInt("step2cnt");
		
		// 서명대기(을 서명완료, status=30) 갯수
		DataObject step3Dao = new DataObject();
		String step3Query = 
				"select count(*) as step3cnt " +
				"  from tcb_contmaster a, tcb_cust b, tcb_member c " +
				" where a.cont_no = b.cont_no  and a.cont_chasu = b.cont_chasu and a.member_no <> b.member_no and a.member_no = c.member_no " +
				"   and b.member_no = '" + auth.getString("_MEMBER_NO") + "' and a.status = '30' ";
		DataSet step3Cnt = step3Dao.query(step3Query);
		if (step3Cnt.next()) step3 = step3Cnt.getInt("step3cnt");
		
		// 계약완료(갑/을 서명완료, status=50,91) 갯수
		DataObject step4Dao = new DataObject();
		String step4Query = 
				"select count(*) as step4cnt " +
				"  from tcb_contmaster a, tcb_cust b, tcb_member c " +
				" where a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu and a.member_no <> b.member_no and a.member_no = c.member_no " +
				"   and b.member_no = '" + auth.getString("_MEMBER_NO") + "' and a.status in ('50', '91') ";
		DataSet step4Cnt = step4Dao.query(step4Query);
		if (step4Cnt.next()) step4 = step4Cnt.getInt("step4cnt");
		
		// 연장계약 갯수
		DataObject step5Dao = new DataObject();
		String step5Query = 
				"select count(*) as step5cnt " +
				"  from tcb_contmaster a, tcb_cust b, tcb_member c " +
				" where a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu and a.member_no <> b.member_no and a.member_no = c.member_no " +
				"   and b.member_no = '" + auth.getString("_MEMBER_NO") + "' and a.status in ('50', '91') " +
				"   and TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN TO_CHAR((TO_DATE(a.cont_date,'YYYYMMDD') + (INTERVAL '1' YEAR) - 45),'YYYYMMDD') AND TO_CHAR(TO_DATE(a.cont_date,'YYYYMMDD') + (INTERVAL '1' YEAR),'YYYYMMDD')";
		DataSet step5Cnt = step5Dao.query(step5Query);
		if (step5Cnt.next()) step5 = step4Cnt.getInt("step5cnt");
		
		// 계약진행이력(진행중(보낸/받은계약)) 목록
		sListSql.append("select cont_name, cont_date, status, sign_dn "); 
		sListSql.append("from ");
		sListSql.append("( ");
		sListSql.append("    select a.cont_name, a.cont_date, a.status, b.sign_dn ");
		sListSql.append("    from tcb_contmaster a, tcb_cust b, tcb_member c ");
		sListSql.append("    where a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu ");
		sListSql.append("      and a.member_no <> b.member_no ");
		sListSql.append("      and a.member_no = c.member_no ");
		sListSql.append("      and b.member_no = '" + auth.getString("_MEMBER_NO") + "' ");
		sListSql.append("      and a.status in ('20','21','30','40','41') "); // 20:서명요청, 21:을사서명 후 갑검토대상, 30:을사 서명 완료 후 갑서명대상, 40:반려
		sListSql.append("    order by a.cont_date desc, a.cont_no desc ");
		sListSql.append(") ");
		sListSql.append("where rownum <= 5");
	}
	
	sList = sListDao.query(sListSql.toString());
	while (sList.next()) {
		String name = sList.getString("cont_name");
		if (name.length() > 20) {
			sList.put("cont_name_short", name.substring(0, 20) + "...");
			sList.put("tooltip_yn", "Y");
		} else {
			sList.put("cont_name_short", name);
			sList.put("tooltip_yn", "N");
		}
		sList.put("cont_date", u.getTimeString("yyyy-MM-dd", sList.getString("cont_date")));
		String status = sList.getString("status");
		if (status.equals("20") || status.equals("21") || status.equals("30")) {
			if (sList.getString("sign_dn").equals("")) {
				sList.put("status_name", "서명요청");
			} else {
				sList.put("status_name", "서명진행중");
			}
		} else if (status.equals("40")) {
			sList.put("status_name", "수정요청");
		} else if (status.equals("41")) {
			sList.put("status_name", "반려");
		} else {
			sList.put("status_name", "");
		}
	}
	if (sList.size() < 5) {
		for (int i=sList.size(); i<5; i++) {
			sList.addRow();
			sList.put("cont_name", "");
			sList.put("cont_name_short", "");
			sList.put("cont_date", "");
			sList.put("status", "");
			sList.put("status_name", "");
		}
	}
	sLink = "/web/buyer/contract/contract_recv_list.jsp";
	eLink = "/web/buyer/contract/contend_recv_list.jsp";
}

//공지사항 목록
DataObject nListDao = new DataObject();
StringBuffer nListSql = new StringBuffer();
nListSql.append("select title, reg_date ");
nListSql.append("from ");
nListSql.append("( ");
nListSql.append("    select title, reg_date "); 
nListSql.append("    from tcb_board ");
nListSql.append("    where category = 'noti' and open_yn= 'Y' ");
nListSql.append("    order by open_date desc ");
nListSql.append(") ");
nListSql.append("where rownum <= 5 ");
nList = nListDao.query(nListSql.toString());
while (nList.next()) {
	String title = nList.getString("title");
	if (title.length() > 20) {
		nList.put("title_short", title.substring(0, 20) + "...");
		nList.put("tooltip_yn", "Y");
	} else {
		nList.put("title_short", title);
		nList.put("tooltip_yn", "N");
	}
	nList.put("reg_date", u.getTimeString("yyyy-MM-dd", nList.getString("reg_date")));
}
if (nList.size() < 5) {
	for (int i=nList.size(); i<5; i++) {
		nList.addRow();
		nList.put("title", "");
		nList.put("title_short", "");
		nList.put("reg_date", "");
	}
}
nLink = "/web/buyer/center/noti_list.jsp";

p.setLayout("default");
//p.setDebug(out);
p.setBody("main.index2");
p.setVar("step1", step1);
p.setVar("step2", step2);
p.setVar("step3", step3);
p.setVar("step4", step4);
p.setVar("step5", step5);
p.setLoop("sList", sList);
p.setLoop("nList", nList);
p.setVar("tLink", tLink);
p.setVar("sLink", sLink);
p.setVar("eLink", eLink);
p.setVar("nLink", nLink);
p.display(out);
%>