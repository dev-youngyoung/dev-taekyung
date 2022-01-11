<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

String personWhere = "";
String menuWhere = "";
if(auth.getString("_USER_LEVEL").equals("20")){
	personWhere = " and a.field_seq = '"+auth.getString("_FIELD_SEQ")+"' ";
	menuWhere = " and l_div_cd in (select substr(adm_cd,0,2) from tcb_person_auth where read_yn = 'Y' and member_no = '"+_member_no+"' and person_seq = '"+auth.getString("_PERSON_SEQ")+"')";
}

DataObject personDao = new DataObject("tcb_person");
//personDao.setDebug(out);
DataSet person = personDao.query(
	 " select b.field_name              "  
	+"      , a.*                       "
	+"  from tcb_person a, tcb_field b  "
	+" where a.member_no = b.member_no  "
	+"   and a.field_seq = b.field_seq  "
	+"   and a.member_no = '"+_member_no+"'"
	+"   and nvl(default_yn,'N') <> 'Y' "
	+"   and person_seq <> '"+auth.getString("_PERSON_SEQ")+"' "
	+"   and a.status > '0' "
	+ personWhere
	+"  order by b.field_seq            "
);
DataSet fperson = new DataSet();
if(person.next()){
	fperson.addRow(person.getRow());
}

DataObject menuDao = new DataObject("tcb_menu_info");
//menuDao.setDebug(out);
DataSet l_div = menuDao.query(
	 " select *                                        "
	+"   from tcb_menu_info                            "
	+"  where l_div_cd in (select substr(adm_cd,0,2)   "
	+"                        from tcb_member_menu     "
	+"                       where member_no = '"+_member_no+"')     "
	+"    and depth = '1'                              "
	+ menuWhere
	+"  order by seq                                   "
);


p.setLayout("default");
//p.setDebug(out);
p.setBody("info.person_menu_auth");
p.setVar("menu_cd","000121");
p.setLoop("person", person);
p.setLoop("l_div", l_div);
p.setVar("fperson",fperson);
p.setVar("form_script", f.getScript());
p.setVar("list_query", u.getQueryString(""));
p.display(out);
%>