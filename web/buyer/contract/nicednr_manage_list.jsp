<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000192";

String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM-dd",u.addDate("M",-1)));
String s_edate = u.request("s_edate");

CodeDao code = new CodeDao("tcb_comcode");
String[] code_status = code.getCodeArray("M008", " and code in ('10','20','30','40','41','50')"); 
String[] s_sel = {"1=>일반조사용","2=>소비자품평회용"};
 
f.addElement("s_cust_name", null, null);
f.addElement("s_cont_name", null, null);
f.addElement("s_cust_cd", null, null);
f.addElement("s_status", null, null);
f.addElement("s_project_cd", null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_template_cd", null, null);
f.addElement("s_sel", null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel"})?-1:15);
list.setTable(" tcb_contmaster a, tcb_cust b, tcb_cont_add c ");
list.setFields(" a.cont_no, a.cont_chasu, a.cont_name, a.cont_date, a.field_seq, a.status, b.user_name as cust_name , (select user_name from tcb_person where member_no = '"+_member_no+"' and user_id = a.reg_id ) as reg_name " 
		+" , c.add_col1 as cust_cd , c.add_col2 as project_cd, c.add_col3  as project_name , c.add_col4 as sel  ");
list.addWhere(" a.cont_no = b.cont_no");
list.addWhere(" a.cont_no = c.cont_no");
list.addWhere(" a.cont_chasu = b.cont_chasu");
list.addWhere(" a.cont_chasu = c.cont_chasu");
list.addWhere(" a.member_no = '"+_member_no+"'");

list.addWhere(" b.member_no != '"+_member_no+"'");

if(!s_sdate.equals("")) {
	list.addWhere(" a.cont_date >= '"+s_sdate.replaceAll("-","")+"'");
}
if(!s_edate.equals("")) {
	list.addWhere(" a.cont_date <= '"+s_edate.replaceAll("-","")+"'");
}
list.addSearch("b.user_name", f.get("s_cust_name"),"LIKE");
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.addSearch("c.add_col1",  f.get("s_cust_cd"), "LIKE");
list.addSearch("c.add_col2", f.get("s_project_cd"), "LIKE");
list.addSearch("a.status", f.get("s_status"), "LIKE" );

if(!f.get("s_template_cd").equals("")){
	list.addSearch("a.template_cd", f.get("s_template_cd"), "LIKE");
}else{
	list.addWhere(" a.template_cd in ('2019028','2020069') ");
}  
if(!f.get("s_sel").equals("")){
	list.addSearch("c.add_col4", f.get("s_sel"), "LIKE");  
}  

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
list.setOrderBy("a.cont_no desc, a.cont_chasu asc");

DataSet ds = list.getDataSet();
while(ds.next()){
	
	String url = "contract_msign_sendview.jsp";
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	ds.put("status_name", u.getItem(ds.getString("status"), code_status));
	
	if("10".equals(ds.getString("status"))){
		url = "contract_msign_modify.jsp";
	}else if("50".equals(ds.getString("status"))){
		url = "contend_msign_sendview.jsp";
	}
	
	ds.put("url", url);
}

if(u.request("mode").equals("excel")){
	p.setVar("title", "계약현황");
	String xlsFile = "nicednr_manage_excel.html";

	ds.first();
	while(ds.next()){
	} 
	
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("나이스디앤알 계약현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/"+xlsFile));
	return;
}
 
DataObject templateDao = new DataObject();
DataSet template = templateDao.query("select nvl(display_name, template_name) template_name, template_cd from tcb_cont_template where template_cd in ('2019028','2020069') and member_no = '" + _member_no + "' ");
 
p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.nicednr_manage_list");
p.setVar("menu_cd", _menu_cd);
p.setLoop("template", template);  
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("s_sel", u.arr2loop(s_sel)); 
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>