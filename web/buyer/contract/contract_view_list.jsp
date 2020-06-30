<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.select.*" %>
<%
String _menu_cd = "000069";

String donghees =  " '20121202637'"
                  +",'20121203399'"
                  +",'20121200067'"
                  +",'20130300057'"
                  +",'20130300058'"
                  +",'20130300059'"
                  +",'20130300060'"
                  +",'20130300061'"
                  +",'20130300062'"
                  +",'20130300063'"
                  +",'20130300064'"
                  +",'20130300068'"
                  +",'20130700100'";  
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008", " and code in ('10','20','30','31','40','41','50','91')");

String s_sdate = u.request("s_sdate", u.addDate("M", -1, new Date(), "yyyy-MM-dd"));
String s_edate = u.request("s_edate", u.getTimeString("yyyy-MM-dd"));

boolean memberChk = false;

DataObject memberDao = new DataObject("tcb_member");
DataSet dsDonghee = memberDao.find(" member_no in ("+donghees +")");
while(dsDonghee.next()){
	if(dsDonghee.getString("member_no").equals(_member_no)){
		memberChk = true;
		break;
	}
}
if(!memberChk){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

f.addElement("s_main_member_no",null, null);
f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_status", null, null);


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel","report"})?-1:15);
list.setTable("tcb_contmaster a, tcb_cust b");
list.setFields(
				 "  a.*, b.member_name"
				+" ,( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt "
				+" ,( SELECT  member_name FROM tcb_member WHERE member_no = a.member_no ) main_member_name "
				+" ,( SELECT  user_name FROM tcb_person WHERE user_id = a.reg_id ) user_name "
		      );
list.addWhere(" a.cont_no = b.cont_no");
list.addWhere(" a.cont_chasu = b.cont_chasu");
list.addWhere(" a.status <> '00'");
list.addWhere("b.list_cust_yn = 'Y'");
list.addWhere(" a.member_no in ("+donghees+")");
if(!s_sdate.equals(""))list.addWhere(" a.cont_date >= '"+s_sdate.replaceAll("-","")+"'");
if(!s_edate.equals(""))list.addWhere(" a.cont_date <= '"+s_edate.replaceAll("-","")+"'");
list.addSearch("a.member_no", f.get("s_main_member_no"));
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
list.addSearch("a.status", f.get("s_status"));
/*조회권한*/
if(!auth.getString("_DEFAULT_YN").equals("Y")){//권한을 가질수 없음.
	//10:담당조회  20:부서조회 
	/* if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("10")){
		list.addWhere("a.reg_id = '"+auth.getString("_USER_ID")+"' ");
	}
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("20")){
		list.addWhere("a.field_seq = '"+auth.getString("_FIELD_SEQ")+"' ");
	} */
}
list.setOrderBy("a.cont_no desc, a.cont_chasu asc");


DataSet ds = list.getDataSet();
while(ds.next()){
	if(ds.getInt("cont_chasu")>0){
		if(!u.request("mode").equals("excel")){
			ds.put("cont_name", "<img src='../html/images/re.jpg' align='absmiddle'> " +ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"차)");
		}else{
			ds.put("cont_name", "└ " +ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"차)");
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
}



if(u.request("mode").equals("excel")){
	p.setVar("title", "계약진행현황");
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("계약진행현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/contract_view_list_excel.html"));
	return;
}


if(u.request("mode").equals("report")){
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
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("계약현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/contract_view_list_report.html"));
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_view_list");
p.setVar("menu_cd",_menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("donghees", dsDonghee);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
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
	for(Element element: elements){
		value = element.attr("value");
	}
	return value;
}
%>