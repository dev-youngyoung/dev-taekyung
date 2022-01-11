<%@ page contentType="text/html; charset=UTF-8" %><%@page import="gui.ava.html.image.generator.*"%><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String cfile_seq = u.request("cfile_seq");
String footer_text = u.request("footer_text", "Y");
if(cont_no.equals("")||cont_chasu.equals("")||cfile_seq.equals("")){
	u.jsErrClose("정상적인 경로로 접근하여 주세요.");
	return;
}

String[] exp_stamp_path = {"20181002679=>20181002679/"};//경기테크노파크

String noti_text = "※ 인쇄시 계약서 하단 전자계약 체결 안내 문구 및 도장이미지 표시를 삭제하고자 경우 체크를 해제하세요.";
String ci_img = "";
String stamp_img = "";
String sign_info_img = "";
String footer_img = "";
String down_file_name = "";
String full_file_path = "";

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";

ContractDao contDao = new ContractDao();
DataSet cont = contDao.find( where );
 
if(!cont.next()){
	u.jsErrClose("계약정보가 존재 하지 않습니다.");
	return;
}

DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(where+" and cfile_seq = '"+cfile_seq+"' ");
if(!cfile.next()){
	u.jsErrClose("파일정보가 존재 하지 않습니다.");
	return;
}

if(cfile.getString("auto_yn").equals("Y")){
	noti_text = "※ 인쇄시 계약서 하단 도장이미지 표시를 삭제하고자 경우 체크를 해제하세요.";
}

String cont_userno =  cont.getString("cont_userno"); 
//ci_img 설정
DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+cont.getString("member_no")+"' ");
if(!member.next()){
	u.jsErrClose("계약서 작성 업체 정보가 없습니다.");
	return;
}
if(!member.getString("ci_img_path").equals("")){
	ci_img = u.aseEnc(Startup.conf.getString("file.path.bcont_logo")+member.getString("ci_img_path"));
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
	99	계약폐기
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
		,"91=>pdf_watermark_cancel.gif"
		,"99=>pdf_watermark_disuse.gif"
		};
String stamp_path = Startup.conf.getString("dir")+"/web/buyer/html/images/stamp/contract/"+u.getItem(cont.getString("member_no"), exp_stamp_path);
stamp_img = u.aseEnc(stamp_path+u.getItem(cont.getString("status"), code_stamp_img));

// 자유서식의 경우에만 하단에 관리번호를 뷰어에서 인쇄시 보여준다.
if(cont.getString("template_cd").equals("")||!cfile.getString("auto_yn").equals("Y"))
{
	boolean bFooterShow = true;
	if(cont.getString("status").equals("50")){
		DataObject custDao = new DataObject("tcb_cust");
		int sign_cnt = custDao.findCount("cont_no = '"+cont_no+"' and cont_chasu="+cont_chasu+" and sign_dn is not null");  // 서면계약이면
		if(sign_cnt==0){
			bFooterShow = false;
			stamp_img = "";
		}
	}
	if(footer_text.equals("N"))bFooterShow = false;

	if(bFooterShow){
		String sManageNo = cont_no+"-"+cont_chasu+"-"+cont.getString("true_random");
		String signStr = "";
		if(!cont_userno.equals("")){
			 //signStr = "<table width='740px' height='40px' border='0'><tr><td valign='bottom' style='font-family:나눔고딕; font-size:10px'><font color='#5B5B5B'>*본 계약서는 상기업체 간에 전자서명법  등 관련법령에 근거하여 전자서명으로 체결한 전자계약서입니다.<br>&nbsp;&nbsp;전자계약 진위여부는 나이스다큐(http://www.nicedocu.com,일반기업용)에서 확인하실 수 있습니다. (관리번호:"+sManageNo+")<br>&nbsp;&nbsp;* 계약번호 :" +cont_userno+ "</font></td></tr></table>";
			 signStr = "<table width='740px' height='40px' border='0'><tr><td valign='bottom' style='font-family:나눔고딕; font-size:10px'><font color='#5B5B5B'>*본 계약서는 상기업체 간에 전자서명법  등 관련법령에 근거하여 전자서명으로 체결한 전자계약서입니다. (관리번호:"+sManageNo+")<br>&nbsp;&nbsp;* 계약번호 :" +cont_userno+ "</font></td></tr></table>";
		}else{
			//signStr = "<table width='740px' height='40px' border='0'><tr><td valign='bottom' style='font-family:나눔고딕; font-size:10px'><font color='#5B5B5B'>*본 계약서는 상기업체 간에 전자서명법  등 관련법령에 근거하여 전자서명으로 체결한 전자계약서입니다.<br>&nbsp;&nbsp;전자계약 진위여부는 나이스다큐(http://www.nicedocu.com,일반기업용)에서 확인하실 수 있습니다. (관리번호:"+sManageNo+")</font></td></tr></table>";
			signStr = "<table width='740px' height='40px' border='0'><tr><td valign='bottom' style='font-family:나눔고딕; font-size:10px'><font color='#5B5B5B'>*본 계약서는 상기업체 간에 전자서명법  등 관련법령에 근거하여 전자서명으로 체결한 전자계약서입니다. (관리번호:"+sManageNo+")</font></td></tr></table>";
		}
		
		footer_img = procure.common.conf.Startup.conf.getString("file.path.lcont_temp") + auth.getString("_USER_ID") + "_" + u.getTimeString() + ".png";
		HtmlImageGenerator imageGenerator = new HtmlImageGenerator();
		imageGenerator.loadHtml(signStr);
		imageGenerator.saveAsImage(footer_img);  // 물류쪽 임시 폴더에 같이 저장함. 매일 밤 배치파일이 돌면서 삭제한다.
		footer_img = u.aseEnc(footer_img);
	}
}

if(footer_text.equals("N")){
	stamp_img = "";
	footer_img = "";
}

// String url = "/servlets/nicelib.pdf.PDFDown?";
String url = "/PDFDown?";
url+= "system=buyer";
url+= "&full_file_path="+full_file_path;
url+= "&down_file_name="+down_file_name;
url+= "&stamp_img="+stamp_img; 
url+= "&ci_img="+ci_img;
url+= "&footer_img="+footer_img;
url+= "&sign_info_img="+sign_info_img;
System.out.println("url : " + url);


p.setLayout("pdfjs");
//p.setDebug(out);
p.setBody("contract.pop_pdf_viewer");
p.setVar("url",url);
p.setVar("down_file_name",cfile.getString("doc_name")+"."+cfile.getString("file_ext"));
p.setVar("query", u.getQueryString("footer_text"));
p.setVar("view_noti", !cont.getString("paper_yn").equals("Y"));
p.setVar("footer_text_checked", footer_text.equals("N")?"":"checked" );
p.setVar("page_url", "pop_pdf_viewer.jsp");
p.setVar("noti_text", noti_text);
p.display(out);
%>
