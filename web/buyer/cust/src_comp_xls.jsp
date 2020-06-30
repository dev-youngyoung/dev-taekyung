<%@ page contentType="text/html; charset=EUC-KR" %>
<%@page import="procure.common.db.SQLManager
								,procure.common.value.DataSetValue
								,procure.common.value.ResultSetValue
								,java.sql.Connection
"%>
<%@ include file="init.jsp" %>
<%
	SQLManager			sqlm					=	null;
	Connection			conn					=	null;
	StringBuffer		sb						=	null;
	ResultSetValue	rXls					=	null;
	int							iMaxMemberCnt	=	0;
	try
	{
		String	sMemberNo	= _member_no;	//	ȸ����ȣ
		if(sMemberNo == null || sMemberNo.length() < 1)
		{
			throw new Exception("�������� ��η� ���� �ϼ���.");
		}
		
		sqlm	=	new	SQLManager();
		conn	=	sqlm.getConnection();
		
		
		DataSetValue	dsv		=	null;
		
		//	�ҽ�ī�װ��� �ִ� ��ü�� ���ϱ�
		sb						=	new	StringBuffer();
		sb.append("select max(src_cd_cnt) max_member_cnt \n");
		sb.append("	 from( \n");
		sb.append("				select count(src_cd) src_cd_cnt \n");
		sb.append("					from tcb_src_member \n");
		sb.append("				 where member_no = '"+sMemberNo+"' \n");
		sb.append("				 group by member_no, src_cd \n");
		sb.append(")");
		
		dsv	=	sqlm.getOneRow(sb.toString(),true);
		if(dsv == null || dsv.size() < 1)
		{
			throw new Exception("�ҽ�ī�װ��� ��Ͼ�ü�� �������� �ʾƼ� �ٿ�ε带 �����Ǽ� �����ϴ�.");
		}else
		{
			iMaxMemberCnt	=	dsv.getInt("max_member_cnt");
		}
		
		//	�ҽ�ī�װ� ���� ���ϱ�
		sb	=	new	StringBuffer();
		sb.append("select a.src_cd \n");
		sb.append("       ,a.l_src_cd \n");
		sb.append("       ,b.src_nm l_src_nm \n");
		sb.append("       ,(select count(l_src_cd) from tcb_src_adm where member_no = a.member_no and l_src_cd = a.l_src_cd and depth=3) l_src_cnt \n");
		sb.append("       ,a.m_src_cd \n");
		sb.append("       ,c.src_nm m_src_nm \n");
		sb.append("       ,(select count(m_src_cd) from tcb_src_adm where member_no = a.member_no and l_src_cd = a.l_src_cd and m_src_cd = a.m_src_cd and depth=3) m_src_cnt \n");
		sb.append("       ,a.s_src_cd \n");
		sb.append("       ,a.src_nm s_src_nm \n");
		sb.append("from tcb_src_adm a \n");
		sb.append("      ,tcb_src_adm b \n");
		sb.append("      ,tcb_src_adm c \n");
		sb.append("where substr(a.src_cd,1,3)||'000000' = b.src_cd \n");
		sb.append("  and a.member_no = b.member_no \n");
		sb.append("  and substr(a.src_cd,1,6)||'000' = c.src_cd \n");
		sb.append("  and a.member_no = c.member_no \n");
		sb.append("  and a.depth = 3 \n");
		sb.append("  and a.src_cd != '999999999' \n");
		sb.append("  and a.member_no = '"+sMemberNo+"' \n");
		sb.append("order by a.l_src_cd, a.m_src_cd, a.s_src_cd \n");
		
		ResultSetValue	rSrc	=	sqlm.getRows(sb.toString(),true);
		if(rSrc == null || rSrc.size() < 1)
		{
			throw new Exception("�ҽ�ī�װ��� �������� �ʾƼ� �ٿ�ε带 �����Ǽ� �����ϴ�.");
		}else
		{
			HashMap	hm	=	null;
			
			ResultSetValue	rComp			=	null;
			int							iRoopCnt	=	0;
			ArrayList				al				=	new	ArrayList();
			while(rSrc.next())
			{
				hm	=	new	HashMap();
				hm.put("SRC_CD", rSrc.getString("src_cd"));
				hm.put("L_SRC_CD", rSrc.getString("l_src_cd"));
				hm.put("L_SRC_NM", rSrc.getString("l_src_nm"));
				hm.put("L_SRC_CNT", rSrc.getString("l_src_cnt"));
				hm.put("M_SRC_CD", rSrc.getString("m_src_cd"));
				hm.put("M_SRC_NM", rSrc.getString("m_src_nm"));
				hm.put("M_SRC_CNT", rSrc.getString("m_src_cnt"));
				hm.put("S_SRC_CD", rSrc.getString("s_src_cd"));
				hm.put("S_SRC_NM", rSrc.getString("s_src_nm"));
				
				sb	=	new	StringBuffer();
				sb.append("select b.member_name \n");
				sb.append("  from tcb_src_member a \n");
				sb.append("       ,tcb_member b \n");
				sb.append(" where a.src_member_no = b.member_no \n");
				sb.append("   and a.member_no = '"+sMemberNo+"' \n");
				sb.append("   and a.src_cd = '"+rSrc.getString("src_cd")+"' \n");
				sb.append(" order by b.member_name");
				rComp	=	sqlm.getRows(sb.toString(),true);
				for(int i=1; rComp.next(); i++)
				{
					hm.put("COMP_"+i, rComp.getString("member_name"));
				}
				
				iRoopCnt	=	iMaxMemberCnt	-	rComp.size();
				for(int i=1; i<=iRoopCnt; i++)
				{
					hm.put("COMP_"+(rComp.size()+i), "");
				}
				al.add(hm);
			}
			
			if(al != null && al.size() > 0)
			{
				rXls	=	new	ResultSetValue();
				rXls.getData(al);
			}
		}
		
		response.setHeader("Content-Type", "application/vnd.ms-xls");
		response.setHeader("Content-Disposition", "attachment; filename=" + StrUtil.k2a("�ҽ�ī�װ��� ��Ͼ�ü ��Ȳ.xls"));
	}catch(Exception e)
	{
		u.jsError(e.toString());
		return;
	}finally
	{
		sqlm.close(conn);	 
	}
