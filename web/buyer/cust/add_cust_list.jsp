<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
f.addElement("s_member_name",null, null);
f.addElement("s_cretop",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:15);
list.setTable("tcb_client a inner join tcb_member b on a.client_no = b.member_no inner join tcb_member_add c on b.member_no=c.member_no");
list.setFields(		"a.client_no  \n"
		+	",b.member_name \n"
		+	",b.vendcd \n"
		+	",b.boss_name \n"
		+	",c.post_address"
		+	",decode(c.post_address, null, '<font color=red>미등록</font>', '등록') cust_insert"
		+	",decode(c.credit_rating, null, '<font color=red>미등록</font>', '등록') cretop_insert"
);
list.addWhere(" a.member_no = '"+_member_no+"'");
list.addSearch("b.member_name", f.get("s_member_name"), "LIKE");
if(f.get("s_cretop").equals("Y")){
	list.addWhere("c.credit_rating is not null");
}
if(f.get("s_cretop").equals("N")){
	list.addWhere("c.credit_rating is null");
}
list.setOrderBy("client_seq desc");

DataSet 	ds 				= list.getDataSet();
Security	security	=	new	Security();
String		sJuminNo	=	"";
if(u.request("mode").equals("excel")){

	while(ds.next())
	{
		ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	}
	String fileName = "";
	fileName = "기업현황.xls";
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(fileName.getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/cust/add_cust_list_excel.html"));
	return;
}

while(ds.next()){
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.add_cust_list");
p.setVar("menu_cd","000084");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000084", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.setVar("isExcel", auth.getString("_USER_LEVEL").equals("30")?false:true);  // 일반사용자는 엑셀다운 못함
p.display(out);
%>