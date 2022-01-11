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
list.setTable("tcb_contmaster a, tcb_cust b, tcb_member c");
list.setFields("a.cont_no , a.cont_chasu, a.template_cd, a.cont_name, a.cont_date,a.cont_sdate, a.cont_edate, a.cont_total, a.status, a.cont_userno, a.paper_yn, c.member_name as cust_name, b.sign_dn ");
list.addWhere(" a.cont_no = b.cont_no  and a.cont_chasu = b.cont_chasu ");
list.addWhere(" a.member_no <> b.member_no ");
list.addWhere(" a.member_no = c.member_no ");
list.addWhere(" b.member_no = '"+_member_no+"'");
list.addWhere("	a.status in ('50','91', '99') ");// 50:완료된 계약 91:계약해지 99:계약폐기
if(!f.get("s_sdate").equals(""))list.addWhere(" a.cont_date >= '"+f.get("s_sdate").replaceAll("-","")+"'");
if(!f.get("s_edate").equals(""))list.addWhere(" a.cont_date <= '"+f.get("s_edate").replaceAll("-","")+"'");

if(_member_no.equals("20201000002")){
	DataObject ssoUserDao = new DataObject("sso_user_info");
	DataSet ssoUser = ssoUserDao.find("user_id = '" + auth.getString("_USER_ID") + "' ");
	if (!ssoUser.next()) {
		u.jsError("사용자 정보가 존재하지 않습니다.");
		return;
	}
	String userName = ssoUser.getString("user_name");
	String celNo = ssoUser.getString("cel_no");
	String celNo1 = celNo.replaceAll("-", "").substring(0, 3);
	String celNo2 = celNo.replaceAll("-", "").substring(3, 7);
	String celNo3 = celNo.replaceAll("-", "").substring(7);
	
	list.addWhere(" b.user_name = '" + userName + "'");
	list.addWhere(" b.hp1 = '" + celNo1 + "'");
	list.addWhere(" b.hp2 = '" + celNo2 + "'");
	list.addWhere(" b.hp3 = '" + celNo3 + "'");
}

list.addSearch(" c.member_name",f.get("s_cust_name"),"LIKE");
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.setOrderBy("a.reg_date desc");

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
}

if(u.request("mode").equals("excel")){
	p.setVar("title", "완료된계약(받은계약)");
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("완료된계약(받은계약).xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/contend_recv_list_excel.html"));
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