<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%

f.addElement("s_auth_name",u.request("s_auth_name"), null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcc_auth a");
list.setFields(
		 " a.* "
		+ ", (select admin_name from tcc_admin where admin_id = a.mod_id) mod_name"
		+ ", (select count(*) from tcc_admin where auth_cd = a.auth_cd and a.status > 0 ) user_cnt"
		);
//list.addWhere("member_no = '" + auth.getString("_ADMIN_ID") + "' ");
list.addWhere(" status = '10'");
list.addSearch("auth_nm", f.get("s_auth_name"), "LIKE");
list.setOrderBy(" auth_cd desc ");  

//목록 데이타 수정
DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("mod_date",u.getTimeString("yyyy-MM-dd",ds.getString("mod_date")));  //수정일자
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("mgr.auth_list");
p.setVar("menu_cd","000071");
//p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000139", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>
