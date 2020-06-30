<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000067";

DataObject memberDao = new DataObject("tcb_member");
//memberDao.setDebug(out);
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("사용자 정보가 존재하지 않습니다.");
	return;
}

boolean src_l = false;
boolean src_m = false;
boolean src_s = false;
if(member.getString("src_depth").equals("01")){
	src_l = true;
}
if(member.getString("src_depth").equals("02")){
	src_l = true;
	src_m = true;
}
if(member.getString("src_depth").equals("03")){
	src_l = true;
	src_m = true;
	src_s = true;
}

//테크로스 워터앤에너지,테크로스환경서비스 는 자유서식에서 vat 포함여부 기능
boolean bIsTechcross = u.inArray(_member_no, new String[]{"20160401012","20180203437"});
 
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008", "and code in ('50','91')");
String[] code_vat_type = {"1=>VAT별도","2=>VAT포함","3=>VAT미선택"};


String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu and a.paper_yn = 'Y'";

String sColumn = "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date,a.cont_sdate, a.cont_edate, a.cont_total, a.status, a.cont_userno, b.member_no, b.member_name, b.vendcd, b.boss_name, b.cust_detail_code,a.true_random,a.cont_etc2, "
				+"( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt, a.cont_html  ";


String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM-dd",u.addDate("M",-3)));
String s_edate = u.request("s_edate",u.getTimeString("yyyy-MM-dd"));

f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_user_no", null, null);
f.addElement("s_template_cd", null, null);
f.addElement("hdn_sort_column", null, null);
f.addElement("hdn_sort_order", null, null);


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel","report"})?-1:15);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere("b.list_cust_yn = 'Y'");
list.addWhere(" a.member_no = '"+_member_no+"' ");
list.addWhere(" a.status in ('50','91')");//50:완료된 계약 91:계약해지

String s_date_query = "";
if(!s_sdate.equals("")) {
	list.addWhere(" a.cont_date >= '"+s_sdate.replaceAll("-","")+"'");
	s_date_query = " and cont_date >= '"+s_sdate.replaceAll("-","")+"'";
}
if(!s_edate.equals("")) {
	list.addWhere(" a.cont_date <= '"+s_edate.replaceAll("-","")+"'");
	s_date_query += " and cont_date <= '"+s_edate.replaceAll("-","")+"'";
}
if((!f.get("l_src_cd").equals(""))||(!f.get("m_src_cd").equals(""))||(!f.get("s_src_cd").equals(""))){
	list.addWhere(" a.src_cd like '"+f.get("l_src_cd")+f.get("m_src_cd")+f.get("s_src_cd")+"%' ");
}
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
list.addSearch("a.cont_userno",  f.get("s_user_no"), "LIKE");
list.addSearch("a.template_cd",  f.get("s_template_cd"));

/*조회권한*/
if(!auth.getString("_DEFAULT_YN").equals("Y")){
	//10:담당조회  20:부서조회 
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("10")){
		list.addWhere("a.reg_id = '"+auth.getString("_USER_ID")+"' ");
	}
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("20")){
		list.addWhere("a.field_seq in ( select field_seq from tcb_field start with member_no = '"+_member_no+"' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq )");
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

	list.setOrderBy(sSortColumn + " " + sSortOrder);
} else {
	list.setOrderBy("a.cont_no desc, a.cont_chasu asc");
	sSortCustNameIconName = "<font style='color:blue;font-weight:bold'>↕</font>";
}

DataSet ds = list.getDataSet();
while(ds.next()){
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(ds.getInt("cont_chasu")>0){
		if(!u.request("mode").equals("excel")){
			ds.put("cont_name", "<img src='../html/images/re.jpg' align='absmiddle'> " +ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"차)");
		}else{
			ds.put("cont_name", "	" +ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"차)");
		}
	}
	if(ds.getInt("cust_cnt")-2>0){
		ds.put("cust_name", ds.getString("member_name")+ "외"+(ds.getInt("cust_cnt")-2)+"개사");
	}else{
		ds.put("cust_name", ds.getString("member_name"));
	}
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("cont_sdate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_sdate")));
	ds.put("cont_edate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_edate")));
	ds.put("status", u.getItem(ds.getString("status"),code_status));
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	ds.put("cont_total", u.numberFormat(ds.getDouble("cont_total"), 0));
	ds.put("write_type", ds.getString("template_cd").equals("")?"자유서식":"일반서식"); 
	if(bIsTechcross){
		ds.put("vattype", u.getItem(ds.getString("cont_etc2"),code_vat_type)); 
	} 
}


if(u.request("mode").equals("excel")){
	p.setVar("title", "완료된 서명계약 계약현황");
	if(bIsTechcross){
		p.setVar("vatType", "Y");
	} 
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("완료된 계약현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/contend_send_list_excel.html"));
	return;
}


DataObject templateDao = new DataObject();
DataSet template = templateDao.query("select template_name, template_cd from tcb_cont_template where template_cd in (select template_cd from tcb_contmaster where member_no = '"+_member_no+"'"+s_date_query+" and status in ('50','91') group by template_cd) order by display_seq asc, template_cd desc");


p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contend_offcont_list");
p.setVar("menu_cd",_menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setVar("member", member);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("template", template);
p.setLoop("list", ds);
//p.setVar("sSortColumnContUserNo", sSortColumn.equals("a.cont_userno") ? true : false);
p.setVar("sSortColumn", sSortColumn);
p.setVar("sSortOrder", sSortOrder);
p.setVar("sSortCustNameIconName", sSortCustNameIconName);
p.setVar("src_l", src_l);
p.setVar("src_m", src_m);
p.setVar("src_s", src_s);
p.setVar("l_src_cd", f.get("l_src_cd"));
p.setVar("m_src_cd", f.get("m_src_cd"));
p.setVar("s_src_cd", f.get("s_src_cd"));
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>
