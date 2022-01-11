<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000162";

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008", " and code in ('10', '20', '21', '30', '40', '41', '50')");

//String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd",u.addDate("M",-3)));
//String s_edate = u.request("s_edate");
Calendar mon = Calendar.getInstance();
mon.add(Calendar.MONTH , -12);
String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd",mon.getTime()));
String s_edate = u.request("s_edate" , u.getTimeString("yyyy-MM-dd"));

f.addElement("s_status", null, null);
f.addElement("s_template_cd", null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_cont_name",null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_user_no", null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel","report"})?-1:15);
list.setTable(" tcb_contmaster a, tcb_cust b, tcb_stamp c, tcb_stamp d");
list.setFields(" a.cont_no, a.member_no, a.cont_chasu, a.stamp_type, a.cont_name, b.member_no cust_member_no, "
              +" b.member_name, a.cont_date, a.cont_total, c.stamp_money  as  send_stamp_amt, c.issue_date as send_issue_date, c.channel as send_channel, "
              +" c.cert_no as send_cert_no , d.stamp_money as recv_stamp_amt, d.issue_date as recv_issue_date, d.channel as recv_channel, "
              +" d.cert_no as recv_cert_no "
              +",(select decode(count(*),0,'N','Y') from naecs.findt900 where menu_id = 'fietst_register' and edgbn = 'N' and keyno = a.cont_no) as stamp_yn"
              +",(select x.CNAME from TCB_COMCODE x where x.ccode = 'M008' and x.code = a.status) status_nm");
list.addWhere(" a.cont_no = b.cont_no ");
list.addWhere(" a.cont_chasu = b.cont_chasu ");
list.addWhere(" b.sign_seq = '2' ");
list.addWhere(" a.stamp_type = 'Y' ");
//list.addWhere(" a.stamp_type != '0' ");
list.addWhere(" a.member_no = '"+_member_no+"' ");
//list.addWhere(" a.status in ( '20', '21', '30', '40', '41', '50' ) ");
list.addWhere(" a.cont_no = c.cont_no(+) ");
list.addWhere(" a.cont_chasu = c.cont_chasu(+) ");
list.addWhere(" a.member_no = c.member_no(+) ");
list.addWhere(" a.cont_no = d.cont_no(+) ");
list.addWhere(" a.cont_chasu  = d.cont_chasu(+) ");
list.addWhere(" a.member_no <> d.member_no(+) ");
list.addWhere(" a.status not in ('95') ");
String s_date_query = "";
if(!s_sdate.equals("")) {
	list.addWhere(" a.cont_date >= '"+s_sdate.replaceAll("-","")+"'");
	s_date_query = " and cont_date >= '"+s_sdate.replaceAll("-","")+"'";
}
if(!s_edate.equals("")) {
	list.addWhere(" a.cont_date <= '"+s_edate.replaceAll("-","")+"'");
	s_date_query += " and cont_date <= '"+s_edate.replaceAll("-","")+"'";
}
list.addSearch("a.status", f.get("s_status"));
list.addSearch("a.template_cd", f.get("s_template_cd"));
list.addSearch("b.member_name", f.get("s_cust_name"), "LIKE");
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.addSearch("a.cont_userno",  f.get("s_user_no"), "LIKE");
/*조회권한*/
if(!auth.getString("_DEFAULT_YN").equals("Y")){
	//10:담당조회  20:부서조회 
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("10")){
		list.addWhere("a.reg_id = '"+auth.getString("_USER_ID")+"' ");
	}
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("20")){
		list.addWhere("a.field_seq = '"+auth.getString("_FIELD_SEQ")+"' ");
	}
}

list.setOrderBy("a.reg_date desc");

DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
    if(!ds.getString("cont_chasu").equals("0")){
		ds.put("cont_name", "<img src='../html/images/re.jpg'> "+ds.getString("cont_name")+" ("+ds.getString("cont_chasu")+"차)");
	}
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("cont_total", u.numberFormat(ds.getDouble("cont_total"), 0));
	ds.put("send_reg", u.inArray(ds.getString("stamp_type"), new String[]{"1","3"}));
	ds.put("send_reg_yn", ds.getDouble("send_stamp_amt")>0);
	ds.put("send_stamp_amt", u.numberFormat(ds.getDouble("send_stamp_amt"), 0));
	ds.put("send_issue_date", u.getTimeString("yyyy-MM-dd",ds.getString("send_issue_date")));
	ds.put("recv_reg", u.inArray(ds.getString("stamp_type"), new String[]{"2","3"}));
	ds.put("recv_reg_yn", ds.getDouble("recv_stamp_amt")>0);
	ds.put("recv_issue_date", u.getTimeString("yyyy-MM-dd",ds.getString("recv_issue_date")));
	ds.put("recv_stamp_amt", u.numberFormat(ds.getDouble("recv_stamp_amt"), 0));
	ds.put("stamp_yn", ds.getString("stamp_yn"));
	ds.put("status_nm", ds.getString("status_nm"));
}	

if(u.request("mode").equals("excel")){
	
	p.setVar("title", "인지세 조회("+s_sdate+" ~ "+f.get("s_edate")+") ");
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(("인지세조회.xls").getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/cont_stamp_send_list_excel.html"));
	return;
	
}

DataObject templateDao = new DataObject();
DataSet template = templateDao.query("select nvl(display_name, template_name) template_name, template_cd from tcb_cont_template where template_cd in (select decode(template_cd, '', '9999999', template_cd) template_cd from tcb_contmaster where member_no = '"+_member_no+"'"+s_date_query+" and status in ('50','91') group by template_cd) order by display_seq asc, template_cd desc");

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.cont_stamp_send_list");
p.setVar("menu_cd",_menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setLoop("template", template);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu,share_seq"));
p.setVar("form_script", f.getScript());
p.display(out);
%>
