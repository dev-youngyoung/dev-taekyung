<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="org.zefer.pd4ml.PD4ML" %>
<%@ page import="org.zefer.pd4ml.PD4PageMark" %>
<%@ page import="java.awt.*" %>
<%@ page import="org.zefer.pd4ml.PD4Constants" %>
<%@ page import="nicelib.pdf.PDFWaterMark" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

String where = "cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'";

ContractDao contDao = new ContractDao("tcb_contmaster a");
//contDao.setDebug(out);
DataSet cont = contDao.find(
	where
	,  "a.*"
	 + ", (select field_name from tcb_field where member_no  = a.member_no and field_seq = a.field_seq) field_name"
	 + ", (select user_name from tcb_person where member_no = a.member_no and user_id = a.reg_id) reg_name"
	 + ", (select template_cd from tcb_contmaster where cont_no = a.cont_no and cont_chasu = '0') org_template_cd"
);
if(!cont.next()){
	u.jsError("계약정보가 존재 하지 않습니다.");
	return;
}

//계약업체 조회
DataObject custDao = new DataObject("tcb_cust");
DataSet cust1 = custDao.find(where + " and member_no = '"+cont.getString("member_no")+"' ");
if(!cust1.next()){}
DataSet cust2 = custDao.find(where + " and member_no <> '"+cont.getString("member_no")+"' ");
if(!cust2.next()){}
cust2.put("vendcd", u.getBizNo(cust2.getString("vendcd")));

//거래형태
String[] code_bis_type = {
		 "2018257=>1"//직매입 표준거래계약서
		,"2018260=>2"//특약매입 표준거래계약서
		,"2019001=>3"//단기특약매입 표준거래계약서
		,"2017232=>4"//급식용 하나가득 PB계약서
		,"2018071=>4"//(축산)PB상품_거래계약서
};
cont.put("bis_type", u.getItem(cont.getString("org_template_cd"), code_bis_type));

//계약구분
String[] code_cont_type = {
	//신규계약
	 "2018257=>1"//직매입 표준거래계약서
	,"2018260=>1"//특약매입 표준거래계약서
	,"2019001=>2"//단기특약매입 표준거래계약서
	,"2017232=>"//급식용 하나가득 PB계약서
	,"2018071=>"//(축산)PB상품_거래계약서
	//재계약
	,"2018026=>3"//추가약정서(정규)
	,"2017286=>4"//추가약정서(행사)
	,"2018165=>4"//단기행사 재계약서(가공·생필·특산)
	,"2019278=>3"//추가약정서(신규)
};
cont.put("cont_type", u.getItem(cont.getString("template_cd"), code_cont_type));

cont.put("cont_sdate", u.getTimeString("yyyy-MM-dd", cont.getString("cont_sdate") ));
cont.put("cont_edate", u.getTimeString("yyyy-MM-dd", cont.getString("cont_edate") ));


//취급품목
String[] code_item_name = {
		//신규계약
		"2018257=>input_contract_a3"//직매입 표준거래계약서
		,"2018260=>input_contract_a3"//특약매입 표준거래계약서
		,"2019001=>input_contract_a3"//단기특약매입 표준거래계약서
		,"2017232=>"//급식용 하나가득 PB계약서
		,"2018071=>"//(축산)PB상품_거래계약서
		//재계약
		,"2018026=>a7"//추가약정서(정규)
		,"2017286=>a7"//추가약정서(행사)
		,"2018165=>input_contract_a3"//단기행사 재계약서(가공·생필·특산)
		,"2019278=>a12"//추가약정서(신규)
};
if(!u.getItem(cont.getString("template_cd"), code_item_name).equals("")){
	JsoupUtil jutil = new JsoupUtil(cont.getString("cont_html"));
	cont.put("item_name", jutil.getValue(u.getItem(cont.getString("template_cd"), code_item_name)));

}else if(!u.getItem(cont.getString("org_template_cd"), code_item_name).equals("")){
	DataSet tempCont = contDao.find(" cont_no = '"+cont.getString("cont_no")+"' and cont_chasu = '0' ");
	tempCont.next();
	JsoupUtil jutil = new JsoupUtil(tempCont.getString("cont_html"));
	cont.put("item_name", jutil.getValue(u.getItem(tempCont.getString("template_cd"), code_item_name)));
}

