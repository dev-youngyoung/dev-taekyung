<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
CodeDao codeDao = new CodeDao("tcb_comcode");

f.addElement("cont_no", null, "hname:'계약번호', required:'Y'");
f.addElement("cont_chasu", null, "hname:'계약차수', required:'Y'");
f.addElement("cont_name", null, "hname:'계약명', required:'Y'");
f.addElement("member_no", null, "hname:'결제업체회원번호', required:'Y'");
f.addElement("member_name", null, "hname:'결제업체', required:'Y'");
f.addElement("pay_type", null, "hname:'결제형태', required:'Y'");
f.addElement("member_name", null, "hname:'결제업체명', required:'Y'");
f.addElement("pay_number", null, "hname:'주문번호', required:'Y', minbyte:'20'");
f.addElement("tid", null, "hname:'TID', required:'Y', minbyte:'30'");
f.addElement("pay_amount", null, "hname:'결제금액', required:'Y'");
f.addElement("accept_date", u.getTimeString("yyyy-MM-dd"), "hname:'결제일자', required:'Y'");
f.addElement("accept_hh", "00", "hname:'결제시간', required:'Y'");
f.addElement("accept_mm", "00", "hname:'결제시간', required:'Y'");
f.addElement("accept_ss", "00", "hname:'결제시간', required:'Y'");


if(u.isPost()&&f.validate()){

	// 011
	String pay_type = f.get("pay_type").substring(0,2);
	String receit_type = f.get("pay_type").substring(2,3);
	String accept_date = f.get("accept_date").replaceAll("-", "")+f.get("accept_hh")+f.get("accept_mm")+f.get("accept_ss");

	DB db = new DB();
	DataObject pay = new DataObject("tcb_pay");

	pay.item("cont_no", f.get("cont_no"));
	pay.item("cont_chasu", f.get("cont_chasu"));
	pay.item("member_no", f.get("member_no"));
	pay.item("cont_name", f.get("cont_name"));
	pay.item("pay_amount", f.get("pay_amount").replaceAll(",", ""));
	pay.item("pay_type", pay_type);
	pay.item("accept_date", accept_date);
	pay.item("pay_number", f.get("pay_number"));
	pay.item("tid", f.get("tod"));
	pay.item("receit_type", receit_type);
	pay.item("etc",f.get("etc"));
	db.setCommand(pay.getInsertQuery(), pay.record);

	DataObject cust = new DataObject("tcb_cust");
	cust.item("pay_yn", "Y");
	db.setCommand(cust.getUpdateQuery("cont_no= '"+f.get("cont_no")+"' and cont_chasu = '"+f.get("cont_chasu")+"' and member_no = '"+f.get("member_no")+"'  "), cust.record);

	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}

	out.println("<script>");
	out.println("alert('저장하였습니다.');");
	out.println("opener.location.reload();");
	out.println("self.close();");
	out.println("</script>");
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("buyer.pop_pay_insert");
p.setVar("popup_title","결제내역 수동입력");
p.setVar("sysdate", u.getTimeString());
p.setVar("form_script",f.getScript());
p.display(out);
%>