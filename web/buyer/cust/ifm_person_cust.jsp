<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String person_seq = u.request("person_seq");

f.addElement("s_member_name",null, null);
f.addElement("s_cust_code",null, null);

if(person_seq.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

String sQuery = " select tm.vendcd, tm.member_no, tp.user_name, tp.tel_num, tc.client_no, td.*"
	+" from tcb_client_detail td "
    +"      inner join tcb_client tc on td.member_no = tc.member_no and td.client_seq = tc.client_seq"
    +"      inner join tcb_member tm on tc.client_no = tm.member_no"
	+"      inner join tcb_person tp on tp.member_no = tm.member_no and tp.person_seq = td.cust_person_seq"
	+" where td.member_no = '"+_member_no+"'"
	+"  and td.person_seq = '"+person_seq+"'";

if(!f.get("s_member_name").equals(""))
	sQuery += " and td.cust_detail_name like '%" + f.get("s_member_name") + "%'";
if(!f.get("s_cust_code").equals(""))
	sQuery += " and td.cust_detail_code like '%" + f.get("s_cust_code") + "%'";


DataObject custDao = new DataObject();
DataSet list = custDao.query(sQuery);

while(list.next()){
	list.put("vendcd", u.getBizNo(list.getString("vendcd")));
	if(list.getString("cust_detail_code").equals(""))
		list.put("cust_detail_code", "<font color=red>[미등록]</font>");
}

p.setLayout("black");
p.setDebug(out);
p.setBody("cust.ifm_person_cust");
p.setLoop("list", list);
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script", f.getScript());
p.display(out);
%>