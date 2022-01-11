<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
if(!u.inArray(auth.getString("_MEMBER_TYPE"), new String[]{"01","03"}) ){//갑사가 아니면 을사 관리 목록으로
	u.redirect("./client_person_list.jsp");
	return;
}

String _menu_cd = "000120";

CodeDao code = new CodeDao("tcb_comcode");
String[] code_user_level = code.getCodeArray("M013", "and code >= '"+auth.getString("_USER_LEVEL")+"' ");
 

DataObject authDao = new DataObject("tcb_auth");
DataSet authInfo = authDao.find("member_no = '"+_member_no+"' ","*","auth_cd asc");

 
f.addElement("s_user_level", null,null);
f.addElement("s_use_yn", null,null);
f.addElement("s_auth_cd", null,null);
f.addElement("s_field_name", null,null);
f.addElement("s_user_name",null,null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:15);
list.setTable("tcb_person a");
list.setFields(
		  "a.* "
		+ " ,(select field_name from tcb_field where member_no = a.member_no and field_seq= a.field_seq) field_name "
		+ " ,(select auth_nm from tcb_auth where member_no = a.member_no and auth_cd= a.auth_cd) auth_nm "
		);
list.addWhere(" a.member_no = '"+_member_no+"'");
list.addWhere(" a.status > 0 ");
list.addWhere(" (a.user_level >= '"+auth.getString("_USER_LEVEL")+"' or a.user_level is null)");
list.addSearch(" a.user_level", f.get("s_user_level"));
list.addSearch(" a.use_yn", f.get("s_use_yn"));
list.addSearch(" a.auth_cd", f.get("s_auth_cd"));
list.addSearch("a.user_name", f.get("s_user_name"), "LIKE");
if(!f.get("s_field_name").equals("")){
	list.addWhere(" a.field_seq in (select field_seq from tcb_field where member_no = '"+_member_no+"' and field_name like '%"+f.get("s_field_name")+"%' )");
}
/*조회권한*/
if(!auth.getString("_DEFAULT_YN").equals("Y")){
	//20:부서조회   40:모든부서
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("20")){
		list.addWhere(" ( a.field_seq = '"+auth.getString("_FIELD_SEQ")+"' or a.field_seq in (select field_seq from tcb_auth_field where member_no = '"+_member_no+"' and menu_cd = '"+_menu_cd+"'  and auth_cd = '"+auth.getString("_AUTH_CD")+"' ) )");
	} 
}

  
list.setOrderBy("a.field_seq asc, a.user_level asc, a.auth_cd asc ,a.person_seq desc ");

DataSet ds = list.getDataSet();
while(ds.next()){
	ds.put("user_level", u.getItem(ds.getString("user_level"), code_user_level));
	ds.put("reg_date", u.getTimeString("yyyy-MM-dd", ds.getString("reg_date")));
	ds.put("passdate", u.getTimeString("yyyy-MM-dd", ds.getString("passdate")));
	ds.put("person_seq", u.aseEnc(ds.getString("person_seq")) ); 
	ds.put("use_yn", ds.getString("use_yn").equals("Y")?"사용":"<font color='red'>사용중지</font>");
}


if(u.request("mode").equals("excel")){

	String fileName = "담당자 현황.xls";
	p.setLoop("list", ds);
	p.setVar("isCJ", _member_no.equals("20130400333"));
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(fileName.getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/info/person_list_excel.html"));
	return;
}


p.setLayout("default");
p.setDebug(out);
p.setBody("info.person_list");
p.setVar("menu_cd",_menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("code_user_level", u.arr2loop(code_user_level));
p.setLoop("authInfo", authInfo);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("form_script", f.getScript());
p.setVar("list_query", u.getQueryString("person_seq"));
p.display(out);
%>