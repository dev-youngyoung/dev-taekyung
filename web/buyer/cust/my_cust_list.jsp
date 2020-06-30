<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String custtype = u.request("custtype");  // �ŷ�ó Ÿ��. null�̸� �׳� �ŷ�ó. (1:�븮��)
String[] status_code = {"01=>��ȸ��", "02=>��ȸ��"};  // ȸ������
String[] code_cmp_typ = {"7=>�޾�","8=>���"};
//�ŷ�ó �ڵ� ����
boolean isDetailCode = u.inArray(_member_no, new String[]{"20150500312","20160401012","20171100802"});//(��)����������, ������Ÿġ���ͼַ�� �ֽ�ȸ��, NICE�������
//�������� ��ȸ (������Ÿġ)
boolean isLicense = _member_no.equals("20160401012");
boolean isCategory = _member_no.equals("20191200612");

//�ſ��򰡿���
//������  /usr/local/nicecredit/bin/nice_nicedata.sh
//���̽���غ�  /usr/local/nicednb/run.sh
boolean isCredit = u.inArray(_member_no, new String[]{"20150800539","20180100738","20121200734","20200406309"}); // ��þ, ������ũ������ڸ���(��),��������
String auth_key = "";
String auth_cd = "";
if(isCredit) {
	if(_member_no.equals("20150800539")) { // ��þ
		auth_cd = "987"; // clp_cd
		auth_key = "4b316c7a4f6e466661544e525630704f6269517151413d3d";//  ��ȣȭŰ
	}
	if(_member_no.equals("20180100738")) { // ������ũ������ڸ���(��)
		auth_cd = "1122"; // clp_cd
		auth_key = "595878564e3074314c55354b536c6851567a52395a773d3d";//  ��ȣȭŰ
	}
	if(_member_no.equals("20121200734")) { // ��������
		auth_cd = "1215"; // clp_cd
		auth_key = "627a6f77586c6c77597a343057693959536b39584b513d3d";//  ��ȣȭŰ
	}
	if(_member_no.equals("20200406309")) { // ����ġ�����̿��� �ֽ�ȸ��
		auth_cd = "1241"; // clp_cd
		auth_key = "5030745350576470504734795969465a5830353954513d3d";//  ��ȣȭŰ
	}
}

//��ü ���� ���� ����� ��� �ϴ� ���
boolean isUseClientRegcd = u.inArray( _member_no, new String[]{"20180203437","20181002679","20191200612"});//���̿��� , �����ũ����ũ,��Ʈ��


DataSet userCode = new DataSet();
if(isLicense){
	DataObject userCodeDao = new DataObject("tcb_user_code");
	userCode = userCodeDao.query(
	  " select code                            "
	 +"      , code_nm                         "
	 +"      , (select code_nm                 "
	 +"           from tcb_user_code           "
	 +"          where depth = '3'             "
	 +"            and member_no = a.member_no "
	 +"            and l_cd = a.l_cd           "
	 +"            and m_cd = a.m_cd           "
	 +"            and s_cd = a.s_cd)  s_nm    "
	 +"  from tcb_user_code a                  "
	 +" where member_no = '"+_member_no+"' "
	 +"   and depth = '4'                      "
	 +"   and use_yn = 'Y'                     "
	 +" order by a.code asc		               "
			);
	while(userCode.next()){
		userCode.put("code_nm", userCode.getString("s_nm")+">"+userCode.getString("code_nm"));
	}
}


f.addElement("s_member_name",null, null);
f.addElement("s_status", u.request("s_status"), null);
if(isDetailCode){
	f.addElement("s_cust_detail_code",null, null);
}
if(isLicense){
	f.addElement("s_tech_cd",null, null);
}
if(isCategory){
	f.addElement("s_condition",null, null);
	f.addElement("s_category",null, null);
}

String table = "tcb_client a inner join tcb_member b on a.client_no = b.member_no inner join tcb_person c on b.member_no=c.member_no";
String column = "a.client_no, a.client_seq, a.status, a.temp_yn \n"
		+	",b.vendcd \n"
		+	",b.member_name \n"
		+	",b.boss_name \n"
		+	",b.member_gubun"
		+	",b.condition"
		+	",b.category"
		+	",b.address"
		+	",b.status mstatus"
		+	",c.email"
		+	",c.user_name"
		+	",c.tel_num"
		+	",c.hp1, c.hp2, c.hp3"
	    +	",c.fax_num"
		+(isDetailCode?", (select cust_detail_code from tcb_client_detail where person_seq = '1' and member_no = a.member_no and client_seq = a.client_seq and client_detail_seq = '1') cust_detail_code":"");

