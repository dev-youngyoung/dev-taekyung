<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String id = u.request("id");
if(id.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

DataObject pDao = new DataObject("tcb_order_field");
DataSet ds = pDao.find("field_seq=" + id + " and  member_no = '"+_member_no+"'");
if(!ds.next()){
	u.jsError("해당 현장이 없습니다.");
	return;
}

f.addElement("order_name", ds.getString("order_name"), "hname:'발주자', required:'Y', maxbyte:'100'");
f.addElement("field_name", ds.getString("field_name"), "hname:'현장명', required:'Y', maxbyte:'200'");
f.addElement("field_loc", ds.getString("field_loc"), "hname:'현장위치', required:'Y', maxbyte:'200'");
f.addElement("del_yn", ds.getString("del_yn"), "hname:'현장상태', required:'Y'");

// 입력수정
if(u.isPost() && f.validate())
{
	DataObject dao = new DataObject("tcb_order_field");

	dao.item("order_name", f.get("order_name"));
	dao.item("field_name", f.get("field_name"));
	dao.item("field_loc", f.get("field_loc"));
	dao.item("del_yn", f.get("del_yn"));
	if(!dao.update("member_no='"+_member_no+"' and field_seq='"+id+"'")){
		u.jsError("처리중 오류가 발생 하였습니다. ");
		return;
	}

	u.jsAlertReplace("저장 되었습니다.", "./order_field_modify.jsp?"+u.getQueryString());
	return;
}


p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.order_field_modify");
p.setVar("popup_title","현장 정보");

p.setVar("modify", true);
p.setVar("ds", ds);
p.setVar("list_query", u.getQueryString("id"));
p.setVar("query",u.getQueryString());			// 삭제
p.setVar("form_script",f.getScript());
p.display(out);
%>