//물류대행수수료
String[] code_logis_fee = {
		//신규계약
		"2018257=>2|a7"//직매입 표준거래계약서
};
if(!u.getItem(cont.getString("template_cd"), code_logis_fee).equals("")){
	DataObject contSubDao = new DataObject("tcb_cont_sub");
	DataSet contSub = contSubDao.find("cont_no = '"+cont.getString("cont_no")+"' and cont_chasu = '"+cont.getString("cont_chasu")+"' and sub_seq = '2' and option_yn in ('A','Y')");
	if(contSub.next()){
		JsoupUtil jutil = new JsoupUtil(cont.getString("cont_html"));
		cont.put("logis_fee", jutil.getValue(u.getItem(cont.getString("template_cd"), code_logis_fee))+"%(VAT포함)");
	}
}else if(!u.getItem(cont.getString("org_template_cd"), code_logis_fee).equals("")){
	DataObject contSubDao = new DataObject("tcb_cont_sub");
	DataSet contSub = contSubDao.find("cont_no = '"+cont.getString("cont_no")+"' and cont_chasu = '0' and sub_seq = '2' and option_yn in ('A','Y')");
	if(contSub.next()){
		JsoupUtil jutil = new JsoupUtil(cont.getString("cont_html"));
		cont.put("logis_fee", jutil.getValue(u.getItem(cont.getString("org_template_cd"), code_logis_fee))+"%(VAT포함)");
	}
}


//취급수수료
String[] code_handling_fee = {
		//신규계약
		"2018257=>11|cont_text_01"//직매입 표준거래계약서
};
if(!u.getItem(cont.getString("template_cd"), code_handling_fee).equals("")){
	String input_name = "cont_text_01";
	DataObject contSubDao = new DataObject("tcb_cont_sub");
	DataSet contSub = contSubDao.find("cont_no = '"+cont.getString("cont_no")+"' and cont_chasu = '"+cont.getString("cont_chasu")+"' and sub_seq = '11' and option_yn in ('A','Y')");
	if(contSub.next()){
		JsoupUtil jutil = new JsoupUtil(contSub.getString("cont_sub_html"));
		cont.put("handling_fee", jutil.getValue(input_name)+"%(VAT별도)");
	}
}else if(!u.getItem(cont.getString("org_template_cd"), code_handling_fee).equals("")){
	String input_name = "cont_text_01";
	DataObject contSubDao = new DataObject("tcb_cont_sub");
	DataSet contSub = contSubDao.find("cont_no = '"+cont.getString("cont_no")+"' and cont_chasu = '0' and sub_seq = '11' and option_yn in ('A','Y')");
	if(contSub.next()){
		JsoupUtil jutil = new JsoupUtil(contSub.getString("cont_sub_html"));
		cont.put("handling_fee", jutil.getValue(input_name)+"%(VAT별도)");
	}
}


//대금결제일
String[] code_pay_date = {
		//신규계약
		"2018257=>contract_input_a1"//직매입 표준거래계약서
		,"2018260=>contract_input_a1"//특약매입 표준거래계약서
		,"2019001=>a6"//단기특약매입 표준거래계약서
		,"2017232=>input_contract_a3"//급식용 하나가득 PB계약서
		,"2018071=>select_contract_a1"//(축산)PB상품_거래계약서
};
if(!u.getItem(cont.getString("template_cd"), code_pay_date).equals("")){
	JsoupUtil jutil = new JsoupUtil(cont.getString("cont_html"));
	cont.put("pay_date", jutil.getValue(u.getItem(cont.getString("template_cd"), code_pay_date)));

}else if(!u.getItem(cont.getString("org_template_cd"), code_pay_date).equals("")){
	DataSet tempCont = contDao.find(" cont_no = '"+cont.getString("cont_no")+"' and cont_chasu = '0' ");
	tempCont.next();
	JsoupUtil jutil = new JsoupUtil(tempCont.getString("cont_html"));
	cont.put("pay_date", jutil.getValue(u.getItem(tempCont.getString("template_cd"), code_pay_date)));

}

