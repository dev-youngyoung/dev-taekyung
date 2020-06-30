<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%
f.addElement("s_title",u.request("s_title"), null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_board");
list.setFields("*");
list.addWhere(" category = 'noti' and open_yn= 'Y'");
list.addSearch("title", f.get("s_title"), "LIKE");
list.setOrderBy(" open_date desc ");

//목록 데이타 수정
DataSet rs = list.getDataSet();

while(rs.next()){
	rs.put("open_date",u.getTimeString("yyyy-MM-dd",rs.getString("open_date")));
}

p.setLayout("default");
p.setDebug(out);
p.setBody("center.noti_list");
p.setVar("menu_cd","000125");
p.setLoop("list", rs);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("noti_seq"));
p.setVar("form_script",f.getScript());
p.display(out);
%>