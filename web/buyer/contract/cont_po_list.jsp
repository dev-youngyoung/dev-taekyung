<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@page import="procure.common.file.MakeZip"%>
<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.select.*" %>
<%
String _menu_cd = "000076";

CodeDao code = new CodeDao("tcb_comcode");
String[] code_status = code.getCodeArray("M008", " and code in ('11','20','21','30','40','41')");

boolean is3M= u.inArray(_member_no, new String[]{"20121203661","20130400010","20130400009","20130400011","20130400008"});
boolean isKTH = u.inArray(_member_no, new String[]{"20150500312"}); // w쇼핑
boolean isSKB = _member_no.equals("20171101813"); // sk브로드밴드   20120100001
boolean isCJT = u.inArray(_member_no, new String[]{"20130400333"}); // CJ대한통운
boolean isOlive = u.inArray(_member_no, new String[]{"20150500217"}); // CJ올리브네트웍스

boolean bDetailCode = false;
String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu inner join tcb_cont_add c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu"
				+ " inner join tcb_field d on d.member_no = a.member_no and d.field_seq = a.field_seq inner join tcb_person e on e.user_id = a.reg_id";
String sColumn = "a.cont_no, a.cont_chasu, d.field_name, e.user_name,"
				+ "a.cont_name, a.cont_date, c.add_col4, b.member_name, c.add_col6, c.add_col7, c.add_col8, c.add_col9, c.add_col10, c.add_col11,"
				+ "(select count(member_no) cnt from tcb_cust where cont_no = a.cont_no and cont_chasu = a.cont_chasu) cust_cnt,"
				+ "(select count(*) rowspan from tcb_cont_add where cont_no = a.cont_no and cont_chasu = a.cont_chasu) rowspan";

String s_sdate = u.request("s_sdate",is3M && auth.getString("_FIELD_SEQ").equals("2") ? "2013-07-01" : u.getTimeString("yyyy-MM-dd",u.addDate("M",-3)));
String s_edate = u.request("s_edate",u.getTimeString("yyyy-MM-dd"));

if(	_member_no.equals("20121000046") )
	bDetailCode = true;  // 거래처 코드 표시 (예: 파렛트풀)

f.addElement("s_field_name",null, null);
f.addElement("s_member_name",null, null);
f.addElement("user_name", null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);

if(	_member_no.equals("20121000046")){
	f.addElement("s_cust_detail_code",null, null);
	f.addElement("s_user_name",null, null);
}
if(isKTH || isOlive){
	f.addElement("s_cust_detail_code",null, null);
	f.addElement("s_user_name",null, null);
}


if(bDetailCode||isKTH||isOlive)
{
	sTable += " inner join tcb_cust c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu and a.member_no = c.member_no";
	sColumn += ", c.user_name";
}


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
//list.setListNum(15);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel"})?-1:15);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere("b.list_cust_yn = 'Y'");
list.addWhere(" a.member_no = '"+_member_no+"' ");
list.addWhere(" a.status = '50'");
String s_date_query = "";
if(!s_sdate.equals("")) {
	list.addWhere(" a.cont_date >= '"+s_sdate.replaceAll("-","")+"'");
	s_date_query = " and cont_date >= '"+s_sdate.replaceAll("-","")+"'";
}
if(!s_edate.equals("")) {
	list.addWhere(" a.cont_date <= '"+s_edate.replaceAll("-","")+"'");
	s_date_query += " and cont_date <= '"+s_edate.replaceAll("-","")+"'";
}

list.addSearch("b.member_name",  f.get("s_member_name"), "LIKE");
list.addSearch("d.field_name",  f.get("s_field_name"), "LIKE");
list.addSearch("e.user_name",  f.get("s_user_name"), "LIKE");
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

list.setOrderBy("a.cont_no desc");

DataSet ds = list.getDataSet();

String cont_no = "";
String cont_chasu = "";

while(ds.next()){
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(ds.getInt("cust_cnt")-2>0){
		ds.put("cust_name", ds.getString("member_name")+ "외"+(ds.getInt("cust_cnt")-2)+"개사");
	}else{
		ds.put("cust_name", ds.getString("member_name"));
	}
	
	if( cont_no.equals(ds.getString("cont_no"))&&  cont_chasu.equals(ds.getString("cont_chasu"))){
		ds.put("first",false);
	}else{
		ds.put("first",true);
		cont_no = ds.getString("cont_no");
		cont_chasu = ds.getString("cont_chasu");
	}
	
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("add_col4", u.getTimeString("yyyy-MM-dd",ds.getString("add_col4")));
	ds.put("add_col9", u.numberFormat(ds.getString("add_col9")));
	ds.put("add_col10", u.numberFormat(ds.getString("add_col10")));
	ds.put("add_col11", u.numberFormat(ds.getString("add_col11")));
}

if(u.request("mode").equals("excel")){
	p.setVar("title", "발주서 현황");
	p.setVar("date", s_sdate + " ~ " + s_edate);

	ds.first();
	
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("발주서 현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/cont_po_list_excel.html"));
	return;
} 

DataObject templateDao = new DataObject();
DataSet template = templateDao.query("select template_name, template_cd from tcb_cont_template where template_cd in (select template_cd from tcb_contmaster where member_no = '"+_member_no+"' and status != '10' group by template_cd) order by display_seq asc, template_cd desc");

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.cont_po_list");
p.setVar("menu_cd",_menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setLoop("template", template);
p.setVar("isSKB", isSKB);
p.setVar("isCJT", isCJT);
p.setVar("isOlive", isOlive);
p.setVar("isDefaultYn", auth.getString("_DEFAULT_YN").equals("Y"));
p.setVar("detail_cd", bDetailCode );   // 파렛트폴은 담당자 세부정보 표시
p.setVar("isKTH",isKTH);  //KTH 거래처 코드 표시
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