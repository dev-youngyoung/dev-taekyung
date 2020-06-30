<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.select.*" %>
<%
String _menu_cd = "000059";

boolean isKTH = u.inArray(_member_no, new String[]{"20150500312","20171100802"}); // w쇼핑, NICE정보통신(거래처코드표시)
boolean isSKB = _member_no.equals("20171101813"); // sk브로드밴드   20120200001
boolean bDetailCode = false;
String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu ";
//String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu";
String sColumn = "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date, a.status, a.cont_userno, a.paper_yn, b.member_no, b.member_name, b.cust_detail_code, a.sign_types, "
				+"( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt ";

if(	_member_no.equals("20121000046"))
	bDetailCode = true;  // 거래처 코드 표시 (예: 파렛트풀)

f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_vendcd",null, null);

if(	_member_no.equals("20121000046")){
	f.addElement("s_cust_detail_code",null, null);
	f.addElement("s_user_name",null, null);
}
if(isKTH){
	f.addElement("s_cust_detail_code",null, null);
	f.addElement("s_user_name",null, null);
}

if(bDetailCode||isKTH)
{
	sTable += " inner join tcb_cust c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu and a.member_no = c.member_no";
	sColumn += ", c.user_name";
}

if(u.request("mode").equals("excel") && isSKB){
	sColumn += ", a.cont_total, a.true_random, b.user_name, b.vendcd, b.tel_num, b.hp1, b.hp2, b.hp3, b.email, b.address, b.post_code, a.cont_html";
}


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel"})?-1:15);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere(" b.list_cust_yn = 'Y' ");
list.addWhere(" a.member_no = '"+_member_no+"' ");
list.addWhere(" a.status = '10'");
// 한수테크니컬은 송다래 선임, 윤다래 책임 외에 관리자라도 연봉계약서 조회 못함
if(_member_no.equals("20130300071") && !u.inArray(auth.getString("_USER_ID"), new String[]{"jhyoon","drsong"}) ) { 
	list.addWhere("nvl(a.template_cd,'0') not in ('2017021','2017023','2017024','2017025','2017048','2017082','2017083','2017100','2018035')");
}

if(bDetailCode||isKTH)
{
	list.addSearch("b.cust_detail_code", f.get("s_cust_detail_code"), "=");
	list.addSearch("c.user_name", f.get("s_user_name"), "LIKE");
}

if(u.request("mode").equals("excel") && isSKB){
	list.addWhere("a.template_cd='2015016'"); // 청구서2
}

//list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
if(!f.get("s_cont_name").equals("")){// 티알엔 대소문자 구분 없이 검색 2020-02-12
	list.addWhere(" lower(a.cont_name) like  '%'||lower('"+f.get("s_cont_name")+"')||'%'");
}
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
list.addSearch("b.vendcd",  f.get("s_vendcd").replaceAll("-", ""), "LIKE");
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
list.setOrderBy("a.cont_no desc");

DataSet ds = list.getDataSet();
while(ds.next()){
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(ds.getInt("cust_cnt")-2>0){
		ds.put("cust_name", ds.getString("member_name")+ "외"+(ds.getInt("cust_cnt")-2)+"개사");
	}else{
		ds.put("cust_name", ds.getString("member_name"));
	}
	if(ds.getString("paper_yn").equals("Y")){//서면계약
		ds.put("cont_name", "<span style='color:blue'>[서면계약]</span>"+ds.getString("cont_name"));
	}

	if((bDetailCode||isKTH)&& ds.getString("cust_detail_code").equals(""))
		ds.put("cust_detail_code", "<font color='red'>[미등록]</font>");

	if(ds.getString("paper_yn").equals("Y")){
		ds.put("link", "offcont_modify.jsp");
	}else{
		ds.put("link", ds.getString("template_cd").trim().equals("")?"contract_free_modify.jsp":ds.getString("sign_types").equals("")?"contract_modify.jsp":"contract_msign_modify.jsp");
	}
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
}

if(u.request("mode").equals("excel") && isSKB){
	p.setVar("isSKB", isSKB); // sk브로드밴드
	p.setVar("title", "임시저장 계약-청구서");
	String xlsFile = "contract_send_list_excel_2015016.html";

	ds.first();
	while(ds.next()){
		Document document = Jsoup.parse(ds.getString("cont_html"));
		String cust_code = getJsoupValue(document,"cust_code");  // 업체코드
		String req_month = getJsoupValue(document,"req_month");  // 청구월
		String req_count = getJsoupValue(document,"req_count");  // 청구차수
		String cont_total_str = getJsoupValue(document,"cont_total");  // 청구차수

		ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
		ds.put("cont_total", cont_total_str);
		ds.put("cust_code", cust_code);
		ds.put("req_month", req_month);
		ds.put("req_count", req_count);
		ds.put("cont_no", u.aseDec(ds.getString("cont_no")));
	}
	
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("임시저장 계약.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/"+xlsFile));
	return;	
} 
p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_writing_list");
p.setVar("menu_cd", _menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("detail_cd", bDetailCode );   // 파렛트폴은 담당자 세부정보 표시
p.setVar("isKTH",isKTH);//KTH 거래처 코드 표시
p.setVar("isSKB", isSKB);
p.setVar("view_checkbox", isSKB);
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