<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_user_level = codeDao.getCodeArray("M013");

f.addElement("s_user_name", null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_person a");
list.setFields("a.*");
list.addWhere(" a.status > 0 ");
list.addWhere(" a.use_yn = 'Y' ");
list.addWhere( "a.member_no = '"+_member_no+"'");
list.addWhere( "(a.default_yn = 'Y' or auth_cd in (select auth_cd from tcb_auth_menu where menu_cd = '000159' and btn_auth = '20') )");
list.addSearch("a.user_name",f.get("s_user_name"),"LIKE");
list.setOrderBy("user_name asc ");

//목록 데이타 수정
DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("user_level_nm", u.getItem(ds.getString("user_level"), code_user_level));
}

p.setLayout("popup");
p.setBody("cust.pop_asse_charge");
p.setVar("popup_title","담당자검색");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("menu_cd",u.request("menu_cd"));
p.setVar("ele_person_seq",u.request("ele_person_seq"));
p.setVar("ele_user_id",u.request("ele_user_id"));
p.setVar("ele_user_name",u.request("ele_user_name"));
p.setVar("callback", u.request("callback"));
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.display(out);
%>