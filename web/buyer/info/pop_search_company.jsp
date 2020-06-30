<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String callback = u.request("callback");
if(callback.equals("")){
	u.jsErrClose("정상적인 경로로 접근하세요.");
	return;
}
DataObject memberDao = new DataObject("tcb_member a");
//memberDao.setDebug(out);

f.addElement("s_member_name",null, null);
f.addElement("s_vendcd",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
list.setTable(" tcb_member a inner join tcb_client b on a.member_no=b.client_no");
list.setFields("a.* ");
list.addWhere("b.member_no='"+_member_no+"'");
list.addWhere("nvl(a.status,'z') <> '90'");
list.addSearch("a.member_name", f.get("s_member_name"), "LIKE");
list.addSearch("a.vendcd", f.get("s_vendcd"));
list.setOrderBy("member_name asc ");

DataSet ds = null;
if(!u.request("search").equals("")){	
	//목록 데이타 수정
	ds = list.getDataSet();
	
	while(ds.next()){
		ds.put("vendcd",u.getBizNo(ds.getString("vendcd")));
	}
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("info.pop_search_company");
p.setVar("popup_title","업체검색");
p.setLoop("list", ds);
p.setVar("callback", callback);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>