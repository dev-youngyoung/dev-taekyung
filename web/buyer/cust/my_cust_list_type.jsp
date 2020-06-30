<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_client_type = null;
String[] code_cmp_typ = {"7=>휴업","8=>폐업"};
String client_type = u.request("s_client_type", "");  // 거래처 타입.
String sClientWhere = "";
if(_member_no.equals("20130400091")) // 대보정보통신
{
	code_client_type = new String[]{"0=>물품","1=>용역"};
	p.setVar("menu_cd","000082");
	p.setVar("view_cust_type", true);  // 업체유형 검색 조건 보기
}
else if(_member_no.equals("20150200088"))  // 코스모코스
{
	code_client_type = new String[]{"0=>원자재","1=>외주","2=>부자재"};
	p.setVar("menu_cd","000082");
	p.setVar("view_cust_type", true);  // 업체유형 검색 조건 보기
}
else if(u.inArray(_member_no, new String[]{"20121200116", "20140101025", "20120200001","20170101031","20121204063","20170602171"}))  // 한국제지, 신세계, 테스트, 홈플러스//대림씨엔에스
{
	code_client_type = new String[]{"0=>물품","1=>공사","2=>용역"};
	p.setVar("menu_cd","000082");
	p.setVar("view_cust_type", true);  // 업체유형 검색 조건 보기
}
else if(_member_no.equals("20130400333"))  // CJ대한통운
{
	code_client_type = new String[]{"0=>수송","1=>구매","2=>공사"};
	p.setVar("menu_cd","000082");
	p.setVar("view_cust_type", true);  // 업체유형 검색 조건 보기
}
else // 3M, 한국유리공업
{
	if(client_type.equals("")) client_type = "0"; // 기본값이 없으면 협력업체
	p.setVar("view_cust_type", false);
	code_client_type = new String[]{"0=>공급사","1=>판매(대리)점"};
	if(client_type.equals("1"))
	{
		p.setVar("menu_cd","000090");
	} else {
		p.setVar("menu_cd","000082");
	}
}
if(!client_type.equals("")){
	sClientWhere = " a.client_type like '%"+client_type+"%'";
}

//신용평가연계
boolean isCredit = u.inArray(_member_no, new String[]{"20121204063"}); // 홈플러스
String auth_key = "";
String auth_cd = "";
if(isCredit) {
	if(_member_no.equals("20121204063")) { // 홈플러스
		auth_cd = "778"; // clp_cd
		auth_key = "4d456c68555468654b56387a6148466d646d396f55673d3d";//  암호화키
	}
}


f.addElement("s_client_type", client_type, null);
f.addElement("s_member_name",null, null);


String table = "tcb_client a, tcb_member b inner join tcb_person c on b.member_no=c.member_no";
String column = "a.* "
		+	",b.vendcd "
		+	",b.member_name "
		+	",b.boss_name "
		+	",b.member_gubun"
		+	",c.email"
		+	",c.user_name"				
		+	",decode(b.status,'01','정회원','02','비회원','00','탈퇴') status_nm"
		+	",c.tel_num"
		+	",c.hp1, c.hp2, c.hp3"
		+	",c.fax_num"; 
if(u.request("mode").equals("excel")){
	column += ",b.address";
}

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



//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:15);
list.setTable(table);
list.setFields(column);
list.addWhere(" a.member_no = '"+_member_no+"'");
list.addWhere("	a.client_no = b.member_no ");
list.addWhere("	(a.client_reg_cd = '1' or a.client_reg_cd is null) ");
list.addWhere("	c.default_yn = 'Y' ");

if(!sClientWhere.equals(""))
	list.addWhere(sClientWhere);  // 거래처 타입

list.addWhere("	b.member_gubun != '04' ");
if(!f.get("s_member_name").equals("")){
	list.addWhere(" upper(b.member_name) like upper('%"+f.get("s_member_name")+"%')");
}
list.setOrderBy("client_seq desc");


DataSet 	ds 				= list.getDataSet();
Security	security	=	new	Security();
String		sJuminNo	=	"";

if(u.request("mode").equals("excel")){
	while(ds.next())
	{
		
		ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
		ds.put("client_type", u.getItems(ds.getString("client_type"), code_client_type));
		ds.put("client_status", ds.getString("status").equals("90")?"거래정지":"-");
		ds.put("temp_yn", ds.getString("temp_yn").equals("Y")?"일회성업체":"-");
	}

	String fileName = "";
	fileName = "거래처.xls";
	p.setLoop("list", ds);
	p.setVar("view_clienttype", true);
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
	ds.put("check_status", ds.getString("status").equals("90")?"checked":"");
	ds.put("temp_checked", ds.getString("temp_yn").equals("Y")?"checked":"");
	ds.put("cust_detail_code", ds.getString("cust_detail_code").equals("")?"<span style=\"color:red\">미등록</span>":ds.getString("cust_detail_code"));
	ds.put("client_type", u.getItems(ds.getString("client_type"), code_client_type));
}


p.setLayout("default");
p.setDebug(out);
p.setBody("cust.my_cust_list_type");
if(client_type.equals("1")){
	//대리점 조회
	p.setVar("menu_cd","000090");
	p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000090", "btn_auth").equals("10"));	
}else{
	//협력업체 조회
	p.setVar("menu_cd","000089");
	p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000089", "btn_auth").equals("10"));
}
p.setVar("auth_form", false);
p.setLoop("code_client_type", u.arr2loop(code_client_type));
p.setVar("isCredit", isCredit);
p.setLoop("list", ds);
p.setVar("isExcel", true);  // 일반사용자는 엑셀다운 못함
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>