<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp"%>
<%
String member_no = u.request("member_no");	// 회원번호
String m_cd	 = u.request("m_cd");
String s_cd = u.request("s_cd");
String d_cd = u.request("d_cd");
String depth = u.request("depth");

DataObject dao = new DataObject("tcb_client_tech");

StringBuffer	sb	=	new	StringBuffer();
sb.append(" select                                                       ");
sb.append("        e.member_no                                           ");
sb.append("      , e.member_name                                         ");
sb.append("      , e.vendcd                                              ");
sb.append("      , e.boss_name                                           ");
sb.append("      , d.tech_expl                                           ");
sb.append("      , d.etc                                                 ");
sb.append("      , b.code_nm  m_nm                                       ");
sb.append("      , decode(a.depth , '3', c.code_nm,'4',c.code_nm) s_nm   ");
sb.append("      , decode(a.depth , '4', a.code_nm) d_nm                 ");
sb.append("   from tcb_user_code a                                       ");
sb.append("      , tcb_user_code b                                       ");
sb.append("      , tcb_user_code c                                       ");
sb.append("      , tcb_client_tech d                                     ");
sb.append("      , tcb_member e                                          ");
sb.append("  where a.member_no = b.member_no                             ");
sb.append("    and substr(a.code,1,4)||'000000' = b.code                 ");
sb.append("    and a.member_no = c.member_no                             ");
sb.append("    and substr(a.code,1,7)||'000' = c.code                    ");
sb.append("    and a.depth <> '1'                                        ");
sb.append("    and d.client_no = e.member_no                             ");
sb.append("    and a.member_no = '"+member_no+"'                         ");
sb.append("    and a.l_cd = 'A'                                          ");
sb.append("    and a.code = d.tech_cd                                    ");
if(depth.equals("2")){
	sb.append("and substr(a.code,1,4) = 'A"+m_cd+"'                      ");
}else if(depth.equals("3")){
	sb.append("and substr(a.code,1,7) = 'A"+m_cd+s_cd+"'                 ");
}else if(depth.equals("4")){
	sb.append("and a.code = 'A"+m_cd+s_cd+d_cd+"'                        ");
}
sb.append("  order by  a.code asc ,e.member_name asc	                  ");
DataSet	ds	=	dao.query(sb.toString());
while(ds.next()){
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
}
out.println(u.loop2json(ds));
%>