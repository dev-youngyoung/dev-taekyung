<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.Jsoup"%>
<%@ page import="org.jsoup.nodes.Document"%>
<%@ page import="org.jsoup.nodes.Element"%>
<%@ page import="org.jsoup.select.Elements"%>
<%

String asse_no = u.request("asse_no", "");

String[] kind_cd = {"N=>신규평가", "S=>수시평가", "R=>정기평가"};
String[] div_cd = {"Q=>Q.C팀", "E=>ENC본부", "S=>구매팀", "F=>안전"};

DataSet asse_year = new DataSet();
asse_year.addRow();
asse_year.put("", "----선택----");
String lastYear = u.getTimeString("yyyy",u.addDate("Y",-1));
String thisYear = u.getTimeString("yyyy");
String nextYear = u.getTimeString("yyyy",u.addDate("Y",+1));
asse_year.put("year", lastYear);
asse_year.addRow();
asse_year.put("year", thisYear);
asse_year.addRow();
asse_year.put("year", nextYear);
p.setLoop("asse_year", asse_year);

boolean modify = false;
DataSet assessment = new DataSet();
if(!"".equals(asse_no)){

	DataObject assessmentDao = new DataObject("tcb_assemaster");
	//personDao.setDebug(out);
	assessment = assessmentDao.find("asse_no = '"+asse_no+"'");

	if(!assessment.next()){
		u.jsError("정상적인 경로로 접근 하세요.");
		return;
	}else{
		assessment.put("s_yn_check", "Y".equals(assessment.getString("s_yn"))?"checked":"");
		assessment.put("qc_yn_check", "Y".equals(assessment.getString("qc_yn"))?"checked":"");
		assessment.put("enc_yn_check", "Y".equals(assessment.getString("enc_yn"))?"checked":"");
		assessment.put("f_yn_check", "Y".equals(assessment.getString("f_yn"))?"checked":"");
		modify = true;

		f.addElement("asse_year", assessment.getString("asse_year"), "hname:'평가년도', required:'Y'");
		f.addElement("kind_cd", assessment.getString("kind_cd"), "hname:'평가종류', required:'Y'");
	}

	String goUrl = "";
	if("1".equals(auth.getString("_FIELD_SEQ"))){
		System.out.println("구매팀");
		System.out.println(auth.getString("_FIELD_SEQ"));
		goUrl = "assessment_checking_slist.jsp";

	}else if("2".equals(auth.getString("_FIELD_SEQ"))){
		System.out.println("QC");
		System.out.println(auth.getString("_FIELD_SEQ"));
		goUrl = "assessment_checking_qlist.jsp";

	}else if("3".equals(auth.getString("_FIELD_SEQ"))){
		System.out.println("ENC");
		System.out.println(auth.getString("_FIELD_SEQ"));
		goUrl = "assessment_checking_elist.jsp";
	}else{
		System.out.println("안전");
		System.out.println(auth.getString("_FIELD_SEQ"));
		goUrl = "assessment_checking_flist.jsp";
	}
	assessment.put("goUrl", goUrl);
}


