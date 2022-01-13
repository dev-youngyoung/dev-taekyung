<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@page import="procure.common.file.MakeZip"%>
<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.select.*" %>
<%
String _menu_cd = "000060";

CodeDao code = new CodeDao("tcb_comcode");
String[] code_status = code.getCodeArray("M008", " and code in ('11','12','20','21','30','40','41')");


/* boolean isKTH = u.inArray(_member_no, new String[]{"20150500312","20171100802"}); // w쇼핑, NICE정보통신(거래처코드표시)
boolean isSKB = _member_no.equals("20171101813"); // sk브로드밴드   20120100001
boolean isCJT = u.inArray(_member_no, new String[]{"20130400333"}); // CJ대한통운
boolean isPersonView = u.inArray(_member_no, new String[]{"20130500619","20121200734"}); // 위메프/ 농협유통
boolean isNicednr = _member_no.equals("20151100446");
boolean isPbpartners = _member_no.equals("20180100028"); //(주)피비파트너즈 
boolean isWoowahan = _member_no.equals("20190600690"); // 우아한청년들 
boolean isKtmns = _member_no.equals("20140900004"); // 케이티엠앤에스
boolean isKakao = u.inArray(_member_no, new String[]{"20130900194"}); // 카카오  
boolean isKakaoc = u.inArray(_member_no, new String[]{"20181201176"}); // 카카오커머스
boolean isKlp = _member_no.equals("20121200073");// 한국로지스풀(주) */


boolean bDetailCode = false;
String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu";
String sColumn = "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date, a.status, a.cont_userno, b.member_no, b.member_name, b.cust_detail_code,b.boss_name,a.sign_types,"
				 +"(select agree_person_name from tcb_cont_agree where cont_no = a.cont_no and cont_chasu=a.cont_chasu and agree_seq = "
			     +"      (select min(agree_seq) from tcb_cont_agree where cont_no = a.cont_no and cont_chasu=a.cont_chasu and agree_cd=2 and r_agree_person_id is null) ) agree_name,"
				 +"( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt ";









f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_vendcd",null, null);
f.addElement("s_status", null, null);
f.addElement("s_template_cd", null, null);



String s_contdate = u.request("s_contdate"); 


if(bDetailCode)
{
	sTable += " inner join tcb_cust c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu and a.member_no = c.member_no";
	sColumn += ", c.user_name reg_name";
}



if(u.request("mode").equals("excel")){
	sColumn += ", a.cont_total, a.true_random, a.cont_sdate, a.cont_edate, b.user_name, b.vendcd, b.tel_num, b.hp1, b.hp2, b.hp3, b.email, b.address, b.post_code";

	
	
	
	 
	
}

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel"})?-1:15);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere("b.list_cust_yn = 'Y'");
list.addWhere(" a.member_no = '"+_member_no+"' ");
// 한수테크니컬은 윤진희 선임, 윤다래 책임 외에 관리자라도 연봉계약서 조회 못함
if(_member_no.equals("20130300071") && !u.inArray(auth.getString("_USER_ID"), new String[]{"jhyoon","drsong"}) ) { 
	list.addWhere("nvl(a.template_cd,'0') not in ('2017021','2017023','2017024','2017025','2017048','2017082','2017083','2017100','2018035')");
}


list.addWhere(" a.status in ('11','12','20','21','30','40','41')");
list.addWhere(" a.subscription_yn is null");//신청서 제외


if(bDetailCode)
{
	list.addSearch("b.cust_detail_code", f.get("s_cust_detail_code"), "=");
	list.addSearch("c.user_name", f.get("s_user_name"), "LIKE");
}
list.addSearch("a.status",  f.get("s_status"));
//list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
if(!f.get("s_cont_name").equals("")){// 티알엔 대소문자 구분 없이 검색 2020-02-12
	list.addWhere(" lower(a.cont_name) like  '%'||lower('"+f.get("s_cont_name")+"')||'%'");
}



list.addSearch("a.cont_userno",  f.get("s_cust_userno"), "LIKE");
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
list.addSearch("b.vendcd",  f.get("s_vendcd").replaceAll("-", ""), "LIKE");

if(f.get("s_template_cd").equals("9999999")) { // 자유서식
	list.addWhere("a.template_cd is null");
} else {
	list.addSearch("a.template_cd", f.get("s_template_cd"));
}

list.addSearch("a.cont_etc1",  f.get("s_division"));  // CJ대한통운
list.addSearch("a.field_seq",  f.get("s_field_seq")); // CJ대한통운
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
if("20190300598".equals(_member_no))
{
	list.addWhere(" a.field_seq not in ('21')");
}
list.setOrderBy("nvl(mod_req_date,a.reg_date) desc, a.cont_no desc, a.cont_chasu");

