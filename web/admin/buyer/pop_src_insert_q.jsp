<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%		
	String	sMemberNo = u.request("member_no");

	DataObject doTcbSrcAdm = new DataObject("tcb_src_adm");
	DataSet	dsTcbSrcAdm	= doTcbSrcAdm.query("select b.src_nm l_src_nm \n"	+
											"				,c.src_nm m_src_nm \n"	+
											"				,a.src_nm s_src_nm \n"	+
											"  from tcb_src_adm a \n"	+
											"				,tcb_src_adm b \n"	+
											"				,tcb_src_adm c \n"	+
											" where substr(a.src_cd,1,3)||'000000' = b.src_cd \n"	+
											"		and substr(a.src_cd,1,6)||'000' = c.src_cd \n"	+
											"   and a.member_no = b.member_no \n"	+
											"   and a.member_no = c.member_no \n"	+
											"		and a.depth = '3' \n"	+
											"		and a.member_no = '"+sMemberNo+"' \n"	+
											" order by a.l_src_cd, a.m_src_cd, a.s_src_cd");
	out.print(u.loop2json(dsTcbSrcAdm));
%>