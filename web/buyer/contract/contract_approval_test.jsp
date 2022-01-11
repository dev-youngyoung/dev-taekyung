<%@ page contentType="text/html; charset=UTF-8" %>
<%
String userID = request.getParameter("userID");
String jobID = request.getParameter("jobID");
String docID = request.getParameter("docID");
String Document = request.getParameter("Document");

System.out.println("userID : " + userID);
System.out.println("jobID : " + jobID);
System.out.println("docID : " + docID);
System.out.println("Document : " + Document);

out.print("<?xml version=\"1.0\" encoding=\"UTF-8\"?><ndata><status>Success</status><code>0</code></ndata>");
%>