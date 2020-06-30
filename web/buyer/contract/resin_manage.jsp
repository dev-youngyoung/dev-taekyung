<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000155";

// 레진엔터테인먼트 계약현황관리
String[] code_status = new String[] {"10=>연재예정","20=>연재중","30=>장기휴재중","40=>연재완료"};

String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM-dd",u.addDate("M",-6)));
String s_edate = u.request("s_edate");

String[] code_date_gubun = {"cont_date=>a.cont_date","n_fday=>e.n_fday","e_fday=>e.e_fday","j_fday=>e.j_fday"};

String s_date_gubun = u.request("s_date_gubun","cont_date");

f.addElement("s_item_name",null, null);
f.addElement("s_member_name",null, null);
f.addElement("s_write_name",null, null);
f.addElement("n_status", null, null);
f.addElement("e_status", null, null);
f.addElement("j_status", null, null);
f.addElement("c_status", null, null);
f.addElement("s_template_cd", null, null);
f.addElement("s_date_gubun", s_date_gubun, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel"})?-1:15);
list.setTable("tcb_contmaster a, tcb_cust b, tcb_cont_add c, tcb_cont_resin e ");
list.setFields(
		 "   a.cont_no, a.cont_chasu, a.cont_name, a.cont_date, a.cont_sdate, a.cont_edate, a.cont_total, a.status"
		+" , b.member_no, b.member_name, b.hp1, b.hp2, b.hp3, b.email, b.address"
		+" , add_col1 item_name" 
		+" , c.add_col2 c_writer_type1 " 
		+" , c.add_col3 c_writer_type2 " 
		+" , c.add_col4 write_name " 
		+" , c.add_col5 write_amt " 
		+" , c.add_col6 draw_amt " 
		+" , c.add_col7 kor_fee " 
		+" , c.add_col8 eng_fee " 
		+" , c.add_col9 jr_fee " 
		+" , c.add_col10 tt_etc_yn " 
		+" , e.n_status ,e.e_status, e.j_status, e.c_status "
		+" , e.n_sday, e.n_eday, e.n_fday, e.e_sday, e.e_eday, e.e_fday, e.j_sday, e.j_eday, e.j_fday, e.c_sday, e.c_eday, e.c_fday "
		+",(select user_name from tcb_person where user_id = a.reg_id) user_name"
		);
list.addWhere(" a.cont_no = b.cont_no");
list.addWhere(" a.cont_chasu= b.cont_chasu");
list.addWhere(" b.sign_seq = '2'");
list.addWhere(" a.cont_no = c.cont_no");
list.addWhere(" a.cont_chasu= c.cont_chasu");
list.addWhere(" a.cont_no = e.cont_no(+)");
list.addWhere(" a.member_no = '"+_member_no+"' ");
list.addWhere(" a.template_cd <> '2018197' ");
if(!s_date_gubun.equals("")){
	if(!s_sdate.equals("")) {
		list.addWhere(u.getItem(s_date_gubun, code_date_gubun)+" >= '"+s_sdate.replaceAll("-","")+"'");
	}
	if(!s_edate.equals("")) {
		list.addWhere(u.getItem(s_date_gubun, code_date_gubun)+" <= '"+s_edate.replaceAll("-","")+"'");
	}
}
list.addWhere("a.status in ('50')");
list.addSearch("d.n_status",  f.get("n_status"));
list.addSearch("d.e_status",  f.get("e_status"));
list.addSearch("d.j_status",  f.get("j_status"));
list.addSearch("d.c_status",  f.get("c_status"));
list.addSearch("c.add_col1", f.get("s_item_name"), "LIKE");
list.addSearch("b.member_name",  f.get("s_member_name"), "LIKE");
list.addSearch("c.add_col4",  f.get("s_write_name"), "LIKE");
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
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
    ds.put("cont_chasu_nm", ds.getInt("cont_chasu")==0 ? "최초" : ds.getString("cont_chasu")+"차");
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("n_status_nm", u.getItem(ds.getString("n_status"), code_status));
	ds.put("e_status_nm", u.getItem(ds.getString("e_status"), code_status));
	ds.put("j_status_nm", u.getItem(ds.getString("j_status"), code_status));
	ds.put("c_status_nm", u.getItem(ds.getString("c_status"), code_status));
	String c_writer_type = "";
	if(!ds.getString("c_writer_type1").equals(""))c_writer_type +=ds.getString("c_writer_type1");
	if(!ds.getString("c_writer_type2").equals("")){
		if(!c_writer_type.equals(""))c_writer_type+="/";
		c_writer_type +=ds.getString("c_writer_type2"); 
	}
	
	ds.put("c_writer_type",c_writer_type);
	
	if(ds.getString("n_status").equals("")) {
	    ds.put("pop_link_n", "<a href=\"javascript:OpenWindow('resin_series_i.jsp?type=n&cont_no="+ds.getString("cont_no")+"','pop_series', '420','440');\"  style='color:blue'>[등록]</a>");
	} else {
        ds.put("pop_link_n", "<a href=\"javascript:OpenWindow('resin_series_m.jsp?type=n&cont_no="+ds.getString("cont_no")+"','pop_series', '420','440');\"  style='color:blue'>"+ds.getString("n_status_nm")+"</a>");
	}

	if(ds.getString("e_status").equals("")) {
		ds.put("pop_link_e", "<a href=\"javascript:OpenWindow('resin_series_i.jsp?type=e&cont_no="+ds.getString("cont_no")+"','pop_series', '420','440');\"  style='color:blue'>[등록]</a>");
	} else {
		ds.put("pop_link_e", "<a href=\"javascript:OpenWindow('resin_series_m.jsp?type=e&cont_no="+ds.getString("cont_no")+"','pop_series', '420','440');\"  style='color:blue'>"+ds.getString("e_status_nm")+"</a>");
	}

	if(ds.getString("j_status").equals("")) {
		ds.put("pop_link_j", "<a href=\"javascript:OpenWindow('resin_series_i.jsp?type=j&cont_no="+ds.getString("cont_no")+"','pop_series', '420','440');\"  style='color:blue'>[등록]</a>");
	} else {
		ds.put("pop_link_j", "<a href=\"javascript:OpenWindow('resin_series_m.jsp?type=j&cont_no="+ds.getString("cont_no")+"','pop_series', '420','440');\"  style='color:blue'>"+ds.getString("j_status_nm")+"</a>");
	}

	if(ds.getString("c_status").equals("")) {
		ds.put("pop_link_c", "<a href=\"javascript:OpenWindow('resin_series_i.jsp?type=c&cont_no="+ds.getString("cont_no")+"','pop_series', '420','440');\"  style='color:blue'>[등록]</a>");
	} else {
		ds.put("pop_link_c", "<a href=\"javascript:OpenWindow('resin_series_m.jsp?type=c&cont_no="+ds.getString("cont_no")+"','pop_series', '420','440');\"  style='color:blue'>"+ds.getString("c_status_nm")+"</a>");
	}
}

