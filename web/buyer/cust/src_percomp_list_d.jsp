<%@ page contentType="text/html; charset=EUC-KR"%><%@ include file="init.jsp"%>
<%		
String member_no	= u.request("member_no");	// ȸ����ȣ
String src_cd		= u.request("src_cd");
if(member_no.equals("") || src_cd.equals("")){
    out.print("");
	return;
}

DB db = new DB();
DataObject srcMemberDao = new DataObject("tcb_src_member");

if(!srcMemberDao.delete("src_member_no='"+member_no+"' and src_cd='"+src_cd+"'")){
	out.print("");
	return;
}
out.print("1");
%>