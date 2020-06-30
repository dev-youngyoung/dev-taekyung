<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
CodeDao codeDao = new CodeDao("tcb_comcode");

f.addElement("main_member_no", null, "hname:'����ȸ����ȣ', required:'Y'");
f.addElement("bid_no", null, "hname:'�����ȣ', required:'Y'");
f.addElement("bid_deg", null, "hname:'����', required:'Y'");
f.addElement("bid_name", null, "hname:'�����', required:'Y'");
f.addElement("member_no", null, "hname:'������üȸ����ȣ', required:'Y'");
f.addElement("member_name", null, "hname:'������ü', required:'Y'");
f.addElement("pay_type", null, "hname:'��������', required:'Y'");
f.addElement("member_name", null, "hname:'������ü��', required:'Y'");
f.addElement("tid", null, "hname:'TID', required:'Y', minbyte:'30'");
f.addElement("pay_amount", null, "hname:'�����ݾ�', required:'Y'");
f.addElement("accept_date", u.getTimeString("yyyy-MM-dd"), "hname:'��������', required:'Y'");
f.addElement("accept_hh", "00", "hname:'�����ð�', required:'Y'");
f.addElement("accept_mm", "00", "hname:'�����ð�', required:'Y'");
f.addElement("accept_ss", "00", "hname:'�����ð�', required:'Y'");


if(u.isPost()&&f.validate()){

	// 011
	String pay_type = f.get("pay_type").substring(0,2);
	String receit_type = f.get("pay_type").substring(2,3);
	String accept_date = f.get("accept_date").replaceAll("-", "")+f.get("accept_hh")+f.get("accept_mm")+f.get("accept_ss");

	DB db = new DB();
	DataObject pay = new DataObject("tcb_bid_pay");

	pay.item("main_member_no", f.get("main_member_no"));
	pay.item("bid_no", f.get("bid_no"));
	pay.item("bid_deg", f.get("bid_deg"));
	pay.item("member_no", f.get("member_no"));
	pay.item("bid_name", f.get("bid_name"));
	pay.item("pay_amount", f.get("pay_amount").replaceAll(",", ""));
	pay.item("pay_type", pay_type);
	pay.item("accept_date", accept_date);
	pay.item("etc",f.get("etc"));

	String nice_orderno		= f.get("bid_no");
	int iOrdernoLen = nice_orderno.length();
	RandomString rndStr = new RandomString();
	nice_orderno += rndStr.getString(20-iOrdernoLen, "a");
	pay.item("pay_number", nice_orderno);
	pay.item("tid", f.get("tod"));
	pay.item("receit_type", receit_type);
	db.setCommand(pay.getInsertQuery(), pay.record);

	DataObject supp = new DataObject("tcb_bid_supp");
	supp.item("pay_yn", "Y");
	db.setCommand(supp.getUpdateQuery("main_member_no='"+f.get("main_member_no")+"' and bid_no= '"+f.get("bid_no")+"' and bid_deg = '"+f.get("bid_deg")+"' and member_no = '"+f.get("member_no")+"'  "), supp.record);

	if(!db.executeArray()){
		u.jsError("���忡 ���� �Ͽ����ϴ�.");
		return;
	}

	out.println("<script>");
	out.println("alert('�����Ͽ����ϴ�.');");
	out.println("opener.location.reload();");
	out.println("self.close();");
	out.println("</script>");
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("buyer.pop_bid_pay_insert");
p.setVar("popup_title","�������� �����Է�");
p.setVar("sysdate", u.getTimeString());
p.setVar("form_script",f.getScript());
p.display(out);
%>