<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
if(u.inArray(auth.getString("_MEMBER_TYPE"), new String[]{"01","03"}) ){//갑사가 아니면 을사 관리 목록으로
	u.redirect("./person_list.jsp");
	return;
}

f.addElement("s_user_name",null,null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:15);
list.setTable("tcb_person a");
list.setFields("a.*,(select field_name from tcb_field where member_no = a.member_no and field_seq= a.field_seq) field_name");
list.addWhere(" a.member_no = '"+_member_no+"'");
list.addWhere(" a.status > 0 ");
list.addWhere(" (a.user_level >= '"+auth.getString("_USER_LEVEL")+"' or a.user_level is null)");

list.addSearch("a.user_name", f.get("s_user_name"), "LIKE");
list.setOrderBy("a.person_seq desc ");

DataSet ds = list.getDataSet();
while(ds.next()){
	ds.put("reg_date", u.getTimeString("yyyy-MM-dd", ds.getString("reg_date")));
	ds.put("use_yn", ds.getString("use_yn").equals("Y")?"사용":"미사용");
}


if(u.request("mode").equals("excel")){
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("info.client_person_list");
p.setVar("menu_cd","000120");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("form_script", f.getScript());
p.setVar("list_query", u.getQueryString("person_seq"));
p.display(out);
%>