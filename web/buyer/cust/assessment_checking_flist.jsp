<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] kind_cd = {"N=>�ű�","S=>����","R=>����"};
String[] status_cd = {"10=>�򰡴��","20=>����","50=>�򰡿Ϸ�"};

f.addElement("s_member_name",null, null);
f.addElement("s_project_name",null, null);

//��� ����
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(15);
list.setTable("tcb_assemaster a, tcb_assedetail b ");
list.setFields("a.*, b.div_cd, to_number( b.total_point ) as total_point, to_number( b.rating_point) as rating_point, (select user_name from tcb_person WHERE user_id = a.reg_id) as user_nm ");
list.addWhere("a.asse_no = b.asse_no");
list.addWhere("a.main_member_no = '"+_member_no+"' ");
list.addWhere("b.div_cd in ('F') ");
list.addWhere("a.status = '20' ");
list.addSearch("a.member_name", f.get("s_member_name"), "LIKE");
list.addSearch("lower(a.project_name)", f.get("s_project_name").toLowerCase(), "LIKE");
list.setOrderBy("a.asse_year desc, a.member_name desc ");

DataSet	ds = list.getDataSet();
while(ds.next()){

	if("0".equals(ds.getString("total_point"))){
		ds.put("total_point", "");
		ds.put("rating_point", "-");
	}else{
		ds.put("total_point", "("+ds.getString("total_point")+")");
	}
	ds.put("status_nm", u.getItem(ds.getString("status"), status_cd));	//����
	if("".equals(ds.getString("user_nm"))){
		ds.put("user_nm", "-");		//����
	}
	if("".equals(ds.getString("reg_date"))){
		ds.put("reg_date", "-");	//����
	}else{
		ds.put("reg_date", u.getTimeString("yyyy-MM-dd",ds.getString("reg_date")));	//����
	}
}

if(u.isPost()&&f.validate()){
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.assessment_checking_flist");
p.setVar("menu_cd","000105");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>