<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="nicelib.sap.*" %>
<%
String userId = u.request("user_id");
String formId = u.request("form_id");

InvestConsultSap investConsultSap = new InvestConsultSap();
DataSet sapList = investConsultSap.getInvestConsultSapList(userId, formId);

p.setLayout("popup");
// p.setDebug(out);
p.setBody("contract.pop_search_inv_cslt_sap_list");
p.setVar("popup_title", "투자품의목록");
p.setLoop("list", sapList);
p.setVar("form_id", formId);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>