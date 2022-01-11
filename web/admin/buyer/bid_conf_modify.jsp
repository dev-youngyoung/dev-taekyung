<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_bid_kind_cd =  codeDao.getCodeArray("M021");//입찰유형
String[] code_bid_method =  codeDao.getCodeArray("M023");//경쟁방법
String[] code_succ_method =  codeDao.getCodeArray("M024");//낙찰자선정방법
String[] code_item_form_cd =  codeDao.getCodeArray("M026");//내역양식

boolean isUpdate = false;

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' and member_type in ('01','03')");
if(!member.next()){
	u.jsError("업체 정보가 없습니다.");
	return;
}



String bid_kind_cd = "";
String bid_method = "";
String public_bid_yn = "";
String default_bid_method = "";
String succ_method = "";
String default_succ_method = "";
String item_form_cd = "";
String vat_yn = "";
String nego_yn = "";
String project_yn = "";


String multi_amt_open_yn = "";
String multi_select_cnt = "";
String multi_amt_srate = "";
String multi_amt_scnt = "";
String multi_amt_erate = "";
String multi_amt_ecnt = "";

String ext_limit = "";
String succ_pay_yn = "";


String exp_url = "";

DataObject bidConfDao = new DataObject("tcb_bid_conf");
DataSet info = bidConfDao.find(" member_no = '"+member_no+"' and conf_gubun = 'bid'");
if(info.next()){
	isUpdate = true;
	String[] arr = info.getString("conf_text").split("\\|");
	bid_kind_cd = u.getItem("bid_kind_cd", arr);
	bid_method = u.getItem("bid_method", arr);
	public_bid_yn = u.getItem("public_bid_yn", arr);
	default_bid_method = u.getItem("default_bid_method", arr);
	succ_method = u.getItem("succ_method", arr);
	default_succ_method = u.getItem("default_succ_method", arr);
	item_form_cd = u.getItem("item_form_cd", arr);
	vat_yn = u.getItem("vat_yn", arr);
	nego_yn = u.getItem("nego_yn", arr);
	project_yn = u.getItem("project_yn", arr);
	
	
	multi_amt_open_yn = u.getItem("multi_amt_open_yn", arr);
	multi_select_cnt = u.getItem("multi_select_cnt", arr);
	multi_amt_srate = u.getItem("multi_amt_srate", arr);
	multi_amt_scnt = u.getItem("multi_amt_scnt", arr);
	multi_amt_erate = u.getItem("multi_amt_erate", arr);
	multi_amt_ecnt = u.getItem("multi_amt_ecnt", arr);
	ext_limit = u.getItem("ext_limit", arr);
	succ_pay_yn = u.getItem("succ_pay_yn", arr);
	
	exp_url = u.getItem("exp_url", arr);
}


f.addElement("bid_kind_cd", bid_kind_cd, "hname:'입찰유형', required:'Y'");
f.addElement("bid_method", bid_method, "hname:'입찰방법', required:'Y'");
f.addElement("public_bid_yn", public_bid_yn, "hname:'전체공개여부'");
f.addElement("default_bid_method", default_bid_method, "hname:'입찰방법 기본값'");
f.addElement("succ_method", succ_method, "hname:'낙찰방법', required:'Y'");
f.addElement("default_succ_method", default_succ_method, "hname:'낙찰방법 기본값'");
f.addElement("item_form_cd", item_form_cd, "hname:'견적내역depth', required:'Y'");
f.addElement("vat_yn", vat_yn, "hname:'VAT포함여부', required:'Y'");
f.addElement("nego_yn", nego_yn, "hname:'견적수정사용여부', required:'Y'");
f.addElement("project_yn", project_yn, "hname:'프로젝트관리사용여부', required:'Y'");
f.addElement("multi_amt_open_yn", multi_amt_open_yn, "hname:'추첨번호 공개여부'");
f.addElement("multi_select_cnt", multi_select_cnt, "hname:'추첨번호갯수'");
f.addElement("multi_amt_srate", multi_amt_srate, "hname:'예비가격구간'");
f.addElement("multi_amt_scnt", multi_amt_scnt, "hname:'예비가격구간갯수'");
f.addElement("multi_amt_erate", multi_amt_erate, "hname:'예비가격구간'");
f.addElement("multi_amt_ecnt", multi_amt_ecnt, "hname:'예비가격구간갯수'");
f.addElement("ext_limit", ext_limit, "hname:'역경매 연장횟수'");
f.addElement("succ_pay_yn", succ_pay_yn, "hname:'낙찰수수료 과금여부'");
f.addElement("exp_url", null, "hname:'예외처리url'");


// 입력수정
if(u.isPost() && f.validate()){
	if(f.get("conf_text").equals("")){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	
	
	String conf_text = new String(Base64Coder.decode(f.get("conf_text")),"UTF-8");
	bidConfDao = new DataObject("tcb_bid_conf");
	//templateDao.setDebug(out);
	if(isUpdate){
		bidConfDao.item("conf_text", conf_text);
		if(!bidConfDao.update(" member_no = '"+member_no+"' and conf_gubun = 'bid' ")){
			u.jsError("처리에 실패 하였습니다.");
			return;
		}
	}else{
		bidConfDao.item("member_no", member_no);
		bidConfDao.item("conf_gubun","bid");
		bidConfDao.item("conf_text", conf_text);
		bidConfDao.item("status", "1");
		if(!bidConfDao.insert()){
			u.jsError("처리에 실패 하였습니다.");
			return;
		}
		
	}
	u.jsAlertReplace("저장 처리 하였습니다.", "bid_conf_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.bid_conf_modify");
p.setVar("member", member);
p.setVar("menu_cd", "000045");
p.setLoop("code_bid_kind_cd", u.arr2loop(code_bid_kind_cd));
p.setLoop("code_bid_method", u.arr2loop(code_bid_method));
p.setLoop("code_succ_method", u.arr2loop(code_succ_method));
p.setLoop("code_item_form_cd", u.arr2loop(code_item_form_cd));
p.setVar("exp_url", exp_url);
p.setVar("list_query", u.getQueryString("member_no"));
p.setVar("query",u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>