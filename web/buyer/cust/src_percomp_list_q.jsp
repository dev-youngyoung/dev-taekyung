<%@ page contentType="text/html; charset=UTF-8"%><%@ include file="init.jsp"%>
<%		
String sMemberNo	= u.request("member_no");	// 회원번호
String sLSrcCd		= u.request("l_src_cd");		// 대분류코드
String sMSrcCd		= u.request("m_src_cd");		// 중분류코드
String sSSrcCd		= u.request("s_src_cd");		// 소분류코드
String sDepth		= u.request("depth");			// depth

DataObject doTcbSrcAdm = new DataObject("tcb_src_adm");

StringBuffer	sb	=	new	StringBuffer();
sb.append("select b.member_no \n");
sb.append("				,b.member_name \n");
sb.append("				,b.member_no   \n");
sb.append("				,substr(b.vendcd,1,3)||'-'||substr(b.vendcd,4,2)||'-'||substr(b.vendcd,6,5) vendcd \n");
sb.append("				,b.boss_name \n");
sb.append("				,c.src_nm l_src_nm \n");
sb.append("				,d.src_nm m_src_nm \n");
sb.append("				,e.src_nm s_src_nm \n");
sb.append("				,e.src_cd \n");
sb.append("  from tcb_src_member a \n");
sb.append("				,tcb_member b \n");
sb.append("				,tcb_src_adm c \n");
sb.append("				,tcb_src_adm d \n");
sb.append("				,tcb_src_adm e \n");
sb.append(" where a.src_member_no = b.member_no \n");
sb.append("	  and a.member_no = c.member_no \n");
sb.append("	  and substr(a.src_cd,0,3)||'000000' = c.src_cd \n");
sb.append("	  and a.member_no = d.member_no \n");
sb.append("	  and substr(a.src_cd,0,6)||'000' = d.src_cd \n");
sb.append("	  and a.member_no = e.member_no \n");
sb.append("	  and a.src_cd = e.src_cd \n");
sb.append("	  and a.member_no = '"+sMemberNo+"' \n");
if(sDepth.equals("1"))
{
	sb.append("	  and e.l_src_cd = '"+sLSrcCd+"' \n");
}else if(sDepth.equals("2"))
{
	sb.append("	  and e.l_src_cd = '"+sLSrcCd+"' \n");
	sb.append("	  and e.m_src_cd = '"+sMSrcCd+"' \n");
}else
{
	sb.append("	  and e.l_src_cd = '"+sLSrcCd+"' \n");
	sb.append("	  and e.m_src_cd = '"+sMSrcCd+"' \n");
	sb.append("	  and e.s_src_cd = '"+sSSrcCd+"' \n");
}
sb.append(" order by b.member_no, e.l_src_cd, e.m_src_cd, e.s_src_cd");

DataSet	dsTcbSrcAdm	=	doTcbSrcAdm.query(sb.toString());

out.println(u.loop2json(dsTcbSrcAdm));
%>