<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

//에스케이스토아주식회사 청구서

DataObject doTM = new DataObject("tcb_member");
DataSet dsTM = doTM.find("member_no = '"+_member_no+"'");
if(!dsTM.next()){
	u.jsError("작성 업체정보가 없습니다.");
	return;
}else
{
	dsTM.put("vendcd2",u.getBizNo(dsTM.getString("vendcd")));
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.batch_contract_insert");
p.setVar("menu_cd","000054");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000054", "btn_auth").equals("10"));
p.setVar(dsTM);
p.setVar("form_script", f.getScript());
p.display(out);
%>