<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
	DataSet rs 					= null;
	String	sMemberNo		=	_member_no;		//	ȸ����ȣ
	String  sPersonSeq		=	u.request("person_seq");

	if(	u.isPost())
	{
		String[]	saAdmCd	=	u.reqArr("chk_field_seq");	//	�μ��ڵ�

		DataObject doTMI = new DataObject("tcb_fieldperson");
		int iDelCnt	=	doTMI.getOneInt("SELECT COUNT(*) \n"+
										"	 FROM tcb_fieldperson \n"+
										"	WHERE member_no = '"+sMemberNo+"' and person_seq = '"+sPersonSeq+"'");

		DB db = new DB();

		if(iDelCnt > 0)
		{
			doTMI = new DataObject("tcb_fieldperson");
			db.setCommand(doTMI.getDeleteQuery(" member_no = '"+sMemberNo+"' and person_seq = '"+sPersonSeq+"'"), null);
		}

		if(saAdmCd != null && saAdmCd.length > 0)
		{
			for(int i=0; i < saAdmCd.length; i++)
			{
				doTMI = new DataObject("tcb_fieldperson");
				doTMI.item("member_no"	,sMemberNo);	//	ȸ����ȣ
				doTMI.item("person_seq", sPersonSeq);   //  �����
				doTMI.item("field_seq"	,saAdmCd[i]);	//	������ȣ
				db.setCommand(doTMI.getInsertQuery(), doTMI.record);
			}
		}

		if(!db.executeArray()){
			u.jsError("���忡 ���� �Ͽ����ϴ�.");
			return;
		}
		u.jsAlertReplace("�����Ͽ����ϴ�.","person_part_info.jsp?member_no="+sMemberNo+"&person_seq="+sPersonSeq);
		return;
	}else
	{
		//��� ����
		ListManager list = new ListManager();
		//list.setDebug(out);
		list.setListQuery("select a1.*, nvl2(b1.member_no,'Y','') adm_yn \n"
				+ "from tcb_field a1 \n"
				+ "left outer join tcb_fieldperson b1 \n" 
				+ "on a1.member_no = b1.member_no and a1.field_seq = b1.field_seq and  b1.person_seq = '"+sPersonSeq+"' \n"
				+ "where a1.member_no='"+sMemberNo+"'");

		rs = list.getDataSet();
		
		if(u.request("mode").equals("excel"))
		{
			while(rs.next())
			{
				rs.put("adm_yn", rs.getString("adm_yn"));
			}
			
			p.setLoop("list", rs);
			
			response.setContentType("application/vnd.ms-excel");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("����ں� ��ȸ�μ� ����.xls".getBytes("KSC5601"),"8859_1") + "\"");
			out.println(p.fetch("../html/info/person_part_info_excel.html"));
			return;			
		}
	}
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../html/css/style.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="../html/js/common.js"></script>
<script language="javascript" type="text/javascript" src="../html/js/lib.validate.js"></script>
<script language="javascript" type="text/javascript" src="../html/js/grid.prototype.js"></script>
<script language="javascript" type="text/javascript" src="../html/js/nvscroll.js"></script>
<script language="javascript">
	/***************************
		���� check
	***************************/
	function fChkNenu()
	{
		var	oTable	=	event.srcElement.parentElement.parentElement.parentElement;
		var	iIndex	=	event.srcElement.parentElement.parentElement.rowIndex;

		if(event.srcElement.checked)
		{
			oTable.rows[iIndex].cells[0].style.backgroundColor	=	"#EAE7FE";
			oTable.rows[iIndex].cells[oTable.rows[iIndex].cells.length-1].style.backgroundColor	=	"#EAE7FE";
		}else
		{
			oTable.rows[iIndex].cells[0].style.backgroundColor	=	"";
			oTable.rows[iIndex].cells[oTable.rows[iIndex].cells.length-1].style.backgroundColor	=	"";
		}
	}

	/***************************
		�޴����� ����
	***************************/
	function fSumbit()
	{
		if(!confirm("���������� �����Ͻðڽ��ϱ�?"))	return;

		var	form	=	document.form1;
		form.method	=	"POST";
		form.action	=	"./person_part_info.jsp";
		form.submit();
	}
</script>
</head>
<body topmargin="0" leftmargin="0">
<form name="form1">
	<input type="hidden" name="member_no" value="<%=sMemberNo%>">
	<input type="hidden" name="person_seq" value="<%=sPersonSeq%>">
	<div class="div_table">
		<table id="dept_table">
		<colgroup>
		  <col width="60" align="center">
		  <col>
		</colgroup>
		<tr>
		  <th>����</th>
		  <th>�μ���</th>
		</tr>
		<%
			String	_sChecked					=	"";
			String	_sBackgroundColor	=	"";
			while(rs.next())
			{
				if(rs.getString("adm_yn").equals("Y"))
				{
					_sChecked	=	" checked";
					_sBackgroundColor = " style=\"background-color:#EAE7FE\"";
				}else
				{
					_sChecked	=	"";
					_sBackgroundColor = "";
				}
		%>
		<tr class="cel2" hname="<%=rs.getString("field_name")%>">
		  <td<%=_sBackgroundColor%>><input type="checkbox" name="chk_field_seq" onClick="fChkNenu()"value="<%=rs.getString("field_seq")%>"<%=_sChecked%>></td>

		  <td<%=_sBackgroundColor%>><%=rs.getString("field_name")%></td>
		</tr>
		<%
			}
		%>
		</table>
	</div>
</form>
</body>