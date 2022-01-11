<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.Jsoup"%>
<%@ page import="org.jsoup.nodes.Document" %>
<%@ page import="org.jsoup.nodes.Element" %>
<%@ page import="org.jsoup.select.Elements" %>
<%@ page import="procure.common.file.MakeZip" %>
<%
String _menu_cd = "000063";

DataObject memberDao = new DataObject("tcb_member");
//memberDao.setDebug(out);
DataSet member = memberDao.find("member_no = '" + _member_no + "'");
if (!member.next()) {
	u.jsError("사용자 정보가 존재하지 않습니다.");
	return;
}

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008", "and code in ('50', '91', '99')");
String[] code_bid_method = null;
String[] code_succ_method = null;
String[] code_vat_type = {"1=>VAT별도", "2=>VAT포함", "3=>VAT미선택"}; // 자유서식 VAT유형

String sTable = "tcb_contmaster a, tcb_cust b, tcb_cust c, tcb_person d "; // b:을(업체)정보, c:갑(농심)정보, d:유저정보

String sColumn = "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date, a.cont_sdate, a.cont_edate, a.cont_total, a.reg_date, a.reg_id, a.stamp_type, a.appr_status, a.appr_yn, a.status, a.cont_userno, a.cont_etc1, a.cont_etc2, a.auto_yn, b.member_no, b.member_name, b.vendcd, b.boss_name, b.cust_detail_code, a.true_random, a.sign_types, c.user_name, c.division, d.division as division_p, "
			   + "( SELECT COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt ";

Calendar mon = Calendar.getInstance();
mon.add(Calendar.MONTH , -12);
String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd",mon.getTime()));
String s_edate = u.request("s_edate" , u.getTimeString("yyyy-MM-dd"));

f.addElement("s_cont_name", null, null);
f.addElement("s_cust_name", null, null);
f.addElement("s_vendcd", null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_manage_no", null, null);
f.addElement("s_user_name", null, null);
f.addElement("hdn_sort_column", null, null);
f.addElement("hdn_sort_order", null, null);
f.addElement("s_cont_gubun", null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel", "report"}) ? -1 : 15);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere("a.cont_no = b.cont_no ");
list.addWhere("a.cont_chasu = b.cont_chasu ");
list.addWhere("a.member_no != b.member_no ");
list.addWhere("a.cont_no = c.cont_no ");
list.addWhere("a.cont_chasu = c.cont_chasu ");
list.addWhere("a.member_no = c.member_no ");
list.addWhere("a.reg_id = d.user_id ");
list.addWhere("d.member_no = '" + _member_no + "' ");
list.addWhere("a.paper_yn is null ");
list.addWhere("a.member_no = '" + _member_no + "' ");
list.addWhere("a.status in ('50', '91', '99') "); // 50:완료된 계약, 91:계약해지, 99:계약폐기
list.addWhere("a.subscription_yn is null "); // 신청서 제외

String s_date_query = "";
if (!s_sdate.equals("")) {
	list.addWhere("a.cont_date >= '" + s_sdate.replaceAll("-", "") + "'");
	s_date_query = "and cont_date >= '" + s_sdate.replaceAll("-", "") + "'";
}
if (!s_edate.equals("")) {
	list.addWhere("a.cont_date <= '" + s_edate.replaceAll("-", "") + "'");
	s_date_query += "and cont_date <= '" + s_edate.replaceAll("-", "") + "'";
}

if (!f.get("s_cont_name").equals("")) { // 티알엔 대소문자 구분 없이 검색 2020-02-12
	list.addWhere("lower(a.cont_name) like '%'||lower('" + f.get("s_cont_name") + "')||'%'");
}

list.addSearch("b.member_name", f.get("s_cust_name"), "LIKE");
list.addSearch("b.vendcd",  f.get("s_vendcd").replaceAll("-", ""), "LIKE");
list.addSearch("a.status", f.get("s_status"));
list.addSearch("c.user_name", f.get("s_user_name"), "LIKE");
list.addSearch("a.cont_etc1",  f.get("s_division"));  // CJ대한통운
list.addSearch("a.field_seq",  f.get("s_field_seq")); // CJ대한통운 
list.addSearch("d.project_cd",  f.get("s_project_cd"),"LIKE");  // 엘지히타치

// 조회권한
if (!auth.getString("_DEFAULT_YN").equals("Y")) {
	//10:담당조회  20:부서조회 
	if (_authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), _menu_cd, "select_auth").equals("10")) {
		list.addWhere(
				  "("
				+ "   a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' "
			    + "or a.reg_id = '" + auth.getString("_USER_ID") + "' "
			    + "or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + _member_no + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '" + _menu_cd + "') "
		    	+ ")"); 
	}
	if (_authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), _menu_cd, "select_auth").equals("20")) {
		list.addWhere(
				  "("
				+ "   a.agree_field_seqs like '%|" + auth.getString("_FIELD_SEQ") + "|%' "
				+ "or a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' " // 결제 라인 조회 권한은 부여된 권한 보다 우선 한다.
				+ "or a.field_seq in (select field_seq from tcb_field start with member_no = '" + _member_no + "' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq ) " 
				+ "or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + _member_no + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '" + _menu_cd + "') " 
				+ ")");
	}
}
//계약구분
if("P".equals(f.get("s_cont_gubun"))){
	// 표준계약
	list.addWhere(" a.template_cd is not null ");
}else if("B".equals(f.get("s_cont_gubun"))){
	// 비표준계약
	list.addWhere(" a.template_cd is null ");
}else if("A".equals(f.get("s_cont_gubun"))){
	// 자동연장
	list.addWhere(" a.auto_yn = 'Y' ");
}

