<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%
String _menu_cd = "000052";

String[] code_bid_kind = {"10=>물품","20=>용역","30=>공사","90=>견적"};

DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template = templateDao.find(" status > 0 and template_type in ('00','10') and member_no like '%"+_member_no+"%' and use_yn ='Y' ","template_cd, nvl(display_name,template_name)template_name","display_seq asc");

String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd",u.addDate("Y",-1)));
String s_edate = u.request("s_edate", u.getTimeString("yyyy-MM-dd"));

f.addElement("s_bid_name",null, null);
f.addElement("s_member_name", null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(15);
list.setTable("tcb_bid_master a, tcb_bid_supp b ");
list.setFields("a.bid_kind_cd, a.bid_no, a.bid_deg, a.bid_name, a.bid_date, b.member_no, b.member_name, decode(a.succ_method,'03', a.nego_amt, '06', a.nego_amt, b.total_cost) total_cost ");
list.addWhere(" a.bid_kind_cd in ('10','20','30','90')");
list.addWhere(" a.main_member_no = b.main_member_no ");
list.addWhere(" a.bid_no = b.bid_no ");
list.addWhere(" a.bid_deg = b.bid_deg ");
list.addWhere(" a.status = '07' ");//낙찰인건만
list.addWhere(" b.bid_succ_yn = 'Y'"); //낙찰된 업체만.
list.addWhere(" a.cont_yn = 'Y'");// 계약대상인 건만.
list.addWhere(" b.cont_no is null ");// 계약안된것만.
list.addWhere(" a.main_member_no = '"+_member_no+"' ");
list.addSearch("a.bid_name", f.get("s_bid_name"), "LIKE");
list.addSearch("b.member_name", f.get("s_member_name"), "LIKE");
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
list.setOrderBy("bid_no desc ");

DataSet	ds = list.getDataSet();
while(ds.next()){
	ds.put("total_cost", u.numberFormat(ds.getString("total_cost")));
	ds.put("bid_kind_cd", u.getItem(ds.getString("bid_kind_cd"),code_bid_kind));
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_select_bid");
p.setVar("menu_cd", _menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setLoop("template", template);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>