<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.select.*" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String div = u.request("div");
if(cont_no.equals("")||cont_chasu.equals("")||div.equals("")){
	return;
}

ContractDao contDao = new ContractDao("tcb_contmaster");
DataSet cont = contDao.find("member_no = '"+_member_no+"' and cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cont.next()){
	u.jsAlert("계약정보가 없습니다.");
	return;
}
Document doc = Jsoup.parse(cont.getString("cont_html"));
String html = "";
if(doc.getElementById(div)!= null){
	html = doc.getElementById(div).html();	
}

out.print(html);
%>