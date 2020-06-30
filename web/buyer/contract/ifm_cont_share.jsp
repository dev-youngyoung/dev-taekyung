<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
if(cont_no.equals("")||cont_chasu.equals("")){
	return;
}

DataObject shareDao = new DataObject("tcb_share");
DataSet list = shareDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and status > 0  ","*", "seq asc");
while(list.next()){
	list.put("send_date", u.getTimeString("yyyy-MM-dd HH:mm", list.getString("send_date")));
	list.put("recv_date", list.getString("recv_date").equals("")?"¹ָּ®ְ־":u.getTimeString("yyyy-MM-dd HH:mm", list.getString("recv_date")));
}


p.setLayout("blank");
p.setDebug(out);
p.setBody("contract.ifm_cont_share");
p.setLoop("list", list);
p.setVar("query",u.getQueryString());
p.setVar("list_query",u.getQueryString("cont_no, cont_chasu"));
p.display(out);

%>