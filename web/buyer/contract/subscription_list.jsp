<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000157";

boolean isNicePay = _member_no.equals("20120600068"); // 나이스페이먼츠(주) 20120600068
//boolean isNicePay = _member_no.equals(u.request("member_no")) ;

 
CodeDao code = new CodeDao("tcb_comcode");
String[] code_status = new String[] {"30=>신청중","41=>반려","50=>완료"};//code.getCodeArray("M008", " and code in ('30','41','50')"); // 30:신청중(서명대기), 41:반려, 50:계약완료

String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM-dd",u.addDate("M",-1)));
String s_edate = u.request("s_edate",u.getTimeString("yyyy-MM-dd"));


boolean bDetailCode = false;
String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu ";
String sColumn = "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date, a.status, a.cont_userno, b.member_no, b.member_name, b.cust_detail_code,b.boss_name,"
				 +"(select agree_person_name from tcb_cont_agree where cont_no = a.cont_no and cont_chasu=a.cont_chasu and agree_seq = "
			     +"      (select min(agree_seq) from tcb_cont_agree where cont_no = a.cont_no and cont_chasu=a.cont_chasu and agree_cd=2 and r_agree_person_id is null) ) agree_name,"
				 +"( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt ";

f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_status", null, null);
f.addElement("s_template_cd", null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);

if(u.request("mode").equals("excel")){
	sColumn += ", a.cont_total, a.true_random, b.user_name, b.vendcd, b.tel_num, b.hp1, b.hp2, b.hp3, b.email, b.address, b.post_code ";
	if(isNicePay){
		sTable += ("  left join tcb_cont_add c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu  ");
		sColumn += "  , c.add_col1 as bank_name , c.add_col2 as bank_no, c.add_col3 as bank_user , c.add_col4 as boss_birthday  ";
	}
	p.setVar("isNicePay",isNicePay);
}


//System.out.println(sTable);
//System.out.println(sColumn);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel"})?-1:15);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere("b.list_cust_yn = 'Y'");
list.addWhere(" a.member_no = '"+_member_no+"' ");
String s_date_query = "";
if(!s_sdate.equals("")) {
	list.addWhere(" a.cont_date >= '"+s_sdate.replaceAll("-","")+"'");
}
if(!s_edate.equals("")) {
	list.addWhere(" a.cont_date <= '"+s_edate.replaceAll("-","")+"'");
}

list.addWhere("a.status in ('30','41','50')");
list.addWhere("a.subscription_yn = 'Y'");
list.addSearch("a.status",  f.get("s_status"));
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
list.addSearch("a.template_cd",  f.get("s_template_cd"));
/*조회권한*/
if(!auth.getString("_DEFAULT_YN").equals("Y")){
	//10:담당조회  20:부서조회 
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("10")){
		list.addWhere("(  a.agree_field_seqs like '%|"+auth.getString("_FIELD_SEQ")+"|%' or a.reg_id = '"+auth.getString("_USER_ID")+"' ) ");
	}
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("20")){
		list.addWhere("( a.agree_field_seqs like '%|"+auth.getString("_FIELD_SEQ")+"|%' or a.field_seq in ( select field_seq from tcb_field start with member_no = '"+_member_no+"' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq ) )");
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

	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
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
	p.setVar("title", "신청서 현황");
	String xlsFile = "subscription_list_excel.html";

	ds.first();
	while(ds.next()){
		ds.put("cont_total", u.numberFormat(ds.getDouble("cont_total"), 0));
		ds.put("status_name", ds.getString("status_name").replaceAll("<br>", ""));
		
	}


	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("신청서 현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/"+xlsFile));
	return;
}


DataObject templateDao = new DataObject();
DataSet template = templateDao.query("select template_name, template_cd from tcb_cont_template where template_cd in (select template_cd from tcb_contmaster where member_no = '"+_member_no+"' and status in ('00','30','41','50') group by template_cd) and doc_type='3'  order by display_seq asc, template_cd desc");



p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.subscription_list");
p.setVar("menu_cd",_menu_cd);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setLoop("template", template);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>