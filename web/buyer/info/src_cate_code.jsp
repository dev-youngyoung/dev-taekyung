<%@ page contentType="text/html; charset=EUC-KR"%><%@ include file="init.jsp"%>
<%
String p_src_cd = u.request("p_src_cd");
String depth = "1";
if(p_src_cd.replace("000", "").length()==3) {
	depth = "2";
} else if(p_src_cd.replace("000", "").length()==6) {
	depth = "3";
} 


String query = "select nvl((to_char(to_number(max(replace(src_cd, '000', '')))+1)),rpad('"+p_src_cd.replace("000", "")+"' || '001' ,9,'0')) from tcb_src_adm where member_no='"
		+_member_no+"' and depth='"+depth+"' ";

if(!depth.equals("1")) {
	query = query + "and src_cd like '"+p_src_cd.replace("000", "")+"'||'%'";
}

DataObject srcCatDao = new DataObject("tcb_src_adm");
String srcCd = srcCatDao.getOne(query);
if(!"999999999".equals(srcCd)){
	if(p_src_cd.replace("000", "").length()==3) {
		srcCd = u.strrpad(srcCd, 6, "0");
	} else if(p_src_cd.replace("000", "").length()==6) {
		srcCd = u.strrpad(srcCd, 9, "0");
	} else {
		srcCd = u.strrpad(srcCd, 3, "0");
	}
}else{
	srcCd  = "001000000";
}
srcCd = u.strpad(srcCd, 9, "0"); 
out.print(srcCd);
%>