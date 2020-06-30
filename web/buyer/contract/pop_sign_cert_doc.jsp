<%@page import="nicelib.pdf.PDFWaterMark"%>
<%@page import="org.zefer.pd4ml.PD4Constants"%>
<%@page import="java.awt.Insets"%>
<%@page import="org.zefer.pd4ml.PD4PageMark"%>
<%@page import="org.zefer.pd4ml.PD4ML"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
if(cont_no.equals("")|| cont_chasu.equals("")){
	u.jsErrClose("정상적인 경로로 접근하세요.");
	return;
}

String where =" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";


DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find(where);
if(!cont.next()){
	u.jsErrClose("대상계약건이 존재 하지 않습니다.");
	return;
}


DataObject custDao =  new DataObject("tcb_cust");
DataSet cust1 = custDao.find(where);
if(!cust1.next()){
}
cont.put("member_name", cust1.getString("member_name"));
cust1.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust1.getString("sign_date")));


DataSet cust2 = custDao.find(where+" and sign_seq = '2' ","tcb_cust.*,(select member_gubun from tcb_member where member_no = tcb_cust.member_no) member_gubun");
if(!cust2.next()){
}
cont.put("cust_name", cust2.getString("user_name"));
if(cust2.getString("member_gubun").equals("03")){
	cont.put("cust_name", cust2.getString("user_name")+ " ( "+cust2.getString("member_name") +" )");
}
cust2.put("boss_birth_date", u.getTimeString("yyyy-MM-dd", cust2.getString("boss_birth_date")));
cust2.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust2.getString("sign_date")));
DataSet signInfo = u.json2Dataset(cust2.getString("sign_data"));
if(!signInfo.next()){}
cust2.put("identify_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", signInfo.getString("sSuccDate").replaceAll("[^0-9]","") ));
cust2.put("tsa_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", signInfo.getString("tsa_gentime").replaceAll("[^0-9]","") ));


DataObject contLogDao = new DataObject("tcb_cont_log");
DataSet contLog = contLogDao.query(
		 "    select a.* "
		+"         , b.member_no"
		+"         , b.member_gubun"
		+"         , b.member_name"
		+"         , (select user_name from tcb_person where member_no = a.member_no and person_seq = a.person_seq ) user_name"
		+"  from tcb_cont_log a, tcb_member b"
		+" where a.member_no = b.member_no"
		+"    and a.cont_no= '"+cont_no+"' "
		+"    and a.cont_chasu = '"+cont_chasu+"'"
		+"  order by a.log_seq  asc"
		);
DataSet logInfo = new DataSet();
while(contLog.next()){
	//생성시간 생성자 로그에서 추출
	if(contLog.getString("log_seq").equals("1")&& contLog.getString("cont_status").equals("10")){
		cont.put("reg_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", contLog.getString("log_date")));
		cont.put("reg_name", contLog.getString("user_name"));
	}
	
	//최종 전송시간 로그에서 추출
	if(contLog.getString("member_no").equals(cont.getString("member_no"))&&contLog.getString("cont_status").equals("20")){
		cust1.put("send_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", contLog.getString("log_date")));
		cust1.put("send_user_name", contLog.getString("user_name"));
	}
	if(contLog.getString("cont_status").equals("50")){
		cust1.put("sign_user_name", contLog.getString("user_name"));
	}
	
	contLog.put("log_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", contLog.getString("log_date")));
	contLog.put("proc_name", contLog.getString("user_name"));
	if(!contLog.getString("member_gubun").equals("04")){
		contLog.put("proc_name", contLog.getString("proc_name")+" ( "+contLog.getString("member_name")+" )");
	}
	
	if(contLog.getString("log_level").equals("10")){
		logInfo.addRow();
		logInfo.setRow(contLog.getRow());
	}
}

if(u.isPost()&&f.validate()){
	


String doc_html =  new String(Base64Coder.decode(f.get("doc_html_rm")),"UTF-8");
	
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
html.append(doc_html);
html.append("</body></html>");
	
DataObject memberDao = new DataObject("tcb_member");
String ci_img_path = memberDao.getOne(" select ci_img_path from tcb_member where member_no = '20151100446'");
if(!ci_img_path.equals("")){
	ci_img_path = u.aseEnc(Startup.conf.getString("file.path.bcont_logo")+ci_img_path);
}

PD4ML pd4ml = new PD4ML();


PD4PageMark headerMark = new PD4PageMark();
headerMark.setAreaHeight( 30 );				//header 영역 설정

//header 데이터 셋팅
headerMark.setHtmlTemplate("");
pd4ml.setPageHeader(headerMark);

//footer 영역설정
//PD4PageMark footerMark = new PD4PageMark();
//footerMark.setAreaHeight( 35 );
//footerMark.setHtmlTemplate("<span><font style=\"font-size:12px\" color=\"#5B5B5B\">*본 문서는 나이스다큐(http://www.nicedocu.com)를 통해 생성 되었습니다.</font></span>");20170623 이팀장님 요청으로 제거

//pd4ml.setPageFooter(footerMark);
pd4ml.setPageInsets(new Insets(10,20,5,20));						//여백설정
pd4ml.setHtmlWidth(750);									//변환할 html의 width 정보
pd4ml.setPageSize(PD4Constants.A4);									//용지모양 A4설정
//pd4ml.setPageSize(pd4ml.changePageOrientation(PD4Constants.A4));	//가로로 설정
pd4ml.useTTF("java:fonts", true);									//지정한 폰트 사용
pd4ml.setDefaultTTFs("Nanum Gothic", "Times New Roman", "Arial");	//default 폰트 설정
pd4ml.enableDebugInfo();


String mimeType = "application/octet-stream";  
response.setContentType(mimeType);
response.setHeader("Access-Control-Allow-Credentials", "true");
//response.setHeader("Content-Disposition", "attachment;filename="+StrUtil.ConfCharset(sFileTarFile)+"\"");
response.setHeader("Content-Disposition", "attachment;filename="+new String(("서명사실_확인서.pdf").getBytes("EUC-KR"), "ISO-8859-1")+";");
//response.setContentLength(fileSize);
ByteArrayOutputStream byteOuterupStream = new ByteArrayOutputStream();
pd4ml.render(new StringReader(html.toString()), byteOuterupStream);

byte[] pdf_byte = byteOuterupStream.toByteArray();
PDFWaterMark waterMark = new PDFWaterMark();
ServletOutputStream outputStream = response.getOutputStream();
waterMark.setImage(pdf_byte,ci_img_path,"","","",outputStream);
byteOuterupStream.close();
outputStream.close();
	
	
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("contract.pop_sign_cert_doc");
p.setVar("popup_title","서명사실 확인서");
p.setVar("cont", cont);
p.setVar("cust1", cust1);
p.setVar("cust2", cust2);
p.setLoop("logInfo", logInfo);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.display(out);
%>