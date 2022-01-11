<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008");
String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd", u.addDate("M", -1)));

f.addElement("s_status", null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", null, null);
f.addElement("s_cont_name",null, null);
f.addElement("s_member_name",null, null);
f.addElement("s_client_name",null, null);


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(15);
list.setListNum(u.request("mode").equals("excel")?-1:15);
list.setTable("tcb_contmaster a , tcb_cust b, tcb_cust c, tcb_useinfo d, tcb_person e");
list.setFields(
		 "   a.cont_no "
		+" , a.cont_chasu "
		+" , a.cont_name "
		+" , a.reg_id "
		+" , a.cont_date "
		+" , (select field_name from tcb_field where member_no = a.member_no and field_seq = a.field_seq ) as field_name "
		+" , b.member_name "
		+" , c.member_no client_no"
		+" , c.member_name client_name "
		+" , (select listagg(member_name,',') within group(order by sign_seq) from tcb_cust where cont_no = a.cont_no and cont_chasu = a.cont_chasu and sign_seq >= 3) client_names "
		+" , a.status "
		+" , b.pay_yn won_pay_yn "
		+" , c.pay_yn su_pay_yn" 
		+" , d.recpmoneyamt "
		+" , d.suppmoneyamt "
		+" , d.paytypecd"
		+" , e.user_id client_id"
		);
list.addWhere("a.cont_no = b.cont_no ");
list.addWhere("a.cont_chasu = b.cont_chasu ");
list.addWhere("a.member_no = b.member_no ");
list.addWhere("a.cont_no = c.cont_no ");
list.addWhere("a.cont_chasu = c.cont_chasu ");
list.addWhere("c.sign_seq = '2'");
list.addWhere(" a.member_no = d.member_no(+) ");
list.addWhere(" c.member_no = e.member_no(+) ");
list.addWhere(" 'Y' = e.default_yn(+) ");

if(!s_sdate.equals("")){
	list.addWhere("a.cont_date >= '"+s_sdate.replaceAll("-", "")+"' ");
}
if(!f.get("s_edate").equals("")){
	list.addWhere("a.cont_date <= '"+f.get("s_edate").replaceAll("-", "")+"' ");
}

list.addSearch("a.status", f.get("s_status"));
list.addSearch("b.member_name", f.get("s_member_name"), "LIKE");
if(!f.get("s_client_name").equals("")){
	list.addWhere(" exists ( select * from tcb_cust where cont_no = a.cont_no and cont_chasu = a.cont_chasu and member_name like '%"+f.get("s_client_name")+"%')");
}
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.setOrderBy("a.cont_no desc, a.cont_chasu asc");

DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("str_cont_no",ds.getString("cont_no"));
	ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(!ds.getString("cont_chasu").equals("0")){
		ds.put("cont_name", ds.getString("cont_name"));
	}
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("status_name", ds.getString("status").equals("00")?"숨김":u.getItem(ds.getString("status"), code_status));
	
	//버튼설정
	ds.put("btn_writing", !ds.getString("status").equals("10"));
	ds.put("btn_finish", !u.inArray( ds.getString("status"), new String[]{"50"}));
	ds.put("btn_hide", !ds.getString("status").equals("00"));
	ds.put("btn_won_pay", (!ds.getString("won_pay_yn").equals("Y"))&&ds.getString("paytypecd").equals("30"));
	ds.put("btn_su_pay", !ds.getString("su_pay_yn").equals("Y"));
}


DataObject contDao = new DataObject(list.table);
int tot_cnt = contDao.findCount(list.where);

p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.contract_list");
p.setVar("menu_cd","000047");
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setVar("tot_cnt", u.numberFormat(tot_cnt));
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>