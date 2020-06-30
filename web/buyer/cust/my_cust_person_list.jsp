<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_status = {"01=>정회원", "02=>비회원"};  // 회원상태


f.addElement("s_member_name",null, null);
f.addElement("s_status", null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:15);
list.setTable("tcb_client a, tcb_member b , tcb_person c, tcb_member_boss d");
list.setFields("b.member_no, b.member_name, b.status, c.jumin_no, tel_num, c.hp1,c.hp2,c.hp3,c.hp1||'-'||c.hp2||'-'||c.hp3 hp_no, c.email, b.address , d.boss_birth_date, d.boss_gender");
list.addWhere("a.client_no = b.member_no");
list.addWhere("b.member_no = c.member_no");
list.addWhere("b.member_no = d.member_no(+)");
list.addWhere("c.default_yn = 'Y'");
list.addWhere("b.status <> '00' ");
list.addWhere("b.member_gubun = '04'  ");
list.addWhere("a.member_no = '"+_member_no+"'  ");
list.addSearch("b.member_name", f.get("s_member_name"), "LIKE");
list.addSearch("b.status", f.get("s_status"));
list.setOrderBy("member_name asc");

DataSet ds = list.getDataSet();
Security security =	new	Security();

while(ds.next()){
	if(!ds.getString("jumin_no").equals("")){
		String jumin_no = u.aseDec(ds.getString("jumin_no"));//생년월일
		String gender =""; //성별
		if(jumin_no.length() == 8){//19120601 1912년 06월 01일
			jumin_no = u.getTimeString("yyyy-MM-dd",jumin_no);
			gender = "";
	    }else
	    if(jumin_no.length() == 7){//1101011 11년01월01일 1(남)
	    	gender = u.inArray(jumin_no.substring(6,7), new String[]{"1","3"})?"(남)":"(여)";
	    	jumin_no = jumin_no.substring(0,6);
	    	if(Integer.parseInt(jumin_no.substring(0,2)) > 25){
	    		jumin_no = u.getTimeString("yyyy-MM-dd","19"+jumin_no);
	    	}else{
	    		jumin_no = u.getTimeString("yyyy-MM-dd","20"+jumin_no);
	    	}
	    }else
	    if(jumin_no.length() == 6){
	    	jumin_no = jumin_no;//110101
	    	gender = "";
	    	if(Integer.parseInt(jumin_no.substring(0,2)) > 25){
	    		jumin_no = u.getTimeString("yyyy-MM-dd","19"+jumin_no);
	    	}else{
	    		jumin_no = u.getTimeString("yyyy-MM-dd","20"+jumin_no);
	    	}
	    }
		ds.put("gender", gender);
		ds.put("birth_date", jumin_no);
	}
	
	if(!ds.getString("boss_birth_date").equals("")){
		ds.put("birth_date", u.getTimeString("yyyy-MM-dd", ds.getString("boss_birth_date")));
		ds.put("gender", ds.getString("boss_gender").equals("")?"":("("+ds.getString("boss_gender")+")"));
	}
	ds.put("status", u.getItem(ds.getString("status"), code_status));
}

if(u.request("mode").equals("excel")){
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("개인회원.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/cust/my_cust_person_excel.html"));
	return;
}


p.setLayout("default");
p.setDebug(out);
p.setBody("cust.my_cust_person_list");
p.setVar("menu_cd","000087");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000087", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.setVar("form_script",f.getScript());
p.display(out);
%>