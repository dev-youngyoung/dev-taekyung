<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%@ include file="../chk_login.jsp" %>
<%

	f.addElement("s_member_name",u.request("s_member_name"), null);
	f.addElement("s_title",u.request("s_title"), null);

	//목록 생성
	ListManager list = new ListManager();
	list.setRequest(request);
	//list.setDebug(out);
	list.setListNum(10);
	list.setTable(" tcb_member a, tcb_client b, tcb_member_pds c ");
	list.setFields("c.*, a.member_name");
	list.addWhere(" b.client_no = '"+_member_no+"'");
	list.addWhere("	b.member_no = a.member_no and b.member_no = c.member_no");
	list.addSearch("c.title", f.get("s_title"), "LIKE");
	list.addSearch("a.member_name", f.get("s_member_name"), "LIKE");
	list.setOrderBy("c.reg_date desc");

	DataSet ds = list.getDataSet();
	while(ds.next()){
		ds.put("reg_date", u.getTimeString("yyyy-MM-dd", ds.getString("reg_date")));
	}


	p.setLayout("default");
//p.setDebug(out);
	p.setBody("center.cust_pds_list");
	p.setVar("menu_cd","000124");
	p.setLoop("list",ds);
	p.setVar("pagerbar", list.getPaging());
	p.setVar("query", u.getQueryString());
	p.setVar("list_query", u.getQueryString(""));
	p.setVar("form_script",f.getScript());
	p.display(out);

%>