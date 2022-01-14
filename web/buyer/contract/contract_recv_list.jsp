<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

CodeDao code = new CodeDao("tcb_comcode");
String[] code_status = {"20=>서명요청","21=>서명진행중","30=>서명진행중","40=>수정요청","41=>반려"};//상태코드와 다른게 서명 여부로 상태명변경

f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name", null, null);
f.addElement("s_status", null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(15);
list.setTable("tcb_contmaster a, tcb_cust b, tcb_member c");
list.setFields("a.cont_no , a.cont_chasu, a.template_cd, a.cont_name, a.cont_date, a.status, c.member_name as cust_name, b.sign_dn, a.sign_types ");
list.addWhere(" a.cont_no = b.cont_no  and a.cont_chasu = b.cont_chasu ");
list.addWhere(" a.member_no <> b.member_no ");
list.addWhere(" a.member_no = c.member_no ");
list.addWhere(" b.member_no = '"+_member_no+"'");
list.addWhere("	a.status in ('20','21','30','40','41') ");// 20:서명요청, 21:을사서명 후 갑검토대상, 30:을사 서명 완료 후 갑서명대상, 40:반려
list.addSearch(" c.member_name" ,f.get("s_cust_name"),"LIKE");
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
if(u.inArray(f.get("s_status"), new String[]{"20","21","30"})){
	list.addWhere(" a.status in ('20','21','30') ");
	if(f.get("s_status").equals("20")) list.addWhere(" b.sign_dn is null ");
	if(f.get("s_status").equals("21") || f.get("s_status").equals("30")) list.addWhere("  b.sign_dn is not null  ");
}else{
	list.addSearch("a.status",f.get("s_status"));
}
/* list.setOrderBy("cont_no desc"); */
list.setOrderBy("nvl(a.mod_req_date,a.reg_date) desc, a.cont_no desc, a.cont_chasu");

DataSet ds = list.getDataSet();
while(ds.next()){
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(ds.getInt("cont_chasu")>0)
		ds.put("cont_name", ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"차)");

	if(u.inArray(ds.getString("status"), new String[]{"20","21","30"})){
		if(ds.getString("sign_dn").equals("")){
			ds.put("status_name", "<span class='caution-text'>서명요청</span>");
		}else{
			ds.put("status_name", "서명진행중");
		}
	}else{
		ds.put("status_name", u.getItem(ds.getString("status"), code_status));
	}
	if(ds.getString("status").equals("41"))ds.put("status_name", "<span style='color:blue'>"+ds.getString("status_name")+"<span>");
	if(ds.getString("template_cd").equals("2019177")){
		if(auth.getString("_MEMBER_GUBUN").equals("04")){
			ds.put("link", ds.getString("template_cd").equals("")?"contract_free_recvview.jsp":"contract_msign_recvview.jsp");	
		}else{
			ds.put("link", ds.getString("template_cd").equals("")?"contract_free_recvview.jsp":"contract_recvview.jsp");
		}
	}else{
		ds.put("link", ds.getString("template_cd").equals("")?"contract_free_recvview.jsp":ds.getString("sign_types").equals("")?"contract_recvview.jsp":"contract_msign_recvview.jsp");
	}
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_recv_list");
p.setVar("menu_cd","000061");
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>