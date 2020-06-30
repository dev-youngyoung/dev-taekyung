<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

//입력수정
if(u.isPost()){
	
	String asse_no = f.get("asse_no");
	String div_cd = f.get("div_cd");	
	String ratingDate = f.get("ratingDate");
	String point = f.get("point");
	String rating = f.get("rating");
	String doc_html = new String(Base64Coder.decode(f.get("doc_html")),"UTF-8");;
	if(asse_no.equals("")){
		u.jsError("정상적인 경로로 접근 하세요1.");
		return;
	}
	
	DataObject assessmentDao = new DataObject("tcb_assemaster a  inner join tcb_assedetail b on a.asse_no = b.asse_no and b.div_cd = 'S'");
	DataSet assessment = assessmentDao.find(" a.asse_no = '"+asse_no+"'", "a.*, b.asse_html, b.asse_subhtml");
	if(!assessment.next()){
		u.jsError("정상적인 경로로 접근 하세요2.");
		return;
	}
	
	DB db = new DB();
	DataObject assedetailDao = new DataObject("tcb_assedetail");
	//assedetailDao.item("reg_id", auth.getString("_USER_ID"));
	//assedetailDao.item("reg_name", auth.getString("_USER_NAME"));
	assedetailDao.item("sub_point", point);
	//assedetailDao.item("rating_point", rating);
	//assedetailDao.item("reg_date", ratingDate);
	assedetailDao.item("status", "20");
	assedetailDao.item("asse_subhtml", doc_html);
	db.setCommand(assedetailDao.getUpdateQuery("asse_no= '"+asse_no+"' and div_cd = '"+div_cd+"'"), assedetailDao.record);
	
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlert("저장 하였습니다.");
	
	out.println("<script language='javascript'>");
	out.println("opener.financeCallback('"+point+"');");
	out.println("window.close();");
	out.println("</script>");
	out.close();

}

%>