String sSortColumn = f.get("hdn_sort_column");
String sSortOrder = f.get("hdn_sort_order");
String sSortCustNameIconName = "";
if (!sSortColumn.equals("")) {
	if (sSortOrder.equals("asc")) sSortCustNameIconName = "<font style='color:blue;font-weight:bold'>↑</font>";
	else sSortCustNameIconName = "<font style='color:blue;font-weight:bold'>↓</font>";
	list.setOrderBy(sSortColumn + " " + sSortOrder);
} else {
	sSortCustNameIconName = "<font style='color:blue;font-weight:bold'>↕</font>";
	// list.setOrderBy("a.cont_no desc, a.cont_chasu asc");
	list.setOrderBy("a.reg_date desc");
}

DataSet ds = list.getDataSet();
while (ds.next()) {
	ds.put("manage_no", ds.getString("cont_no") + "-" + ds.getString("cont_chasu") + "-" + ds.getString("true_random"));
    ds.put("cont_no_dec", ds.getString("cont_no"));
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if (ds.getInt("cont_chasu") > 0) {
		if (!u.request("mode").equals("excel")) {
			ds.put("cont_name", "<img src='../html/images/re.jpg' align='absmiddle'> " + ds.getString("cont_name") + " (" + ds.getString("cont_chasu") + "차)");
		} else {
			ds.put("cont_name", "	" + ds.getString("cont_name") + " (" + ds.getString("cont_chasu") + "차)");
		}
	}
	if (ds.getInt("cust_cnt")-2 > 0) {
		ds.put("cust_name", ds.getString("member_name") + "외" + (ds.getInt("cust_cnt")-2) + "개사");
	} else {
		ds.put("cust_name", ds.getString("member_name"));
	}
	ds.put("link", ds.getString("template_cd").equals("") ? "contend_free_sendview.jsp" : ds.getString("sign_types").equals("") ? "contend_sendview.jsp" : "contend_msign_sendview.jsp");
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd", ds.getString("cont_date")));
	ds.put("cont_sdate", u.getTimeString("yyyy-MM-dd", ds.getString("cont_sdate")));
	ds.put("cont_edate", u.getTimeString("yyyy-MM-dd", ds.getString("cont_edate")));
	ds.put("reg_date", u.getTimeString("yyyy-MM-dd", ds.getString("reg_date")));
	ds.put("status_nm", u.getItem(ds.getString("status"), code_status));
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	ds.put("cont_total", u.numberFormat(ds.getDouble("cont_total"), 0));
	ds.put("write_type", ds.getString("template_cd").equals("") ? "자유서식" : "일반서식");
	if (ds.getString("division") == null || ds.getString("division").equals("")) ds.put("division", ds.getString("division_p"));
	if (ds.getString("appr_status").equals("10")) ds.put("appr_status_name", "상신대기");
	else if (ds.getString("appr_status").equals("20")) ds.put("appr_status_name", "상신완료");
	else if (ds.getString("appr_status").equals("30")) ds.put("appr_status_name", "기안올림");
	else if (ds.getString("appr_status").equals("31")) ds.put("appr_status_name", "중간승인");
	else if (ds.getString("appr_status").equals("40")) ds.put("appr_status_name", "기안반려");
	else if (ds.getString("appr_status").equals("50")) ds.put("appr_status_name", "최종승인");
	else ds.put("appr_status_name", ds.getString("appr_status"));
}
 
