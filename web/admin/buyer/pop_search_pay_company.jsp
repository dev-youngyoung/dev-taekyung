<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String[] code_status = {"00=>탈퇴", "01=>정회원", "02=>비회원", "03=>재가입"};  // 회원상태
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_member_type = codeDao.getCodeArray("M002");

f.addElement("s_member_name",null, null);
f.addElement("s_vendcd",null, null);
f.addElement("s_member_type",null, null);
f.addElement("s_status",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_member");
list.setFields("*");
list.addSearch("status", f.get("s_status"));
list.addSearch("member_type", f.get("s_member_type"));
list.addSearch("member_name", f.get("s_member_name"), "LIKE");
list.addSearch("vendcd", f.get("s_vendcd"));
list.setOrderBy("member_name asc ");

DataSet ds = new DataSet();
if(!u.request("search").equals("")){
	//목록 데이타 수정
	ds = list.getDataSet();
	while(ds.next()){
		ds.put("vendcd",u.getBizNo(ds.getString("vendcd")));
		ds.put("member_type_nm",u.getItem(ds.getString("member_type"), code_member_type));
		ds.put("status_nm",u.getItem(ds.getString("status"), code_status));
	}
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("buyer.pop_search_pay_company");
p.setVar("popup_title","업체검색");
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("code_member_type", u.arr2loop(code_member_type));
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>