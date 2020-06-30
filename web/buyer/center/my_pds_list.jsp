<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%@ include file="../chk_login.jsp" %>
<%
f.addElement("s_title",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable(" tcb_member_pds a, tcb_person b, tcb_member c");
list.setFields("a.*, b.user_name");
list.addWhere(" a.member_no= '"+_member_no+"'");
list.addWhere("	a.member_no = b.member_no and b.member_no = c.member_no and a.reg_id = b.user_id");
list.addSearch("a.title", f.get("s_title"), "LIKE");
list.setOrderBy("seq desc");

DataSet ds = list.getDataSet();
while(ds.next()){
	ds.put("reg_date", u.getTimeString("yyyy-MM-dd", ds.getString("reg_date")));
}

p.setLayout("default");
p.setDebug(out);
p.setBody("center.my_pds_list");
p.setVar("menu_cd","000123");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000123", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("seq"));
p.setVar("form_script",f.getScript());
p.display(out);

%>