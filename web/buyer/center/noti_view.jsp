<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%
DataObject dao = new DataObject("tcb_board");

String id = u.request("id");
if(id.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

DataSet ds = dao.find(" category='noti' and board_id="+id);
if(!ds.next()){
	u.jsError("�ش� ���ù��� �����ϴ�.");
	return;
}

String contents = ds.getString("contents").replaceAll("&quot;", "\"").replaceAll("&lt;", "<").replaceAll("&gt;", ">");
ds.put("contents", contents);
ds.put("file_size", u.getFileSize(ds.getLong("file_size")));
ds.put("open_date", u.getTimeString("yyyy-MM-dd", ds.getString("open_date")));
ds.put("reg_date", u.getTimeString("yyyy-MM-dd", ds.getString("reg_date")));

p.setLayout("default");
p.setDebug(out);
p.setBody("center.noti_view");
p.setVar("menu_cd","000125");
p.setVar("info", ds);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("id"));
p.setVar("form_script",f.getScript());
p.display(out);
%>