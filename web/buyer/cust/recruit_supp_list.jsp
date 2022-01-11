<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String seq = u.request("seq");
if(seq.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}


DataObject recruitDao = new DataObject("tcb_recruit");
DataSet recruit = recruitDao.find("member_no = '"+_member_no+"' and seq = '"+seq+"' ");
if(!recruit.next()){
	u.jsError("공고 정보가 없습니다.");
	return;
}

DataObject categoryDao =  new DataObject("tcb_recruit_category");
DataSet category = categoryDao.find("member_no = '"+_member_no+"' and seq = '"+seq+"' ");

f.addElement("s_vendnm",null, null);
f.addElement("s_vendcd",null, null);
f.addElement("s_category",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:10);
list.setTable(" tcb_recruit_supp a");
list.setFields(" a.*");
list.addWhere(" a.member_no = '"+_member_no+"'");
list.addSearch("a.vendcd", f.get("s_vendcd").replaceAll("-", ""));
list.addSearch("a.vendnm", f.get("s_vendnm"), "LIKE");
if(f.getArr("s_category")!=null){
	String[] s_cate = f.getArr("s_category");
	String codes =  "";
	for(int i = 0 ; i < s_cate.length ; i++){
		if(!codes.equals(""))codes+=",";
		codes+="'"+s_cate[i]+"'";
	}
	list.addWhere(" vendcd in ( select vendcd from tcb_recruit_supp_category where member_no = a.member_no and seq = a.seq and code in ("+codes+"))");
}
list.setOrderBy(" a.seq desc");

DataSet ds = list.getDataSet();
while(ds.next()){
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	ds.put("capital", u.numberFormat(ds.getLong("capital")));
	ds.put("sales_amt", u.numberFormat(ds.getLong("sales_amt")));
	ds.put("reg_date", u.getTimeString("yyyy-MM-dd", ds.getString("reg_date")));
	String category_nm = "";
	DataSet cateSupp = categoryDao.query(
			 "select code_name                                          "
			+" from tcb_recruit_supp_category a, tcb_recruit_category b "
			+"where a.member_no = b.member_no                           "
			+"  and a.seq = b.seq                                       "
			+"  and a.code = b.code                                     "
			+"  and a.member_no = '"+_member_no+"'                      "
			+"  and a.seq = '"+seq+"'                                   "
			+"  and a.vendcd = '"+ds.getString("vendcd").replaceAll("-","")+"'"
			);
	while(cateSupp.next()){
		if(!category_nm.equals(""))category_nm+=", ";
		category_nm+= "<nobr>"+cateSupp.getString("code_name")+"</nobr>";
	}
	ds.put("category", category_nm);
}

if(u.request("mode").equals("excel")){
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("협력업체모집현황.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/cust/recruit_supp_list_excel.html"));
	return;
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.recruit_supp_list");
p.setVar("menu_cd","000096");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000096", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("category", category);
p.setLoop("list", ds);
p.setVar("s_categorys", u.join(",",f.getArr("s_category")));
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no, seq"));
p.setVar("form_script",f.getScript());
p.display(out);

%>