if(u.isPost()&& f.validate()){

	String status = "10";  // 작성중
	if("1".equals(f.get("save_div"))){
		status = "20";  // 평가중
	}

	DataSet year = new DataSet();
	year.addRow();
	String year2 = u.getTimeString("yyyy",u.addDate("Y",-2));
	String year1 = u.getTimeString("yyyy",u.addDate("Y",-1));
	String year0 = u.getTimeString("yyyy");

	DB db = new DB();

	//평가대상 테이블 키 생성
	DataObject asseDao = new DataObject("tcb_assemaster");
	String new_asse_no = asseDao.getOne(
			" SELECT 'N'|| (TO_NUMBER(TO_CHAR(SYSDATE, 'yyyymm')) + 233300) || LPAD( (NVL(MAX(TO_NUMBER(SUBSTR(asse_no, 8))), 0) + 1), 4, '0' ) asse_no "
			+"FROM tcb_assemaster "
			+"WHERE SUBSTR(asse_no, 2, 6) = TO_CHAR((TO_NUMBER(TO_CHAR(SYSDATE, 'yyyymm')) + 233300)) "
			);

	db.setCommand("delete from tcb_assedetail where asse_no = '"+asse_no+"'", null);
	db.setCommand("delete from tcb_assemaster where asse_no = '"+asse_no+"'", null);

	DataObject assemasterDao = new DataObject("tcb_assemaster");
	assemasterDao.item("asse_no", new_asse_no);
	assemasterDao.item("member_no", f.get("member_no"));
	assemasterDao.item("member_name", f.get("member_name"));
	assemasterDao.item("asse_year", f.get("asse_year"));
	//assemasterDao.item("reg_id", auth.getString("_USER_ID"));
	//assemasterDao.item("reg_date", u.getTimeString());
	assemasterDao.item("project_name", f.get("project_name"));
	assemasterDao.item("kind_cd", f.get("kind_cd"));
	assemasterDao.item("s_yn", f.get("s_yn", "N"));
	assemasterDao.item("qc_yn", f.get("qc_yn", "N"));
	assemasterDao.item("enc_yn", f.get("enc_yn", "N"));
	assemasterDao.item("f_yn", f.get("f_yn", "N"));
	assemasterDao.item("status", status);
	assemasterDao.item("main_member_no", _member_no);
	db.setCommand(assemasterDao.getInsertQuery(), assemasterDao.record);

	DataObject templateDao = new DataObject("tcb_asse_template");

	int divCnt = 0;
	String[] divCd = null;
	String[] template_html = null;
	String[] template_subhtml = null;

	DataSet dsHtmlData = new DataSet();
	dsHtmlData.addRow();
	dsHtmlData.put("member_name", f.get("member_name"));
	dsHtmlData.put("project_name", f.get("project_name"));
	dsHtmlData.put("year2", year2);
	dsHtmlData.put("year1", year1);
	dsHtmlData.put("year0", year0);

	if("Y".equals(f.get("qc_yn")) && "Y".equals(f.get("enc_yn")) && "Y".equals(f.get("f_yn"))){
		divCnt = 3;
		divCd = new String[]{"Q", "E", "F"};

		// qc
		DataSet template = templateDao.find(" template_cd = '3'");
		template_html = new String[]{"","",""};
		template_subhtml = new String[]{"","",""};
		if(template.next()){
			template_html[0] = setHtmlValue(template.getString("template_html"), dsHtmlData);
			template_subhtml[0] = setHtmlValue(template.getString("template_subhtml"), dsHtmlData);
		}

		// enc
		DataSet template1 = templateDao.find(" template_cd = '4'");
		if(template1.next()){
			template_html[1] = setHtmlValue(template1.getString("template_html"), dsHtmlData);
			template_subhtml[1] = "";
		}

		// 안전
		DataSet template2 = templateDao.find(" template_cd = '5'");
		if(template2.next()){
			template_html[2] = setHtmlValue(template2.getString("template_html"), dsHtmlData);
			template_subhtml[2] = "";
		}

	}else if("Y".equals(f.get("qc_yn"))){
		divCnt = 1;
		divCd = new String[]{"Q"};	//QC
		DataSet template= templateDao.find(" template_cd = '3'");
		if(template.next()){

			template_html = new String[]{setHtmlValue(template.getString("template_html"), dsHtmlData)};
			template_subhtml = new String[]{setHtmlValue(template.getString("template_subhtml"), dsHtmlData)};

		}

	}else if("Y".equals(f.get("enc_yn"))){
		divCnt = 1;
		divCd = new String[]{"E"};
		DataSet template= templateDao.find(" template_cd = '4'");
		if(template.next()){

			template_html = new String[]{setHtmlValue(template.getString("template_html"), dsHtmlData)};
			template_subhtml = new String[]{template.getString("template_subhtml")};

		}

	}else if("Y".equals(f.get("f_yn"))){
		divCnt = 1;
		divCd = new String[]{"F"};
		DataSet template= templateDao.find(" template_cd = '5'");
		if(template.next()){

			template_html = new String[]{setHtmlValue(template.getString("template_html"), dsHtmlData)};
			template_subhtml = new String[]{template.getString("template_subhtml")};

		}

	}

	if("Y".equals(f.get("s_yn"))){	//구매팀
		divCnt = 1;
		if("N".equals(f.get("kind_cd"))){	//평가서종류 N:신규, R:정기
			divCd = new String[]{"S"};	//구매
			DataSet template= templateDao.find(" template_cd = '1'");
			if(template.next()){
				template_html = new String[]{setHtmlValue(template.getString("template_html"), dsHtmlData)};
				template_subhtml = new String[]{ setHtmlValue(template.getString("template_subhtml"), dsHtmlData)};

			}
		}else{
			divCd = new String[]{"S"};	//구매
			DataSet template= templateDao.find(" template_cd = '2'");
			if(template.next()){

				template_html = new String[]{setHtmlValue(template.getString("template_html"), dsHtmlData)};
				template_subhtml = new String[]{ setHtmlValue(template.getString("template_subhtml"), dsHtmlData)};

			}
		}
	}

	for(int i=0; i<divCnt; i++){
		DataObject assedetailDao = new DataObject("tcb_assedetail");
		assedetailDao.item("asse_no", new_asse_no);
		assedetailDao.item("div_cd", divCd[i]);
		assedetailDao.item("asse_html", template_html[i]);
		assedetailDao.item("asse_subhtml", template_subhtml[i]);
		assedetailDao.item("total_point", 0);
		assedetailDao.item("rating_point", 0);
		assedetailDao.item("kind_cd", f.get("kind_cd"));
		assedetailDao.item("status", status);
		db.setCommand(assedetailDao.getInsertQuery(), assedetailDao.record);
	}


	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}

	u.jsAlertReplace("저장하였습니다.","assessment_list.jsp?"+u.getQueryString());
	return;

}

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.assessment_modify");
p.setVar("menu_cd","000101");
p.setVar("modify", modify);
p.setVar("assessment", assessment);
p.setLoop("kind_cd", u.arr2loop(kind_cd));
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
	for( Element elem : asse_doc.select("span#year0") ){ elem.text(dsCustData.getString("year0")); }
	for( Element elem : asse_doc.select("span#year1") ){ elem.text(dsCustData.getString("year1")); }
	for( Element elem : asse_doc.select("span#year2") ){ elem.text(dsCustData.getString("year2")); }
	for( Element elem : asse_doc.select("span#year00") ){ elem.text(dsCustData.getString("year0")); }
	for( Element elem : asse_doc.select("span#year11") ){ elem.text(dsCustData.getString("year1")); }
	for( Element elem : asse_doc.select("span#year22") ){ elem.text(dsCustData.getString("year2")); }
	for( Element elem : asse_doc.select("span.cust_name_area_2") ){ elem.text(dsCustData.getString("member_name")); }	//업체명
	for( Element elem : asse_doc.select("span.project_name") ){ elem.text(dsCustData.getString("project_name")); }	//프로젝트명
	asse_doc.select("input[name=project_name]").attr("value", dsCustData.getString("project_name"));	// 프로젝트명

	System.out.println("------project_name----" + dsCustData.getString("project_name"));
	//System.out.println("------asse_html----" + asse_doc.toString());
	asse_html = asse_doc.getElementsByTag("script")+asse_doc.getElementsByTag("body").html();

	return asse_html;
}

%>