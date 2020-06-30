<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000075";

CodeDao code = new CodeDao("tcb_comcode");
String[] code_status = code.getCodeArray("M008", " and code in ('11','20','21','30','40','41')");

boolean bDetailCode = false;
String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu";
String sColumn = "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.agree_field_seqs, a.cont_date, a.status, a.cont_userno, b.member_no, b.member_name,"
				 +"(select agree_person_name from tcb_cont_agree where cont_no = a.cont_no and cont_chasu=a.cont_chasu and agree_seq = "
			     +"      (select min(agree_seq) from tcb_cont_agree where cont_no = a.cont_no and cont_chasu=a.cont_chasu and agree_cd=2 and r_agree_person_id is null) ) agree_name,"
				 +"( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt ";

f.addElement("s_template_cd", null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_cont_name",null, null);
f.addElement("s_user_no", null, null);
f.addElement("s_status", null, null);

String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM-dd",u.addDate("M",-1)));
String s_edate = u.request("s_edate",u.getTimeString("yyyy-MM-dd"));
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere("b.list_cust_yn = 'Y'");

list.addWhere(" a.member_no = '"+_member_no+"' ");
list.addWhere(" a.status in ('11','20','21','30','40','41')");

if(!s_sdate.equals("")) {
	list.addWhere(" a.cont_date >= '"+s_sdate.replaceAll("-","")+"'");
}
if(!s_edate.equals("")) {
	list.addWhere(" a.cont_date <= '"+s_edate.replaceAll("-","")+"'");
}
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.addSearch("a.cont_userno",  f.get("s_user_no"), "LIKE");
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
list.addSearch("a.status",  f.get("s_status"));
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
list.setOrderBy("a.cont_no desc");

DataSet ds = list.getDataSet();
DataObject contStepDao = new DataObject("tcb_cont_agree");
while(ds.next()){
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(ds.getInt("cust_cnt")-2>0){
		ds.put("cust_name", ds.getString("member_name")+ "외"+(ds.getInt("cust_cnt")-2)+"개사");
	}else{
		ds.put("cust_name", ds.getString("member_name"));
	}

	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	if(ds.getString("status").equals("30")){//서명대기 상태이면 생상 표시
		ds.put("status_name", "<span class=\"caution-text\">"+u.getItem(ds.getString("status"), code_status)+"<span>");
	}else if(ds.getString("status").equals("21")) {  // 승인대기
		ds.put("status_name", "<span class=\"caution-text\">"+u.getItem(ds.getString("status"), code_status)+"<br>("+ds.getString("agree_name")+")</span>");
	}else if(ds.getString("status").equals("40")){//수정요청 상태이면 생상 표시
		ds.put("status_name", "<span style='color:blue'>"+u.getItem(ds.getString("status"), code_status)+"<span>");
	}else{
		ds.put("status_name", u.getItem(ds.getString("status"), code_status));
	}
	
	DataSet subLoop = new DataSet();
	DataSet contStep = contStepDao.query(
			  " select * "
			+ "from tcb_cont_agree "
			+ "where cont_no like '"+u.aseDec(ds.getString("cont_no"))+"' || '%' and cont_chasu = '0'"
			+ "and agree_cd <> '0'"
			+ "order by agree_seq");
	
	while(contStep.next()){
		contStep.put("agree_name", contStep.getString("agree_name").replaceAll("<br>",""));
	}
	
	ds.put(".subLoop", contStep);
}

DataObject templateDao = new DataObject();
DataSet template = templateDao.query("select template_name, template_cd from tcb_cont_template where template_cd in (select template_cd from tcb_contmaster where member_no = '"+_member_no+"' and status in ('11','20','21','30','40','41') group by template_cd) order by display_seq asc, template_cd desc");

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_charge_list");
p.setVar("menu_cd", _menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setLoop("template", template);
p.setVar("isDefaultYn", auth.getString("_DEFAULT_YN").equals("Y"));
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString("agree_info"));
p.setVar("list_query", u.getQueryString("agree_info"));
p.setVar("form_script", f.getScript());
p.display(out);
%>