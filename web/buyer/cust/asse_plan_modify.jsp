<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_kind_cd = { "S=>수시평가","R=>정기평가"}; 
String[] code_div_cd = {"S=>본사", "Q=>현장"};

String asse_no = u.request("asse_no");
if(asse_no.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject asseDao = new DataObject("tcb_assemaster");
DataSet asse = asseDao.find("main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"' and status = '10'");
if(!asse.next()){
	u.jsError("평가계획 정보가 없습니다.");
	return;
}
DataObject detailDao = new DataObject("tcb_assedetail");
DataSet detail = detailDao.find("asse_no = '"+asse_no+"'");
while(detail.next()){
	if(detail.getString("div_cd").equals("S")){
		asse.put("s_user_id", detail.getString("reg_id"));
		asse.put("s_user_name", detail.getString("reg_name"));
		asse.put("s_template_cd", detail.getString("template_cd"));
	}
	if(detail.getString("div_cd").equals("Q")){
		asse.put("qc_user_id", detail.getString("reg_id"));
		asse.put("qc_user_name", detail.getString("reg_name"));
		asse.put("qc_template_cd", detail.getString("template_cd"));
	}
}

DataObject templateDao = new DataObject("tcb_asse_template");
DataSet templateQ = templateDao.find("member_no = '"+_member_no+"' and template_div_cd= 'Q' and template_use_yn = 'Y' ", "template_cd, template_name", " template_cd asc");

f.addElement("project_name", asse.getString("project_name"), "hname:'평가명', required:'Y'");
f.addElement("member_name", asse.getString("member_name"), "hname:'평가업체', required:'Y'");
f.addElement("kind_cd", asse.getString("kind_cd"), "hname:'평가종류', required:'Y'");
f.addElement("s_yn", asse.getString("s_yn"), "hname:'본사평가'");
f.addElement("qc_yn", asse.getString("qc_yn"), "hname:'현장평가'");

f.addElement("qc_temlate_cd", asse.getString("qc_template_cd"), "hname:'현장평가방법'");

if(u.isPost()&&f.validate()){		
	DB db = new DB();
	asseDao = new DataObject("tcb_assemaster");
	asseDao.item("project_name", f.get("project_name"));
	asseDao.item("member_no", f.get("member_no"));
	asseDao.item("member_name", f.get("member_name"));
	asseDao.item("reg_id", auth.getString("_USER_ID"));
	asseDao.item("reg_date", u.getTimeString());
	asseDao.item("kind_cd", f.get("kind_cd"));
	asseDao.item("s_yn", f.get("s_yn").equals("Y")?"Y":"N");
	asseDao.item("qc_yn", f.get("qc_yn").equals("Y")?"Y":"N");
	asseDao.item("bid_no",f.get("bid_no"));
	asseDao.item("bid_deg",f.get("bid_deg"));
	db.setCommand(asseDao.getUpdateQuery("main_member_no = '"+_member_no+"' and asse_no= '"+asse_no+"'  "), asseDao.record);
	
	templateDao = new DataObject("tcb_asse_template");
	db.setCommand("delete from tcb_assedetail where asse_no = '"+asse_no+"'  ", null);
	if(f.get("s_yn").equals("Y")){
		DataSet template = templateDao.find("member_no = '"+_member_no+"' and template_div_cd= 'S' and template_kind_cd = '"+f.get("kind_cd")+"' and template_use_yn = 'Y' ");
		if(!template.next()){
			u.jsError("등록된 평가지가 없습니다.");
			return;
		}
		detailDao = new DataObject("tcb_assedetail");
		detailDao.item("asse_no", asse_no);
		detailDao.item("div_cd", "S");
		detailDao.item("reg_id", f.get("s_user_id"));
		detailDao.item("reg_name", f.get("s_user_name"));
		detailDao.item("kind_cd", f.get("kind_cd"));
		detailDao.item("asse_html", template.getString("template_html"));
		detailDao.item("template_cd", template.getString("template_cd"));
		detailDao.item("status", "10");
		db.setCommand(detailDao.getInsertQuery(), detailDao.record);
	}
	if(f.get("qc_yn").equals("Y")){
		DataSet template = templateDao.find("member_no = '"+_member_no+"' and template_div_cd= 'Q' and template_kind_cd = '"+f.get("kind_cd")+"' and template_use_yn = 'Y' and template_cd = '"+f.get("qc_temlate_cd")+"'  ");
		if(!template.next()){
			u.jsError("등록된 평가지가 없습니다.");
			return;
		}
		detailDao = new DataObject("tcb_assedetail");
		detailDao.item("asse_no", asse_no);
		detailDao.item("div_cd", "Q");
		detailDao.item("reg_id", f.get("qc_user_id"));
		detailDao.item("reg_name", f.get("qc_user_name"));
		detailDao.item("kind_cd", f.get("kind_cd"));
		detailDao.item("asse_html", template.getString("template_html"));
		detailDao.item("template_cd", template.getString("template_cd"));
		detailDao.item("status", "10");
		db.setCommand(detailDao.getInsertQuery(), detailDao.record);
	}
	
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장하였습니다.","asse_plan_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.asse_plan_modify");
p.setVar("menu_cd","000158");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000158", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setLoop("code_kind_cd", u.arr2loop(code_kind_cd) );
p.setVar("asse", asse);
p.setLoop("templateQ", templateQ );
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("asse_no"));
p.display(out);
%>
