<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] gubun = {"01=>���๮��","02=>������û"};

f.addElement("s_companynm",null, null);

ListManager list = new ListManager(jndi);
list.setRequest(request);
//list.setDebug(out);
list.setListNum(50);
list.setTable("tcb_qna");
list.setFields("qnaseq, gubun, companynm, personnm, mobile, to_char(insertdate, 'YYYY-MM-DD HH24:MI:SS') insertdate ");
list.setOrderBy("insertdate desc");

list.addSearch("companynm", f.get("s_companynm"), "LIKE");
//��� ����Ÿ ����
DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("gubun_nm", u.getItem(ds.getString("gubun"), gubun));
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("mgr.si_qna_list");
p.setVar("menu_cd","000037");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>