<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String template_cd = u.request("template_cd");

out.print("<script language=\"javascript\">");
out.print("grid.clear();");
out.print("</script>");

if(template_cd.equals("")){
	return;
}

DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template = templateDao.find("template_cd = '"+template_cd+"'");
if(!template.next()){
}

DataObject rfileTemplateDao = new DataObject("tcb_rfile_template");
DataSet ds = rfileTemplateDao.find("template_cd='"+template_cd+"' and member_no = '"+_member_no+"' ", "*", "rfile_seq asc");

out.print("<script language=\"javascript\">");
while(ds.next()){
	if(ds.getString("reg_type").equals("10")){
		String html = "'<input type=\"checkbox\" name=\"attch\" "+(ds.getString("attch_yn").equals("Y")?"checked":"")+" disabled>"+
				      "<input type=\"hidden\" name=\"attch_yn\" value=\""+ds.getString("attch_yn")+"\"><input type=\"hidden\" name=\"reg_type\" value=\""+ds.getString("reg_type")+"\" >'"+
				      ", '<input type=\"text\" name=\"doc_name\" class=\"in_readonly\" value=\""+ds.getString("doc_name")+"\" style=\"width:98%\" readonly>'"+
				      ", '')";
				out.print("grid.addRow(null,new Array("+html+");");
	}else{
		String html = "'<input type=\"checkbox\" name=\"attch\" onclick=\"chkClick(this,\\'form1\\',\\'attch_yn\\',\\'Y\\')\" "+(ds.getString("attch_yn").equals("Y")?"checked":"")+">"+
					  "<input type=\"hidden\" name=\"attch_yn\" value=\""+ds.getString("attch_yn")+"\"><input type=\"hidden\" name=\"reg_type\" value=\""+ds.getString("reg_type")+"\" >'"+
		              ", '<input type=\"text\" name=\"doc_name\" class=\"label\" value=\""+ds.getString("doc_name")+"\" style=\"width:98%\" required=\"Y\" hname=\"구비서류명\">'"+
		              ", '<button type=\"button\" class=\"sbtn ico-delete auth_css\" onclick=\"grid.del(this);\"><span><\\/span>삭제<\\/button>')";
		out.print("grid.addRow(null,new Array("+html+");");
	}
}
if(template.getString("sign_types").equals("")) {
	out.println("document.getElementById('btn_rfile_add').style.display='';");
}else{
	out.println("document.getElementById('btn_rfile_add').style.display='none';");
}
out.print("</script>");
%>