%>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<body>
<table width="<%=652-163+(163*iMaxMemberCnt)%>" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"><b style="font-size:18pt">�ҽ�ī�װ��� ��Ͼ�ü ��Ȳ<b></td>
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
					<td height="30" bgcolor="#cccccc" colspan=<%=iMaxMemberCnt%>>��Ͼ�ü</td>
				</tr>
<%
	String	_sLSrcCd	=	"";
	String	_sMSrcCd	=	"";

	rXls.first();
	while(rXls.next())
	{
%>
				<tr align="left" height="25">
<%
		if(!_sLSrcCd.equals(rXls.getString("l_src_cd")))
		{
%>
					<td rowspan=<%=rXls.getString("l_src_cnt")%>><%=rXls.getString("l_src_nm")%></td>
<%			
			_sLSrcCd	=	rXls.getString("l_src_cd");
%>
					<td rowspan=<%=rXls.getString("m_src_cnt")%>><%=rXls.getString("m_src_nm")%></td>
<%		
			_sMSrcCd	=	rXls.getString("m_src_cd");
		}else
		{
			if(!_sMSrcCd.equals(rXls.getString("m_src_cd")))
			{
%>
					<td rowspan=<%=rXls.getString("m_src_cnt")%>><%=rXls.getString("m_src_nm")%></td>
<%				
				_sMSrcCd	=	rXls.getString("m_src_cd");				
			}
		}
%>	
					<td><%=rXls.getString("s_src_nm")%></td>
<%
		for(int i=1; i <= iMaxMemberCnt; i++)
		{
%>
					<td><%=rXls.getString("comp_"+i)%></td>
<%			
		}
%>  
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