<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

DataObject dao = new DataObject("tcb_person");
DataSet ds = dao.find("status > 0 and member_no = '"+_member_no+"' and use_yn = 'Y' and user_gubun = '20' ");
if(!ds.next()){
}
String person_seq =ds.getString("person_seq"); 

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.person_place");
p.setLoop("list", ds);
p.setVar("person_seq",person_seq);
p.setVar("form_script", f.getScript());
p.display(out);	
%>