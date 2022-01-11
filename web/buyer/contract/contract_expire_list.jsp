<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.select.*" %>
<%
String _menu_cd = "000066";

CodeDao code = new CodeDao("tcb_comcode");

boolean bDetailCode = false;
if(	_member_no.equals("20121000046")	)
	bDetailCode = true;  // 거래처 코드 표시 (예: 파렛트풀)

boolean is3M= u.inArray(_member_no, new String[]{"20121203661","20130400010","20130400009","20130400011","20130400008"});


String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd"));
String s_edate = u.request("s_edate", u.getTimeString("yyyy-MM-dd",u.addDate("M",3)));

f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_cust_detail_code",null, null);

String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu";
String sColumn = "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date, a.status, a.cont_userno, a.cont_edate, b.member_no, b.member_name, b.vendcd, b.cust_detail_code, "
		+" ( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt ";

if(u.request("mode").equals("excel"))
{
	if(is3M)
	{
		sTable += " left join tcb_cont_sub d on a.cont_no = d.cont_no and a.cont_chasu = d.cont_chasu and d.sub_seq=1";
		sColumn += ",d.cont_sub_html sub_html, a.cont_html";
	}
}

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel","report"})?-1:15);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere("b.list_cust_yn='Y'");
if(_member_no.equals("20120200004")){
	list.addWhere(" a.member_no in ( '20120200004','20120400014','20120400018','20120400019','20121100029','20121100031','20140100807','20140100855') ");
}else{
	list.addWhere(" a.member_no = '"+_member_no+"' ");
	list.addWhere("b.list_cust_yn='Y'");
}

list.addWhere(" a.status in ('50')");
list.addWhere(" a.cont_edate is not null  ");// 만료 일자가 있는 것만
list.addWhere(" a.subscription_yn is null");//신청서 제외
if(!s_sdate.equals(""))list.addWhere(" a.cont_edate >= '"+s_sdate.replaceAll("-","")+"' ");
if(!s_edate.equals(""))list.addWhere(" a.cont_edate <= '"+s_edate.replaceAll("-","")+"' ");

if(bDetailCode)
	list.addSearch("b.cust_detail_code", f.get("s_cust_detail_code"), "LIKE");
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
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

list.setOrderBy("a.cont_edate asc");

DataSet ds = list.getDataSet();
while(ds.next()){
	ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(ds.getInt("cont_chasu")>0)
		ds.put("cont_name", ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"차)");

	if(ds.getInt("cust_cnt")-2>0){
		ds.put("cust_name", ds.getString("member_name")+ "외"+(ds.getInt("cust_cnt")-2)+"개사");
	}else{
		ds.put("cust_name", ds.getString("member_name"));
	}

	if(bDetailCode && ds.getString("cust_detail_code").equals(""))
		ds.put("cust_detail_code", "<font color='red'>[미등록]</font>");

	ds.put("link", ds.getString("template_cd").equals("")?"contend_free_sendview.jsp":"contend_sendview.jsp");
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("cont_edate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_edate")));
}

if(u.request("mode").equals("excel")){
	p.setVar("is3M",is3M);//3m 계약시작일, 계약금액 미표시
	if(is3M)
	{
		ds.first();
		while(ds.next()){
			if(ds.getString("template_cd").equals("2013040"))  // 판매대리점 계약서
			{
				Document document = Jsoup.parse(ds.getString("sub_html"));
				String Division = getJsoupValue(document,"t12");  // 3M 사업부서 (Division)

				ds.put("division", Division);
			}
			else if(ds.getString("template_cd").equals("2013042"))  // 판매점 계약서
			{
				Document document = Jsoup.parse(ds.getString("cont_html"));
				String Division = getJsoupValue(document,"t1");  // 3M 사업부서 (Division)

				ds.put("division", Division);
			}
			else
			{
			}
		}
	}	
	
	p.setVar("title", "만료예정 계약");
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("만료예정 계약현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/contend_expire_list_excel.html"));
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_expire_list");
p.setVar("menu_cd", _menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("detail_cd", bDetailCode );   // 파렛트폴은 담당자 세부정보 표시
p.setVar("form_script", f.getScript());
p.setVar("pagerbar", list.getPaging());
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