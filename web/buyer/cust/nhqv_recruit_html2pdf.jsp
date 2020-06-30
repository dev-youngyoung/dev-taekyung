<%@page import="nicelib.pdf.PDFWaterMark"%>
<%@page import="org.zefer.pd4ml.*"%>
<%@page import="java.awt.*"%>
<%@ page import="org.jsoup.Jsoup,org.jsoup.nodes.Document,org.jsoup.nodes.Element,org.jsoup.select.Elements"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String gubun = u.aseDec(u.request("gubun")) ;
String noti_seq = u.aseDec(u.request("noti_seq")) ;
String member_no = u.aseDec(u.request("member_no")) ;
String ci_img = u.request("ci_img");
String down_file_name = u.request("down_file_name");
if(noti_seq.equals("")||member_no.equals("")){
	u.jsErrClose("정상적인 경로로 접근하여 주세요.");
	return;
}

if(!ci_img.equals("")) ci_img = u.aseDec(ci_img);
if(!down_file_name.equals("")) down_file_name = u.aseDec(down_file_name);

DataObject custDao = new DataObject("tcb_recruit_cust");
DataSet cust = custDao.find("member_no = '20160901598' and noti_seq = '"+noti_seq+"' and client_no= '"+member_no+"'");
if(!cust.next()){
	u.jsError("신청서 정보가 없습니다.");
	return;
}

String __html = "";
if(gubun.equals("req")){
	__html = cust.getString("req_html");
}else{
	__html = cust.getString("evaluate_html");
	String etc_html = 
	 "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" class=\"lineTable\" style='margin-top:2px'>"
	+"<colgroup><col width='25%'><col width='75%'></colgrup>"
	+"<tr>"
	+"<td style=\"padding:3px\" align=\"center\">기타평가사항</td>"
	+"<td style=\"padding:3px\" >"+u.nl2br(cust.getString("evaluate_etc"))+"</td>"
	+"</tr>"
	+"</table>";
	__html += etc_html;
}


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
html.append(removeHtml(__html));
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
//footerMark.setHtmlTemplate("");

pd4ml.setPageFooter(footerMark);
pd4ml.setPageInsets(new Insets(10,20,5,20));						//여백설정
pd4ml.setHtmlWidth(750);									//변환할 html의 width 정보
pd4ml.setPageSize(PD4Constants.A4);									//용지모양 A4설정
//pd4ml.setPageSize(pd4ml.changePageOrientation(PD4Constants.A4));	//가로로 설정
pd4ml.useTTF("java:fonts", true);									//지정한 폰트 사용
pd4ml.setDefaultTTFs("Nanum Gothic", "Times New Roman", "Arial");	//default 폰트 설정
pd4ml.enableDebugInfo();


response.setHeader("Pragma", "No-cache");
response.setDateHeader("Expires", 0);
response.setHeader("Cache-Control", "no-Cache");
response.setContentType("application/pdf");
response.setHeader("Content-Disposition", "attachment;filename="+new String((down_file_name+".pdf").getBytes("EUC-KR"), "ISO-8859-1")+";");
ByteArrayOutputStream byteOuterupStream = new ByteArrayOutputStream();
pd4ml.render(new StringReader(html.toString()), byteOuterupStream);

byte[] pdf_byte = byteOuterupStream.toByteArray();
PDFWaterMark waterMark = new PDFWaterMark();
ServletOutputStream outputStream = response.getOutputStream();
waterMark.setImage(pdf_byte,ci_img,"","","",outputStream);
byteOuterupStream.close();
outputStream.close();
%>
<%!
// input box 등을 제거
public String removeHtml(String html)
{
	String html_rm = "";
	// DB용
	Document doc = Jsoup.parse(html);
	// PDF용
	for( Element elem : doc.select("input[type=checkbox]") ){ if(elem.hasAttr("checked")) elem.parent().html("▣"); else elem.parent().html("□");  }  // 체크박스
	for( Element elem : doc.select("input[type=radio]") ){ if(elem.hasAttr("checked")) elem.parent().html("▣"); else elem.parent().html("□"); }  // 라디오
	for( Element elem : doc.select("input[type=hidden]") ){ elem.remove(); }  // input box 값 모두 제거
	for( Element elem : doc.select("input") ){ elem.parent().html(elem.val());  }  // input box 값 모두 제거
	for( Element elem : doc.select("select") ){ elem.parent().html(elem.select("option[selected]").val()); }
	for( Element elem : doc.select("textarea") ){ elem.parent().html(elem.val()); }

	html_rm = doc.toString();

	return html_rm;
}
%>