//PL보험기간
DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find("cont_no = '"+cont.getString("cont_no")+"' and warr_type = '70' and warr_edate >= '"+u.getTimeString("yyyyMMdd")+"' ","*" ," cont_chasu desc");
if(warr.next()){
	cont.put("warr_sdate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_sdate")));
	cont.put("warr_edate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_edate")));
	cont.put("warr_syear", warr.getString("warr_sdate").substring(0,4));
	cont.put("warr_smonth", warr.getString("warr_sdate").substring(4,6));
	cont.put("warr_sday", warr.getString("warr_sdate").substring(6));
	cont.put("warr_eyear", warr.getString("warr_edate").substring(0,4));
	cont.put("warr_emonth", warr.getString("warr_edate").substring(4,6));
	cont.put("warr_eday", warr.getString("warr_edate").substring(6));
}

//판매매장
String[] code_store_name = {
		//신규계약
		 "2018260=>2|store_name,store_floor"//특약매입 표준거래계약서
		,"2019001=>2|store_name,store_floor"//단기특약매입 표준거래계약서
		//재계약
		,"2018026=>2|store_name,store_floor"//추가약정서(정규)
		,"2017286=>2|store_name,store_floor"//추가약정서(행사)
		,"2018165=>2|store_name,store_floor"//단기행사 재계약서(가공·생필·특산)
		,"2019278=>2|store_name,store_floor"//추가약정서(신규)
};
if(!u.getItem(cont.getString("template_cd"), code_store_name).equals("")){
	DataObject contSubDao = new DataObject("tcb_cont_sub");
	DataSet contSub = contSubDao.find("cont_no = '"+cont.getString("cont_no")+"' and cont_chasu = '"+cont.getString("cont_chasu")+"' and sub_seq = '2' and option_yn in ('A','Y')");
	if(contSub.next()){
		JsoupUtil jutil = new JsoupUtil(contSub.getString("cont_sub_html"));
		String[] store_names = jutil.getValue("store_name",",").split(",");
		String[] store_floor = jutil.getValue("store_floor",",").split(",");
		String store_name = "";
		for(int i = 0 ; i < store_names.length;i++){
			if(store_names[i].equals("")) continue;
			if(!store_name.equals("")) store_name+="/";
			store_name += store_names[i]+"("+store_floor[i]+"층)";
		}
		cont.put("store_name", store_name);
	}
}else if(!u.getItem(cont.getString("org_template_cd"), code_store_name).equals("")){

	DataObject contSubDao = new DataObject("tcb_cont_sub");
	DataSet contSub = contSubDao.find("cont_no = '"+cont.getString("cont_no")+"' and cont_chasu = '0' and sub_seq = '2' and option_yn in ('A','Y')");
	if(contSub.next()){
		JsoupUtil jutil = new JsoupUtil(contSub.getString("cont_sub_html"));
		String[] store_names = jutil.getValue("store_name",",").split(",");
		String[] store_floor = jutil.getValue("store_floor",",").split(",");
		String store_name = "";
		for(int i = 0 ; i < store_names.length;i++){
			if(store_names[i].equals("")) continue;
			if(!store_name.equals("")) store_name+="/";
			store_name += store_names[i]+"("+store_floor[i]+"층)";
		}
		cont.put("store_name", store_name);
	}
}

