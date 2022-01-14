<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

CodeDao code = new CodeDao("tcb_comcode");
String[] code_cont_status = code.getCodeArray("M008", "and code in ('50','91')");

f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name", null, null);
f.addElement("s_sdate", null, null);
f.addElement("s_edate", null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:15);
list.setTable("tcb_contmaster a, tcb_cust b, tcb_member c, tcb_cust d");
list.setFields(  "a.cont_no , a.cont_chasu, a.template_cd, a.cont_name, a.cont_date,a.cont_sdate, a.cont_edate, a.cont_total, a.status, a.cont_userno, a.paper_yn, c.member_name as cust_name, b.sign_dn,d.vendcd ,d.boss_name,d.user_name,d.email"
		           + ",d.tel_num,d.hp1,d.hp2,d.hp3,d.sign_date,(select template_name from tcb_cont_template where template_cd = a.template_cd) template_name");
list.addWhere(" a.cont_no = b.cont_no  and a.cont_chasu = b.cont_chasu ");
list.addWhere(" a.member_no <> b.member_no ");
list.addWhere(" a.member_no = c.member_no ");
list.addWhere(" a.cont_no = d.cont_no ");
list.addWhere(" a.cont_chasu = d.cont_chasu ");
list.addWhere(" a.member_no = d.member_no ");
list.addWhere(" b.member_no = '"+_member_no+"'");
list.addWhere("	a.status in ('50','91') ");// 50:완료된 계약 91:계약해지
if(!f.get("s_sdate").equals(""))list.addWhere(" a.cont_date >= '"+f.get("s_sdate").replaceAll("-","")+"'");
if(!f.get("s_edate").equals(""))list.addWhere(" a.cont_date <= '"+f.get("s_edate").replaceAll("-","")+"'");
list.addSearch(" c.member_name",f.get("s_cust_name"),"LIKE");
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
/* list.setOrderBy("cont_no desc, cont_chasu asc"); */
list.setOrderBy("(select max(nvl(mod_req_date,reg_date)) from tcb_contmaster where member_no = a.member_no and cont_no = a.cont_no) desc, a.cont_no desc, a.cont_chasu");

DataSet ds = list.getDataSet();
while(ds.next()){
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(ds.getInt("cont_chasu")>0){
		if(!u.request("mode").equals("excel")){	
			ds.put("cont_name", "<img src='../html/images/re.jpg' align='absmiddle'> " +ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"차)");
		}else{
			ds.put("cont_name", "└ " +ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"차)");
		}
	}		
	if(!ds.getString("template_cd").equals("")){//일반계약
		ds.put("link","contend_recvview.jsp");
	}else{
		if(ds.getString("paper_yn").equals("Y")){//서명계약
			ds.put("link", "contend_offcont_recvview.jsp");	
		}else{//자유서식
			ds.put("link", "contend_free_recvview.jsp");	
		}
	}
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("cont_sdate", u.getTimeString("yyyy-MM-dd", ds.getString("cont_sdate")));
	ds.put("cont_edate", u.getTimeString("yyyy-MM-dd", ds.getString("cont_edate")));
	ds.put("status", u.getItem(ds.getString("status"), code_cont_status));
	ds.put("sign_date", u.getTimeString("yyyy-MM-dd", ds.getString("sign_date")));
	if(!"".equals(ds.getString("hp1")) &&  !"".equals(ds.getString("hp2")) &&  !"".equals(ds.getString("hp3")))
	{
		ds.put("hp", ds.getString("hp1")+"-"+ds.getString("hp2")+"-"+ds.getString("hp3"));	
	}else
	{
		ds.put("hp", "");
	}
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
}

if(u.request("mode").equals("excel")){
	p.setVar("title", "완료된계약(받은계약)");
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("완료된계약(받은계약).xls".getBytes("KSC5601"),"8859_1") + "\"");
	if("20130700376".equals(_member_no))	/* 웅진식품의 경우 */
	{
		out.println(p.fetch("../html/contract/contend_recv_list_excel_20130700376.html"));
	}else
	{
		out.println(p.fetch("../html/contract/contend_recv_list_excel.html"));
	}
	return;
}



p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contend_recv_list");
p.setVar("menu_cd","000065");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>