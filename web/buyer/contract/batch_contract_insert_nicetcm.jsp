<%@page import="org.jsoup.Jsoup
				,org.jsoup.nodes.Document
				,org.jsoup.nodes.Element"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
DataObject doTM = new DataObject("tcb_member");
DataSet dsTM = doTM.find("member_no = '"+_member_no+"'");
if(!dsTM.next()){
	u.jsError("�ۼ� ��ü������ �����ϴ�.");
	return;
}else
{
	dsTM.put("vendcd2",u.getBizNo(dsTM.getString("vendcd")));
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.batch_contract_insert_nicetcm");
p.setVar("menu_cd","000199");  
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000199", "btn_auth").equals("10"));  
p.setVar(dsTM);
p.setVar("form_script", f.getScript());
p.display(out); 

 
%>