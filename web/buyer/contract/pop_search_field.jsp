<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
// 부서검색 팝업
f.addElement("s_field_name",null, null);
f.addElement("s_field_seq", null, null);

StringBuffer setTable = new StringBuffer();
setTable.append("(SELECT '20201000001' MEMBER_NO, '0000' FIELD_SEQ, '전체' FIELD_NAME FROM DUAL ");
setTable.append(" UNION ");
setTable.append(" SELECT MEMBER_NO, FIELD_SEQ, FIELD_NAME FROM TCB_FIELD ");
setTable.append(" WHERE USE_YN = 'Y') ");
// 목록 생성
ListManager list = new ListManager();
list.setRequest(request);
list.setListNum(5);
list.setTable(setTable.toString());       
list.setFields("*");
list.addWhere("LOWER(FIELD_NAME) LIKE LOWER('%" + f.get("s_field_name") + "%')");
list.addSearch("FIELD_SEQ", f.get("s_field_seq"), "LIKE");
list.setOrderBy("FIELD_SEQ");

DataSet ds = null;
Security security = new	Security();
if (!u.request("search").equals("")) {
	// 목록 데이타 수정
	ds = list.getDataSet();

	if(!ds.next()) {
		u.jsError("조회된 부서정보가 없습니다.");
		return;
	};
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_search_field");
p.setVar("popup_title","부서 검색");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>