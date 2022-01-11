<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../init.jsp" %>
<%
String cont_no = "";
String cont_chasu = "";
try {
	cont_no = u.aseDec(u.request("c"));
	cont_chasu = "0";
	if(cont_no.equals("")){
		u.jsError("권한이 없는 접근입니다.");
		return;
	}
}
catch(Exception e) 
{
	u.jsError("정상적인 경로로 접근 하세요.");
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
	u.jsError("계약정보가 존재 하지 않습니다.");
	return;
}

DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(where);
if(!cfile.next()){
	u.jsErrClose("파일정보가 존재 하지 않습니다.");
	return;
}


//ci_img 설정
DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+cont.getString("member_no")+"' ");
if(!member.next()){
	u.jsErrClose("계약서 작성 업체 정보가 없습니다.");
	return;
}
if(!member.getString("ci_img_path").equals("")){
	ci_img = u.aseEnc(Startup.conf.getString("file.path.buyer.ci_img")+member.getString("ci_img_path"));
}

//파일 경로
full_file_path = u.aseEnc(Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name"));
down_file_name = u.aseEnc(cfile.getString("doc_name"));


/*
	00	계약상태(일반기업용)
	10	작성중
	11	검토중
	12	내부반려
	20	서명요청
	21	승인대기
	30	서명대기
	40	수정요청
	41	반려
	50	계약완료
	90	종료계약
	91	계약해지
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


// String url = "/servlets/nicelib.pdf.PDFDown?";
String url = "/PDFDown?";
       url+= "system=buyer";
       url+= "&full_file_path="+full_file_path;
       url+= "&down_file_name="+down_file_name;
       url+= "&stamp_img="+stamp_img;
       url+= "&ci_img="+ci_img;
       url+= "&footer_img="+footer_img;
       url+= "&sign_info_img="+sign_info_img;

u.redirect(url);       
%>
