<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000070";

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("P001");
String[] sccode_type = codeDao.getCodeArray("P002");
String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd", u.addDate("M", -1)));

f.addElement("s_sdate",s_sdate, null);
f.addElement("s_edate",null, null);
f.addElement("s_field_name",null, null);
f.addElement("s_sccode",null, null);
f.addElement("s_status",null, null);
f.addElement("s_cont_name",null, null);
f.addElement("s_member_name",null, null);
f.addElement("s_won_member_name",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel"})?-1:15);
list.setTable("tcb_proof a, tcb_contmaster b, tcb_field c, tcb_proof_cust d, tcb_proof_cust e");
list.setFields(" a.proof_no, c.field_name, b.cont_name, a.req_date , d.member_name, a.status, a.sccode, e.member_name won_member_name ");
list.addWhere("a.cont_no = b.cont_no       	");
list.addWhere("a.cont_chasu = b.cont_chasu  ");
list.addWhere("b.member_no = c.member_no   	");
list.addWhere("b.field_seq = c.field_seq   	");
list.addWhere("a.proof_no = d.proof_no     	");
list.addWhere("a.member_no = d.member_no    ");
list.addWhere("d.cust_gubun = '20'	 		");
list.addWhere("a.proof_no = e.proof_no 		");
list.addWhere("e.cust_gubun = '10'	 		");
if(!s_sdate.equals("")){
	list.addWhere("a.reg_date >= '"+s_sdate.replaceAll("-", "")+"' ");
}
if(!f.get("s_edate").equals("")){
	list.addWhere("a.reg_date <= '"+f.get("s_edate").replaceAll("-", "")+"' ");
}

list.addSearch("c.field_name", f.get("s_field_name"), "LIKE");
list.addSearch(" a.sccode", f.get("s_sccode"));
list.addSearch(" a.status", f.get("s_status"));
list.addSearch("b.cont_name",  f.get("s_cont_name"), "LIKE");
list.addSearch("d.member_name",  f.get("s_member_name"), "LIKE");
list.addSearch("e.member_name",  f.get("s_won_member_name"), "LIKE");
list.setOrderBy("a.reg_date desc, a.proof_no desc");

DataSet ds = list.getDataSet();
while(ds.next()){
	ds.put("str_proof_no",ds.getString("proof_no"));
	ds.put("proof_no", u.aseEnc(ds.getString("proof_no")));
	ds.put("req_date", u.getTimeString("yyyy-MM-dd",ds.getString("req_date")));
	ds.put("status_nm" , u.getItem(ds.getString("status"), code_status));
	ds.put("sccode_nm" , u.getItems(ds.getString("sccode"), sccode_type));

	//버튼설정
	ds.put("btn_writing", !ds.getString("status").equals("10"));
	ds.put("btn_finish", !u.inArray( ds.getString("status"), new String[]{"50"}));
	ds.put("btn_hide", !ds.getString("status").equals("00"));
}

p.setLayout("default");
p.setDebug(out);
p.setBody("buyer.proof_list");
p.setVar("menu_cd",_menu_cd);
p.setLoop("sccode_type", u.arr2loop(sccode_type));
p.setLoop("code_status", u.arr2loop(code_status) );
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no"));
p.setVar("form_script", f.getScript());
p.display(out);
%>