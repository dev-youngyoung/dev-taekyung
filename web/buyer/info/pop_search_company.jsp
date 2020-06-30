<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String callback = u.request("callback");
if(callback.equals("")){
	u.jsErrClose("�������� ��η� �����ϼ���.");
	return;
}
DataObject memberDao = new DataObject("tcb_member a");
//memberDao.setDebug(out);

f.addElement("s_member_name",null, null);
f.addElement("s_vendcd",null, null);

//��� ����
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
	//��� ����Ÿ ����
	ds = list.getDataSet();
	
	while(ds.next()){
		ds.put("vendcd",u.getBizNo(ds.getString("vendcd")));
	}
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("info.pop_search_company");
p.setVar("popup_title","��ü�˻�");
p.setLoop("list", ds);
p.setVar("callback", callback);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>