if(isCredit) {
	table +=  " left outer join "
			+"    ( "
			+"        select grade, cashgrade, coop_bizno from dnb_credithist nc "
			+"        where bizno = '"+auth.getString("_VENDCD")+"' "
			+"          and udate = (  "
			+"                    select /** INDEX_DESC(PK_DNB_CREDITHIST) */ udate  "
			+"                      from dnb_credithist nb                      "
			+"                     where validdate>=TO_CHAR(sysdate, 'YYYYMMDD')  " 
			+"                       and nc.bizno=nb.bizno                       "
			+"                       and nc.coop_bizno=nb.coop_bizno             "
			+"                       and rownum=1 "
			+"                        ) "
			+"    ) d    on b.vendcd = d.coop_bizno ";

	column += ", d.grade, d.cashgrade";
}

//��� ����
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:15);
list.setTable(table);
list.setFields(column);
list.addWhere(" a.member_no = '"+_member_no+"'");

if(!custtype.equals("")) // �ŷ�ó Ÿ��
	list.addWhere(" a.client_type = '"+custtype+"'");
else
	list.addWhere(" a.client_type is null ");

list.addWhere("	b.member_gubun != '04' ");
list.addWhere("	c.default_yn = 'Y' ");
list.addWhere("	c.status = 1 ");
list.addSearch("b.member_name", f.get("s_member_name"), "LIKE");
if(!f.get("s_cust_detail_code").equals("")){
	list.addWhere(" a.client_seq in ( select client_seq from tcb_client_detail where  member_no = '"+_member_no+"' and cust_detail_code = '"+f.get("s_cust_detail_code")+"' )");
}
if(!f.get("s_tech_cd").equals("")){
	list.addWhere(" b.member_no in ( select client_no from tcb_client_tech where  member_no = '"+_member_no+"' and tech_cd = '"+f.get("s_tech_cd")+"' )");
}
list.addSearch("b.condition",f.get("s_condition"), "LIKE");
list.addSearch("b.category",f.get("s_category"), "LIKE");
if(isUseClientRegcd) list.addWhere(" (a.client_reg_cd = '1' or a.client_reg_cd is null )");
list.addSearch("b.status", f.get("s_status"), "=");
list.setOrderBy("client_seq desc");


DataSet ds = list.getDataSet();
Security security = new Security();
String sJuminNo = "";
if(u.request("mode").equals("excel")){

	while(ds.next()){
		ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
		ds.put("member_gubun_name", u.getItem(ds.getString("mstatus"), status_code));
		ds.put("client_status", ds.getString("status").equals("90")?"�ŷ�����":"-");
		ds.put("temp_yn", ds.getString("temp_yn").equals("Y")?"��ȸ����ü":"-");
	}
	String fileName = "";
	if(custtype.equals("1")) // �ŷ�ó Ÿ�� (�븮��)
		fileName = "�븮�� �����Ȳ.xls";
	else
		fileName = "���¾�ü �����Ȳ.xls";
	p.setLoop("list", ds);
	p.setVar("isDetailCode", isDetailCode);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(fileName.getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/cust/my_cust_excel.html"));
	return;
}

AesUtil au = new AesUtil();
while(ds.next()){
	ds.put("xlink",isCredit?"http://xlink.nicednb.com/weblink/toServer.do?clp_cd="+auth_cd+"&bz_ins_no=" + au.encrypt(auth_key,ds.getString("vendcd")) : "" );
	ds.put("clip_grd",isCredit?"":au.encrypt("123467890123456890",ds.getString("vendcd")));
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	ds.put("member_gubun_name", u.getItem(ds.getString("mstatus"), status_code));
	ds.put("check_status", ds.getString("status").equals("90")?"checked":"");
	ds.put("temp_checked", ds.getString("temp_yn").equals("Y")?"checked":"");
	ds.put("cust_detail_code", ds.getString("cust_detail_code").equals("")?"<span style=\"color:red\">�̵��</span>":ds.getString("cust_detail_code"));
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.my_cust_list");
p.setVar("menu_cd","000082");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000082", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.setVar("isKTH", isDetailCode);
p.setVar("isCategory", isCategory);
p.setVar("isLicense", isLicense);
p.setVar("isCredit", isCredit);
p.setLoop("userCode", userCode);
p.setLoop("status_code", u.arr2loop(status_code));
p.setVar("isExcel", auth.getString("_USER_LEVEL").equals("30")?false:true);  // �Ϲݻ���ڴ� �����ٿ� ����
p.display(out);
%>