if (u.request("mode").equals("excel")) {
	p.setVar("title", "완료된 계약현황");
	String xlsFile = "contend_send_list_excel.html";
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("완료된 계약현황.xls".getBytes("KSC5601"), "8859_1") + "\"");
	out.println(p.fetch("../html/contract/" + xlsFile));
	return;
} else if(u.request("mode").equals("report")){
	ds.first();
	while(ds.next()){
		Document document = Jsoup.parse(ds.getString("cont_html"));
		String cont_ref_info = getJsoupValue(document,"ref_info");
		String cont_edate = "";
		String cont_eyear = getJsoupValue(document, "cont_eyear");
		String cont_emonth = getJsoupValue(document, "cont_emonth");
		String cont_eday = getJsoupValue(document, "cont_eday");
		String cont_pre = getJsoupValue(document, "cont_pre");
		String cont_middle1 = getJsoupValue(document, "cont_middle1");
		String cont_middle2 = getJsoupValue(document, "cont_middle2");
		String cont_rest = getJsoupValue(document, "cont_rest");
		if (!cont_eyear.equals("") && !cont_emonth.equals("") && !cont_eday.equals("")) {
			cont_edate = cont_eyear + cont_emonth + cont_eday;
		}
		ds.put("cont_ref_info", cont_ref_info);
		ds.put("cont_edate", u.getTimeString("yyyy-MM-dd", cont_edate));
		ds.put("calc_cont_pre","");
		ds.put("calc_cont_middle1","");
		ds.put("calc_cont_middle2","");
		ds.put("calc_cont_rest","");
		if (ds.getDouble("cont_total")>0) {
			if (!cont_pre.equals("")) ds.put("calc_cont_pre", (Double.parseDouble(cont_pre.replaceAll(",", "")) / ds.getDouble("cont_total") * 100));
			if (!cont_middle1.equals("")) ds.put("calc_cont_middle1", (Double.parseDouble(cont_middle1.replaceAll(",", "")) / ds.getDouble("cont_total") * 100));
			if (!cont_middle2.equals("")) ds.put("calc_cont_middle2", (Double.parseDouble(cont_middle2.replaceAll(",", "")) / ds.getDouble("cont_total") * 100));
			if (!cont_rest.equals("")) ds.put("calc_cont_rest", (Double.parseDouble(cont_rest.replaceAll(",", "")) / ds.getDouble("cont_total") * 100));
		}
		ds.put("cont_pre", cont_pre);
		ds.put("cont_middle1", cont_middle1);
		ds.put("cont_middle2", cont_middle2);
		ds.put("cont_rest", cont_rest);
		ds.put("cont_total", u.numberFormat(ds.getDouble("cont_total"), 0));
	}

	p.setVar("title", "계&nbsp;&nbsp;약&nbsp;&nbsp;현&nbsp;&nbsp;황");
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("계약현황.xls".getBytes("KSC5601"), "8859_1") + "\"");
	out.println(p.fetch("../html/contract/contend_send_list_report.html"));
	return;
} else if(u.request("mode").equals("down")){
	String[] save = f.getArr("save");
	if(save==null) return;
	return;
}

DataObject templateDao = new DataObject();
DataSet template = templateDao.query("select nvl(display_name, template_name) template_name, template_cd from tcb_cont_template where template_cd in (select decode(template_cd, '', '9999999', template_cd) template_cd from tcb_contmaster where member_no = '" + _member_no + "'" + s_date_query + " and status in ('50', '91') group by template_cd) order by display_seq asc, template_cd desc");

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contend_send_list");
p.setVar("menu_cd", _menu_cd);
p.setVar("auth_select", _authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setVar("member", member);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("template", template);
p.setLoop("list", ds);
p.setVar("sSortColumn", sSortColumn);
p.setVar("sSortOrder", sSortOrder);
p.setVar("sSortCustNameIconName", sSortCustNameIconName);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>
<%!
public String getJsoupValue(Document document, String name) {
	String value = "";
	Elements elements = document.getElementsByAttributeValue("name", name);
	int i = 0;

	for (Element element : elements) {
		if (i > 0) value += "<br>";
		if (element.nodeName().equals("textarea")) value += element.text();
		else value += element.attr("value");
		i++;
	}
	return value;
}
%>