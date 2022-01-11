 <%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="org.jsoup.Jsoup
				,org.jsoup.nodes.Document
				,org.jsoup.nodes.Element
				,java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

String message = "OK";
String gridData = u.request("gridData");
String template_cd = u.request("template_cd");

if(!gridData.equals("")){
	gridData = URLDecoder.decode(gridData,"UTF-8");
}

JSONArray gridRows = JSONArray.fromObject(gridData);

if(gridRows.size() > 0){
	DB db = new DB();
	DataObject temField = new DataObject("TCB_CONT_TEMPLATE_FIELD");
	int seq = temField.getOneInt("SELECT nvl(max(seq),0) seq FROM TCB_CONT_TEMPLATE_FIELD WHERE TEMPLATE_CD = '" + template_cd+ "' ");
	for(int i=0; i<gridRows.size(); i ++){
		JSONObject gridRow = (JSONObject)gridRows.get(i);
		System.out.println("gridRow :::::::::: " + gridRow);
		temField = new DataObject("TCB_CONT_TEMPLATE_FIELD");
		String status = gridRow.getString("status");
		
		/* int cnt = 0;
		cnt = temField.findCount("TEMPLATE_CD = '"+ template_cd + "' AND FIELD_SEQ = '" + gridRow.getString("field_seq") + "' "); */
		
		temField.item("template_cd", template_cd);
		temField.item("field_seq", gridRow.getString("field_seq"));
		temField.item("field_name", gridRow.getString("field_name"));
		
		if(status.equals("created")){
			seq = seq + 1;
			temField.item("seq", seq);
			db.setCommand("INSERT INTO TCB_CONT_TEMPLATE_FIELD( "
						+ " TEMPLATE_CD, SEQ, FIELD_SEQ, FIELD_NAME, USE_YN, ALL_YN "
						+ " )VALUES("
						+ " $template_cd$, $seq$, $field_seq$, $field_name$, 'Y', 'N'"		
						+ " )", temField.record);
		}else if(status.equals("deleted")){
			db.setCommand("DELETE FROM TCB_CONT_TEMPLATE_FIELD WHERE TEMPLATE_CD = $template_cd$ AND FIELD_SEQ = $field_seq$ ", temField.record);
		}
	}
	
	if(!db.executeArray()){
		message = "ERROR";
	}
	String result = "{ \"result\": \"" + message + "\"}";
	out.print(result);
}
%>