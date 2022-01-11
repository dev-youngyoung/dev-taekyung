<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="procure.common.file.MakeZip"%>
<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.select.*" %>
<%
String _menu_cd = "000060";

CodeDao code = new CodeDao("tcb_comcode");
String[] code_status = code.getCodeArray("M008", " and code in ('21', '20', '30') "); // 콤보박스 승인대기, 서명요청, 서명대기
String[] combo_status = {code_status[1], code_status[0], code_status[2]};
//String[] code_status = code.getCodeArray("M008", " and code in ('11', '12', '20', '21', '30', '40', '41') ");

String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu";
String sColumn =  "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date, a.status, nvl(a.cont_userno,a.cont_no) cont_userno, a.auto_yn, " 
				+ "b.member_no, b.member_name, b.cust_detail_code, b.boss_name, a.sign_types, "
				+ "(select agree_person_name from tcb_cont_agree where cont_no = a.cont_no and cont_chasu = a.cont_chasu and agree_seq = "
				+ "    (select min(agree_seq) from tcb_cont_agree where cont_no = a.cont_no and cont_chasu = a.cont_chasu and agree_cd = 2 and r_agree_person_id is null)) agree_name, "
				+ "(SELECT COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt ";

f.addElement("s_cont_name", null, null);
f.addElement("s_cust_name", null, null);
f.addElement("s_vendcd", null, null);
f.addElement("s_status", null, null);
f.addElement("s_template_cd", null, null);
f.addElement("s_cont_gubun", null, null);

if (u.request("mode").equals("excel")) {
	sColumn += ", a.cont_total, a.true_random, a.cont_sdate, a.cont_edate, b.user_name, b.vendcd, b.tel_num, b.hp1, b.hp2, b.hp3, b.email, b.address, b.post_code";
}

// 목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel"})? -1 : 15);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere(" b.list_cust_yn = 'Y' ");
list.addWhere(" a.member_no = '" + _member_no + "' ");
list.addWhere(" a.status in ('11', '12', '20', '21', '30', '40', '41') ");
list.addWhere(" a.subscription_yn is null "); //신청서 제외

list.addSearch("a.status",  f.get("s_status"));
//list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
if (!f.get("s_cont_name").equals("")){ // 티알엔 대소문자 구분 없이 검색 2020-02-12
	list.addWhere(" lower(a.cont_name) like '%'||lower('"+f.get("s_cont_name")+"')||'%' ");
}
list.addSearch("a.cont_userno", f.get("s_cust_userno"), "LIKE");
list.addSearch("b.member_name", f.get("s_cust_name"), "LIKE");
list.addSearch("b.vendcd", f.get("s_vendcd").replaceAll("-", ""), "LIKE");
if (f.get("s_template_cd").equals("9999999")) { // 자유서식
	list.addWhere("a.template_cd is null");
} else {
	list.addSearch("a.template_cd", f.get("s_template_cd"));
}
list.addSearch("a.cont_etc1", f.get("s_division"));  // CJ대한통운
list.addSearch("a.field_seq", f.get("s_field_seq")); // CJ대한통운

// 조회권한
if (!auth.getString("_DEFAULT_YN").equals("Y")) {
	//10:담당조회  20:부서조회 
	if (_authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), _menu_cd, "select_auth").equals("10")) {
		list.addWhere("(  "
			+"     a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' "
		    +"  or a.reg_id = '" + auth.getString("_USER_ID") + "' "
		    +"  or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + _member_no + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '" + _menu_cd + "') "
		    +"           ) "); 
	}
	if (_authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), _menu_cd, "select_auth").equals("20")) {
		list.addWhere(" (  "
			+"     a.agree_field_seqs like '%|" + auth.getString("_FIELD_SEQ") + "|%' "
			+"  or a.agree_person_ids like '%" + auth.getString("_USER_ID") + "|%' " // 결제 라인 조회 권한은 부여된 권한 보다 우선 한다.
			+"  or a.field_seq in ( select field_seq from tcb_field start with member_no = '" + _member_no + "' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq ) " 
			+"  or a.field_seq in (select field_seq from tcb_auth_field where member_no = '" + _member_no + "' and auth_cd = '" + auth.getString("_AUTH_CD") + "' and menu_cd = '" + _menu_cd + "') " 
			+"          ) ");
	}
}

