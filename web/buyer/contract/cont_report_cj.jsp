<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM")+"-01");
String s_edate = u.request("s_edate",u.getTimeString("yyyy-MM-dd"));
String s_date_type = u.request("s_date_type").equals("") ? "1" : u.request("s_date_type");

f.addElement("s_date_type", s_date_type, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);


String s_date_query = "";
if(!s_sdate.equals("")) {
	if(s_date_type.equals("1"))
		s_date_query = " and cont_date >= '"+s_sdate.replaceAll("-","")+"'";
	else
		s_date_query = " and substr(reg_date,0,8) >= '"+s_sdate.replaceAll("-","")+"'";
}
if(!s_edate.equals("")) {
	if(s_date_type.equals("1"))
		s_date_query += " and cont_date <= '"+s_edate.replaceAll("-","")+"'";
	else
		s_date_query += " and substr(reg_date,0,8) <= '"+s_edate.replaceAll("-","")+"'";
}

String sql = "select cont_etc1,"
					+ "nvl(sum(decode(status,'10',1,0)),0) writing_cnt, "
					+ "nvl(sum(decode(status,'20',1,0)),0) req_cnt, "
					+ "nvl(sum(decode(status,'30',1,0)),0) stendby_cnt, "
					+ "nvl(sum(decode(status,'40',1,0)),0) mod_req_cnt, "
					+ "nvl(sum(decode(status,'41',1,0)),0) return_cnt, "
					+ "nvl(sum(decode(status,'50',1,0)),0) complete_cnt "
			 + "from tcb_contmaster "
					+ "where member_no = '20130400333' "
					+ s_date_query
			+ " group by cont_etc1 "
			+ " order by cont_etc1 ";


DataObject dao = new DataObject();
DataSet ds = dao.query(sql);

int[] tot = new int[7];

while(ds.next()){
	ds.put("sum", ds.getInt("writing_cnt")+ds.getInt("req_cnt")+ds.getInt("stendby_cnt")+ds.getInt("mod_req_cnt")+ds.getInt("return_cnt")+ds.getInt("complete_cnt"));	
	tot[0] += ds.getInt("writing_cnt");
	tot[1] += ds.getInt("req_cnt");
	tot[2] += ds.getInt("stendby_cnt");
	tot[3] += ds.getInt("mod_req_cnt");
	tot[4] += ds.getInt("return_cnt");
	tot[5] += ds.getInt("complete_cnt");
	tot[6] += ds.getInt("sum");
}
DataSet dsTot = new DataSet();
dsTot.addRow();
dsTot.put("writing_cnt", tot[0]);
dsTot.put("req_cnt", tot[1]);
dsTot.put("stendby_cnt", tot[2]);
dsTot.put("mod_req_cnt", tot[3]);
dsTot.put("return_cnt", tot[4]);
dsTot.put("complete_cnt", tot[5]);
dsTot.put("sum", tot[6]);
p.setVar("tot", dsTot);

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.cont_report_cj");
p.setVar("menu_cd","000072");
p.setLoop("list", ds);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script", f.getScript());
p.display(out);
%>