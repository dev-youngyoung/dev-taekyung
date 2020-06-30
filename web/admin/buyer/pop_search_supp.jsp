<%@ page contentType="text/html; charset=EUC-KR"%><%@ include file="init.jsp"%>
<%
String main_member_no = u.request("main_member_no");
String bid_no = u.request("bid_no");
String bid_deg = u.request("bid_deg");
String callback = u.request("callback");
if(main_member_no.equals("")||bid_no.equals("")||bid_deg.equals("")||callback.equals("")){
	u.jsErrClose("�������� ��η� �����ϼ���.");
	return;
}

f.addElement("s_member_name", null, null);
f.addElement("s_vendcd", null, null);

//��� ����
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
list.setTable(" tcb_member a, tcb_client b ");
list.setFields("a.*");
list.addWhere(" a.member_no = b.client_no");
list.addWhere(" b.member_no = '"+main_member_no+"' ");
list.addWhere(" a.member_no not in ( select member_no from tck_bid_supp where main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"')");
list.addSearch("a.vendcd", f.get("s_vendcd").replaceAll("-", ""));
list.addSearch("a.member_name", f.get("s_member_name"), "LIKE");
list.setOrderBy("member_name asc ");

DataSet ds = null;
if (!u.request("search").equals("")) {
	ds = list.getDataSet();
	while (ds.next()) {
		ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
		DataObject personDao = new DataObject("tcb_person");
		DataSet person = personDao.find(" member_no = '" + ds.getString("member_no") + "' ");
		ds.put(".person", person);
	}
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("buyer.pop_search_supp");
p.setVar("popup_title", "��ü�˻�");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script", f.getScript());
p.display(out);
%>