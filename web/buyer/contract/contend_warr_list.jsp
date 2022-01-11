<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000068";

CodeDao code = new CodeDao("tcb_comcode");

String[] code_warr_type = code.getCodeArray("M007");


String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM-dd",u.addDate("M",-6)));
String s_edate = u.request("s_edate",u.getTimeString("yyyy-MM-dd"));
String s_date_name = u.request("s_date_name", "cont_date");

f.addElement("s_code_warr_type", null, null);
f.addElement("s_reg_gubun", null, null);
f.addElement("s_cust_name", null, null);
f.addElement("s_date_name", s_date_name, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_cont_name",null, null);
f.addElement("hdn_sort_column", null, null);
f.addElement("hdn_sort_order", null, null);

DataObject dao = new DataObject("tcb_warr");

StringBuffer	sb	=	new	StringBuffer();
sb.append("  select  a.cont_no                               \n");
sb.append("        , a.cont_chasu                            \n");
sb.append("        , a.cont_name                             \n");
sb.append("        , b.member_name                           \n");
sb.append("        , (select user_name from tcb_cust where cont_no = b.cont_no and  cont_chasu = b.cont_chasu and  sign_seq = '1' )  user_name \n");
sb.append("        , round(a.cont_total) cont_total          \n");
sb.append("        , a.cont_date                             \n");
sb.append("        , a.cont_sdate                            \n");
sb.append("        , a.cont_edate                  	         \n");
sb.append("        , c.warr_type                             \n");
sb.append("        , c.warr_sdate                            \n");
sb.append("        , c.warr_edate                            \n");
sb.append("        , c.warr_no                               \n");
sb.append("        , c.warr_seq                              \n");
sb.append("        , c.status warr_status                    \n");
sb.append("        , ( 										 \n");
sb.append("           select count(*) 						 \n");
sb.append("             from tcb_warr 						 \n");
sb.append("            where cont_no = a.cont_no			 \n");
sb.append("              and cont_chasu = a.cont_chasu		 \n"); 
if(!f.get("s_code_warr_type").equals("")) sb.append("  and  warr_type like '%"+f.get("s_code_warr_type")+"%' \n");
if(f.get("s_reg_gubun").equals("Y"))sb.append(" and warr_no is not null");
if(f.get("s_reg_gubun").equals("N"))sb.append(" and warr_no is null");
sb.append("          ) rowspan 							     \n");
sb.append("   from tcb_contmaster a, tcb_cust b ,tcb_warr c  \n");
sb.append("  where a.cont_no = b.cont_no                     \n");
sb.append("    and a.cont_chasu = b.cont_chasu               \n");
sb.append("    and b.sign_seq = '2'                          \n");
sb.append("    and a.cont_no = c.cont_no                     \n");
sb.append("    and a.cont_chasu = c.cont_chasu               \n");
sb.append("    and a.status = '50'               			 \n");
sb.append("    and a.member_no = '"+_member_no+"' 			 \n");
if(s_date_name.equals("warr_edate")){
	if(!s_sdate.equals("")) sb.append("  and exists( select * from tcb_warr where cont_no = a.cont_no and cont_chasu = a.cont_chasu and warr_edate >= '"+s_sdate.replaceAll("-","")+"' ) \n");
	if(!s_edate.equals("")) sb.append("  and exists( select * from tcb_warr where cont_no = a.cont_no and cont_chasu = a.cont_chasu and warr_edate <= '"+s_edate.replaceAll("-","")+"' ) \n");
}else {
	if(!s_sdate.equals("")) sb.append("  and a." + s_date_name + " >= '" + s_sdate.replaceAll("-", "") + "' \n");
	if(!s_edate.equals("")) sb.append("  and a." + s_date_name + " <= '" + s_edate.replaceAll("-", "") + "' \n");
}
if(!f.get("s_cont_name").equals("")) sb.append("  and lower(a.cont_name) like '%'||lower('"+f.get("s_cont_name")+"')||'%' \n");
if(!f.get("s_cust_name").equals("")) sb.append("  and b.member_name like '%"+f.get("s_cust_name")+"%' \n");
if(!f.get("s_code_warr_type").equals("")) sb.append("  and c.warr_type like '%"+f.get("s_code_warr_type")+"%' \n");
if(f.get("s_reg_gubun").equals("Y"))sb.append(" and c.warr_no is not null");
if(f.get("s_reg_gubun").equals("N"))sb.append(" and c.warr_no is null");
/*조회권한*/
if(!auth.getString("_DEFAULT_YN").equals("Y")){
	//10:담당조회  20:부서조회 
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("10")){
		sb.append(" and a.reg_id = '"+auth.getString("_USER_ID")+"' ");
	}
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("20")){
		sb.append(" and a.field_seq = '"+auth.getString("_FIELD_SEQ")+"' ");
	}
}
String sSortColumn = f.get("hdn_sort_column");

