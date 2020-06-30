<%@page import="nicelib.pdf.PDFWaterMark"%>
<%@page import="org.zefer.pd4ml.*"%>
<%@page import="java.awt.*"%>
<%@ page import="org.jsoup.Jsoup,org.jsoup.nodes.Document,org.jsoup.nodes.Element,org.jsoup.select.Elements"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String asse_no = u.request("asse_no");
String div_cd = u.request("div_cd");
String ci_img = u.request("ci_img");
String stamp_img = u.request("stamp_img");
String footer_img = u.request("footer_img");
String down_file_name = u.request("down_file_name");
if(asse_no.equals("")){
	//u.jsError("�������� ��η� �����ϼ���.");
	return;
}

if(!ci_img.equals("")) ci_img = u.aseDec(ci_img);
if(!stamp_img.equals("")) stamp_img = u.aseDec(stamp_img);
if(!footer_img.equals("")) footer_img = u.aseDec(footer_img);
if(!down_file_name.equals("")) down_file_name = u.aseDec(down_file_name);

DataObject asseDao = new DataObject("tcb_assemaster");
DataSet asse = asseDao.find("main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"' ");
if(!asse.next()){
	u.jsError("�򰡰�ȹ ������ �����ϴ�.");
	return;
}

DataObject detailDao = new DataObject("tcb_assedetail");
DataSet detail = detailDao.find(" asse_no = '"+asse_no+"' and div_cd = '"+div_cd+"'");
if(!detail.next()){
	u.jsError("�򰡻� ������ �����ϴ�.");
	return;
}



StringBuffer html = new StringBuffer();
html.append("<html><head><style type=\"text/css\">");
html.append("<!--");
html.append("		td {  font-family: \"�������\",\"Arial\"; font-size: 12px; font-style: normal; letter-spacing:0; color: black;line-height:150%}");
html.append("		.lineTable { border-collapse:collapse; border:1 solid black }");
html.append("		.lineTable td { border:1 solid black }");
html.append("		.lineTable .noborder { border:0 }");	
html.append("-->");
html.append("</style>");
html.append("</head><body>");
html.append(removeHtml(detail.getString("asse_html")));
html.append("</body></html>");


PD4ML pd4ml = new PD4ML();


PD4PageMark headerMark = new PD4PageMark();
headerMark.setAreaHeight( 30 );				//header ���� ����

//header ������ ����
headerMark.setHtmlTemplate("");
pd4ml.setPageHeader(headerMark);

//footer ��������
//PD4PageMark footerMark = new PD4PageMark();
//footerMark.setAreaHeight( 35 );
//footerMark.setHtmlTemplate("<span><font style=\"font-size:12px\" color=\"#5B5B5B\">*�� ������ ���̽���ť(http://www.nicedocu.com)�� ���� ���� �Ǿ����ϴ�.</font></span>");20170623 ������� ��û���� ����

//pd4ml.setPageFooter(footerMark);
pd4ml.setPageInsets(new Insets(10,20,5,20));						//���鼳��
pd4ml.setHtmlWidth(750);									//��ȯ�� html�� width ����
pd4ml.setPageSize(PD4Constants.A4);									//������� A4����
//pd4ml.setPageSize(pd4ml.changePageOrientation(PD4Constants.A4));	//���η� ����
pd4ml.useTTF("java:fonts", true);									//������ ��Ʈ ���
pd4ml.setDefaultTTFs("Nanum Gothic", "Times New Roman", "Arial");	//default ��Ʈ ����
pd4ml.enableDebugInfo();


String mimeType = "application/octet-stream";  
response.setContentType(mimeType);
response.setHeader("Access-Control-Allow-Credentials", "true");
//response.setHeader("Content-Disposition", "attachment;filename="+StrUtil.ConfCharset(sFileTarFile)+"\"");
response.setHeader("Content-Disposition", "attachment;filename="+new String((down_file_name+".pdf").getBytes("EUC-KR"), "ISO-8859-1")+";");
//response.setContentLength(fileSize);
ByteArrayOutputStream byteOuterupStream = new ByteArrayOutputStream();
pd4ml.render(new StringReader(html.toString()), byteOuterupStream);

byte[] pdf_byte = byteOuterupStream.toByteArray();
PDFWaterMark waterMark = new PDFWaterMark();
ServletOutputStream outputStream = response.getOutputStream();
waterMark.setImage(pdf_byte,ci_img,stamp_img,"",footer_img,outputStream);
byteOuterupStream.close();
outputStream.close();
%>
<%!
// input box ���� ����
public String removeHtml(String html)
{
	String html_rm = "";
	// DB��
	Document doc = Jsoup.parse(html);
	// PDF��
	for( Element elem : doc.select("input[type=checkbox]") ){ if(elem.hasAttr("checked")) elem.parent().text("��"); else elem.parent().text("��");  }  // üũ�ڽ�
	for( Element elem : doc.select("input[type=radio]") ){ if(elem.hasAttr("checked")) elem.parent().text("��"); else elem.parent().text("��"); }  // ����
	for( Element elem : doc.select("input") ){ elem.parent().text(elem.val()); }  // input box �� ��� ����
	for( Element elem : doc.select("select") ){elem.parent().text(elem.select("option[selected]").val());}
	for( Element elem : doc.select("textarea") ){ elem.parent().text(elem.val()); }

	html_rm = doc.toString();

	return html_rm;
}
%>
