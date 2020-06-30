<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_client_type = {"1=>등록업체","2=>협력업체"};
String[] code_client_reg_cd = {"0=>가등록","1=>정식등록"};

String client_type = u.request("client_type");
if(client_type.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

String s_client_reg_cd = client_type.equals("1")?u.request("s_client_reg_cd", "1"):u.request("s_client_reg_cd");

f.addElement("s_client_reg_cd", s_client_reg_cd, null);
f.addElement("s_member_name",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:15);
list.setTable("tcb_client a, tcb_member b inner join tcb_person c on b.member_no=c.member_no ");
list.setFields(		"a.* "
				+	",b.vendcd "
				+	",b.member_name"
				+	",b.boss_name"
				+	",b.member_gubun"
				+	",b.address"
				+	",c.email"
				+	",c.user_name"				
				+	",decode(b.status,'01','정회원','02','비회원','00','탈퇴') status_nm"
				+	",c.tel_num"
				+	",c.hp1, c.hp2, c.hp3"
				);
list.addWhere(" a.member_no = '"+_member_no+"'");
list.addWhere(" a.client_type = '"+client_type+"' ");
list.addWhere("	a.client_no = b.member_no ");
list.addWhere("	c.default_yn = 'Y' ");
list.addWhere("	b.member_gubun != '04' ");
list.addSearch(" a.client_reg_cd", s_client_reg_cd);
if(!f.get("s_member_name").equals("")){
	list.addWhere(" upper(b.member_name) like upper('%"+f.get("s_member_name")+"%')");
}
list.setOrderBy("client_seq desc");

DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	ds.put("client_reg_cd_nm", u.getItems(ds.getString("client_reg_cd"), code_client_reg_cd));
	if(u.request("mode").equals("excel")){
		DataObject admDao = new DataObject("tcb_src_adm");
		String src_nm = ""; 
				DataSet src = admDao.query(
				 "select  l_src_nm || decode(m_src_nm,null,null, '>') ||m_src_nm|| decode(s_src_nm,null,null, '>')||s_src_nm  as src_nm"
				+"  from ("
				+"    select "
				+"           (select src_nm from tcb_src_adm where member_no = a.member_no and l_src_cd = a.l_src_cd and m_src_cd = '000'  and s_src_cd = '000' and l_src_cd <> '000') l_src_nm "
				+"         , (select src_nm from tcb_src_adm where member_no = a.member_no and l_src_cd = a.l_src_cd and m_src_cd = a.m_src_cd  and s_src_cd = '000' and m_src_cd<>'000') m_src_nm "
				+"         , (select src_nm from tcb_src_adm where member_no = a.member_no and l_src_cd = a.l_src_cd and m_src_cd = a.m_src_cd  and s_src_cd = a.s_src_cd and s_src_cd<> '000') s_src_nm " 
				+"     from tcb_src_adm  a, tcb_src_member b "
				+"  where a.member_no = b.member_no "
				+"      and a.src_cd = b.src_cd "
				+"      and b.member_no = '"+_member_no+"' "
				+"      and b.src_member_no = '"+ds.getString("client_no")+"' "
				+" ) "
				);
		while(src.next()){
			if(!src_nm.equals(""))src_nm+="<br>";
			src_nm += src.getString("src_nm");
		}
		ds.put("src_nm", src_nm);
	}
}

if(u.request("mode").equals("excel")){
	
	String title = "";
	
	if(client_type.equals("1"))
		title = "등록업체현황";
	else
		title = "협력업체현황";
	
	p.setLoop("list", ds);
	p.setVar("title", title);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String((title + ".xls").getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/cust/nhqv_cust_list_excel.html"));
	return;
}


p.setLayout("default");
p.setDebug(out);
p.setBody("cust.nhqv_cust_list_type");
if(client_type.equals("1")){// 1:등록업체 2:협력업체
	p.setVar("menu_cd","000091");
	p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000091", "btn_auth").equals("10"));
}else{
	p.setVar("menu_cd","000092");
	p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000092", "btn_auth").equals("10"));
}
p.setVar("auth_form", false);
p.setLoop("code_client_reg_cd", u.arr2loop(code_client_reg_cd));
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>