if(u.request("mode").equals("excel")){
	p.setVar("title", "계약현황");
	String xlsFile = "resin_manage_excel.html";

	ds.first();
	while(ds.next()){
		ds.put("cont_sdate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_sdate")));
		ds.put("cont_edate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_edate")));
		ds.put("cont_total", u.numberFormat(ds.getString("cont_total")));
		ds.put("n_sday", u.getTimeString("yyyy-MM-dd",ds.getString("n_sday")));
		ds.put("n_eday", u.getTimeString("yyyy-MM-dd",ds.getString("n_eday")));
		ds.put("n_fday", u.getTimeString("yyyy-MM-dd",ds.getString("n_fday")));
		ds.put("e_sday", u.getTimeString("yyyy-MM-dd",ds.getString("e_sday")));
		ds.put("e_eday", u.getTimeString("yyyy-MM-dd",ds.getString("e_eday")));
		ds.put("e_fday", u.getTimeString("yyyy-MM-dd",ds.getString("e_fday")));
		ds.put("j_sday", u.getTimeString("yyyy-MM-dd",ds.getString("j_sday")));
		ds.put("j_eday", u.getTimeString("yyyy-MM-dd",ds.getString("j_eday")));
		ds.put("j_fday", u.getTimeString("yyyy-MM-dd",ds.getString("j_fday")));
		ds.put("c_sday", u.getTimeString("yyyy-MM-dd",ds.getString("c_sday")));
		ds.put("c_eday", u.getTimeString("yyyy-MM-dd",ds.getString("c_eday")));
		ds.put("c_fday", u.getTimeString("yyyy-MM-dd",ds.getString("c_fday")));
		ds.put("tt_etc_yn", ds.getString("tt_etc_yn").equals("Y")?"유":"무");
	}


	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("레진엔터 계약현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/"+xlsFile));
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.resin_manage");
p.setVar("menu_cd", _menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>