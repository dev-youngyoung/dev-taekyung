<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
// 사업자, 개인 모두 검색할 수 있는 화면 사용(C:사업자, P:개인, B:개인사업자 대표자, 공백: 개별) CP, CP로 구분 하여 사용
String search_type = u.request("search_type");  
String sign_seq = u.request("sign_seq");
String template_cd = u.request("template_cd");

f.addElement("s_division",null, null);
f.addElement("s_member_name",null, null);

// 목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
list.setTable("tcb_client a, tcb_member b, tcb_person c, tcb_member_boss d");
list.setFields("b.*, c.user_id, c.user_name, c.tel_num , c.hp1, c.hp2, c.hp3, c.email, c.division, c.user_empno,c.jumin_no boss_birth_date, d.boss_gender, d.boss_hp1, d.boss_hp2, d.boss_hp3,d.boss_email, d.boss_ci");
list.addWhere("a.client_no = b.member_no ");
list.addWhere("b.member_no = c.member_no ");
list.addWhere("b.member_no = d.member_no(+) ");
list.addWhere("b.member_gubun = '04' ");
list.addWhere("b.status <> '00' ");
list.addWhere("NVL(c.division, ' ') <> 'NDS' ");
//list.addWhere("c.default_yn = 'Y' ");
list.addWhere("a.member_no= '" + _member_no + "'");
// 템플릿에 따라 직원/일용직의 목록을 구별하여 보여줌
System.out.println("[pop_search_person.jsp] template_cd : " + template_cd);
if (!template_cd.isEmpty()) {
	if (template_cd.equals("2020811") || template_cd.equals("2020816") || template_cd.equals("2020819") || template_cd.equals("2020820")) {
		// 일용직
		list.addWhere("c.dept_yn = 'Y'");
		if (template_cd.equals("2020811") || template_cd.equals("2020816")) 
		{
			// [카레레스토랑팀]근로계약서(외식시급 B)월60시간 이상, [카레레스토랑팀]근로계약서(외식시급 A)월60시간 미만
			// 상위부서 = 현재로그인부서 에 부서 = 현재로그인부서 OR로 추가 (2021.06.11 swplus)
			//list.addWhere("c.prio_dept_code = '" + auth.getString("_FIELD_SEQ") + "'"); // 상위부서 = 현재 로그인 부서
			list.addWhere("(c.prio_dept_code = '" + auth.getString("_FIELD_SEQ") + "' or c.dept_code = '" + auth.getString("_FIELD_SEQ") + "')"); // 상위부서 = 현재 로그인 부서 or 부서 = 현재로그인부서
		} 
		else if (template_cd.equals("2020819") || template_cd.equals("2020820")) 
		{
			// [인사]근로계약서(단시간/시급), [인사]근로계약서(단시간/일급)
			list.addWhere("c.dept_code = '" + auth.getString("_FIELD_SEQ") + "'"); // 소속부서 = 현재 로그인 부서
		}
	} 
	else 
	{
		// 직원
		list.addWhere("c.dept_yn = 'N'");
		if (template_cd.equals("2020801")) 
		{
			// [인사]근로계약서(종합직/일반직 A)
			// orgd_code = '직급',job_code='직무' 
			list.addWhere("c.ogrd_code > '200'");
			list.addWhere("c.ogrd_code <= '750'");
			list.addWhere("c.job_code not in ('jb0207', 'ga0205', 'jf0307', 'jf0407')");
		} else if (template_cd.equals("2020802")) {
			// [인사]근로계약서(종합직/일반직 B)
			list.addWhere("c.ogrd_code > '200'");
			list.addWhere("c.ogrd_code <= '750'");
			list.addWhere("c.job_code in ('jb0207', 'ga0205', 'jf0307', 'jf0407')");
		} else if (template_cd.equals("2020803")) {
			// [인사]근로계약서(서비스_SSP직 A)
			list.addWhere("c.ogrd_code = '940'");
			list.addWhere("c.job_code != 'gc0103'");
		} else if (template_cd.equals("2020821")) {
			// [인사]근로계약서(서비스_SP직 A)
			list.addWhere("c.ogrd_code = '945'");
			list.addWhere("c.job_code != 'gc0103'");
		} else if (template_cd.equals("2020804")) {
			// [인사]근로계약서(서비스_농협SP직 B)
			list.addWhere("c.ogrd_code in ('940', '945')");
			list.addWhere("c.job_code = 'gc0103'");
		} else if (template_cd.equals("2021002")) {
			// [인사]개인정보동의서(순회SP직) : 신규적용(2021.02.15)
			list.addWhere("c.ogrd_code in ('940', '945', '721', '992')");
			list.addWhere("c.job_code = 'gc0102'");
		} else if (template_cd.equals("2020805")) {
			// [인사]근로계약서(서비스_TS직 A)
			list.addWhere("c.ogrd_code = '947'");
			list.addWhere("c.job_code not in ('gd0105', 'gd0109', 'gb0108')");
		} else if (template_cd.equals("2020807")) {
			// [인사]근로계약서(서비스_TS직 B)
			list.addWhere("c.ogrd_code = '947'");
			list.addWhere("c.job_code in ('gd0105', 'gd0109', 'gb0108', 'he0812', 'gd0108')");
		} else if (template_cd.equals("2020808")) {
			// [카레레스토랑팀]근로계약서(외식서비스_N카페 B)
			list.addWhere("c.ogrd_code in ('956', '968')");
		} else if (template_cd.equals("2020809")) {
			// [카레레스토랑팀]근로계약서(외식서비스_카레 A)
			list.addWhere("c.ogrd_code >= '950'");
			list.addWhere("c.ogrd_code <= '964'");
			list.addWhere("c.ogrd_code != '956'");
		} else if (template_cd.equals("2020810") || template_cd.equals("2020818")) {
			// [인사]근로계약서(계약직 A), [인사]근로계약서(계약직 B)
			list.addWhere("c.ogrd_code = '995'");
		}
	}
}
list.addSearch("c.user_name", f.get("s_member_name"), "LIKE");
list.addSearch("c.division", f.get("s_division"), "LIKE");
//list.setOrderBy("member_name asc");
list.setOrderBy("c.division, c.user_name asc");

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
		ds.put("member_name", ds.getString("user_name"));	//계약자 이름(B2C)
	}
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_search_person");
p.setVar("popup_title","개인 검색");
p.setVar("tab_view_cp", search_type.equals("CP"));
p.setVar("tab_view_pb", search_type.equals("PB"));
p.setLoop("list", ds);
p.setVar("template_cd", template_cd);
p.setVar("sign_seq", sign_seq);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>