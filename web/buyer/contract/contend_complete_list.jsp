<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000154";

String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd",u.addDate("M",-1)));
String s_edate = u.request("s_edate",u.getTimeString("yyyy-MM-dd"));

f.addElement("s_member_name",null, null);
f.addElement("s_cont_name",null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_template_cd", null, null);

String table = "tcb_contmaster a,  tcb_cont_add b,    tcb_cust c, tcb_person d  ";
String fileds = " a.cont_no, a.cont_chasu, a.member_no, a.cont_name, a.template_cd, a.cont_date, a.cont_sdate, a.cont_edate, a.reg_id, a.status, (select template_name from tcb_cont_template where template_cd = a.template_cd ) as template_name"
		//+" , b.add_col1, b.add_col2, b.add_col3, b.add_col4, b.add_col5, b.add_col6, b.add_col7 "
		+" , c.member_name, c.boss_name, c.address, c.vendcd "
		+" , d.user_name , (select field_name from tcb_field where member_no = '"+_member_no+"' and field_seq = d.field_seq ) as field_name ";

if(u.request("mode").equals("excel")){

	table = "tcb_contmaster a,   tcb_cont_add b, tcb_cust c, tcb_person d ";
	fileds = " a.cont_no, a.cont_chasu, a.member_no, a.cont_name, a.template_cd, a.cont_date, a.cont_sdate, a.cont_edate, a.reg_id, a.status, (select template_name from tcb_cont_template where template_cd = a.template_cd ) as template_name"
			+" , b.add_col1, b.add_col2, b.add_col3, b.add_col4, b.add_col5, b.add_col6, b.add_col7 "
			+" , c.member_name, c.boss_name, c.address, c.vendcd "
			+" , d.user_name , (select field_name from tcb_field where member_no = '"+_member_no+"' and field_seq = d.field_seq ) as field_name "
			+" , (select listagg(  (select cname from tcm_comcode where ccode = 'M007' and code = w.warr_type ) || warr_sdate || '~' || warr_edate , '|')" 
			+" within group (order by cont_no ) from tcb_warr w where cont_no = a.cont_no and cont_chasu = a.cont_chasu ) as warr_date ";
}

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum("excel".equals(u.request("mode"))?-1:15);
list.setTable(table);
list.setFields(fileds);
list.addWhere(
   "     a.cont_no = b.cont_no  "
  +" and a.cont_chasu = b.cont_chasu " 
  +" and a.member_no = '"+_member_no+"' " 
  +" and a.cont_no = c.cont_no  "
  +" and a.cont_chasu = c.cont_chasu  "
  +" and c.member_no != '"+_member_no+"'  "
  +" and d.member_no = '"+_member_no+"' "
  +" and a.reg_id = d.user_id"
  +" and a.status = '50' "
);
list.addSearch("a.template_cd", f.get("s_template_cd"));
if(!s_sdate.equals("")) {
	list.addWhere(" a.cont_date >= '"+s_sdate.replaceAll("-","")+"'");
}
if(!s_edate.equals("")) {
	list.addWhere(" a.cont_date <= '"+s_edate.replaceAll("-","")+"'");
}
list.addSearch(" member_name ", f.get("s_member_name"), "like");
list.addSearch(" cont_name ", f.get("s_cont_name"), "like");
/*조회권한*/
if(!auth.getString("_DEFAULT_YN").equals("Y")){
	//10:담당조회  20:부서조회 
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("10")){
		list.addWhere("a.reg_id = '"+auth.getString("_USER_ID")+"' ");
	}
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("20")){
		list.addWhere("a.field_seq = '"+auth.getString("_FIELD_SEQ")+"' ");
	}
}

list.setOrderBy(" a.cont_no desc, a.cont_chasu ");
DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("cont_sdate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_sdate")));
	ds.put("cont_edate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_edate")));
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
}




if(u.request("mode").equals("excel")){
	
	p.setVar("title", "완료된 계약현황(양식내역)");
	String xlsFile = "contend_complete_list_excel.html";

	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("완료된 계약현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/"+xlsFile));
	return;
	
}

DataObject templateDao = new DataObject();
DataSet template = templateDao.query("select nvl(display_name , template_name ) as template_name , template_cd  from tcb_cont_template where template_cd in ( select template_cd from tcb_cont_Template_add ) and member_no like '%"+_member_no+"%'  and status != '-1' ");


p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contend_complete_list");
p.setVar("menu_cd",_menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.setLoop("template", template);
p.setLoop("list", ds);
p.display(out);
%>
