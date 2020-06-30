<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
CodeDao code = new CodeDao("tcb_comcode");
String[] code_client_type = code.getCodeArray("M210");  // 전문분야
String[] code_client_reg_cd = {"1=>정식등록","0=>가등록"};
String[] code_cmp_typ = {"7=>휴업","8=>폐업"};

f.addElement("s_member_name", null, null);
f.addElement("s_client_type", null, null);
f.addElement("s_client_reg_cd", null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:15);
list.setTable("tcb_client a inner join tcb_member b on a.client_no = b.member_no inner join tcb_person c on b.member_no=c.member_no");
list.setFields(		"a.client_no, a.client_seq, a.status, a.temp_yn, a.client_type, a.client_reg_cd \n"
		+	",decode(b.member_gubun,'04',(select jumin_no \n"
		+	"								from tcb_person \n"
		+	"							  where member_no = b.member_no \n"
		+	"								and default_yn = 'Y'),b.vendcd) vendcd \n"
		+	",b.member_name \n"
		+	",b.boss_name \n"
		+	",b.member_gubun"
		+	",b.category"
		+	",b.address"
		+	",c.email"
		+	",c.user_name"
		+	",c.tel_num"
		+	",c.hp1, c.hp2, c.hp3"
		 +	",c.fax_num"
);
list.addWhere("a.member_no = '"+_member_no+"'");
list.addWhere("b.member_gubun != '04' ");
list.addWhere("c.default_yn = 'Y' ");
list.addSearch("b.member_name", f.get("s_member_name"), "LIKE");
if(!f.get("s_client_type").equals(""))
	list.addWhere("a.client_type" + (f.get("s_client_type").equals("-1") ? " is null" : "='"+f.get("s_client_type")+"'") );
if(!f.get("s_client_reg_cd").equals(""))
	list.addWhere("a.client_reg_cd = '" + f.get("s_client_reg_cd") + "'");
list.setOrderBy("client_seq desc");

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
		ds.put("client_status", ds.getString("status").equals("90")?"거래정지":"-");
		ds.put("temp_yn", ds.getString("temp_yn").equals("Y")?"일회성업체":"-");
	}
	String fileName = "";
	fileName = "협력업체 현황.xls";
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(fileName.getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/cust/my_cust_excel.html"));
	return;
}

AesUtil au = new AesUtil();
while(ds.next()){
	if(!ds.getString("member_gubun").equals("04"))
	{
		//ds.put("clip_grd", au.encrypt("123467890123456890",ds.getString("vendcd")));
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
	ds.put("check_status", ds.getString("status").equals("90")?"checked":"");
	ds.put("temp_checked", ds.getString("temp_yn").equals("Y")?"checked":"");
	ds.put("client_type", ds.getString("client_type").equals("") ? "<font color='red'>미등록<font>" : u.getItem(ds.getString("client_type"), code_client_type));
	ds.put("client_reg_cd", "0".equals(ds.getString("client_reg_cd")) ? "<font color='red'>가등록<font>" : u.getItem(ds.getString("client_reg_cd"), code_client_reg_cd));
}


p.setLayout("default");
p.setDebug(out);
p.setBody("cust.nh_cust_list");
p.setVar("menu_cd","000083");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000083", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setLoop("code_client_type", u.arr2loop(code_client_type));
p.setLoop("code_client_reg_cd", u.arr2loop(code_client_reg_cd));
p.setVar("form_script",f.getScript());
p.setVar("isExcel", auth.getString("_USER_LEVEL").equals("30")?false:true);  // 일반사용자는 엑셀다운 못함
p.display(out);
%>