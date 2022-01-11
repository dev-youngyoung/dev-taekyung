<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
// 사업자, 개인 모두 검색할 수 있는 화면 사용(C:사업자, P:개인, B:개인사업자 대표자, 공백: 개별) CP, CP로 구분 하여 사용
String search_type = u.request("search_type");  
String sign_seq = u.request("sign_seq");

f.addElement("s_member_name", null, null);
f.addElement("s_vendcd", null, null);
f.addElement("s_if_gubn", null, null);

// 목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
/* list.setTable("(SELECT MEMBER_NAME, VENDCD, BOSS_NAME, MEMBER_NO, ADDRESS, replace(POST_CODE,'-','') POST_CODE, '01' MEMBER_GUBUN, NULL USER_NAME, NULL HP1, NULL HP2, NULL HP3, NULL EMAIL FROM TCB_MEMBER " +
		   		"WHERE MEMBER_GUBUN <> '04' AND NVL(STATUS, 'Z') <> '90' AND MEMBER_NO NOT IN ('" + _member_no + "')" +
		   		"UNION " +
		   		"SELECT A.COM_NAME, COMM_NO, A.BOSS_NAME, A.MEMBER_NO, A.HEAD_OFCE_ADRS, replace(A.HEAD_OFCE_POST,'-','') HEAD_OFCE_POST, '01', B.USER_NAME, B.HP1, B.HP2, B.HP3, B.EMAIL FROM IF_MMBAT100 A, TCB_PERSON B WHERE A.MEMBER_NO = B.MEMBER_NO AND B.PERSON_SEQ = (SELECT MAX(X.PERSON_SEQ) FROM TCB_PERSON X WHERE A.MEMBER_NO = X.MEMBER_NO))"); */
list.setTable(
		"(SELECT TO_CHAR(TO_NUMBER(A.CUST_CODE)) AS CUST_CODE, A.IF_GUBN, A.COM_NAME MEMBER_NAME, COMM_NO VENDCD, A.BOSS_NAME, A.MEMBER_NO, A.HEAD_OFCE_ADRS ADDRESS, replace(A.HEAD_OFCE_POST,'-','') POST_CODE, '01' MEMBER_GUBUN, B.USER_NAME, B.HP1, B.HP2, B.HP3, B.EMAIL, NVL2(B.HP1||B.HP2||B.HP3,B.HP1||'-'||B.HP2||'-'||B.HP3,'') AS MEM_HP " + 
		" FROM IF_MMBAT100 A, " + 
		" (SELECT MEMBER_NO, PERSON_SEQ, USER_NAME, HP1, HP2, HP3, EMAIL FROM ( SELECT ROW_NUMBER() OVER(PARTITION BY MEMBER_NO ORDER BY PERSON_SEQ DESC) RNUM, MEMBER_NO, PERSON_SEQ, USER_NAME, HP1, HP2, HP3, EMAIL FROM TCB_PERSON )" +
		" WHERE RNUM = 1 ) B " +
		" WHERE A.MEMBER_NO = B.MEMBER_NO(+)) "
		);       
list.setFields("*");
list.addWhere("LOWER(MEMBER_NAME) LIKE LOWER('%" + f.get("s_member_name") + "%')");
list.addSearch("VENDCD", f.get("s_vendcd"), "LIKE");
list.addSearch("IF_GUBN", f.get("s_if_gubn"));
list.setOrderBy("MEMBER_NAME");

DataSet ds = null;
Security security = new	Security();
if (!u.request("search").equals("")) {
	// 목록 데이타 수정
	ds = list.getDataSet();

	while (ds.next()) {
		if (!ds.getString("jumin_no").equals("")) {
			String jumin_no = security.AESdecrypt(ds.getString("jumin_no"));
			String genderHan = "";
			if (jumin_no.length() > 6){
				genderHan = u.inArray(jumin_no.substring(6, 7), new String[]{"1", "3"}) ? " (남)" : " (여)";
			}
			ds.put("print_jumin_no", jumin_no.substring(0, 2) + "년 " + jumin_no.substring(2, 4) + "월 " + jumin_no.substring(4, 6) + "일" + genderHan);
			ds.put("jumin_no", jumin_no);
		}
		if (!ds.getString("boss_birth_date").equals("")) {
			String gender = ds.getString("boss_gender");
			ds.put("print_jumin_no", u.getTimeString("yy년MM월dd일", ds.getString("boss_birth_date")) + "(" + gender + ")");
			ds.put("jumin_no", ds.getString("boss_birth_date"));
			ds.put("boss_birth_date", u.getTimeString("yyyy-MM-dd", ds.getString("boss_birth_date")));
		}
		if (ds.getString("if_gubn").equals("01")) ds.put("if_gubn_name", "판매처");
		else if (ds.getString("if_gubn").equals("02")) ds.put("if_gubn_name", "공급처");
	}
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_search_cust");
p.setVar("popup_title", "업체 검색");
p.setVar("tab_view_cp", search_type.equals("CP"));
p.setVar("tab_view_pb", search_type.equals("PB"));
p.setLoop("list", ds);
p.setVar("sign_seq", sign_seq);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>