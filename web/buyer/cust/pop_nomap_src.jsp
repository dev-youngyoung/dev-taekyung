<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
f.addElement("s_member_name",null, null);
f.addElement("s_vendcd",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_member a \n"+
	      			",(select distinct client_no \n"+
	    		 		"    from tcb_client \n"+
	    		 		"   where member_no = '"+_member_no+"' and (client_reg_cd = '1' or client_reg_cd is null)) b");
list.setFields("a.*");
list.addWhere(" a.member_no = b.client_no \n");
list.addWhere(" a.member_type in ('02','03') \n");
list.addWhere(" a.member_no not in (select src_member_no \n"+
							"											  from( \n"+
							"														 select distinct src_member_no \n"+
							"															 from tcb_src_member \n"+
							"															where member_no = '"+_member_no+"' \n"+
							"))");
list.addWhere(" lower(a.member_name) like lower('%" + f.get("s_member_name") + "%')");
list.addSearch("a.vendcd", f.get("s_vendcd"));
list.setOrderBy("a.member_name asc ");

DataSet ds = null;
ds = list.getDataSet();

while(ds.next()){
	ds.put("vendcd2",ds.getString("vendcd"));
	ds.put("vendcd",u.getBizNo(ds.getString("vendcd")));
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_nomap_src");
p.setVar("popup_title","소싱 미설정 업체목록");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>