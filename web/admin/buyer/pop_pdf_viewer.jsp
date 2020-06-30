<%@page import="java.awt.Dimension"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@page import="gui.ava.html.image.generator.*"%><%@ include file="init.jsp" %>
<%
String cont_no = u.request("cont_no");
String cont_chasu = u.request("cont_chasu");
String cfile_seq = u.request("cfile_seq");
String footer_text = u.request("footer_text", "Y");
if(cont_no.equals("")||cont_chasu.equals("")||cfile_seq.equals("")){
	u.jsErrClose("�������� ��η� �����Ͽ� �ּ���.");
	return;
}


String ci_img = "";
String stamp_img = "";
String sign_info_img = "";
String footer_img = "";
String down_file_name = "";
String full_file_path = "";

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";

ContractDao contDao = new ContractDao("tcb_contmaster");
DataSet cont = contDao.find( where );
if(!cont.next()){
	u.jsErrClose("��������� ���� ���� �ʽ��ϴ�.");
	return;
}

DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(where);
while(cust.next()){
}

DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(where+" and cfile_seq = '"+cfile_seq+"' ");
if(!cfile.next()){
	u.jsErrClose("���������� ���� ���� �ʽ��ϴ�.");
	return;
}


//ci_img ����
DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+cont.getString("member_no")+"' ");
if(!member.next()){
	u.jsErrClose("��༭ �ۼ� ��ü ������ �����ϴ�.");
	return;
}

if(!member.getString("ci_img_path").equals("")){
	ci_img = u.aseEnc(Startup.conf.getString("file.path.bcont_logo_http")+member.getString("ci_img_path"));
}
 
//���� ���
full_file_path = u.aseEnc(Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name"));
down_file_name = u.aseEnc(cfile.getString("doc_name"));


//10:�ۼ��� ,20:�����û ,28:������û,29:�ݷ�,30:����Ϸ�(��), 40:����Ϸ�(ˣ),50:���Ϸ�, 60:Ÿ��, 70:����
String[] code_stamp_img = {
	 "10=>pdf_watermark_edit.gif"
	,"20=>pdf_watermark_progress.gif"
	,"28=>pdf_watermark_progress.gif"
	,"29=>pdf_watermark_progress.gif"
	,"30=>pdf_watermark_progress.gif"
	,"40=>pdf_watermark_progress.gif"
	,"50=>pdf_watermark_finish.gif"
	,"91=>pdf_watermark_cancel"};


stamp_img = u.aseEnc(Startup.conf.getString("dir")+"/web/buyer/html/images/"+u.getItem(cont.getString("status"), code_stamp_img));

// ���������� ��쿡�� �ϴܿ� ������ȣ�� ���� �μ�� �����ش�.
if(cont.getString("template_cd").equals("")||!cfile.getString("auto_yn").equals("Y"))
{
	boolean bFooterShow = true;
	if(cont.getString("status").equals("50")){
		custDao = new DataObject("tcb_cust");
		int sign_cnt = custDao.findCount("cont_no = '"+cont_no+"' and cont_chasu="+cont_chasu+" and sign_dn is not null");  // �������̸�
		if(sign_cnt==0){
			bFooterShow = false;
			stamp_img = "";
		}
	}
	if(footer_text.equals("N"))bFooterShow = false;
	
	if(bFooterShow){
		String sManageNo = cont_no+"-"+cont_chasu+"-"+cont.getString("true_random");
		String signStr = "<table width='740px' height='40px' border='0'><tr><td valign='bottom' style='font-family:�������; font-size:10px'><font color='#5B5B5B'>*�� ��༭�� ����ü ���� ���ڼ����  �� ���ù��ɿ� �ٰ��Ͽ� ���ڼ������� ü���� ���ڰ�༭�Դϴ�.<br>&nbsp;&nbsp;���ڰ�� �������δ� ���̽���ť(http://www.nicedocu.com)���� Ȯ���Ͻ� �� �ֽ��ϴ�. (������ȣ:"+sManageNo+")</font></td></tr></table>";
		footer_img = procure.common.conf.Startup.conf.getString("file.path.lcont_temp") + auth.getString("_USER_ID") + "_" + u.getTimeString() + ".png";
		HtmlImageGenerator imageGenerator = new HtmlImageGenerator();
		Dimension  dimension = imageGenerator.getDefaultSize();
		dimension.setSize(500,40);
		imageGenerator.setSize(dimension);
		imageGenerator.loadHtml(signStr);
		imageGenerator.saveAsImage(footer_img);  // ������ �ӽ� ������ ���� ������. ���� �� ��ġ������ ���鼭 �����Ѵ�.
		footer_img = u.aseEnc(footer_img);
	}
}


String url = "/servlets/nicelib.pdf.PDFDown?";
       url+= "system=buyer";
       url+= "&full_file_path="+full_file_path;
       url+= "&down_file_name="+down_file_name;
       url+= "&stamp_img="+stamp_img;
       url+= "&ci_img="+ci_img;
       url+= "&footer_img="+footer_img;
       url+= "&sign_info_img="+sign_info_img;
       
       
if(u.request("pdfjs_yn").equals("Y")){
	p.setLayout("pdfjs");
	p.setVar("pdfjs_yn", true);
}else{
	p.setLayout("blank");
	p.setVar("pdfjs_yn", false);
}


//p.setDebug(out);
p.setBody("buyer.pop_pdf_viewer");
p.setVar("view_footer_ctrl", !cfile.getString("auto_yn").equals("Y"));
p.setVar("url",url);
p.setVar("down_file_name",cfile.getString("doc_name")+"."+cfile.getString("file_ext"));
p.setVar("query", u.getQueryString("footer_text"));
p.setVar("footer_text_checked", footer_text.equals("N")?"":"checked" );
p.display(out);
%>
