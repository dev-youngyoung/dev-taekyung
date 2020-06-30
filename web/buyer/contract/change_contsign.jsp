<%@page import="com.sun.mail.imap.Utility.Condition"%>
<%@page import="org.jsoup.Jsoup"%>
<%@page import="org.jsoup.nodes.Element"%>
<%@page import="org.jsoup.nodes.Document"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");

DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'  and member_no != '"+_member_no+"'");

DataObject chkMemberDao = new DataObject("tcb_member");
DataSet chkMember = chkMemberDao.find(" member_no = '"+cust.getString("member_no")+"' ");

if(cust.next()){
}

if(chkMember.next()){
	
	if(!"04".equals(chkMember.getString("member_gubun"))){
		u.jsErrClose("개인회원만 서명타입 변경이 가능합니다.");
		return;
	}
	
	u.redirect("pop_change_contsign.jsp?"+u.getQueryString());
	return ;
	
}else{

	if(!"".equals(cust.getString("vendcd")) ){
		u.jsErrClose("개인회원만 서명타입 변경이 가능합니다.");
		return;
	}

	String jumin = cust.getString("boss_birth_date").substring(2,8);
	jumin =   " jumin_no in ('"+u.aseEnc(jumin+"1")+"','"+u.aseEnc(jumin+"2")+"','"+u.aseEnc(jumin+"3")+"','"+u.aseEnc(jumin+"4")+"')";
	
	//목록 생성
	ListManager list = new ListManager();
	list.setRequest(request);
	//list.setDebug(out);
	list.setListNum(3);
	list.setTable("tcb_member a,  tcb_person b ");
	list.setFields(" a.member_no, b.user_name, b.hp1, b.hp2, b.hp3, b.email, b.jumin_no   ");
	list.addWhere(" a.member_no = b.member_no and a.member_gubun = '04' and b.default_yn = 'Y' and b.hp1 = '"+cust.getString("hp1")+"' and b.hp2 = '"+cust.getString("hp2")+"' and b.hp3 = '"+cust.getString("hp3")+"' ");
	list.addWhere(" b.user_name = '"+cust.getString("user_name")+"' and  " + jumin); 
	
	DataSet ds = list.getDataSet();
	
	while(ds.next()){
		String birth_date = u.aseDec(ds.getString("jumin_no")).substring(0,6);
		ds.put("birth_date", birth_date.substring(0,2)+"-"+birth_date.substring(2,4)+"-"+birth_date.substring(4,6));
	}
	
	
	if(u.isPost()){
		DB db = new DB();
		String member_no = f.get("member_no");
		String where =  "cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' " ;
		custDao.item("member_no", member_no);
		db.setCommand("delete from tcb_cont_email where "+ where, null);
		db.setCommand(custDao.getUpdateQuery(where+ " and member_no != '"+_member_no+"' "),custDao.record);
		
		if(!db.executeArray()){
			u.jsErrClose("계약서 서명 전환에 실패하였습니다.");
			return;
		}
		
		u.redirect("pop_change_contsign.jsp?"+u.getQueryString());
		return;
		
	}



	p.setLayout("popup");
	p.setDebug(out);
	p.setBody("contract.pop_change_contsign");
	p.setVar("popup_title","서명타입 전환(공인인증서)대상 회원");
	p.setLoop("list", ds);
	p.setVar("pagerbar", list.getPaging());
	p.setVar("query", u.getQueryString());
	p.setVar("list_query", u.getQueryString(""));
	p.setVar("form_script",f.getScript());
	p.display(out);
}



%>


<%!

public String removeSign(String html){
	String cont_html_rm = "";
	Document cont_doc = Jsoup.parse(html);
	cont_doc.select(".sign_area").attr("style", "display:none");
	cont_html_rm = cont_doc.getElementsByTag("body").html().toString();
	String style = cont_doc.getElementsByTag("style").html();
	String script = cont_doc.getElementsByTag("script").html();
	if(!style.equals(""))cont_html_rm = "<style>"+style+"</style>\n"+cont_html_rm;
	if(!script.equals(""))cont_html_rm = "<script>"+script+"</script>\n"+cont_html_rm;
	return cont_html_rm;
}

//input box 등을 제거
public String removeHtml(String html)
{
	String cont_html_rm = "";

	// DB용
	Document cont_doc = Jsoup.parse(html);

	// PDF용
	for( Element elem : cont_doc.select("input[type=text]") ){ elem.parent().text(elem.val()); }  // input box 값 모두 제거
	for( Element elem : cont_doc.select("select") ){ elem.parent().text(elem.select("option[selected]").val()); }
	cont_doc.select(".no_pdf").attr("style", "display:none"); // pdf 버전에 보여야 안되는것
	
	cont_html_rm = cont_doc.getElementsByTag("body").html().toString();
	String style = cont_doc.getElementsByTag("style").html();
	String script = cont_doc.getElementsByTag("script").html();
	if(!style.equals(""))cont_html_rm = "<style>"+style+"</style>\n"+cont_html_rm;
	if(!script.equals(""))cont_html_rm = "<script>"+script+"</script>\n"+cont_html_rm;
	
	return cont_html_rm;
}

%>
