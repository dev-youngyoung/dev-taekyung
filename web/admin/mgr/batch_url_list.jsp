<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%


f.addElement("s_member_name",u.request("s_member_name"), null);
f.addElement("s_vendcd",u.request("s_vendcd"), null);

ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_batch_url a");
list.setFields("member_no, batch_seq, (select member_name from tcb_member where member_no =  a.member_no) as member_name , template_cd, template_name, batch_url ");
list.setWhere(" status = '10' ");
if(!"".equals(f.get("s_member_name"))){
	list.addWhere("  member_no in ( select member_no from tcb_member where member_name like '%"+f.get("s_member_name")+"%') ");
}
if(!"".equals(f.get("s_vendcd"))){
	list.addWhere("  member_no in ( select member_no from tcb_member where vendcd like '%"+f.get("s_vendcd")+"%') ");
}


//목록 데이타 수정
DataSet ds = list.getDataSet();

while(ds.next()){
	//ds.put("gubun_nm", u.getItem(ds.getString("gubun"), gubun));
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("mgr.batch_url_list");
p.setVar("menu_cd","000073");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>