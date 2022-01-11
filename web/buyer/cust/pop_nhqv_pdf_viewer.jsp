<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String gubun =  u.aseDec(u.request("gubun"));
String noti_seq = u.aseDec(u.request("noti_seq"));
String member_no = u.aseDec(u.request("member_no"));
if(noti_seq.equals("")||member_no.equals("")){
	u.jsErrClose("정상적인 경로로 접근하여 주세요.");
	return;
}


String down_file_name = "";

if(gubun.equals("req")){
	down_file_name = "등록업체신청서";
}else{
	down_file_name = "등록업체 심사 평가표";
}

//ci_img 설정
DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find(" member_no = '20160901598' ");
if(!member.next()){}

String ci_img = member.getString("ci_img_path");
ci_img = member.getString("ci_img_path");
if(!ci_img.equals("")){
	ci_img = u.aseEnc(Startup.conf.getString("file.path.bcont_logo") +ci_img);
}

String pdf_url = "/web/buyer/cust/nhqv_recruit_html2pdf.jsp"
               + "?"+u.getQueryString()
               + "&ci_img="+ci_img
               + "&down_file_name="+u.aseEnc(down_file_name);

p.setLayout("pdfjs");
p.setBody("cust.pop_nhqv_pdf_viewer");
p.setVar("pdf_url", pdf_url);
p.setVar("down_file_name", down_file_name+".pdf");
p.display(out);
%>
