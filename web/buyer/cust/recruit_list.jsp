<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_status = {"10=>모집중","20=>모집완료"};

f.addElement("s_title",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable(" tcb_recruit a");
list.setFields(" a.*, (select count(vendcd) from tcb_recruit_supp where member_no = a.member_no and seq = a.seq) supp_cnt");
list.addWhere(" a.member_no = '"+_member_no+"'");
list.addSearch("a.title", f.get("s_title"), "LIKE");
list.setOrderBy(" a.seq desc");

DataSet ds = list.getDataSet();
while(ds.next()){
	ds.put("s_date", u.getTimeString("yyyy-MM-dd", ds.getString("s_date")));
	ds.put("e_date", u.getTimeString("yyyy-MM-dd", ds.getString("e_date")));
	ds.put("status", u.getItem(ds.getString("status"), code_status));
	ds.put("supp_cnt", u.numberFormat(ds.getLong("supp_cnt")));
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.recruit_list");
p.setVar("menu_cd","000096");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000096", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no, seq"));
p.setVar("form_script",f.getScript());
p.display(out);
%>