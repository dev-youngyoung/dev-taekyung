<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String templateCd = u.request("template_cd");
DataObject dataObj = new DataObject("TCB_CONT_TEMPLATE_FIELD");

DataSet contList = dataObj.find("TEMPLATE_CD = '" + templateCd +"'","*","SEQ");
JSONArray objArr = new JSONArray();

while(contList.next()){
	JSONObject obj = new JSONObject();
	Enumeration keys = contList.getRow().keys();
	for(int k=0; keys.hasMoreElements(); k++) {
		String key = (String)keys.nextElement();
		if(!"__ord".equals(key) && !"__last".equals(key)){
			obj.put(key, contList.getRow().get(key));
		}
	}
	objArr.add(obj);
}

out.print(objArr);
%>