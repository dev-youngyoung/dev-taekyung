<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
// 사업자, 개인 모두 검색할 수 있는 화면 사용(C:사업자, P:개인, B:개인사업자 대표자, 공백: 개별) CP, CP로 구분 하여 사용
String search_type = u.request("search_type");  
String sign_seq = u.request("sign_seq");

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '" + _member_no + "'");
if (!member.next()) {
	u.jsErrClose("사용자 정보가 존재하지 않습니다.");
	return;
}

f.addElement("s_member_name", null, null);
f.addElement("s_vendcd", null, null);

// 목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
list.setTable(
		  "tcb_member a "
		+ "inner join tcb_client z " 
		+ "on a.member_no = z.client_no "
		+ "left outer join (select * from tcb_src_member where member_no = '" + _member_no + "') b "
		+ "on b.src_member_no = a.member_no");
list.setFields("distinct a.*");
list.addWhere("z.client_reg_cd = '1' ");
list.addWhere("a.member_gubun <> '04' ");
list.addWhere("z.member_no = '" + _member_no + "'");
list.addWhere("nvl(a.status, 'z') <> '90' ");
list.addWhere("lower(a.member_name) like lower('%" + f.get("s_member_name") + "%')");
list.addSearch("a.vendcd", f.get("s_vendcd"));
list.setOrderBy("a.member_name asc");

DataSet ds = null;
if (!u.request("search").equals("")) {
	// 목록 데이타 수정
	ds = list.getDataSet();
	while (ds.next()) {
		ds.put("jumin_no", "");
		ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
		DataObject personDao = new DataObject("tcb_person a");
		DataSet person = personDao.find(
				  "member_no = '" + ds.getString("member_no") + "' and status > 0 "
				, "person_seq, user_name, tel_num, email, hp1, hp2, hp3");
		ds.put(".person", person);
	}
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_search_company");
p.setVar("popup_title", "사업자 검색");
p.setVar("tab_view_cp", search_type.equals("CP"));
p.setVar("member", member);
p.setLoop("list", ds);
p.setVar("sign_seq", sign_seq);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script", f.getScript());
p.display(out);
%>