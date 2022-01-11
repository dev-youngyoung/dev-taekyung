<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
	DataSet rs 					= null;
	String	sMemberNo		=	_member_no;		//	회원번호
	String  sPersonSeq		=	u.request("person_seq");

	if(	u.isPost())
	{
		String[]	saAdmCd	=	u.reqArr("chk_field_seq");	//	부서코드

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
				doTMI.item("member_no"	,sMemberNo);	//	회원번호
				doTMI.item("person_seq", sPersonSeq);   //  사용자
				doTMI.item("field_seq"	,saAdmCd[i]);	//	관리번호
				db.setCommand(doTMI.getInsertQuery(), doTMI.record);
			}
		}

		if(!db.executeArray()){
			u.jsError("저장에 실패 하였습니다.");
			return;
		}
		u.jsAlertReplace("저장하였습니다.","person_part_info.jsp?member_no="+sMemberNo+"&person_seq="+sPersonSeq);
		return;
	}else
	{
		//목록 생성
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
			response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("담당자별 조회부서 관리.xls".getBytes("KSC5601"),"8859_1") + "\"");
			out.println(p.fetch("../html/info/person_part_info_excel.html"));
			return;			
		}
	}
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../html/css/style.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="../html/js/common.js"></script>
<script language="javascript" type="text/javascript" src="../html/js/lib.validate.js"></script>
<script language="javascript" type="text/javascript" src="../html/js/grid.prototype.js"></script>
<script language="javascript" type="text/javascript" src="../html/js/nvscroll.js"></script>
<script language="javascript">
	/***************************
		권한 check
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
		메뉴권한 저장
	***************************/
	function fSumbit()
	{
		if(!confirm("권한정보를 저장하시겠습니까?"))	return;

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
		  <th>선택</th>
		  <th>부서명</th>
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