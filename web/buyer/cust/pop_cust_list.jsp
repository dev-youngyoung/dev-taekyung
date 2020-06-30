<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

f.addElement("s_member_name",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(8);
String sTable = "tcb_client tc "
			+ "inner join tcb_member tm on tc.client_no = tm.member_no "
			+ "left join tcb_client_detail td on td.member_no = tc.member_no and td.client_seq = tc.client_seq "
			+ "left join tcb_person tp on tp.member_no=tm.member_no and tp.person_seq = td.cust_person_seq";

list.setTable(sTable);
list.setFields(
			  "tm.member_no"
			+ ",tm.member_name"
			+ ",td.cust_detail_name"
			+ ",td.cust_detail_code"
			+ ",tm.vendcd"
			+ ",tm.boss_name"
			+ ",tm.post_code"
			+ ",tm.member_slno"
			+ ",tm.address"
			+ ",tp.person_seq"
			+ ",tp.user_name"
			+ ",tp.tel_num"
			+ ",tp.email"
			+ ",tp.hp1"
			+ ",tp.hp2"
			+ ",tp.hp3"
);
list.addWhere(" tc.member_no = '"+_member_no+"' ");
list.addWhere(" member_gubun <> '04' ");
//list.addWhere(" td.cust_detail_code is not null ");
list.addSearch("tm.member_name", f.get("s_member_name"), "LIKE");
list.setOrderBy("tm.member_no desc");

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
p.setBody("cust.pop_cust_list");
p.setVar("popup_title","업체검색");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>