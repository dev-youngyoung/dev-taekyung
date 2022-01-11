<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.select.*" %>
<%
String _menu_cd = "000059";

String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu ";
String sColumn = "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date, a.status, nvl(a.cont_userno,a.cont_no) cont_userno, a.paper_yn, b.member_no, b.member_name, b.cust_detail_code, a.sign_types, "
				+ "( SELECT COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt, "
				+ "NVL((SELECT cname FROM tcb_comcode WHERE CCODE = 'M009' AND CODE = a.APPR_STATUS ), '임시저장') appr_status_name ";

f.addElement("s_cont_name", null, null);
f.addElement("s_cust_name", null, null);
f.addElement("s_vendcd", null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel"}) ? -1 : 15);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere(" b.list_cust_yn = 'Y' ");
list.addWhere(" a.member_no = '" + _member_no + "' ");
list.addWhere(" a.status = '10'");

if (!f.get("s_cont_name").equals("")) { // 티알엔 대소문자 구분 없이 검색 2020-02-12
	list.addWhere(" lower(a.cont_name) like '%'||lower('" + f.get("s_cont_name") + "')||'%'");
}
list.addSearch("b.member_name", f.get("s_cust_name"), "LIKE");
list.addSearch("b.vendcd", f.get("s_vendcd").replaceAll("-", ""), "LIKE");

// 조회권한
if (!auth.getString("_DEFAULT_YN").equals("Y")) {
	// 10:담당조회  20:부서조회 
	if (_authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), _menu_cd, "select_auth").equals("10")) {
		list.addWhere("a.reg_id = '" + auth.getString("_USER_ID") + "'");
	}
	if (_authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), _menu_cd, "select_auth").equals("20")) {
		list.addWhere("a.field_seq in ( select field_seq from tcb_field start with member_no = '" + _member_no + "' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq)");
	}
}
// list.setOrderBy("a.cont_no desc");
list.setOrderBy("a.reg_date desc");

DataSet ds = list.getDataSet();
while (ds.next()) {
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if (ds.getInt("cust_cnt") - 2 > 0) {
		ds.put("cust_name", ds.getString("member_name") + "외" + (ds.getInt("cust_cnt") - 2) + "개사");
	} else {
		ds.put("cust_name", ds.getString("member_name"));
	}
	if (ds.getString("paper_yn").equals("Y")) {//서면계약
		ds.put("cont_name", "<span style='color:blue'>[서면]</span>" + ds.getString("cont_name"));
	}else{
		if(ds.getString("template_cd").trim().equals("")){
			ds.put("cont_name", "<span style='color:blue'>[자유서식]</span>" + ds.getString("cont_name"));
		}
	}

	if (ds.getString("paper_yn").equals("Y")) {
		ds.put("link", "offcont_modify.jsp");
	} else {
		ds.put("link", ds.getString("template_cd").trim().equals("") ? "contract_free_modify.jsp" : ds.getString("sign_types").equals("") ? "contract_modify.jsp" : "contract_msign_modify.jsp");
	}
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd", ds.getString("cont_date")));
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_writing_list");
p.setVar("menu_cd", _menu_cd);
p.setVar("auth_select", _authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no, cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>
<%!
public String getJsoupValue(Document document, String name) {
	String value = "";
	Elements elements = document.getElementsByAttributeValue("name", name);
	
	int i = 0;

	for (Element element: elements) {
		if (i > 0) value += "<br>";
		if (element.nodeName().equals("textarea")) value += element.text();
		else value += element.attr("value");
		i++;
	}
	return value;
}
%>