<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_kind_cd = { "S=>수시평가", "R=>정기평가"};//"N=>신규평가"
String[] code_div_cd = {"S=>본사", "Q=>현장"};

String asse_no = u.request("asse_no");
String div_cd = u.request("div_cd");
if(asse_no.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject asseDao = new DataObject("tcb_assemaster");
DataSet asse = asseDao.find("main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"' and status = '20'");
if(!asse.next()){
	u.jsError("평가계획 정보가 없습니다.");
	return;
}

DataObject detailDao = new DataObject("tcb_assedetail");
DataSet detail = detailDao.find(" asse_no = '"+asse_no+"' and div_cd = '"+div_cd+"'");
if(!detail.next()){
	u.jsError("평가상세 정보가 없습니다.");
	return;
}
detail.put("progress_end", detail.getString("status").equals("20"));

if(u.isPost()&&f.validate()){		
	DB db = new DB();
	
	String total_point = f.get("total_point");
	String rating_point = "";
	if(asse.getString("s_yn").equals("Y")&&asse.getString("qc_yn").equals("Y")){
		rating_point = (Math.ceil((Double.parseDouble(total_point)/2)*100)/100)+"";
	}else{
		rating_point = total_point;
	}
	
	String asse_html = new String(Base64Coder.decode(f.get("asse_html")),"UTF-8");
	detailDao = new DataObject("tcb_assedetail");
	detailDao.item("total_point", total_point);
	detailDao.item("rating_point", rating_point);
	detailDao.item("asse_html", asse_html);
	detailDao.item("reg_date", u.getTimeString());
	db.setCommand(detailDao.getUpdateQuery("asse_no= '"+asse_no+"' and div_cd = '"+div_cd+"'"), detailDao.record);
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장하였습니다.","asse_progress_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.asse_progress_modify");
p.setVar("menu_cd","000159");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000159", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setLoop("code_kind_cd", u.arr2loop(code_kind_cd) );
p.setVar("asse", asse);
p.setVar("detail", detail);
p.setVar("confirm_year", u.getTimeString("yyyy"));
p.setVar("confirm_month", u.getTimeString("MM"));
p.setVar("confirm_day", u.getTimeString("dd"));
p.setVar("btn_auth", detail.getString("reg_id").equals(auth.getString("_USER_ID"))||auth.getString("_DEFAULT_YN").equals("Y"));
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("asse_no,div_cd"));
p.display(out);
%>
