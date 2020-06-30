<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.select.*" %>
<%!
/*public String getJsoupValue(Document document, String name){
	String value = "";
	Elements elements = document.getElementsByAttributeValue("name", name);
	for(Element element: elements){
		value = element.attr("value");
	}
	return value;
}*/
%>
<%
String test02   =  " '20121203043'"
        		  +",'20150700962'"
				  +",'20150900434'";
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008", " and code in ('10','20','30','31','40','41','50','91')");

String s_sdate = u.request("s_sdate", u.addDate("M", -1, new Date(), "yyyy-MM-dd"));
String s_edate = u.request("s_edate", u.getTimeString("yyyy-MM-dd"));

boolean memberChk = false;

DataObject memberDao = new DataObject("tcb_member");
DataSet Test02 = memberDao.find(" member_no in ("+test02 +")");
while(Test02.next()){
	if(Test02.getString("member_no").equals(_member_no)){
		memberChk = true;
		break;
	}
}
if(!memberChk){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

f.addElement("s_main_member_no",null, null);
f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_status", null, null);


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel","report"})?-1:15);
list.setTable("tcb_contmaster a, tcb_cust b");
list.setFields(
				 "  a.*, b.member_name"
				+" ,( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt "
				+" ,( SELECT  member_name FROM tcb_member WHERE member_no = a.member_no ) main_member_name "
				+" ,( SELECT  user_name FROM tcb_person WHERE user_id = a.reg_id ) user_name "
		      );
list.addWhere(" a.cont_no = b.cont_no");
list.addWhere(" a.cont_chasu = b.cont_chasu");
list.addWhere(" a.status <> '00'");
list.addWhere(" b.list_cust_yn= 'Y'");
list.addWhere(" a.member_no in ("+test02+")");
if(!s_sdate.equals(""))list.addWhere(" a.cont_date >= '"+s_sdate.replaceAll("-","")+"'");
if(!s_edate.equals(""))list.addWhere(" a.cont_date <= '"+s_edate.replaceAll("-","")+"'");
list.addSearch("a.member_no", f.get("s_main_member_no"));
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
list.addSearch("a.status", f.get("s_status"));
list.setOrderBy("a.cont_no desc, a.cont_chasu asc");


DataSet ds = list.getDataSet();
while(ds.next()){
	if(ds.getInt("cont_chasu")>0){
		if(!u.request("mode").equals("excel")){
			ds.put("cont_name", "<img src='../html/images/re.jpg' align='absmiddle'> " +ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"차)");
		}else{
			ds.put("cont_name", "└ " +ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"차)");
		}
	}
	if(ds.getInt("cust_cnt")-2>0){
		ds.put("cust_name", ds.getString("member_name")+ "외"+(ds.getInt("cust_cnt")-2)+"개사");
	}else{
		ds.put("cust_name", ds.getString("member_name"));
	}
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("cont_sdate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_sdate")));
	ds.put("cont_edate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_edate")));
	ds.put("status", u.getItem(ds.getString("status"),code_status));
	ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
}



if(u.request("mode").equals("excel")){
	p.setVar("title", "계약진행현황");
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("계약진행현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/contract_view_list_excel.html"));
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_view_list_new");
p.setVar("menu_cd","000073");
p.setLoop("test02", Test02);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>