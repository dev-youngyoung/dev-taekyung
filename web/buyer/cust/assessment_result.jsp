<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.Jsoup"%>
<%@ page import="org.jsoup.nodes.Document"%>
<%@ page import="org.jsoup.nodes.Element"%>
<%@ page import="org.jsoup.select.Elements"%>
<%

String asse_no = u.aseDec(u.request("param"));
String div_cd = u.request("param1");
if(asse_no.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

DataObject assessmentDao = new DataObject("tcb_assemaster a  inner join tcb_assedetail b on a.asse_no = b.asse_no and b.div_cd = '"+div_cd+"'");
DataSet assessment = assessmentDao.find(" a.asse_no = '"+asse_no+"'", "a.*, b.asse_html, b.asse_subhtml, b.sub_point");
if(!assessment.next()){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}
DataSet dsHtmlData = new DataSet();
dsHtmlData.addRow();
dsHtmlData.put("sub_point", "".equals(assessment.getString("sub_point"))?"0":assessment.getString("sub_point"));
assessment.put("asse_html", setHtmlValue(assessment.getString("asse_html"), dsHtmlData));	


if(u.isPost() && f.validate()){
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.assessment_result");
p.setVar("nevi","홈 &gt; 거래업체관리 &gt; 업체 평가관리 &gt; 협력업체 평가현황");
p.setVar("title_img","asse_purchase_list");
p.setVar("assessment", assessment);
p.setVar("form_script", f.getScript());
p.display(out);
%>

<%!
// input box 등을 제거
public String removeHtml(String html)
{
	String cont_html_rm = "";

	// DB용
	Document cont_doc = Jsoup.parse(html);


	// PDF용
	for( Element elem : cont_doc.select("input[type=text]") ){ elem.parent().text(elem.val()); }  // input box 값 모두 제거
	for( Element elem : cont_doc.select("input[type=checkbox]") ){ if(elem.hasAttr("checked")) elem.parent().text("▣"); else elem.parent().text("□");  }  // 체크박스
	for( Element elem : cont_doc.select("input[type=radio]") ){ if(elem.hasAttr("checked")) elem.parent().text("▣"); else elem.parent().text("□"); }  // 라디오
	for( Element elem : cont_doc.select("select") ){ elem.parent().text(elem.select("option[selected]").val()); }

	//cont_doc.select("#pdf_comment").attr("style", "display:none"); // pdf 버전에 보여야 안되는것

	cont_html_rm = cont_doc.toString();

	return cont_html_rm;
}

// 양식에 값 채워넣기
public String setHtmlValue(String html, DataSet dsCustData)
{
	String asse_html = "";

	// DB용
	Document asse_doc = Jsoup.parse(html);

	//cont_doc.select("input[name=mns_code]").attr("value", dsCustData.getString("r_mns_code"));	// 접점코드

	// span으로 된 부분 값 채우기
	for( Element elem : asse_doc.select("span#financeitem1") ){ elem.text(dsCustData.getString("sub_point")); }
	for( Element elem : asse_doc.select("span#financeitemSumPoint") ){ elem.text(dsCustData.getString("sub_point")); }
	
	asse_html = asse_doc.toString();

	return asse_html;
}

%>
