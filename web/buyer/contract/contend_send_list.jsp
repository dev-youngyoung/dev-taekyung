<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.Jsoup"%>
<%@ page import="org.jsoup.nodes.Document" %>
<%@ page import="org.jsoup.nodes.Element" %>
<%@ page import="org.jsoup.select.Elements" %>
<%@ page import="procure.common.file.MakeZip" %>
<%
String _menu_cd = "000063";


/* boolean isDongheeGroup = u.inArray(_member_no, new String[]{"20130300068","20130300064","20130300063","20130300062","20130300061","20130300060","20130300059","20130300058","20130300057","20121203399","20121202637","20121200067","20130700100"});
boolean isPersonView = u.inArray(_member_no, new String[]{"20130700108","20130500619","20130400333","20181201176"}); // 인터파크, 위메프, CJ대한통운, 카카오커머스  
boolean is3M= u.inArray(_member_no, new String[]{"20121203661","20130400010","20130400009","20130400011","20130400008"});
boolean isSKB = _member_no.equals("20171101813")?true:false;
boolean isOlive = _member_no.equals("20150500217")?true:false;
boolean isKTH = u.inArray(_member_no, new String[]{"20150500312","20171100802"}); // w쇼핑, NICE정보통신(거래처코드표시)
boolean isCJT = u.inArray(_member_no, new String[]{"20130400333"}); // CJ대한통운
boolean isNH = _member_no.equals("20151101243");//NH개발
boolean isLGH = _member_no.equals("20160401012");//테크로스 워터앤에너지
boolean isTES = _member_no.equals("20180203437");//테크로스 환경서비스
boolean bviewContNo = u.inArray(_member_no, new String[]{"20160900378"}); // 소니코리아
boolean view_status = u.inArray(_member_no, new String[]{"20130500619","20150500312"}); // 위메프, w쇼핑
boolean isGenie = _member_no.equals("20190300995"); // 지니뮤직
boolean isNicednr = _member_no.equals("20151100446"); //나이스디앤알
boolean isWoowahan = _member_no.equals("20190600690"); // 우아한청년들
boolean isDwst =  _member_no.equals("20160601552"); 
boolean isNHhanaro =  _member_no.equals("20121200734"); //농협유통 
boolean isJobkorea =  _member_no.equals("20130500190"); //잡코리아  
boolean isPbpartners = _member_no.equals("20180100028"); //(주)피비파트너즈 
boolean isKintexs = _member_no.equals("20181102435"); //킨텍스
boolean isTrn = _member_no.equals("20150600110"); //티알엔
boolean isKlp = _member_no.equals("20121200073");// 한국로지스풀(주)
boolean isNicetcm = _member_no.equals("20160500857");// 한국전자금융
boolean isKakaoc = u.inArray(_member_no, new String[]{"20181201176"}); //  카카오커머스 
boolean isKakao = u.inArray(_member_no, new String[]{"20130900194"}); // 카카오   */







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



CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008", "and code in ('50','91','99')");
String[] code_bid_method = null;
String[] code_succ_method = null;
String[] code_vat_type = {"1=>VAT별도","2=>VAT포함","3=>VAT미선택"}; //자유서식 VAT유형




boolean bDetailCode = false;

/* String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu and a.paper_yn is null"; */
String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu";

String sColumn = "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date,a.cont_sdate, a.cont_edate, a.cont_total, a.status, a.cont_userno, a.cont_etc1, a.cont_etc2, b.member_no, b.member_name, b.vendcd, b.boss_name, b.cust_detail_code, a.true_random, a.sign_types, "
				+"( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt,  "
				+"a.paper_yn";



String s_sdate = u.request("s_sdate",auth.getString("_FIELD_SEQ").equals("2") ? "2013-07-01" : u.getTimeString("yyyy-MM-dd",u.addDate("M",-1)));
String s_edate = u.request("s_edate");

f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_vendcd",null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_manage_no", null, null);
f.addElement("s_user_no", null, null);
f.addElement("s_template_cd", null, null);

if(	_member_no.equals("20121000046")){
	f.addElement("s_cust_detail_code",null, null);
	f.addElement("s_user_name",null, null);
}

f.addElement("hdn_sort_column", null, null);
f.addElement("hdn_sort_order", null, null);



if(bDetailCode)
{
	sTable += " inner join tcb_cust c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu and a.member_no = c.member_no";
	sColumn += ", c.user_name, b.email,b.hp1,b.hp2,b.hp3";
}








//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel","report"})?-1:15);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere("b.list_cust_yn = 'Y'");

list.addWhere(" a.member_no = '"+_member_no+"' ");

// 한수테크니컬은 송다래 선임, 윤다래 책임 외에 관리자라도 연봉계약서 조회 못함
if(_member_no.equals("20130300071") && !u.inArray(auth.getString("_USER_ID"), new String[]{"jhyoon","drsong"}) ) { 
	list.addWhere("nvl(a.template_cd,'0') not in ('2017021','2017023','2017024','2017025','2017048','2017082','2017083','2017100','2018035')");
}