// 계약구분
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

list.setOrderBy("a.reg_date desc");

DataSet ds = list.getDataSet();
while (ds.next()) {
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if (ds.getInt("cust_cnt")-2 > 0) {
		ds.put("cust_name", ds.getString("member_name") + "외" + (ds.getInt("cust_cnt")-2) + "개사");
	} else {
		ds.put("cust_name", ds.getString("member_name"));
	}

	ds.put("link", ds.getString("template_cd").equals("") ? "contract_free_sendview.jsp" : ds.getString("sign_types").equals("") ? "contract_sendview.jsp" : "contract_msign_sendview.jsp");
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("cont_sdate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_sdate")));
	ds.put("cont_edate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_edate")));
	if (ds.getString("status").equals("30")) { // 서명대기 상태이면 색상 표시
		ds.put("status_name", "<span class=\"caution-text\">" + u.getItem(ds.getString("status"), code_status) + "</span>");
	} else if(ds.getString("status").equals("12")) { // 내부반려
		ds.put("status_name", "<span style='color:red'>" + u.getItem(ds.getString("status"), code_status) + "</span>");
	} else if(ds.getString("status").equals("21")) { // 승인대기
		ds.put("status_name", "<span class=\"caution-text\">" + u.getItem(ds.getString("status"), code_status) + "<br>(" + ds.getString("agree_name") + ")</span>");
	} else if(ds.getString("status").equals("40")) { // 수정요청 상태이면 생상 표시
		ds.put("status_name", "<span style='color:blue'>" + u.getItem(ds.getString("status"), code_status) + "</span>");
	} else {
		ds.put("status_name", u.getItem(ds.getString("status"), code_status));
	}
}

if(u.request("mode").equals("excel")){
	p.setVar("title", "진행중 계약현황");
	String xlsFile = "contract_send_list_excel.html";

	ds.first();
	while (ds.next()) {
		ds.put("cont_total", u.numberFormat(ds.getDouble("cont_total"), 0));
		ds.put("status_name", ds.getString("status_name").replaceAll("<br>", ""));
	}

	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("진행중 계약현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/" + xlsFile));
	return;
} else if(u.request("mode").equals("down")) {
	String[] save = f.getArr("save");
	if (save == null) return;

	String file_path = "";
	String cont_chasu = "";

	DataSet files = new DataSet();
	DataObject cfileDao = new DataObject("tcb_cfile a inner join tcb_contmaster b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu");

	for (int i=0; i<save.length; i++) {
		String[] arrCont = save[i].split("_");

		DataSet dsCfile = cfileDao.find(
				  "a.cont_no = '" + u.aseDec(arrCont[0]) + "' and a.cont_chasu = " + arrCont[1]
				, "b.cont_name, a.file_path, a.file_name, a.doc_name, a.file_ext");
		while (dsCfile.next()) {
			files.addRow();
			files.put("file_path", Startup.conf.getString("file.path.bcont_pdf") + dsCfile.getString("file_path") + dsCfile.getString("file_name"));
			//files.put("doc_name", "["+dsCfile.getString("member_name") + "] " + dsCfile.getString("doc_name") + "." + dsCfile.getString("file_ext"));
			files.put("doc_name", dsCfile.getString("cont_name") + "." + dsCfile.getString("file_ext"));
		}
	}

	MakeZip mk = new MakeZip();
	mk.make(files, response);

	return;
}

DataObject templateDao = new DataObject();
DataSet template = templateDao.query("select nvl(display_name, template_name) template_name, template_cd from tcb_cont_template where template_cd in (select decode(template_cd, '', '9999999', template_cd) template_cd from tcb_contmaster where member_no = '" + _member_no + "' and status in ('11', '20', '21', '30', '40', '41') group by template_cd) order by display_seq asc, template_cd desc");

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_send_list");
p.setVar("menu_cd", _menu_cd);
p.setVar("auth_select", _authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("code_status", u.arr2loop(combo_status));
p.setLoop("list", ds);
p.setLoop("template", template);
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
	int i=0;

	for (Element element : elements) {
		if (i > 0) value += "<br>";
		if (element.nodeName().equals("textarea")) value += element.text();
		else value += element.attr("value");
		i++;
	}
	return value;
}
%>