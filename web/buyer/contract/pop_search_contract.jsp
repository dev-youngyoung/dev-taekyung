<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String callback=u.request("callback");

// 계약상태
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008");

String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd", u.addDate("M", -3)));

f.addElement("s_template_cd", null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", null, null);
f.addElement("s_status", null, null);
f.addElement("s_cont_name", null, null);
f.addElement("s_cust_name", null, null);

String date_query = "";
if (!s_sdate.equals("")) date_query += " and cont_date >= '" + s_sdate.replaceAll("-", "") + "'"; 
if (!f.get("s_edate").equals("")) date_query += " and cont_date <= '" + f.get("s_edate").replaceAll("-", "") + "'"; 
DataObject templateDao = new DataObject();
DataSet template = templateDao.query(
		  "select nvl(display_name, template_name) template_name, template_cd "
		+ "  from tcb_cont_template "
		+ " where template_cd in ( "
		+ "     select decode(template_cd, '', '9999999', template_cd) template_cd " 
		+ "       from tcb_contmaster "
		+ "      where member_no = '" + _member_no + "'"
		+ date_query
		+ "       and status <> '00' "
		+ "     group by template_cd "
		+ "     ) "
		+ "order by display_seq asc, template_cd desc");

// 목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_contmaster a, tcb_cust b");
list.setFields(
		  "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date, a.status, a.cont_userno, b.member_name "
		+ ", (SELECT COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt "
		+ ", (select nvl(display_name, template_name) from tcb_cont_template where template_cd = a.template_cd ) template_name ");
list.addWhere(" a.cont_no = b.cont_no ");
list.addWhere(" a.cont_chasu = b.cont_chasu ");
list.addWhere(" b.list_cust_yn = 'Y'");
list.addWhere(" a.member_no = '" + _member_no + "' ");
list.addWhere(" a.cont_chasu = (select max(cont_chasu) from tcb_contmaster where cont_no = a.cont_no) ");
list.addWhere(" a.status <> '00' ");
if (!s_sdate.equals("")) list.addWhere(" a.cont_date >= '" + s_sdate.replaceAll("-", "") + "'");
if (!f.get("s_edate").equals("")) list.addWhere(" a.cont_date <= '" + f.get("s_edate").replaceAll("-", "") + "'");
list.addSearch("a.template_cd", f.get("s_template_cd"));
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.addSearch("b.member_name", f.get("s_cust_name"), "LIKE");
list.addSearch("a.status", f.get("s_status"),"LIKE");
list.setOrderBy("a.cont_no desc, a.cont_chasu asc");

DataSet ds = list.getDataSet();
while (ds.next()) {
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if (ds.getInt("cont_chasu") > 0) {
		ds.put("cont_name", ds.getString("cont_name") + " (" + ds.getString("cont_chasu") + "차)");
	}
	if (ds.getInt("cust_cnt") - 2 > 0) {
		ds.put("cust_name", ds.getString("member_name") + "외" + (ds.getInt("cust_cnt") - 2) + "개사");
	} else {
		ds.put("cust_name", ds.getString("member_name"));
	}
	ds.put("status_nm", u.getItem(ds.getString("status"), code_status));
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd", ds.getString("cont_date")));
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("contract.pop_search_contract");
p.setVar("popup_title", "기존계약검색");
p.setVar("callback", callback);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("template", template);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no, cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>