list.addWhere(" a.status in ('50','91','99')");//50:완료된 계약 91:계약해지, 99:계약폐기
list.addWhere(" a.subscription_yn is null");//신청서 제외


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

if(bDetailCode)
{
	list.addSearch("b.cust_detail_code", f.get("s_cust_detail_code"), "=");
	list.addSearch("c.user_name", f.get("s_user_name"), "LIKE");
	list.addSearch("b.email", f.get("s_email"), "LIKE");
}





//list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
if(!f.get("s_cont_name").equals("")){// 티알엔 대소문자 구분 없이 검색 2020-02-12
	list.addWhere(" lower(a.cont_name) like  '%'||lower('"+f.get("s_cont_name")+"')||'%'");
}
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
list.addSearch("b.vendcd",  f.get("s_vendcd").replaceAll("-", ""), "LIKE");
list.addSearch("a.status", f.get("s_status"));
list.addSearch("a.cont_userno",  f.get("s_user_no"), "LIKE");

if(f.get("s_template_cd").equals("9999999")) { /* 계약양식[자유서식]인 경우 */
	list.addWhere("a.template_cd is null and a.paper_yn is null");
}else if(f.get("s_template_cd").equals("9999998")) { /* 계약양식[서면계약]인 경우 */ 
	list.addWhere("a.template_cd is null and a.paper_yn = 'Y'");
}else {
	list.addSearch("a.template_cd", f.get("s_template_cd"));
}

list.addSearch("a.cont_etc1",  f.get("s_division"));  // CJ대한통운
list.addSearch("a.field_seq",  f.get("s_field_seq")); // CJ대한통운 
list.addSearch("d.project_cd",  f.get("s_project_cd"),"LIKE");  // 엘지히타치

/*조회권한*/
if(!auth.getString("_DEFAULT_YN").equals("Y")){
	//10:담당조회  20:부서조회 
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("10")){
		list.addWhere("(  "
			+"     a.agree_person_ids like '%"+auth.getString("_USER_ID")+"|%' "
		    +"  or a.reg_id = '"+auth.getString("_USER_ID")+"' "
		    +"  or a.field_seq in (select field_seq from tcb_auth_field where member_no = '"+_member_no+"' and auth_cd = '"+auth.getString("_AUTH_CD")+"' and menu_cd = '"+_menu_cd+"') "
		    +"           ) "); 
	}
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("20")){
		list.addWhere(" (  "
			+"     a.agree_field_seqs like '%|"+auth.getString("_FIELD_SEQ")+"|%' "
			+"  or a.agree_person_ids like '%"+auth.getString("_USER_ID")+"|%' " // 결제 라인 조회 권한은 부여된 권한 보다 우선 한다.
			+"  or a.field_seq in ( select field_seq from tcb_field start with member_no = '"+_member_no+"' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq ) " 
			+"  or a.field_seq in (select field_seq from tcb_auth_field where member_no = '"+_member_no+"' and auth_cd = '"+auth.getString("_AUTH_CD")+"' and menu_cd = '"+_menu_cd+"') " 
			+"          ) ");
	}
}
/* 우아한형제들 전체관리자의 경우 보상팀 계약을 볼수 없게 처리 - 20210225 (이종환) */
/* if("20190300598".equals(_member_no) && "Y".equals(auth.getString("_DEFAULT_YN"))) */
	/* 우아한형제들 보상팀 계약을 아예 볼수 없게 처리 - 20210721 (이종환) */
if("20190300598".equals(_member_no))
{
	list.addWhere(" a.field_seq not in ('21')");
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
	ds.put("manage_no", ds.getString("cont_no")+"-"+ds.getString("cont_chasu")+"-"+ds.getString("true_random"));
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

	if((bDetailCode)&& ds.getString("cust_detail_code").equals(""))
		ds.put("cust_detail_code", "<font color='red'>[미등록]</font>");
	

	ds.put("link", ds.getString("template_cd").equals("")?"contend_free_sendview.jsp":ds.getString("sign_types").equals("")?"contend_sendview.jsp":"contend_msign_sendview.jsp");
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("cont_sdate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_sdate")));
	ds.put("cont_edate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_edate")));
	ds.put("status_nm", u.getItem(ds.getString("status"),code_status));
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	ds.put("cont_total", u.numberFormat(ds.getDouble("cont_total"), 0));
	ds.put("write_type", ds.getString("template_cd").equals("")?"자유서식":"일반서식");
}
 
