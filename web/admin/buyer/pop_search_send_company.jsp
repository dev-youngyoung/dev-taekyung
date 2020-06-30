<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

f.addElement("s_member_name",null, null);
f.addElement("s_vendcd",null, null);
f.addElement("s_member_type",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
list.setFields("a.member_name, a.vendcd, a.boss_name, a.member_type, a.status, a.member_no");
list.setTable("tcb_member a");
list.addWhere(" a.member_type in ('01','03') ");
list.addWhere(" a.status = '01' ");
list.addSearch("a.member_name", f.get("s_member_name"), "LIKE");
list.addSearch("a.vendcd", f.get("s_vendcd"));
list.setGroupBy("a.member_name, a.vendcd, a.boss_name, a.member_type, a.status, a.member_no");
list.setOrderBy("a.member_name asc ");

DataSet ds = new DataSet();
if(!u.request("search").equals("")){
	//목록 데이타 수정
	ds = list.getDataSet();
	while(ds.next()){
		ds.put("vendcd",u.getBizNo(ds.getString("vendcd")));
		
		DataObject personDao = new DataObject("tcb_person a");
		//personDao.setDebug(out);
		DataSet person = personDao.find(
				  " member_no = '"+ds.getString("member_no")+"' and use_yn = 'Y' and status > 0 "
				, " a.*, (select field_name from tcb_field where member_no = a.member_no and field_seq = a.field_seq ) dept_name"
				, " a.field_seq asc, user_level desc, user_name asc"
				);
		ds.put(".person", person);
	}
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("buyer.pop_search_send_company");
p.setVar("popup_title","업체검색");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>