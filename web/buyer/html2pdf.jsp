<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
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
	pdfInfo.put("member_no","00000000000");
	pdfInfo.put("cont_no", "N0000000000");
	pdfInfo.put("cont_chasu", "0");
	pdfInfo.put("random_no", "1234");
	pdfInfo.put("cont_userno", "");
	pdfInfo.put("html", cont_html);
	pdfInfo.put("doc_type", "");
	pdfInfo.put("file_seq", "0");
	DataSet pdf = contDao.makePdf(pdfInfo);
	u.p(u.replace((Startup.conf.getString("file.path.bcont_pdf") +pdf.getString("file_path")), "/", "\\") );
}
%>