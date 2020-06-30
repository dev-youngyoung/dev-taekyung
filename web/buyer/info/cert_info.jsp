<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
DataObject mdao = new DataObject("tcb_member tm inner join tcb_person tp on tm.member_no=tp.member_no");
//mdao.setDebug(out);
DataSet member = mdao.find("tm.member_no = '"+_member_no+"' and tp.default_yn='Y'", "tm.member_gubun, tm.cert_end_date, tp.jumin_no, tm.vendcd");
if(!member.next()){
	u.jsError("회원정보가 없습니다.");
	return;
}else{
	if(member.getString("member_gubun").equals("04")) //개인회원
	{
		Security	security	=	new	Security();
		member.put("jumin_no", security.AESdecrypt(member.getString("jumin_no")).substring(0, 6));
	} 
	
	member.put("cert_end_date", u.getTimeString("yyyy-MM-dd",member.getString("cert_end_date")));
}

DataObject clientDao = new DataObject("tcb_client");
//ktm&s 개인사업자인 경우
if(clientDao.findCount(" client_no = '"+_member_no+"' and member_no = '20140900004' ")>0&&auth.getString("_MEMBER_GUBUN").equals("03")){
	u.jsError("※인증서안내\\n\\nktm&s와 거래하시는 개인사업자이신 경우\\n\\n인증서 등록없이 대표자분의 개인범용 공인 인증서로\\n\\n계약서에 서명 하셔야 합니다.\\n\\n개인범용 인증서는 대표자분이 개인으로\\n\\n거래하시는 은행 공인인증센터에서 발급 가능합니다.\\n\\n(개인범용공인인증서 발급비용 :4,400원-부가세포함)");
	return;
}else if(clientDao.findCount(" client_no = '"+_member_no+"' and member_no = '20130400333' ")>0&&auth.getString("_MEMBER_GUBUN").equals("03")){
	u.jsAlert("※인증서안내\\n\\n씨제이대한통운과 거래하시는 개인사업자이신 경우\\n계약건에 따라 사용가능 인증서가 다릅니다.\\n아래 내용을 꼭 참고 하세요.\\n\\n*수송부 관련계약 : 대표자의 개인범용공인인증서( 인증서등록 불필요 / 발급비용 :4,400원-부가세포함)\\n*구매팀/인프라 팀관련계약 : 사업자용인증서(인증서등록 필요)");
// 아가방의 납품계약서의 경우 '사업자'인증서로 ('우준식'과장님과 통화 후 수정함. (우준식 과장님도 잘 모르심.. ㅠㅠ;; ))
//}else if(clientDao.findCount(" client_no = '"+_member_no+"' and member_no = '20151101164' ")>0&&auth.getString("_MEMBER_GUBUN").equals("03")){
//	u.jsError("※인증서안내\\n\\n(주)아가방앤컴퍼니와 거래하시는 개인사업자이신 경우\\n\\n인증서 등록없이 대표자분의 개인범용 공인 인증서로\\n\\n계약서에 서명 하셔야 합니다.\\n\\n개인범용 인증서는 대표자분이 개인으로\\n\\n거래하시는 은행 공인인증센터에서 발급 가능합니다.\\n\\n(개인범용공인인증서 발급비용 :4,400원-부가세포함)");
}else if(clientDao.findCount(" client_no = '"+_member_no+"' and member_no = '20171100251' ")>0&&auth.getString("_MEMBER_GUBUN").equals("03")){
	u.jsError("※인증서안내\\n\\n제시카블랑과 거래하시는 개인사업자이신 경우\\n\\n인증서 등록없이 대표자분의 개인범용 공인 인증서로\\n\\n계약서에 서명 하셔야 합니다.\\n\\n개인범용 인증서는 대표자분이 개인으로\\n\\n거래하시는 은행 공인인증센터에서 발급 가능합니다.\\n\\n(개인범용공인인증서 발급비용 :4,400원-부가세포함)");
	return;
}else if(clientDao.findCount(" client_no = '"+_member_no+"' and member_no = '20191101572' ")>0&&auth.getString("_MEMBER_GUBUN").equals("03")){
	u.jsError("※인증서안내\\n\\n대원강업(주)과 거래하시는 개인사업자이신 경우\\n\\n인증서 등록없이 대표자분의 개인범용 공인 인증서로\\n\\n계약서에 서명 하셔야 합니다.\\n\\n개인범용 인증서는 대표자분이 개인으로\\n\\n거래하시는 은행 공인인증센터에서 발급 가능합니다.\\n\\n(개인범용공인인증서 발급비용 :4,400원-부가세포함)");
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("info.cert_info");
p.setVar("menu_cd","000109");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000108", "btn_auth").equals("10"));
p.setVar("member",member);
p.setVar("person_yn", member.getString("member_gubun").equals("04"));
p.setVar("sys_date", u.getTimeString());
p.setVar("form_script", f.getScript());
p.display(out);
%>