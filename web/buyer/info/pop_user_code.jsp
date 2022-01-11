<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] title = {"A=>취급품목선택","B=>기술분야선택"};

String main_member_no= u.request("main_member_no");
String code_gubun = u.request("code_gubun");
String codeObj = u.request("codeObj");
String nameObj = u.request("nameObj");
if(main_member_no.equals("")|| code_gubun.equals("")){
	u.jsErrClose("정상적인 경로로 접근하세요.");
	return;
}

f.addElement("m_cd", null, null);
f.addElement("s_cd", null, null);
f.addElement("code_nm", null, null);

//대분류 코드
DataObject userCodeDao =new DataObject("tcb_user_code");
DataSet code_m = userCodeDao.find("l_cd = '"+code_gubun+"' and depth=2 ");


//코드 목록
StringBuffer sb = new StringBuffer();
sb.append("select a.code                                       		   ");
sb.append("     ,(select code_nm                                       ");
sb.append("         from tcb_user_code                                 ");
sb.append("        where member_no = a.member_no                       ");
sb.append("          and code = a.l_cd || a.m_cd || '000000'           ");
sb.append("       ) m_nm                                               ");
sb.append("     ,(select count(code)                                   ");
sb.append("         from tcb_user_code                                 ");
sb.append("        where member_no = a.member_no                       ");
sb.append("          and depth = '4'                                   ");
sb.append("          and use_yn = 'Y'                                  ");
sb.append("          and code like  a.l_cd || a.m_cd || '%'            ");
if(!f.get("code_nm").equals(""))//코드명
	sb.append("  and code_nm like '%"+f.get("code_nm")+"%'");
sb.append("      ) m_rowspan                                           ");
sb.append("     ,(select code_nm                                       ");
sb.append("         from tcb_user_code                                 ");
sb.append("        where member_no = a.member_no                       ");
sb.append("          and  code = a.l_cd || a.m_cd || a.s_cd||'000'     ");
sb.append("      ) s_nm                                                ");
sb.append("     ,(select count(code)                                   ");
sb.append("         from tcb_user_code                                 ");
sb.append("        where member_no = a.member_no                       ");
sb.append("          and depth = '4'                                   ");
sb.append("          and use_yn = 'Y'                                  ");
sb.append("          and  code like  a.l_cd || a.m_cd || a.s_cd || '%' ");
if(!f.get("code_nm").equals(""))//코드명
	sb.append("  and code_nm like '%"+f.get("code_nm")+"%'");
sb.append("       ) s_rowspan                                          ");
sb.append("     , a.code_nm                                            ");
sb.append("  from tcb_user_code a                                      ");
sb.append(" where depth = '4'                                          ");
sb.append("   and use_yn = 'Y'										   ");
sb.append("   and l_cd = '"+code_gubun+"'                              ");
sb.append("   and member_no = '"+main_member_no+"'                     ");
if(!f.get("m_cd").equals(""))//대분류
	sb.append("  and m_cd = '"+f.get("m_cd")+"' ");
if(!f.get("s_cd").equals(""))//중분류
	sb.append("  and s_cd = '"+f.get("s_cd")+"'");
if(!f.get("code_nm").equals(""))//코드명
	sb.append("  and code_nm like '%"+f.get("code_nm")+"%'");
sb.append("order by code asc		                                   ");

DataSet list = userCodeDao.query(sb.toString());


String m_nm = "";
String s_nm = "";
while(list.next()){
	if(!m_nm.equals(list.getString("m_nm"))){
		m_nm = list.getString("m_nm");
		list.put("m_rowspan",list.getString("m_rowspan"));
	}else{
		list.put("m_rowspan","");
	}
	if(!s_nm.equals(list.getString("s_nm"))){
		s_nm = list.getString("s_nm");
		list.put("s_rowspan", list.getString("s_rowspan"));
	}else{
		list.put("s_rowspan","");
	}
}


p.setLayout("popup");
p.setDebug(out);
p.setBody("info.pop_user_code");
p.setVar("popup_title",u.getItem(code_gubun, title));
p.setLoop("code_m", code_m);
p.setLoop("list", list);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>