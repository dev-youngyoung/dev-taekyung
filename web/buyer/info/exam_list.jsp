<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_exam_type = {"10=>정기평가","20=>수시평가"};
boolean isCJ = _member_no.equals("20130400333");  // 씨제이대한통운

f.addElement("s_exam_name",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(15);
list.setTable("tcb_exam");
list.setFields("*");
list.addWhere(" member_no = '"+_member_no+"'");
list.addSearch("exam_name", f.get("s_exam_name"), "LIKE");
list.setOrderBy("exam_cd desc");


DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("exam_type", u.getItem(ds.getString("exam_type"), code_exam_type));
	ds.put("reg_date", u.getTimeString("yyyy-MM-dd", ds.getString("reg_date")));
}

p.setLayout("default");
p.setDebug(out);
p.setBody("info.exam_list");
p.setVar("menu_cd","000113");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000113", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("exam_cd"));
p.setVar("form_script",f.getScript());
p.setVar("isCJ", isCJ);
p.display(out);
%>