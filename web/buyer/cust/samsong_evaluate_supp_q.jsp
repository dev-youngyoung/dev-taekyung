<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="java.net.URLDecoder" %>
<%
String yyyymm = u.request("yyyymm");

DataObject evaluateSuppDao = new DataObject("tcb_samsong_evaluate_supp");
DataSet evaluateSupp= evaluateSuppDao.find(" yyyymm = '" + yyyymm + "' ");
while(evaluateSupp.next()){
	evaluateSupp.put("vendcd", u.getBizNo(evaluateSupp.getString("vendcd")) );
}
out.println("{\"rows\":"+u.loop2json(evaluateSupp)+"}");
%>