<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String sMemberNo = u.request("member_no");	//	회원번호
if(sMemberNo.equals("")){
	u.jsError("정상적인 경로 접근하세요.");
	return;	
}

DataObject doTM = new DataObject("tcb_member");
DataSet dsTM = doTM.find("	member_no = '"+sMemberNo+"'");
if(!dsTM.next()){
	u.jsError("업체정보가 없습니다.");
	return;
}else
{
	dsTM.put("vendcd2",u.getBizNo(dsTM.getString("vendcd")));
}

p.setLayout("popup");
p.setVar(dsTM);
//p.setDebug(out);
p.setBody("buyer.pop_src_insert");
p.setVar("popup_title","업체별 소싱관리");
p.setVar("form_script", f.getScript());
p.display(out);

%>