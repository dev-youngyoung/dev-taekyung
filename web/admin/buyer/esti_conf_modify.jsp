<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

CodeDao codeDao = new CodeDao("tcb_comcode");

boolean isUpdate = false;

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' and member_type in ('01','03')");
if(!member.next()){
	u.jsError("업체 정보가 없습니다.");
	return;
}



String vat_yn = "";
String nego_yn = "";
String succ_pay_yn = "";

DataObject bidConfDao = new DataObject("tcb_bid_conf");
DataSet info = bidConfDao.find(" member_no = '"+member_no+"' and conf_gubun = 'esti'");
if(info.next()){
	isUpdate = true;
	String[] arr = info.getString("conf_text").split("\\|");
	vat_yn = u.getItem("vat_yn", arr);
	nego_yn = u.getItem("nego_yn", arr);
	succ_pay_yn = u.getItem("succ_pay_yn", arr);
}



f.addElement("vat_yn", vat_yn, "hname:'VAT포함여부', required:'Y'");
f.addElement("nego_yn", nego_yn, "hname:'견적수정사용여부', required:'Y'");
f.addElement("succ_pay_yn", succ_pay_yn, "hname:'낙찰수수료 과금여부'");

// 입력수정
if(u.isPost() && f.validate()){
	if(f.get("conf_text").equals("")){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	
	
	String conf_text = new String(new sun.misc.BASE64Decoder().decodeBuffer(f.get("conf_text")),"UTF-8");
	bidConfDao = new DataObject("tcb_bid_conf");
	if(isUpdate){
		bidConfDao.item("conf_text", conf_text);
		if(!bidConfDao.update(" member_no = '"+member_no+"' and conf_gubun = 'esti' ")){
			u.jsError("처리에 실패 하였습니다.");
			return;
		}
	}else{
		bidConfDao.item("member_no", member_no);
		bidConfDao.item("conf_gubun", "esti");
		bidConfDao.item("conf_text", conf_text);
		bidConfDao.item("status", "10");
		if(!bidConfDao.insert()){
			u.jsError("처리에 실패 하였습니다.");
			return;
		}
		
	}
	u.jsAlertReplace("저장 처리 하였습니다.", "esti_conf_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.esti_conf_modify");
p.setVar("member", member);
p.setVar("menu_cd", "000045");
p.setVar("list_query", u.getQueryString("member_no"));
p.setVar("query",u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>