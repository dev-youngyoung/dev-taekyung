<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.URLDecoder"%><%@ include file="init.jsp"%>
<%
	String grid = u.request("grid");
	if(!grid.equals("")){
		grid = URLDecoder.decode(grid,"UTF-8");
	}
	DataSet loop = u.grid2dataset(grid);

	response.setHeader("Content-Type", "application/vnd.ms-xls");
	response.setHeader("Content-Disposition", "attachment; filename=" + StrUtil.k2a("보유면허별 등록업체 현황.xls"));
%>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center"><b style="font-size:18pt">보유면허별 등록업체 현황</b></td>
	</tr>
	<tr>
		<td><br></td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="1" cellpadding="2" cellspacing="0" style="font-size:9pt">
				<tr align="center">
					<td height="30" bgcolor="#cccccc">대분류</td>
					<td height="30" bgcolor="#cccccc">중분류</td>
					<td height="30" bgcolor="#cccccc">소분류</td>
					<td height="30" bgcolor="#cccccc">업체명</td>
					<td height="30" bgcolor="#cccccc">사업자번호</td>
					<td height="30" bgcolor="#cccccc">비고</td>
				</tr>
				<%while(loop.next()){%>
					<tr align="left" height="25">
						<td><%=loop.getString("m_nm")%></td>
						<td><%=loop.getString("s_nm")%></td>
						<td><%=loop.getString("d_nm")%></td>
						<td><%=loop.getString("member_name")%></td>
						<td><%=loop.getString("vendcd")%></td>
						<td><%=loop.getString("tech_expl")%></td>
					</tr>
				<%}%>
			</table>
		</td>
	</tr>
</table>
</body>
</html>