<%@page import="gui.ava.html.image.generator.*"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String asse_no = u.request("asse_no");
String div_cd = u.request("div_cd");
if(asse_no.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject asseDao = new DataObject("tcb_assemaster");
DataSet asse = asseDao.find("main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"'");
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

DataObject templateDao = new DataObject("tcb_asse_template");
String template_name = templateDao.getOne("select template_name from tcb_asse_template where template_cd= '"+detail.getString("template_cd")+"'  ");

//ci_img ����
DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find(" member_no = '"+_member_no+"' ");
if(!member.next()){}

String ci_img = member.getString("ci_img_path");
ci_img = member.getString("ci_img_path");
if(!ci_img.equals("")){
	ci_img = u.aseEnc(Startup.conf.getString("file.path.bcont_logo") +ci_img);
}

String stamp_img = u.aseEnc(Startup.conf.getString("dir")+"/web/buyer/html/images/pdf_watermark_doc_print.gif");


String footer_html = "<table width='100%' height='35' border='0'><tr><td valign='bottom' style='font-family:�������; font-size:11pt'><font color='#5B5B5B'>�� �� ������ ���š����� ���� ���̽���ť(www.nicedocu.com, �Ϲݱ����) �ý��ۿ��� ���ͳ����� ��µǾ����ϴ�.</font></td></tr></table>";
String footer_img = Startup.conf.getString("file.path.lcont_temp") + auth.getString("_USER_ID") + "_" + u.getTimeString() + ".png";
HtmlImageGenerator imageGenerator = new HtmlImageGenerator();
imageGenerator.loadHtml(footer_html);
imageGenerator.saveAsImage(footer_img);  // ������ �ӽ� ������ ���� ������. ���� �� ��ġ������ ���鼭 �����Ѵ�.
footer_img = u.aseEnc(footer_img);

String pdf_url = "/web/buyer/cust/asse_html2pdf.jsp"
               + "?"+u.getQueryString()
               + "&stamp_img="+stamp_img
               + "&ci_img="+ci_img
               + "&footer_img="+footer_img
               + "&down_file_name="+u.aseEnc(template_name);

p.setLayout("pdfjs");
//p.setDebug(out);
p.setBody("cust.asse_viewer");
p.setVar("pdf_url",pdf_url);
p.setVar("down_file_name", template_name);
p.display(out);
%>
