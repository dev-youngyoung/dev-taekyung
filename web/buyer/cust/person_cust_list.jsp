<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
DataObject personDao = new DataObject("tcb_person");
//personDao.setDebug(out);


String sQuery =  " select b.field_name              "
		+"      , a.*                       "
		+"  from tcb_person a, tcb_field b  "
		+" where a.member_no = b.member_no  "
		+"   and a.field_seq = b.field_seq  "
		+"   and a.member_no = '"+_member_no+"'"
		+"   and nvl(default_yn,'N') <> 'Y' ";

if(!auth.getString("_DEFAULT_YN").equals("Y")){	// �����ڰ� �ƴϸ� �ڱ�͸�.
	sQuery += "   and a.person_seq = " + auth.getString("_PERSON_SEQ");
}
sQuery += "  order by b.field_seq";

DataSet person = personDao.query(sQuery);
DataSet fperson = new DataSet();
if(person.next()){
	fperson.addRow(person.getRow());
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.person_cust_list");
p.setVar("menu_cd","000086");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000086", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("person", person);
p.setVar("fperson",fperson);  // ù
p.setVar("form_script", f.getScript());
p.setVar("list_query", u.getQueryString(""));
p.display(out);
%>