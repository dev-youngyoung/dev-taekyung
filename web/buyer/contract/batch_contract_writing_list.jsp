<%@page import="org.jsoup.Jsoup
				,org.jsoup.nodes.Document
				,org.jsoup.nodes.Element"%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
DataObject doTM = new DataObject("tcb_member");
DataSet dsTM = doTM.find("member_no = '"+_member_no+"'");
if(!dsTM.next()){
	u.jsError("작성 업체정보가 없습니다.");
	return;
}else
{
	dsTM.put("vendcd2",u.getBizNo(dsTM.getString("vendcd")));
}

String sfield_seq = auth.getString("_FIELD_SEQ");
String sField = "";

//sfield_seq = "1252";	//인사팀
//sfield_seq = "3042";	//영업기획팀
//sfield_seq = "3111";	//영업지원팀

if (!auth.getString("_DEFAULT_YN").equals("Y")) {
//	sField = " and ( field_seq is null or '^'|| replace(replace(field_seq,' ',''),',','^')||'^' like '%^'||" + auth.getString("_FIELD_SEQ") + "||'^%' )";
	if(!"9999".equals(sfield_seq)){	//전산관리자(NDS)
		sField 	= " and template_cd in ("
					+ " select template_cd from tcb_cont_template_field"
					+ " where (field_seq = '0000' or field_seq = "
					+ sfield_seq
					+ ") and all_yn = 'Y')";
	}
}

/* 계약서종류 조회 */
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet ds = templateDao.find(
		  " status > 0 and template_type in ('00', '10') and member_no like '%" + _member_no + "%' and use_yn = 'Y' and (doc_type is null or doc_type = 2) " + sField
		, " template_cd, nvl(display_name,template_name) template_name "
		, " display_seq asc, template_cd desc");

f.addElement("template_cd", null, "hname:'계약서종류', required:'Y'");

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.batch_contract_writing_list");
p.setVar("menu_cd","000212");  
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000212", "btn_auth").equals("10"));  
p.setVar(dsTM);
p.setVar("form_script", f.getScript());
p.setLoop("template", ds);
p.display(out); 

 
%>