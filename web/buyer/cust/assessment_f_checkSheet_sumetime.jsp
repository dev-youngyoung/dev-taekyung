<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.Jsoup"%>
<%@ page import="org.jsoup.nodes.Document"%>
<%@ page import="org.jsoup.nodes.Element"%>
<%@ page import="org.jsoup.select.Elements"%>
<%

String asse_no = u.request("asse_no", "");
if(asse_no.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

boolean modify = true;
DataObject assessmentDao = new DataObject("tcb_assemaster a  inner join tcb_assedetail b on a.asse_no = b.asse_no and b.div_cd = 'F'");
DataSet assessment = assessmentDao.find(" a.asse_no = '"+asse_no+"'", "a.*, b.div_cd, b.asse_html, b.asse_subhtml, b.sub_point, b.status as dstatus");
if(!assessment.next()){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

System.out.println("dstatus : " + assessment.getString("dstatus"));

if("50".equals(assessment.getString("dstatus"))){
	modify = false;	
}


DataSet dsHtmlData = new DataSet();
dsHtmlData.addRow();
dsHtmlData.put("member_name", assessment.getString("member_name"));
assessment.put("asse_html", setHtmlValue(assessment.getString("asse_html"), dsHtmlData));	

if(u.isPost() && f.validate()){
	
	DataObject encDao = new DataObject("tcb_assedetail b ");
	DataSet enc = encDao.find(" b.asse_no = '"+asse_no+"' and b.div_cd = 'F'" , "b.*");
	String encStatus = "";
	if(enc.next()){
		encStatus = enc.getString("status");
	}
		
	String saveDiv = f.get("saveDiv");
	String status = "20";
	String mstatus = "20";
	String message = "임시 저장 하였습니다.";
	
	System.out.println("encStatus : " + encStatus);
	System.out.println("saveDiv : " + saveDiv);
	if("50".equals(saveDiv) || "90".equals(saveDiv)){
		status = "50";	
		mstatus = "50";
		message = "평가완료 하였습니다.";
		
		/*  2017.01.12 평가 완료 버튼이 안보여서 막음.  뭔가 타 수시평가가 끝나지 않으면 완료 안시키려는 것 같은데 모르겠음.
		if("10".equals(encStatus) || "20".equals(encStatus)){
			mstatus = "20";	
		}
		*/
	}
	
	String email = f.get("email");
	String asseNo = f.get("asse_no");
	String div_cd = f.get("div_cd");	
	String ratingDate = f.get("date");
	String point = f.get("point");
	String rating = f.get("rating");
	String doc_html = new String(Base64Coder.decode(f.get("doc_html")),"UTF-8");;
	
	DB db = new DB();
	DataObject assemasterDao = new DataObject("tcb_assemaster");
	assemasterDao.item("reg_id", auth.getString("_USER_ID"));
	assemasterDao.item("reg_date", u.getTimeString());
	assemasterDao.item("status", mstatus);
	db.setCommand(assemasterDao.getUpdateQuery("asse_no= '"+asseNo+"'"), assemasterDao.record);
	
	DataObject assedetailDao = new DataObject("tcb_assedetail");
	assedetailDao.item("reg_id", auth.getString("_USER_ID"));
	assedetailDao.item("reg_name", auth.getString("_USER_NAME"));
	assedetailDao.item("total_point", point);
	assedetailDao.item("rating_point", rating);
	assedetailDao.item("reg_date", u.getTimeString("yyyy-MM-dd"));
	assedetailDao.item("status", status);
	assedetailDao.item("asse_html", doc_html);
	db.setCommand(assedetailDao.getUpdateQuery("asse_no= '"+asseNo+"' and div_cd = '"+div_cd+"'"), assedetailDao.record);
	
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	
	if("90".equals(saveDiv)){
		
		//메일 전송
		p.clear();
		p.setVar("title", "수시평가 결과 ");
		p.setVar("member_name", assessment.getString("member_name"));
		p.setVar("project_name", assessment.getString("project_name"));
		p.setVar("asse_year", assessment.getString("asse_year"));
		p.setVar("reg_date", u.getTimeString("yyyy-MM-dd"));
		p.setVar("resultParam", u.aseEnc(asseNo));
		//p.setVar("img_url", webUrl+"/images/email/20110620/");
		//p.setVar("ret_url", webUrl+"/web/buyer/");
		p.setVar("resultParam1", "F");
		u.mail(email, "[수시평가 결과] " +  assessment.getString("member_name") + " 평가 결과입니다.", p.fetch("mail/assessment_mail.html"));
		u.jsAlertReplace("평가완료 후 결과전송 하였습니다.","assessment_checking_flist.jsp?"+u.getQueryString());
		return;
	}
	
	u.jsAlertReplace(message, "assessment_checking_flist.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.assessment_f_checkSheet_sumetime");
p.setBody("cust.assessment_f_checkSheet_sumetime");
p.setVar("menu_cd","000105");
p.setVar("modify", modify);
p.setVar("del", auth.getString("_DEFAULT_YN").equals("Y"));
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
	for( Element elem : asse_doc.select("span.cust_name_area_2") ){ elem.text(dsCustData.getString("member_name")); }
	
	asse_html = asse_doc.toString();

	return asse_html;
}

%>