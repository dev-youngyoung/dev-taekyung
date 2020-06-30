<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%
DataObject personDao = new DataObject("tcb_person");
//personDao.setDebug(out);


String sQuery =  " select b.field_name "
				+"      , a.person_seq "
				+"      , a.user_name "
				+"  from tcb_person a, tcb_field b  "
				+" where a.member_no = b.member_no  "
				+"   and a.field_seq = b.field_seq  "
				+"   and a.member_no = '"+_member_no+"'"
				+"   and a.status=1"
				+"   and nvl(default_yn,'N') <> 'Y' ";

if(!auth.getString("_DEFAULT_YN").equals("Y")){	// 관리자가 아니면 자기것만.
	sQuery += "   and a.person_seq = " + auth.getString("_PERSON_SEQ");
}
sQuery += "  order by b.field_seq";

DataSet person = personDao.query(sQuery);

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_person_select");
p.setVar("popup_title","담당자 검색");
p.setLoop("person", person);
p.setVar("form_script",f.getScript());
p.display(out);

%>