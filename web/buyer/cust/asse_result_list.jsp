<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] code_detail_status = {"10=>평가대상","20=>평가완료"};

f.addElement("s_project_name", u.request("s_project_name"), null);
f.addElement("s_member_name", u.request("s_member_name"), null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable(
	  " tcb_assemaster a                                                                                    "
     +" left outer join (select asse_no, reg_id, reg_name, status, total_point from tcb_assedetail where div_cd = 'S') b "
     +"  on a.asse_no = b.asse_no                                                                           "
     +" left outer join (select asse_no, reg_id, reg_name, status, total_point from tcb_assedetail where div_cd = 'Q') c "
     +"  on a.asse_no = c.asse_no    "
		);
list.setFields(
		 " a.*                                                                  "
		+", b.reg_name s_user_name, b.status s_status, b.total_point s_point    "
		+", c.reg_name qc_user_name, c.status qc_status, c.total_point qc_point "
		+", (select sum(rating_point) from tcb_assedetail where asse_no = a.asse_no) total_point"
		);
list.addWhere(" a.main_member_no = '"+_member_no+"'");
list.addWhere(" a.status = '30' ");
if(!auth.getString("_DEFAULT_YN").equals("Y")){
	list.addWhere(
			" (a.asse_no in (select asse_no from tcb_assedetail where reg_id = '"+auth.getString("_USER_ID")+"' ) or a.reg_id = '"+auth.getString("_USER_ID")+"' )"
			);
}
list.addSearch("a.project_name", f.get("s_project_name"), "LIKE");
list.addSearch("a.member_name", f.get("s_member_name"), "LIKE");
list.setOrderBy("a.asse_no desc");

DataSet ds = list.getDataSet();
while(ds.next()){
	String url = "./asse_progress_list.jsp?asse_no="+ds.getString("asse_no");
	if(!ds.getString("s_user_name").equals("")){
		if(ds.getString("s_status").equals("10")){
			ds.put("s_status_nm", ds.getString("s_point").equals("")?"<span style='color:red'>[평가대상]</span>":"평가중 [ "+ds.getString("s_point")+" ]");
		}else{
			ds.put("s_status_nm","<span style='color:blue'>평가완료</span>" );
		}
	}else{
		ds.put("s_status_nm", "평가제외");
	}
	
	if(!ds.getString("qc_user_name").equals("")){
		if(ds.getString("qc_status").equals("10")){
			ds.put("qc_status_nm", ds.getString("qc_point").equals("")?"<span style='color:red'>[평가대상]</span>":"평가중 [ "+ds.getString("qc_point")+" ]");
		}else{
			ds.put("qc_status_nm","<span style='color:blue'>평가완료</span>" );
		}
	}else{
		ds.put("qc_status_nm", "평가제외");
	}
	
	ds.put("reg_date", u.getTimeString("yyyy-MM-dd", ds.getString("reg_date")));
}

p.setLayout("default");
//p.setDebug(out);
p.setVar("menu_cd","000160");
p.setBody("cust.asse_result_list");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000160", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("asse_no"));
p.setVar("form_script",f.getScript());
p.display(out);
%>