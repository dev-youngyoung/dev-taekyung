<%@ page contentType="text/html; charset=EUC-KR" %>
<%@page import="java.net.URLDecoder"%><%@ include file="init.jsp"%>
<%
	String grid = u.request("grid");
	if(!grid.equals("")){
		grid = URLDecoder.decode(grid,"UTF-8");
	}
	DataSet loop = u.grid2dataset(grid);

	response.setHeader("Content-Type", "application/vnd.ms-xls");
	response.setHeader("Content-Disposition", "attachment; filename=" + StrUtil.k2a("�������㺰 ��Ͼ�ü ��Ȳ.xls"));
%>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center"><b style="font-size:18pt">�������㺰 ��Ͼ�ü ��Ȳ</b></td>
	</tr>
	<tr>
		<td><br></td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="1" cellpadding="2" cellspacing="0" style="font-size:9pt">
				<tr align="center">
					<td height="30" bgcolor="#cccccc">��з�</td>
					<td height="30" bgcolor="#cccccc">�ߺз�</td>
					<td height="30" bgcolor="#cccccc">�Һз�</td>
					<td height="30" bgcolor="#cccccc">��ü��</td>
					<td height="30" bgcolor="#cccccc">����ڹ�ȣ</td>
					<td height="30" bgcolor="#cccccc">���</td>
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