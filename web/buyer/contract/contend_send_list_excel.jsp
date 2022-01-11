<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008", "and code in ('50','91')");

f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_sdate", null, null);
f.addElement("s_edate", null, null);
f.addElement("s_status", null, null);

f.addElement("hdn_sort_column", null, null);
f.addElement("hdn_sort_order", null, null);

String sQuery = "";
sQuery = "select "
	+ "a.cont_no, "
    + "a.cont_chasu, "
    + "a.template_cd, "
    + "a.cont_name, "
    + "a.cont_date, "
    + "a.cont_sdate, "
    + "a.cont_edate, "
    + "a.cont_total, "  
    + "a.status, "
    + "a.cont_userno, "
    + "b.member_name, "
	+ "( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt "
+ "from tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu "
+ "where b.list_cust_yn = 'Y' "
+ "  and a.member_no = '"+_member_no+"' ";


sQuery += " and a.status in ('50','91')";	//50:완료된 계약 91:계약해지
if(!f.get("s_sdate").equals("")) sQuery += " and a.cont_date >= '"+f.get("s_sdate").replaceAll("-","")+"'";
if(!f.get("s_edate").equals("")) sQuery += " and a.cont_date >= '"+f.get("s_edate").replaceAll("-","")+"'";
if(!f.get("s_cont_name").equals("")) sQuery += " and a.cont_name like '%" + f.get("s_cont_name") + "%'";
if(!f.get("s_cust_userno").equals("")) sQuery += " and a.cont_userno like '%" + f.get("s_cust_userno") + "%'";
if(!f.get("s_cust_name").equals("")) sQuery += " and b.member_name like '%" + f.get("s_cust_name") + "%'";
if(!f.get("s_status").equals("")) sQuery += " and a.status = '" + f.get("s_status") + "'";

String sSortColumn = f.get("hdn_sort_column");
String sSortOrder = f.get("hdn_sort_order");
String sSortCustNameIconName = "";
if(!sSortColumn.equals("")) {
	sQuery += " order by " + sSortColumn + " " + sSortOrder;
} else {
	sQuery += " order by a.cont_no desc, a.cont_chasu asc";
}



System.out.println(sQuery);

//목록 생성
DataObject mdao = new DataObject();
DataSet cont = mdao.query(sQuery);

String member_slno = "";
while(cont.next()){
	if(cont.getInt("cont_chasu")>0)
		cont.put("cont_name", cont.getString("cont_name") + " ("+cont.getString("cont_chasu")+"차)");
	if(cont.getInt("cust_cnt")-2>0){
		cont.put("cust_name", cont.getString("member_name")+ "외"+(cont.getInt("cust_cnt")-2)+"개사");
	}else{
		cont.put("cust_name", cont.getString("member_name"));
	}
	cont.put("link", cont.getString("template_cd").equals("")?"contend_free_sendview.jsp":"contend_sendview.jsp");
	cont.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
	cont.put("cont_sdate", u.getTimeString("yyyy-MM-dd",cont.getString("cont_sdate")));
	cont.put("cont_edate", u.getTimeString("yyyy-MM-dd",cont.getString("cont_edate")));
	//System.out.println("cont_total : " + u.numberFormat(cont.getDouble("cont_total"),0));
	cont.put("cont_total", u.numberFormat(cont.getDouble("cont_total"),0));
	cont.put("status", u.getItem(cont.getString("status"),code_status));
}

cont.first();
String sTitle = "완료된 계약";
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "attachment; filename=" + StrUtil.k2a(sTitle)+".xls");
%>

<html>
<head>
</head>

<body leftmargin="0" topmargin="0">
	<table width="800" border="0" cellpadding="0" cellspacing="0">
  <tr>
  <td align="center"><b style="font-size:18pt"><%=sTitle%><b></td>
  </tr>
  <tr>
  <td><br></td>
  </tr>

  <tr>
  <td>
	<table width="100%" border="1" cellpadding="2" cellspacing="0" style="font-size:9pt">
  	<tr align="center">
    <td>순번</td>
    <td>계약명</td>
    <td>거래처명</td>
    <td>계약일자</td>
    <td>계약시작</td>
    <td>계약종료</td>
    <td>계약금액</td>
    <td>계약번호</td>
    <td>상태</td>
  	</tr>
<%
	String	sVendCd				=	"";	//	사업자등록번호
	String	sMemberSlno		=	"";	//	법인/주민등록번호
	String	sBizPostCode	=	"";	//	우편번호

	for(int i=1; cont.next(); i++)
	{
%>
	<tr align="center">
		<td align="center"><%=i%></td>
		<td align="center"><%=cont.getString("cont_name")%></td>
		<td align="center"><%=cont.getString("cust_name")%></td>
		<td align="center"><%=cont.getString("cont_date")%></td>
		<td align="center"><%=cont.getString("cont_sdate")%></td>
		<td align="center"><%=cont.getString("cont_edate")%></td>
		<td align="right"><%=cont.getString("cont_total")%></td>
		<td align="center"><%=cont.getString("cont_userno")%></td>
		<td align="center"><%=cont.getString("status")%></td>
  	</tr>
<%
	}
%>
		</table>
	</td>
  </tr>
	</table>
</body>
</html>