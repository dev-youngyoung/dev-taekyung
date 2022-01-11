<%@ page import="java.net.URLDecoder" %>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String member_name = URLDecoder.decode(u.request("member_name"), "UTF-8");
String birth_date = u.request("birth_date");
String hp = u.request("hp");
String email_random = u.request("email_random");
String random_string = u.request("random_string");
String random_chk = u.request("random_chk");

DataObject custDao = new DataObject("tcb_contmaster");
DataSet cust = custDao.query(
		" select a.cont_no, a.cont_chasu, b.boss_birth_date"
		+"  from tcb_contmaster a, tcb_cust b "
        + "where a.cont_no=b.cont_no "
        + "  and a.cont_chasu=b.cont_chasu "
        + "  and b.email_random='"+email_random+"' "
        // 20200928 : B2C계약의 경우 계약당사자의 이름으로 비교하도록 수정
        // + "  and b.boss_name='"+member_name+"' "
        + "  and b.member_name='"+member_name+"' "
        + "  and b.hp1||b.hp2||b.hp3='"+hp+"' "
        + "  and a.cont_no='"+cont_no+"' and a.cont_chasu='"+cont_chasu+"' ");
if(!cust.next()){
	
} 

if(!birth_date.equals(cust.getString("boss_birth_date"))){
	out.print(false);
}
 
if("Y".equals(random_chk)){
	String sRandomString = (String) session.getAttribute("_sRandomString");
	if(sRandomString.equals("")) {
        out.print(false+"_01");
        return;
    } else if(!random_string.equals(sRandomString)) {
        out.print(false+"_02");
        return;
    }
	
}


%>
<%
    out.print(true);
%>