String sSortOrder = f.get("hdn_sort_order");
String sSortCustNameIconName = "";
if(!sSortColumn.equals("")) {
	if(sSortOrder.equals("asc"))
		sSortCustNameIconName =  "<font style='color:blue;font-weight:bold'>↑</font>";
	else
		sSortCustNameIconName =  "<font style='color:blue;font-weight:bold'>↓</font>";
		sb.append(" order by " + sSortColumn + " " + sSortOrder + " , cont_no desc, cont_chasu , c.warr_seq asc	\n");
} else {
	sb.append(" order by a.cont_no desc, cont_no desc, cont_chasu , c.warr_seq asc	\n");
	sSortCustNameIconName = "<font style='color:blue;font-weight:bold'>↕</font>";
}

DataSet ds = dao.query(sb.toString());
String cont_no = "";
String cont_chasu = "";
while(ds.next()){
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if( cont_no.equals(ds.getString("cont_no"))&&  cont_chasu.equals(ds.getString("cont_chasu"))){
		ds.put("first",false);
	}else{
		ds.put("first",true);
		cont_no = ds.getString("cont_no");
		cont_chasu = ds.getString("cont_chasu");
	}
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd", ds.getString("cont_date")));
	ds.put("cont_sdate", u.getTimeString("yyyy-MM-dd", ds.getString("cont_sdate")));
	ds.put("cont_edate", u.getTimeString("yyyy-MM-dd", ds.getString("cont_edate")));
	ds.put("warr_name", u.getItem(ds.getString("warr_type"),code_warr_type ));
	ds.put("warr_sdate",u.getTimeString("yyyy-MM-dd", ds.getString("warr_sdate")));
	ds.put("warr_edate",u.getTimeString("yyyy-MM-dd", ds.getString("warr_edate")));
	if(!ds.getString("warr_sdate").equals("")&& !ds.getString("warr_edate").equals("")){
		ds.put("warr_term", ds.getString("warr_sdate")+"<br> ~ "+ ds.getString("warr_edate"));
	}else{
		ds.put("warr_term","");
	}
	ds.put("cont_total", u.numberFormat(ds.getLong("cont_total")));
	
	System.out.println("warr_no -> " + ds.getString("warr_no"));
	System.out.println("warr_status -> " + ds.getString("warr_status"));
	if(ds.getString("warr_no").equals("")){
		//if(ds.getString("warr_status").equals("")){
		if(ds.getString("warr_status").equals("")){
			String btn = "<button type=\"button\" class=\"sbtn ico-save\" onclick=\"contWarr('"+ds.getString("cont_no")+"','"+ds.getString("cont_chasu")+"','"+ds.getString("warr_seq")+"')\"><span></span>직접첨부</button>";
		           btn+= "<br><button type=\"button\" class=\"sbtn ico-request\" onclick=\"warrReq('"+ds.getString("cont_no")+"','"+ds.getString("cont_chasu")+"','"+ds.getString("warr_seq")+"')\"><span></span>보증요청</button>";
			ds.put("btn", btn);
		}else if(ds.getString("warr_status").equals("10")) {
			String btn = "<button type=\"button\" class=\"sbtn ico-save\" onclick=\"contWarr('"+ds.getString("cont_no")+"','"+ds.getString("cont_chasu")+"','"+ds.getString("warr_seq")+"')\"><span></span>직접첨부</button>";
			ds.put("btn", btn);
		}else{
			ds.put("btn", "<a href=\"javascript:contWarr('"+ds.getString("cont_no")+"','"+ds.getString("cont_chasu")+"','"+ds.getString("warr_seq")+"')\"><u>"+u.getItem(ds.getString("warr_status"), code_warr_status)+"</u></a>");
		}
		
	}else{
		if(ds.getString("warr_status").equals("")||ds.getString("warr_status").equals("30")){
			ds.put("btn", "<button type=\"button\" class=\"sbtn ico-search\" onclick=\"contWarr('"+ds.getString("cont_no")+"','"+ds.getString("cont_chasu")+"','"+ds.getString("warr_seq")+"')\"><span></span>조회</button>");
		}else{
			ds.put("btn", "<a href=\"javascript:contWarr('"+ds.getString("cont_no")+"','"+ds.getString("cont_chasu")+"','"+ds.getString("warr_seq")+"')\"><u>"+u.getItem(ds.getString("warr_status"), code_warr_status)+"</u></a>");
		}
	}
	
	
}
if(u.request("mode").equals("excel")){
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("보증보험관리.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/contend_warr_excel.html"));
	return;
}
 

p.setLayout("default");
//p.setDebug(out);
p.setVar("sSortColumn", sSortColumn); 
p.setVar("sSortOrder", sSortOrder);
p.setVar("sSortCustNameIconName", sSortCustNameIconName);
p.setBody("contract.contend_warr_list");
p.setVar("menu_cd",_menu_cd);
p.setLoop("code_warr_type", u.arr2loop(code_warr_type));
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list",ds);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>