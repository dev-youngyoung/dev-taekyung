<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] code_status = {"10=>모집중","20=>모집완료"};

f.addElement("s_title", u.request("s_title"), null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable(" tcb_recruit_noti a");
list.setFields(" a.* , (select count(*) from tcb_recruit_cust where member_no = a.member_no and noti_seq = a.noti_seq) cust_cnt");
list.addWhere(" a.member_no = '"+_member_no+"'");
list.addSearch("a.title", f.get("s_title"), "LIKE");
list.setOrderBy(" a.noti_seq desc");

DataSet ds = list.getDataSet();
while(ds.next()){
	ds.put("req_sdate", u.getTimeString("yyyy-MM-dd", ds.getString("req_sdate")));
	ds.put("req_edate", u.getTimeString("yyyy-MM-dd", ds.getString("req_edate")));
	ds.put("status", u.getItem(ds.getString("status"), code_status));
	ds.put("cust_cnt", u.numberFormat(ds.getLong("cust_cnt")));
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.nhqv_recruit_list");
p.setVar("menu_cd","000098");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000098", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("noti_seq"));
p.setVar("form_script",f.getScript());
p.display(out);
%>