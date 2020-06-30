<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] kind_cd = {"N=>신규","S=>수시","R=>정기"};

f.addElement("s_member_name",null, null);
f.addElement("s_asse_year",null, null);
f.addElement("s_project_name", null, null);

DataSet asse_year = new DataSet();
asse_year.addRow();
asse_year.put("", "----선택----");
String lastYear = u.getTimeString("yyyy",u.addDate("Y",-1));
String thisYear = u.getTimeString("yyyy");
String nextYear = u.getTimeString("yyyy",u.addDate("Y",+1));
asse_year.put("year", lastYear);
asse_year.addRow();
asse_year.put("year", thisYear);
asse_year.addRow();
asse_year.put("year", nextYear);


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(15);
list.setTable(" (SELECT aa.asse_no, aa.member_no, aa.project_name, aa.asse_year, aa.status FROM tcb_assemaster aa where main_member_no = '"+_member_no+"'   group by aa.asse_no, aa.member_no, aa.project_name, aa.asse_year, aa.status) a, tcb_assemaster b ");
list.setFields(" b.* ");
list.addWhere(" a.asse_no = b.asse_no ");
list.addWhere(" a.status = '10' ");
list.addSearch(" b.member_name", f.get("s_member_name"), "LIKE");
list.addSearch(" b.asse_year", f.get("s_asse_year"));
list.addSearch(" b.project_name", f.get("s_project_name"), "LIKE");
list.setOrderBy(" b.asse_year desc, b.member_name desc ");

DataSet	ds = list.getDataSet();
while(ds.next()){
	ds.put("s_yn", "Y".equals(ds.getString("s_yn"))?"V":"-");
	ds.put("qc_yn", "Y".equals(ds.getString("qc_yn"))?"V":"-");
	ds.put("enc_yn", "Y".equals(ds.getString("enc_yn"))?"V":"-");
	ds.put("f_yn", "Y".equals(ds.getString("f_yn"))?"V":"-");
	ds.put("asse_kind_cd", u.getItem(ds.getString("kind_cd"), kind_cd));
	String goUrl = "";
	if("10".equals(ds.getString("status"))){	//작성중
		System.out.println("작성중");
		goUrl = "assessment_insert.jsp";

	}else{
		if("1".equals(auth.getString("_FIELD_SEQ"))){
			System.out.println("구매팀");
			goUrl = "assessment_checking_slist.jsp";

		}else if("2".equals(auth.getString("_FIELD_SEQ"))){
			System.out.println("QC");
			goUrl = "assessment_checking_qlist.jsp";

		}else if("3".equals(auth.getString("_FIELD_SEQ"))){
			System.out.println("ENC");
			goUrl = "assessment_checking_elist.jsp";
		}else{
			System.out.println("안전");
			goUrl = "assessment_checking_flist.jsp";
		}
	}
	ds.put("goUrl", goUrl);
}


if(u.isPost()&&f.validate()){
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.assessment_list");
p.setVar("menu_cd","000101");
p.setLoop("list", ds);
p.setLoop("asse_year", asse_year);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>