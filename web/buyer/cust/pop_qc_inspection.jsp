<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String asse_no = u.request("asse_no", "");
if(asse_no.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

DataObject assessmentDao = new DataObject("tcb_assemaster a  inner join tcb_assedetail b on a.asse_no = b.asse_no and b.div_cd = 'Q'");
DataSet assessment = assessmentDao.find(" a.asse_no = '"+asse_no+"'", "a.*, b.asse_html, b.asse_subhtml, b.div_cd");
if(!assessment.next()){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

if(u.isPost()&&f.validate()){
	String result_point = f.get("result_point");
	String doc_html = new String(Base64Coder.decode(f.get("doc_html")),"UTF-8");;
	if(asse_no.equals("")){
		u.jsError("정상적인 경로로 접근 하세요1.");
		return;
	}
	
	DB db = new DB();
	DataObject assedetailDao = new DataObject("tcb_assedetail");
	assedetailDao.item("status", "20");
	assedetailDao.item("sub_point", result_point);
	assedetailDao.item("asse_subhtml", doc_html);
	db.setCommand(assedetailDao.getUpdateQuery("asse_no= '"+asse_no+"' and div_cd = 'Q'"), assedetailDao.record);
	
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlert("저장 하였습니다."); 
	
	out.println("<script language='javascript'>");
	out.println("opener.document.getElementById('inspectionitem1').innerHTML='"+result_point+"';");
	out.println("opener.culRatingPoint();");
	out.println("window.close();");
	out.println("</script>");
	out.close();
}
p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_qc_inspection");
p.setVar("popup_title","QC업체수시평가");
p.setVar("modify", assessment.getString("status").equals("20"));
p.setVar("cur_date", u.getTimeString("yyyy-MM-dd"));
p.setVar("assessment", assessment);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>