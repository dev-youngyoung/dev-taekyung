<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
u.p("start");
String[] cont_html_rm = f.getArr("cont_html_rm");
String cont_html = new String(Base64Coder.decode(cont_html_rm[0]),"UTF-8");

if(cont_html.equals("")){
	u.p("false");
	return;
}

if(u.isPost()){
	ContractDao contDao = new  ContractDao();
	
	DataSet pdfInfo = new DataSet();
	pdfInfo.addRow();
	pdfInfo.put("member_no","20150100001");
	pdfInfo.put("cont_no", "00000000000");
	pdfInfo.put("cont_chasu", "0");
	pdfInfo.put("cont_gubun", "10");
	pdfInfo.put("random_no", "123456");
	pdfInfo.put("cont_userno", "");
	pdfInfo.put("html", cont_html);
	pdfInfo.put("file_seq", 0);
	DataSet pdf = contDao.makePdf(pdfInfo);
	u.p((Startup.conf.getString("file.path.bcont_pdf") +pdf.getString("file_path")));
}
%>