if(u.request("mode").equals("excel")){
	p.setVar("title", "완료된 계약현황");
	p.setVar("detail_cd", bDetailCode );   // 파렛트폴은 담당자 세부정보 표시
	 
	
	String xlsFile = "contend_send_list_excel.html";
	
	
	

	
	
	
	
	p.setLoop("list", ds);
	//response.setContentType("application/vnd.ms-excel");
	
	String os_check = request.getHeader("User-Agent");
	System.out.println("OS<<<<<<<<: " + os_check); 
	if(os_check.contains("Mac")){ 
		response.setContentType("application/vnd.ms-excel; charset=UTF-8");
	}else{
		response.setContentType("application/vnd.ms-excel");
	}  
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("완료된 계약현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/"+xlsFile));
	return;
}
else if(u.request("mode").equals("report")){
	ds.first();
	while(ds.next()){
		Document document = Jsoup.parse(ds.getString("cont_html"));
		String cont_ref_info = getJsoupValue(document,"ref_info");
		String cont_edate = "";
		String cont_eyear = getJsoupValue(document,"cont_eyear");
		String cont_emonth = getJsoupValue(document,"cont_emonth");
		String cont_eday = getJsoupValue(document,"cont_eday");
		String cont_pre = getJsoupValue(document,"cont_pre");
		String cont_middle1 = getJsoupValue(document,"cont_middle1");
		String cont_middle2 = getJsoupValue(document,"cont_middle2");
		String cont_rest = getJsoupValue(document,"cont_rest");
		if((!cont_eyear.equals(""))&&!cont_emonth.equals("")&&!cont_eday.equals("")){
			cont_edate = cont_eyear+cont_emonth+ cont_eday;
		}
		ds.put("cont_ref_info", cont_ref_info);
		ds.put("cont_edate", u.getTimeString("yyyy-MM-dd", cont_edate));
		ds.put("calc_cont_pre","");
		ds.put("calc_cont_middle1","");
		ds.put("calc_cont_middle2","");
		ds.put("calc_cont_rest","");
		if(ds.getDouble("cont_total")>0){
			if(!cont_pre.equals(""))ds.put("calc_cont_pre",(Double.parseDouble(cont_pre.replaceAll(",", ""))/ds.getDouble("cont_total")*100));
			if(!cont_middle1.equals(""))ds.put("calc_cont_middle1",(Double.parseDouble(cont_middle1.replaceAll(",", ""))/ds.getDouble("cont_total")*100));
			if(!cont_middle2.equals(""))ds.put("calc_cont_middle2",(Double.parseDouble(cont_middle2.replaceAll(",", ""))/ds.getDouble("cont_total")*100));
			if(!cont_rest.equals(""))ds.put("calc_cont_rest",(Double.parseDouble(cont_rest.replaceAll(",", ""))/ds.getDouble("cont_total")*100));
		}
		ds.put("cont_pre", cont_pre);
		ds.put("cont_middle1", cont_middle1);
		ds.put("cont_middle2", cont_middle2);
		ds.put("cont_rest", cont_rest);
		ds.put("cont_total", u.numberFormat(ds.getDouble("cont_total"), 0));
	}

	p.setVar("title", "계&nbsp;&nbsp;약&nbsp;&nbsp;현&nbsp;&nbsp;황");
	p.setLoop("list", ds);
	//response.setContentType("application/vnd.ms-excel");
	String os_check = request.getHeader("User-Agent");
	System.out.println("OS<<<<<<<<: " + os_check); 
	if(os_check.contains("Mac")){ 
		response.setContentType("application/vnd.ms-excel; charset=UTF-8");
	}else{
		response.setContentType("application/vnd.ms-excel");
	}  
	
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("계약현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/contend_send_list_report.html"));
	return;
}
else if(u.request("mode").equals("down")){

	String[] save = f.getArr("save");
	if(save==null) return;
	
	

	return;
}

StringBuffer sb = new	StringBuffer();
sb.append("select a.template_cd, nvl(a.display_name, a.template_name) template_name ");
sb.append("  from tcb_cont_template a ");
sb.append(" where exists (select 'x' ");
sb.append("                 from tcb_contmaster ");
sb.append("		             where member_no = '"+_member_no+"'"+s_date_query+" "); 
sb.append("                  and status in ('50', '91') ");
sb.append("                  and (case when template_cd is null then case when paper_yn = 'Y' then '9999998' else '9999999' end else template_cd end) = a.template_cd) ");
/* 우아한형제들 전체관리자의 경우 보상팀 계약을 볼수 없게 처리 - 20210225 (이종환) */
/* if("20190300598".equals(_member_no) && "Y".equals(auth.getString("_DEFAULT_YN"))) */
if("20190300598".equals(_member_no))
{
	sb.append("   and a.field_seq not in ('21')");	
}
sb.append("order by case when template_cd in ('9999998','9999999') then 9 else 1 end, display_seq ");

DataObject templateDao = new DataObject();
DataSet template = templateDao.query(sb.toString());

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contend_send_list");
p.setVar("menu_cd", _menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setVar("member", member);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("template", template);
p.setLoop("list", ds);
p.setVar("detail_cd", bDetailCode );   // 파렛트폴은 담당자 세부정보 표시
//p.setVar("sSortColumnContUserNo", sSortColumn.equals("a.cont_userno") ? true : false);
//p.setVar("view_checkbox", isSKB||isOlive); 
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
<%!
public String getJsoupValue(Document document, String name){
	String value = "";
	Elements elements = document.getElementsByAttributeValue("name", name);
	int i=0;

	for(Element element: elements){
		if(i > 0) value += "<br>";
		if(element.nodeName().equals("textarea"))
		{
			value += element.text();
		}
		else
		{
			value += element.attr("value");
		}
		i++;
	}
	return value;
}
%>