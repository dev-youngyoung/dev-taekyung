<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000205"; 
String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM-dd",u.addDate("M",-1)));
String s_edate = u.request("s_edate");

CodeDao code = new CodeDao("tcb_comcode");
String[] code_status = code.getCodeArray("M008", " and code in ('10','20','30','40','41','50')"); 
String[] cont_radio = {"1=>개인사유","2=>가정, 건강사유","3=>계약종료","4=>사업장폐쇄","5=>기타"};	
  
f.addElement("s_cont_name", null, null); 
f.addElement("s_cust_name", null, null); 
f.addElement("s_status", null, null); 
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_template_cd", null, null); 
  
String isTemplate =  f.get("s_template_cd") ; 
if(isTemplate.equals("")){isTemplate = "A";}
//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel"})?-1:15);
list.setTable(" tcb_contmaster a, tcb_cust b, tcb_cont_add c "); 
list.setFields(" a.cont_no, a.cont_chasu, a.cont_name, a.cont_date, a.field_seq, a.status, a.cont_sdate, a.cont_edate , b.user_name as cust_name , (select user_name from tcb_person where member_no = '"+_member_no+"' and user_id = a.reg_id ) as reg_name " 
			+" ,b.boss_birth_date as birth_date, b.email, b.hp1 || '-' || b.hp2 || '-' || b.hp3 as hp , c.add_col1, c.add_col2, c.add_col3, c.add_col4, c.add_col5, c.add_col6   "); 
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
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE"); 
list.addSearch("b.user_name", f.get("s_cust_name"), "LIKE"); 
list.addSearch("a.status", f.get("s_status"), "LIKE" );

if(!f.get("s_template_cd").equals("")){
	list.addSearch("a.template_cd", f.get("s_template_cd"), "LIKE");
}else{
	list.addWhere(" a.template_cd in ('2020041','2020042') ");
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
	ds.put("cont_sdate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_sdate")));
	ds.put("cont_edate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_edate"))); 
	ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	ds.put("status_name", u.getItem(ds.getString("status"), code_status));
	if(isTemplate.equals("2020042")){
		ds.put("dele_reason", u.getItem(ds.getString("add_col2"), cont_radio));
	} 
	ds.put("birth_date", u.getTimeString("yyyy-MM-dd",ds.getString("birth_date")));
	
	if("10".equals(ds.getString("status"))){
		url = "contract_msign_modify.jsp";
	}else if("50".equals(ds.getString("status"))){
		url = "contend_msign_sendview.jsp";
	}
	ds.put("url", url);
}

if(u.request("mode").equals("excel")){
	p.setVar("title", "계약현황");
	String xlsFile = "playtime_manage_excel.html";
 
	p.setLoop("list", ds);
	p.setVar("isTemplate", isTemplate);   // 서식 목록 분리
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("플레이타임그룹 계약현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/"+xlsFile));
	return;
}
 
DataObject templateDao = new DataObject();
DataSet template = templateDao.query("select nvl(display_name, template_name) template_name, template_cd from tcb_cont_template where template_cd in ('2020041','2020042') and member_no = '" + _member_no + "' ");
 
p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.playtime_manage_list");
p.setVar("menu_cd", _menu_cd);
p.setLoop("template", template);  
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("code_status", u.arr2loop(code_status)); 
p.setLoop("list", ds);
p.setVar("isTemplate", isTemplate);   // 서식 목록 분리
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>