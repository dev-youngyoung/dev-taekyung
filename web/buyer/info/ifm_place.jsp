<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String person_seq = u.request("person_seq");
if(person_seq.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

f.addElement("idx",null, null);

if(u.isPost()&&!f.get("fields").equals("")){
	String fields = f.get("fields");
	if(fields.equals("")){
		u.jsError("저장할 내용이 없습니다.");
		return;
	}
	DB db = new DB();
	String[] arr = fields.split(",");
	DataObject personFieldDao = null;
	for(int i =0 ; i < arr.length; i++){
		personFieldDao = new DataObject("tcb_fieldperson");
		personFieldDao.item("member_no", _member_no);
		personFieldDao.item("person_seq", person_seq);
		personFieldDao.item("field_seq", arr[i]);
		db.setCommand(personFieldDao.getInsertQuery(), personFieldDao.record);
	}
	if(!db.executeArray()){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	u.redirect("ifm_place.jsp?"+u.getQueryString());
}

String user_name =
 new DataObject("tcb_person")
 .getOne("select user_name from tcb_person where member_no = '"+_member_no+"' and person_seq = '"+person_seq+"'");

DataObject dao = new DataObject("tcb_field");
DataSet ds = dao.query(
	" SELECT B.FIELD_SEQ,B.FIELD_NAME, B.USE_YN 	" 
   +"    FROM TCB_FIELDPERSON A 		"
   +"  INNER JOIN TCB_FIELD B			"
   +"     ON B.MEMBER_NO = A.MEMBER_NO	"
   +"     AND B.FIELD_SEQ = A.FIELD_SEQ	"
   +"    AND B.STATUS > 0 				"
   +"  WHERE A.MEMBER_NO = '"+_member_no+"'		"
   +"    AND A.PERSON_SEQ = '"+person_seq+"'	"
);

while(ds.next()){
	ds.put("use_yn", ds.getString("use_yn").equals("Y")?"사용중":"미사용");
}

p.setLayout("blank");
//p.setDebug(out);
p.setBody("info.ifm_place");
p.setLoop("list", ds);
p.setVar("user_name", user_name);
p.setVar("form_script", f.getScript());
p.setVar("query",u.getQueryString());
p.display(out);	
%>