DataSet ds = list.getDataSet();
while(ds.next()){
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(ds.getInt("cust_cnt")-2>0){
		ds.put("cust_name", ds.getString("member_name")+ "외"+(ds.getInt("cust_cnt")-2)+"개사");
	}else{
		ds.put("cust_name", ds.getString("member_name"));
	}

	if((bDetailCode)&&ds.getString("cust_detail_code").equals(""))
		ds.put("cust_detail_code", "<font color='red'>[미등록]</font>");

	ds.put("link", ds.getString("template_cd").equals("")?"contract_free_sendview.jsp":ds.getString("sign_types").equals("")?"contract_sendview.jsp":"contract_msign_sendview.jsp");
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("cont_sdate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_sdate")));
	ds.put("cont_edate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_edate")));
	if(ds.getString("status").equals("30")){//서명대기 상태이면 생상 표시
		ds.put("status_name", "<span class=\"caution-text\">"+u.getItem(ds.getString("status"), code_status)+"</span>");
	}else if(ds.getString("status").equals("12")) {  // 내부반려
		ds.put("status_name", "<span style='color:red'>"+u.getItem(ds.getString("status"), code_status)+"</span>");
	}else if(ds.getString("status").equals("21")) {  // 승인대기
		ds.put("status_name", "<span class=\"caution-text\">"+u.getItem(ds.getString("status"), code_status)+"<br>("+ds.getString("agree_name")+")</span>");
	}else if(ds.getString("status").equals("40")){//수정요청 상태이면 생상 표시
		ds.put("status_name", "<span style='color:blue'>"+u.getItem(ds.getString("status"), code_status)+"</span>");
	}else{ 
		
			ds.put("status_name", u.getItem(ds.getString("status"), code_status)); 
		 
	}
}

if(u.request("mode").equals("excel")){
	
	
	
	
	
	
	 
	
	
	
	p.setVar("title", "진행중 계약현황");
	String xlsFile = "contract_send_list_excel.html";
	if("20130700376".equals(_member_no))	/* 웅진식품의 경우 */
	{
		xlsFile = "contract_send_list_excel_20130700376.html";	
	}

	ds.first();
	while(ds.next()){
		ds.put("cont_total", u.numberFormat(ds.getDouble("cont_total"), 0));
		ds.put("status_name", ds.getString("status_name").replaceAll("<br>", ""));
		
		

		
		  
	}
 
	p.setLoop("list", ds);  
	String os_check = request.getHeader("User-Agent");
	System.out.println("OS<<<<<<<<: " + os_check); 
	if(os_check.contains("Mac")){ 
		response.setContentType("application/vnd.ms-excel; charset=UTF-8");
	}else{
		response.setContentType("application/vnd.ms-excel");
	}  
	 
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("진행중 계약현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/"+xlsFile));
	return;
}
else if(u.request("mode").equals("down")){
	String[] save = f.getArr("save");
	if(save==null) return;

	String file_path = "";
	String cont_chasu = "";

	DataSet files = new DataSet();
	DataObject cfileDao = new DataObject("tcb_cfile a inner join tcb_contmaster b on a.cont_no=b.cont_no and a.cont_chasu=b.cont_chasu");

	for(int i=0; i < save.length; i ++){
		String[] arrCont = save[i].split("_");

		DataSet dsCfile = cfileDao.find("a.cont_no = '"+u.aseDec(arrCont[0])+"' and a.cont_chasu="+arrCont[1], "b.cont_name, a.file_path, a.file_name, a.doc_name, a.file_ext");
		while(dsCfile.next())
		{
			files.addRow();
			files.put("file_path",Startup.conf.getString("file.path.bcont_pdf")+dsCfile.getString("file_path")+dsCfile.getString("file_name"));
			//files.put("doc_name", "["+dsCfile.getString("member_name") + "] " + dsCfile.getString("doc_name") + "." + dsCfile.getString("file_ext"));
			files.put("doc_name", dsCfile.getString("cont_name") + "." + dsCfile.getString("file_ext"));
		}
	}

	MakeZip mk = new MakeZip();
	mk.make(files, response);

	return;
}

StringBuffer	sb	=	new	StringBuffer();
sb.append("select nvl(display_name, template_name) template_name, ");  
sb.append("       template_cd  ");
sb.append("  from tcb_cont_template "); 
sb.append(" where template_cd in (select decode(template_cd, '', '9999999', template_cd) template_cd "); 
sb.append("		                      from tcb_contmaster ");
sb.append("		                      where member_no = '"+_member_no+"' "); 
sb.append("		                        and status in ('11','20','21','30','40','41') ");
/* 우아한형제들 전체관리자의 경우 보상팀 계약을 볼수 없게 처리 - 20210225 (이종환) */
/* if("20190300598".equals(_member_no) && "Y".equals(auth.getString("_DEFAULT_YN"))) */
if("20190300598".equals(_member_no))
{
	sb.append("   and field_seq not in ('21')");	
}
if("20200106495".equals(_member_no) && "N".equals(auth.getString("_DEFAULT_YN")))
{
	sb.append("   and field_seq not in ('3')");	
}

sb.append("	group by template_cd)  ");
sb.append(" order by display_seq asc, template_cd desc");

DataObject templateDao = new DataObject();
DataSet template = templateDao.query(sb.toString());
 
p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_send_list");
p.setVar("menu_cd", _menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setLoop("template", template);
p.setVar("detail_cd", bDetailCode );   // 파렛트폴은 담당자 세부정보 표시
p.setVar("btn_pop_msign_resend", u.inArray(_member_no, new String[]{"20190600690","20151100446","20200712105"}));//일괄 재전송 팝업 나이스디앤알, 우아한 청년들, 한진중공업 
p.setVar("btn_pop_resend", u.inArray(_member_no, new String[]{"20120200001"}));//일괄 재전송 팝업 (사업자만)
//p.setVar("btn_pop_resend_kakao", u.inArray(_member_no, new String[]{"20181201176"}));//일괄 재전송 팝업 (사업자만) 카카오 전용 (필요시만)
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