f.addElement("logis_fee",cont.getString("logis_fee").equals("")?null:cont.getString("logis_fee"), "hname:'물류대행수수료율'");
f.addElement("handling_fee",cont.getString("handling_fee").equals("")?null:cont.getString("handling_fee"), "hname:'취급수수료율'");
f.addElement("pay_date",cont.getString("pay_date"), "hname:'대금결제일'");
f.addElement("warr_syear",cont.getString("warr_syear"), "hname:'PL보험가입기간'");
f.addElement("warr_smonth",cont.getString("warr_smonth"), "hname:'PL보험가입기간'");
f.addElement("warr_sday",cont.getString("warr_sday"), "hname:'PL보험가입기간'");
f.addElement("warr_eyear",cont.getString("warr_eyear"), "hname:'PL보험가입기간'");
f.addElement("warr_emonth",cont.getString("warr_emonth"), "hname:'PL보험가입기간'");
f.addElement("warr_eday",cont.getString("warr_eday"), "hname:'PL보험가입기간'");
f.addElement("store_name",cont.getString("store_name"), "hname:'판매매장'");

if(u.isPost()) {

	String cont_html_rm = new String(Base64Coder.decode(f.get("cont_html_rm")),"UTF-8");;
	String file_name = "상품구매 약정 체결건의서.pdf";


	StringBuffer html = new StringBuffer();
	html.append("<html><head><style type=\"text/css\">");
	html.append("<!--");
	html.append("		td {  font-family: \"나눔고딕\",\"Arial\"; font-size: 12px; font-style: normal; letter-spacing:0; color: black;line-height:150%}");
	html.append("		.lineTable { border-collapse:collapse; border:1 solid black }");
	html.append("		.lineTable td { border:1 solid black }");
	html.append("		.lineTable .noborder { border:0 }");
	html.append("-->");
	html.append("</style>");
	html.append("</head><body>");
	html.append(cont_html_rm);
	html.append("</body></html>");

	PD4ML pd4ml = new PD4ML();


	PD4PageMark headerMark = new PD4PageMark();
	headerMark.setAreaHeight( 30 );				//header 영역 설정

	//header 데이터 셋팅
	headerMark.setHtmlTemplate("");
	pd4ml.setPageHeader(headerMark);

	//footer 영역설정
	//PD4PageMark footerMark = new PD4PageMark();
	//footerMark.setAreaHeight( 35 );
	//footerMark.setHtmlTemplate("<span><font style=\"font-size:12px\" color=\"#5B5B5B\">*본 문서는 나이스다큐(http://www.nicedocu.com)를 통해 생성 되었습니다.</font></span>");

	//pd4ml.setPageFooter(footerMark);
	pd4ml.setPageInsets(new Insets(10,20,5,20));						//여백설정
	pd4ml.setHtmlWidth(750);									//변환할 html의 width 정보
	pd4ml.setPageSize(PD4Constants.A4);									//용지모양 A4설정
	pd4ml.useTTF("java:fonts", true);									//지정한 폰트 사용
	pd4ml.setDefaultTTFs("Nanum Gothic", "Times New Roman", "Arial");	//default 폰트 설정
	pd4ml.enableDebugInfo();


	String mimeType = "application/octet-stream";
	response.setContentType(mimeType);
	response.setHeader("Access-Control-Allow-Credentials", "true");
	response.setHeader("Content-Disposition", "attachment;filename="+new String((file_name+".pdf").getBytes("EUC-KR"), "ISO-8859-1")+";");
	ByteArrayOutputStream byteOuterupStream = new ByteArrayOutputStream();
	pd4ml.render(new StringReader(html.toString()), byteOuterupStream);

	byte[] pdf_byte = byteOuterupStream.toByteArray();
	PDFWaterMark waterMark = new PDFWaterMark();
	ServletOutputStream outputStream = response.getOutputStream();
	waterMark.setImage(pdf_byte,"","","","",outputStream);
	byteOuterupStream.close();
	outputStream.close();



	return;
}



p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_nhhanaro_buy_report");
p.setVar("popup_title","상품구매 약정 체결건의서");
p.setVar("cont", cont);
p.setVar("cust2", cust2);
p.setVar("print_date", Util.getTimeString("yyyy년 MM월 dd일"));
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>
