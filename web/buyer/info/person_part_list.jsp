<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
//목록 생성
ListManager list = new ListManager();
//list.setDebug(out);
list.setListNum(-1);
list.setTable("tcb_person ");
list.addWhere("member_no = '"+_member_no+"'");
list.addWhere("use_yn='Y'");
list.addWhere("status=1");
list.addWhere("user_id is not null");
list.addSearch("user_name", u.request("s_user_name"), "LIKE");
//list.setOrderBy(" join_date desc");
DataSet rs = list.getDataSet();
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../html/css/style.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="../html/js/common.js"></script>
<script language="javascript" type="text/javascript" src="../html/js/lib.validate.js"></script>
<script language="javascript" type="text/javascript" src="../html/js/grid.prototype.js"></script>
<script language="javascript" type="text/javascript" src="../html/js/nvscroll.js"></script>
<script language="javascript">
	/*****************************
		권한 페이지 이동
	*****************************/
	function goMemMenu(sMemberNo, sMemberName, sPersonSeq, sDivision, excel)
	{
		var	form			=	document.form1;

		if(typeof(form.hdn_member_no) != "undefined")
		{
			if(typeof(form.hdn_member_no.length) == "undefined")
			{
				if(form.hdn_member_no.value == sMemberNo+"&"+sPersonSeq)
				{
					form.hdn_member_no.parentElement.parentElement.style.backgroundColor	=	"#EAE7FE";
				}
			}else
			{
				for(i=0; i < form.hdn_member_no.length; i++)
				{
					if(form.hdn_member_no[i].value == sMemberNo+"&"+sPersonSeq)
					{
						form.hdn_member_no[i].parentElement.parentElement.style.backgroundColor	=	"#EAE7FE";
					}else
					{
						form.hdn_member_no[i].parentElement.parentElement.style.backgroundColor	=	"";
					}
				}
			}
		}

		parent.goMemMenu(sMemberNo,sMemberName,sPersonSeq,sDivision,'');
	}
</script>
</head>
<%
	String	__member_no		=	"";
	String	_user_name		=	"";
	String	_division		=	"";
	String	_person_seq		=	"";

	if(rs != null && rs.next())
	{
		__member_no		=	rs.getString("member_no");
		_user_name		=	rs.getString("user_name");
		_division		=	rs.getString("division");
		_person_seq		=	rs.getString("person_seq");
	}
%>
<body topmargin="0" leftmargin="0" onLoad="goMemMenu('<%=__member_no%>','<%=_user_name%>','<%=_person_seq%>','<%=_division%>')">
<form name="form1">
	<div class="div_table">
		<table>
		<colgroup>
			<col align="center">
			<col align="center">
			<col align="center">
		</colgroup>
		<tr>
		  <th>소속부서</th>
		  <th>이름</th>
		  <th>직급</th>
		</tr>
		<%
			rs.first();
			while(rs.next())
			{
		%>
			<tr class="cel" style="cursor:hand" onClick="goMemMenu('<%=rs.getString("member_no")%>','<%=rs.getString("user_name")%>','<%=rs.getString("person_seq")%>','<%=rs.getString("division")%>')">
			<td><input type="hidden" name="hdn_member_no" value="<%=rs.getString("member_no")%>&<%=rs.getString("person_seq")%>"><%=rs.getString("division")%></td>
			<td><%=rs.getString("user_name")%></td>
			<td><%=rs.getString("position")%></td>
			</tr>
		<%
			}
		%>
		</table>
	</div>
</form>
</body>