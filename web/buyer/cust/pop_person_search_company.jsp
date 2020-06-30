<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%
String person_seq = u.request("person_seq");  // �� �����
if(person_seq.equals(""))
{
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

f.addElement("s_member_name",null, null);
f.addElement("s_vendcd",null, null);

//��� ����
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
list.setTable("tcb_member tm inner join tcb_client tc on tm.member_no = tc.client_no");
list.setFields("*");
list.addWhere(" tm.member_gubun <> '04' ");
list.addWhere(" nvl(tm.status,'z') <> '90'");
list.addWhere(" tc.client_seq not in (select client_seq from tcb_client_detail where member_no = '"+_member_no+"' and person_seq = " + person_seq + ")");// �����߰��Ǿ� �ִ� ��ü ����
list.addSearch("member_name", f.get("s_member_name"), "LIKE");
list.addSearch("vendcd", f.get("s_vendcd"));
list.setOrderBy("member_name asc ");

DataSet ds = null;
if(!u.request("search").equals("")){
	//��� ����Ÿ ����
	ds = list.getDataSet();

	while(ds.next()){
		ds.put("vendcd",u.getBizNo(ds.getString("vendcd")));
	}
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_person_search_company");
p.setVar("popup_title","��ü�˻�");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);

%>