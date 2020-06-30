<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>  
<%
  
String auth_email = "";
String auth_hp = "";
DataObject auth_pdao = new DataObject("tcb_person"); 
DataSet auth_person = auth_pdao.find(" member_no = '"+auth.getString("_MEMBER_NO")+"' and user_id = '"+auth.getString("_USER_ID")+"' and status > 0 ");
if(auth_person.next()){ 
	auth_email =  auth_person.getString("email"); 
	auth_hp = auth_person.getString("hp1") + "-" + auth_person.getString("hp2") + "-" + auth_person.getString("hp3") ; 
} 
   
p.setLayout("blank");
p.setBody("layout.vouchar");
p.setVar("auth_hp", auth_hp);
p.setVar("auth_email", auth_email);
p.setLoop("auth_person", auth_person);
p.setVar("query", u.getQueryString());
p.display(out);
    
%>
