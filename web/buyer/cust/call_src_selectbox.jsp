<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%
String gubun = u.request("gubun");
String l_src_cd = u.request("l_src_cd");
String m_src_cd = u.request("m_src_cd");

DataObject srcDao = new DataObject("tcb_src_adm");
//srcDao.setDebug(out);

DataSet src = new DataSet();
String name = "";
String hname = "";
String colunm_name = "";
String s_gubun = "";

if(gubun.equals("l")){
	
	name = "l_src_cd";
	hname = "대분류";
	colunm_name = "l_src_cd";
	s_gubun = "m";
	src = srcDao.find(" member_no = '"+_member_no+"' and l_src_cd <> '000' and m_src_cd = '000' and s_src_cd = '000' ");
}

if(gubun.equals("m")){
	
	name = "m_src_cd";
	hname = "중분류";
	colunm_name = "m_src_cd";
	s_gubun = "s";
	if(!l_src_cd.equals(""))
		src = srcDao.find(" member_no = '"+_member_no+"' and l_src_cd = '"+l_src_cd+"' and m_src_cd <> '000' and s_src_cd = '000' ");
	else
		src = new DataSet();
}

if(gubun.equals("s")){
	name = "s_src_cd";
	hname = "소분류";
	colunm_name = "s_src_cd";
	s_gubun = "";
	if(! m_src_cd.equals(""))
		src = srcDao.find(" member_no = '"+_member_no+"' and l_src_cd = '"+l_src_cd+"' and m_src_cd = '"+m_src_cd+"' and s_src_cd <> '000'");
	else 
		src = new DataSet();	
}

if(!s_gubun.equals("")){
	out.print("<select name=\""+name+"\" onchange=\"chgSelectBox('"+s_gubun+"')\"> ");
}else{
	out.print("<select name=\""+name+"\" onchange=\"document.forms['form1'].submit()\"> ");
}

	out.print("<option value=\"\">-"+hname+"-</option>");
while(src.next()){
	out.print("<option value=\""+src.getString(colunm_name)+"\">"+src.getString("src_nm")+"</option>");
}
out.print("</select>");
%>