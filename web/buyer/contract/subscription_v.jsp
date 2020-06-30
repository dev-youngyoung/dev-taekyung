<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ include file="../init.jsp" %>
<%
String cont_no = "";
String cont_chasu = "";
try {
	cont_no = u.aseDec(u.request("c"));
	cont_chasu = "0";
	if(cont_no.equals("")){
		u.jsError("������ ���� �����Դϴ�.");
		return;
	}
}
catch(Exception e) 
{
	u.jsError("�������� ��η� ���� �ϼ���.");
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
	u.jsError("��������� ���� ���� �ʽ��ϴ�.");
	return;
}

DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(where);
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
	ci_img = u.aseEnc(Startup.conf.getString("file.path.buyer.ci_img")+member.getString("ci_img_path"));
}

//���� ���
full_file_path = u.aseEnc(Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name"));
down_file_name = u.aseEnc(cfile.getString("doc_name"));


/*
	00	������(�Ϲݱ����)
	10	�ۼ���
	11	������
	12	���ιݷ�
	20	�����û
	21	���δ��
	30	������
	40	������û
	41	�ݷ�
	50	���Ϸ�
	90	������
	91	�������
*/
	String[] code_stamp_img = {
			"10=>pdf_watermark_edit.gif"
			,"11=>pdf_watermark_progress.gif"
			,"12=>pdf_watermark_progress.gif"
			,"20=>pdf_watermark_progress.gif"
			,"21=>pdf_watermark_progress.gif"
			,"30=>pdf_watermark_progress.gif"
			,"40=>pdf_watermark_progress.gif"
			,"41=>pdf_watermark_progress.gif"
			,"50=>pdf_watermark_finish.gif"
			,"90=>pdf_watermark_cancel.gif"
			,"91=>pdf_watermark_cancel.gif"};


stamp_img = u.aseEnc(Startup.conf.getString("dir")+"/web/buyer/html/images/"+u.getItem(cont.getString("status"), code_stamp_img));


String url = "/servlets/nicelib.pdf.PDFDown?";
       url+= "system=buyer";
       url+= "&full_file_path="+full_file_path;
       url+= "&down_file_name="+down_file_name;
       url+= "&stamp_img="+stamp_img;
       url+= "&ci_img="+ci_img;
       url+= "&footer_img="+footer_img;
       url+= "&sign_info_img="+sign_info_img;

u.redirect(url);       
%>
