<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
if(cont_no.equals("")&&cont_chasu.equals("")){
	u.jsErrClose("정상적인 경로로 접근하세요.");
	return;
}

DataObject contLogDao = new DataObject("tcb_cont_log");
//contLogDao.setDebug(out);
DataSet contLog = contLogDao.query(
	   " select a.*, b.member_name, c.user_name            "
	  +"   from tcb_cont_log a, tcb_member b, tcb_person c "
	  +"  where a.member_no = b.member_no                  "
	  +"    and a.member_no = c.member_no                  "
	  +"    and a.person_seq = c.person_seq                "
	  +"    and a.status > '0'                             "
	  +"    and a.cont_no = '"+cont_no+"'                  "
	  +"    and a.cont_chasu = '"+cont_chasu+"'            "
	  +"  order by log_seq asc                             "
		);
while(contLog.next()){
	contLog.put("log_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", contLog.getString("log_date")));
	contLog.put("member_gubun", contLog.getString("member_no").equals(_member_no)?"가맹본부":"점주");
}

if(u.isPost()&&f.validate()){
	
}


p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_cont_log");
p.setVar("popup_title","진행이력조회");
p.setLoop("contLog", contLog);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>