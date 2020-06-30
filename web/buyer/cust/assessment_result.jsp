<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.Jsoup"%>
<%@ page import="org.jsoup.nodes.Document"%>
<%@ page import="org.jsoup.nodes.Element"%>
<%@ page import="org.jsoup.select.Elements"%>
<%

String asse_no = u.aseDec(u.request("param"));
String div_cd = u.request("param1");
if(asse_no.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

DataObject assessmentDao = new DataObject("tcb_assemaster a  inner join tcb_assedetail b on a.asse_no = b.asse_no and b.div_cd = '"+div_cd+"'");
DataSet assessment = assessmentDao.find(" a.asse_no = '"+asse_no+"'", "a.*, b.asse_html, b.asse_subhtml, b.sub_point");
if(!assessment.next()){
	u.jsError("�������� ��η� ���� �ϼ���.");
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
p.setVar("nevi","Ȩ &gt; �ŷ���ü���� &gt; ��ü �򰡰��� &gt; ���¾�ü ����Ȳ");
p.setVar("title_img","asse_purchase_list");
p.setVar("assessment", assessment);
p.setVar("form_script", f.getScript());
p.display(out);
%>

<%!
// input box ���� ����
public String removeHtml(String html)
{
	String cont_html_rm = "";

	// DB��
	Document cont_doc = Jsoup.parse(html);


	// PDF��
	for( Element elem : cont_doc.select("input[type=text]") ){ elem.parent().text(elem.val()); }  // input box �� ��� ����
	for( Element elem : cont_doc.select("input[type=checkbox]") ){ if(elem.hasAttr("checked")) elem.parent().text("��"); else elem.parent().text("��");  }  // üũ�ڽ�
	for( Element elem : cont_doc.select("input[type=radio]") ){ if(elem.hasAttr("checked")) elem.parent().text("��"); else elem.parent().text("��"); }  // ����
	for( Element elem : cont_doc.select("select") ){ elem.parent().text(elem.select("option[selected]").val()); }

	//cont_doc.select("#pdf_comment").attr("style", "display:none"); // pdf ������ ������ �ȵǴ°�

	cont_html_rm = cont_doc.toString();

	return cont_html_rm;
}

// ��Ŀ� �� ä���ֱ�
public String setHtmlValue(String html, DataSet dsCustData)
{
	String asse_html = "";

	// DB��
	Document asse_doc = Jsoup.parse(html);

	//cont_doc.select("input[name=mns_code]").attr("value", dsCustData.getString("r_mns_code"));	// �����ڵ�

	// span���� �� �κ� �� ä���
	for( Element elem : asse_doc.select("span#financeitem1") ){ elem.text(dsCustData.getString("sub_point")); }
	for( Element elem : asse_doc.select("span#financeitemSumPoint") ){ elem.text(dsCustData.getString("sub_point")); }
	
	asse_html = asse_doc.toString();

	return asse_html;
}

%>
