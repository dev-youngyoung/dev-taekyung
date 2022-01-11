<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%

String client_seq = u.request("client_seq");
String person_seq = u.request("person_seq");

if(client_seq.equals("") || person_seq.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

if(u.isPost()){
	// 담당자 업체 등록
	DataObject dao = new DataObject("tcb_client_detail");
	//dao.setDebug(out);

	dao.item("member_no", _member_no);
	dao.item("client_seq", client_seq);
	dao.item("person_seq", person_seq);
	if(!dao.insert()){
		u.jsError("처리중 오류가 발생 하였습니다. 고객 센터로 문의해 주세요.");
		return;
	}
}
u.redirect("ifm_person_cust.jsp?"+u.getQueryString("client_seq"));
return;
%>