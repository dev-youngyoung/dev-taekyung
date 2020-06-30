<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

CodeDao code = new CodeDao("tcb_comcode");
String[] code_status = code.getCodeArray("M008", " and code in ('11','20','21','30','40','41','50')");

String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM-dd",u.addDate("M",-3)));
String s_edate = u.request("s_edate",u.getTimeString("yyyy-MM-dd"));

f.addElement("s_template_cd", null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_cont_name",null, null);
f.addElement("s_field_seq",null, null);
f.addElement("s_status", null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:15);
list.setTable(" tcb_contmaster a, tcb_cust b , tcb_field c, tcb_person d");
list.setFields(
		 "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date, a.status, b.member_no, b.member_name,b.boss_name,c.field_name,d.user_name,"
		+"( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt"
);
list.addWhere("a.cont_no = b.cont_no");
list.addWhere("a.cont_chasu = b.cont_chasu");
list.addWhere("b.member_no <> a.member_no");
list.addWhere(" b.list_cust_yn = 'Y'");
list.addWhere("c.member_no = a.member_no");
list.addWhere("c.field_seq = a.field_seq");
list.addWhere("d.member_no = a.member_no");
list.addWhere("d.user_id = a.reg_id");
list.addWhere(" a.member_no = '"+_member_no+"' ");


DataObject fieldDao = new DataObject("tcb_field");
DataSet field = null; 
list.addWhere(" a.status not in ('00','10','90','91')");
p.setLoop("code_field", field);


String s_date_query = "";
if(!s_sdate.equals("")) {
	list.addWhere(" a.cont_date >= '"+s_sdate.replaceAll("-","")+"'");
	s_date_query = " and cont_date >= '"+s_sdate.replaceAll("-","")+"'";
}
if(!s_edate.equals("")) {
	list.addWhere(" a.cont_date <= '"+s_edate.replaceAll("-","")+"'");
	s_date_query += " and cont_date <= '"+s_edate.replaceAll("-","")+"'";
}
list.addSearch("a.status",  f.get("s_status"));
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
list.addSearch("a.template_cd",  f.get("s_template_cd"));
list.addSearch("a.field_seq",  f.get("s_field_seq")); 
list.setOrderBy("a.cont_no desc");

DataSet ds = list.getDataSet();
while(ds.next()){
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(ds.getInt("cust_cnt")-2>0){
		ds.put("cust_name", ds.getString("member_name")+ "외"+(ds.getInt("cust_cnt")-2)+"개사");
	}else{
		ds.put("cust_name", ds.getString("member_name"));
	}

	ds.put("link", ds.getString("template_cd").equals("") ? ds.getString("status").equals("50") || ds.getString("status").equals("91") ? "contend_free_sendview.jsp?re=cont_part_cj.jsp" : "contract_free_sendview.jsp?re=cont_part_cj.jsp" : ds.getString("status").equals("50") || ds.getString("status").equals("91") ? "contend_sendview.jsp?re=cont_part_cj.jsp" : "contract_sendview.jsp?re=cont_part_cj.jsp");
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	if(ds.getString("status").equals("30")){//서명대기 상태이면 생상 표시
		ds.put("status_name", "<span class=\"caution-text\">"+u.getItem(ds.getString("status"), code_status)+"<span>");
	}else if(ds.getString("status").equals("21")) {  // 승인대기
		ds.put("status_name", "<span class=\"caution-text\">"+u.getItem(ds.getString("status"), code_status)+"<br>("+ds.getString("agree_name")+")</span>");
	}else if(ds.getString("status").equals("40")){//수정요청 상태이면 생상 표시
		ds.put("status_name", "<span style='color:blue'>"+u.getItem(ds.getString("status"), code_status)+"<span>");
	}else{
		ds.put("status_name", u.getItem(ds.getString("status"), code_status));
	}
}

if(u.request("mode").equals("excel")){
	p.setVar("title", "부서별 계약현황");
	
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("부서별 계약현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/cont_part_cj_excel.html"));
	return;
} 

DataObject templateDao = new DataObject();
DataSet template = templateDao.query("select template_name, template_cd from tcb_cont_template where template_cd in (select distinct(template_cd) from tcb_contmaster where member_no = '"+_member_no+"'"+s_date_query+" and status not in ('00','10','90','91') )");


p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.cont_part_cj");
p.setVar("menu_cd","000074");
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setVar("isDefaultYn", auth.getString("_DEFAULT_YN").equals("Y"));
p.setLoop("template", template);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>