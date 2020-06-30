<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
DataSet ds = new DataSet();
ds.addRow();
ds.put("member_no", _member_no);

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.src_cate_list");
p.setVar("menu_cd","000136");
p.setVar("sys_date", u.getTimeString());
p.setVar("form_script", f.getScript());
p.setVar(ds);
p.display(out);
%> 