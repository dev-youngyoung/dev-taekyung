<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] code_cmp_typ = {"7=>휴업","8=>폐업"};

f.addElement("s_member_name",null, null);
f.addElement("s_cust_code",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:15);
String sTable = "tcb_client a "
		+ "inner join tcb_member b on a.client_no = b.member_no "
		+ "left join tcb_client_detail td on td.member_no = a.member_no and td.client_seq = a.client_seq "
		+ "left join tcb_person tp on tp.member_no=td.member_no and tp.person_seq = td.person_seq";

list.setTable(sTable);
list.setFields("a.client_no"
		+	",decode(b.member_gubun,'04',(select jumin_no \n"
		+   "                               from tcb_person \n"
		+   "                              where member_no = b.member_no \n"
		+   "                                and default_yn = 'Y'),b.vendcd) vendcd \n"
		+	",NVL(td.cust_detail_name, b.member_name) cust_detail_code_name "
		+	",b.boss_name"
		+	",b.member_gubun"
		+	",td.*"
		+	",NVL(tp.user_name, '<font color=red>[미지정]</font>') user_name"
);
list.addWhere(" a.member_no = '"+_member_no+"'");
/*
if(!auth.getString("_DEFAULT_YN").equals("Y")){	// 관리자가 아니면 자기 업체만
list.addWhere(" td.person_seq = "+auth.getString("_PERSON_SEQ"));
}
*/
//list.addWhere("	b.member_gubun != '04' ");  // 사업자만..
list.addSearch("td.cust_detail_name", f.get("s_member_name"), "LIKE");
if(f.get("s_cust_code").trim().length() > 0)
	list.addSearch("td.cust_detail_code", f.get("s_cust_code"), "LIKE");
list.setOrderBy("a.client_seq desc");


DataSet 	ds 				= list.getDataSet();
Security	security	=	new	Security();
String		sJuminNo	=	"";
if(u.request("mode").equals("excel")){

	while(ds.next())
	{
		if(!ds.getString("member_gubun").equals("04"))
		{
			ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
		}else
		{
			if(ds.getString("vendcd") != null && ds.getString("vendcd").length() > 0)
			{
				sJuminNo	=	security.AESdecrypt(ds.getString("vendcd"));
				sJuminNo	=	sJuminNo.substring(0,6)	+	"-*******";
				ds.put("vendcd", sJuminNo);
				ds.put("member_name", ds.getString("member_name") + " <font style=color:#FF0000>[개인]</font>");
			}
		}
		if(ds.getString("cust_detail_code").equals(""))
			ds.put("cust_detail_code", "<a href=''><font color=red>[미등록]</font></a>");

		ds.put("status", ds.getString("status").equals("90")?"거래정지":"-");
		ds.put("temp_yn", ds.getString("temp_yn").equals("Y")?"일회성업체":"-");
	}
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("협력업체.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/cust/person_my_cust_excel.html"));
	return;
}

while(ds.next()){
	if(!ds.getString("member_gubun").equals("04"))
	{
		ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	}else
	{
		if(ds.getString("vendcd") != null && ds.getString("vendcd").length() > 0)
		{
			sJuminNo	=	security.AESdecrypt(ds.getString("vendcd"));
			sJuminNo	=	sJuminNo.substring(0,6)	+	"-*******";
			ds.put("vendcd", sJuminNo);
			ds.put("member_name", ds.getString("member_name") + " <font style=color:#FF0000>[개인]</font>");
		}
	}

	if(ds.getString("cust_detail_code").equals(""))
		ds.put("cust_detail_code", "<font color=red>[미등록]</font>");

	ds.put("check_status", ds.getString("status").equals("90")?"거래정지":"-");
	ds.put("temp_checked", ds.getString("temp_yn").equals("Y")?"일회성업체":"-");
	ds.put("cmp_typ_nm", u.getItem(ds.getString("cmp_typ"),code_cmp_typ));
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.person_my_cust_list");
p.setVar("menu_cd","000085");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000085", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("default_yn", auth.getString("_DEFAULT_YN").equals("Y") ? true : false);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>