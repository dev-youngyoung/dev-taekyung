<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String cust_code = u.request("custcode");
if (cust_code.equals("")) {
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

DataObject custDao = new DataObject("if_mmbat100");
// custDao.setDebug(out);
DataSet cust = custDao.query(
	"select " + 
	"	a.cust_code as cust_code " +
	"	, a.comm_no as vendcd " +
	"	, a.com_name as member_name " +
	"	, a.boss_name as boss_name " +
	"	, a.boss_tel as tel_num " +
	"	, a.site_item as condition " +
	"	, a.biz_type as category " +
	"	, a.head_ofce_post as post_code " +
	"	, a.head_ofce_adrs as address " +
	"	, a.sale_chap as sale_chap " +
	"	, a.sale_chap_mobl as sale_chap_mobl " +
	"	, a.if_gubn as gubun " +
	"	, a.member_no as member_no " +
	"from if_mmbat100 a " +
	"where a.cust_code = '" + cust_code + "'"
);
if (!cust.next()) {
	u.jsError("거래처 정보가 없습니다.");
	return;
}

cust.put("vendcd", u.getBizNo(cust.getString("vendcd")));
cust.put("gubun_name", cust.getString("gubun").equals("01") ? "판매처" : cust.getString("gubun").equals("02") ? "구매처" : "");
cust.put("post_code", cust.getString("post_code").trim());

DataObject personDao = new DataObject("tcb_person");
DataSet person = personDao.find(" member_no = '" + cust.getString("member_no") + "' and status > 0  ", "*", " person_seq asc ");

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.cust_view");
p.setVar("menu_cd", "000082");
p.setVar("auth_select", _authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000082", "btn_auth").equals("10"));
p.setVar("cust", cust);
p.setLoop("person", person);
p.setVar("sys_date", u.getTimeString());
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("custcode"));
p.display(out);
%>