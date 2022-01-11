<%@page import="java.sql.ResultSet"%>
<%@page import="nicelib.util.Config"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%@page import="javax.naming.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<% 
	String jndi = Config.getJndi();
	Context initContext = new InitialContext();
	
	DataSource ds = null;
	Connection conn = null;
	Statement stmt = null;
	
	try {
		ds = (DataSource)initContext.lookup(jndi);
		conn = ds.getConnection();
		stmt = conn.createStatement();
		
		stmt.execute("SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') FROM DUAL");
		
		ResultSet rs = stmt.getResultSet();
		while(rs.next()) {
		%>
			<%=rs.getString(1) %>
		<%
		}
	} catch (Exception ex) {
		out.println(ex.toString());
	} finally {
		try { if(stmt != null) stmt.close(); } catch (Exception e) {}
		try { if(conn != null) conn.close(); } catch (Exception e) {}
	} 
%>
