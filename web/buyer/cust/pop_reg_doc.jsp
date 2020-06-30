<%@page import="nicelib.pdf.PDFWaterMark"%>
<%@page import="org.zefer.pd4ml.PD4Constants"%>
<%@page import="java.awt.Insets"%>
<%@page import="org.zefer.pd4ml.PD4ML"%>
<%@page import="org.zefer.pd4ml.PD4PageMark"%>
<%@page import="nicelib.pdf.PDFMaker"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String client_no = u.request("client_no");
if(member_no.equals("")||client_no.equals("")){
	u.jsErrClose("정상적인 경로로 접근하세요.");
	return;
}

DataObject clientDao = new DataObject("tcb_client");
DataSet client = clientDao.find(" member_no = '"+member_no+"' and client_no = '"+client_no+"'");
if(!client.next()){
	u.jsErrClose("거래관계 정보가 없습니다.");
	return;
}


DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
}
member.put("vendcd", u.getBizNo(member.getString("vendcd")));

DataSet c_member = memberDao.find("member_no = '"+client_no+"' ");
if(!c_member.next()){
}
c_member.put("vendcd", u.getBizNo(c_member.getString("vendcd")));


if(u.isPost()){
	
	String doc_html = f.get("doc_html");
	if(doc_html.equals("")){
		return;
	}
	doc_html = new String(Base64Coder.decode(doc_html),"UTF-8");
	
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
	
	
	PD4ML pd4ml = new PD4ML();
	
	
	PD4PageMark headerMark = new PD4PageMark();
	headerMark.setAreaHeight( 30 );				//header 영역 설정
	
	//header 데이터 셋팅
	headerMark.setHtmlTemplate("");
	pd4ml.setPageHeader(headerMark);
	
	//footer 영역설정
	PD4PageMark footerMark = new PD4PageMark();
	footerMark.setAreaHeight( 35 );
	footerMark.setHtmlTemplate("<span><font style=\"font-size:12px\" color=\"#5B5B5B\">※ 본 문서는 구매 · 조달 장터 나이스다큐(www.nicedocu.com, 일반기업용) 시스템에서 인터넷으로 출력되었습니다.</font></span>");
	
	pd4ml.setPageFooter(footerMark);
	pd4ml.setPageInsets(new Insets(10,20,5,20));						//여백설정
	pd4ml.setHtmlWidth(750);									//변환할 html의 width 정보
	pd4ml.setPageSize(PD4Constants.A4);									//용지모양 A4설정
	//pd4ml.setPageSize(pd4ml.changePageOrientation(PD4Constants.A4));	//가로로 설정
	pd4ml.useTTF("java:fonts", true);									//지정한 폰트 사용
	pd4ml.setDefaultTTFs("Nanum Gothic", "Times New Roman", "Arial");	//default 폰트 설정
	pd4ml.enableDebugInfo();
	
	ByteArrayOutputStream byteOutputStream = new ByteArrayOutputStream();
	
	pd4ml.render(new StringReader(html.toString()), byteOutputStream);
	
	
	byte[] pdf_byte = byteOutputStream.toByteArray();
	byteOutputStream.close();
	//img Setting
	String ci_img = ""; 
	/* if(!member.getString("ci_img_path").equals("")){
		ci_img = Startup.conf.getString("file.path.bcont_logo")+member.getString("ci_img_path");
	} */
	PDFWaterMark pdfWaterMake = new PDFWaterMark();
	
	

	String mimeType = "application/octet-stream";  
	response.setContentType(mimeType);
	response.setHeader("Access-Control-Allow-Credentials", "true");
	//response.setHeader("Content-Disposition", "attachment;filename="+StrUtil.ConfCharset(sFileTarFile)+"\"");
	response.setHeader("Content-Disposition", "attachment;filename=\""+new String(("협력업체등록확인증_"+c_member.getString("member_name")+".pdf").getBytes("EUC-KR"), "ISO-8859-1")+"\";");
	//response.setContentLength(fileSize);
	ServletOutputStream outputStream = response.getOutputStream();

	pdfWaterMake.setImage(pdf_byte, ci_img, "", "", "", outputStream);
	
	
	return;
}


p.setLayout("popup");
//p.setDebug(out);
p.setBody("cust.pop_reg_doc");
p.setVar("popup_title","거래처등록확인서");
p.setVar("member",member);
p.setVar("c_member",c_member);
p.setVar("han_sysdate", u.getTimeString("yyyy년 MM월 dd일"));
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("mode"));
p.setVar("form_script",f.getScript());
p.display(out);
%>