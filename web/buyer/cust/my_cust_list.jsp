<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
f.addElement("s_vendcd", null, null);
f.addElement("s_member_name", null, null);
f.addElement("s_boss_name", null, null);
f.addElement("s_gubun", null, null);

// 목록 생성
ListManager list = new ListManager();
list.setRequest(request);
// list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:15);
list.setTable("if_mmbat100 a");
// 거래처코드, 사업자번호, 회사명, 업태, 종목, 대표자명, 구분(01:영업(판매처), 02:구매(공급처))
list.setFields("cust_code as cust_code, comm_no as vendcd, com_name as member_name, site_item as condition, biz_type as category, boss_name as boss_name, if_gubn as gubun, (select decode(count(1),0,'N','Y') from tcb_member x where x.member_no = a.member_no and cert_dn is not null) cert_dn_yn");
if (f.get("s_vendcd") != null && !f.get("s_vendcd").equals("")) list.addSearch("comm_no", f.get("s_vendcd"), "LIKE");
if (f.get("s_member_name") != null && !f.get("s_member_name").equals("")) list.addSearch("com_name", f.get("s_member_name"), "LIKE");
if (f.get("s_boss_name") != null && !f.get("s_boss_name").equals("")) list.addSearch("boss_name", f.get("s_boss_name"), "LIKE");
if (f.get("s_gubun") != null && !f.get("s_gubun").equals("")) {
	list.addSearch("if_gubn", f.get("s_gubun"), "=");
}
// list.setOrderBy("client_seq desc");

DataSet ds = list.getDataSet();
while (ds.next()) {
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	ds.put("gubun_name", ds.getString("gubun").equals("01") ? "판매처" : ds.getString("gubun").equals("02") ? "공급처" : "");
}

if (u.request("mode").equals("excel")) {
	String fileName = "거래처 명부현황.xls";
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(fileName.getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/cust/my_cust_excel.html"));
	return;
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.my_cust_list");
p.setVar("menu_cd", "000082");
p.setVar("auth_select", _authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000082", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script", f.getScript());
p.setVar("isExcel", auth.getString("_USER_LEVEL").equals("30")? false : true); // 일반사용자는 엑셀다운 못함
p.display(out);
%>