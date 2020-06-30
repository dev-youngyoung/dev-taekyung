<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
f.addElement("order_name", null, "hname:'발주자', required:'Y', maxbyte:'100'");
f.addElement("field_name", null, "hname:'현장명', required:'Y', maxbyte:'200'");
f.addElement("field_loc", null, "hname:'현장위치', required:'Y', maxbyte:'200'");

// 입력수정
if(u.isPost() && f.validate())
{
	DataObject dao = new DataObject("tcb_order_field");

	String id = dao.getOne(
			"select nvl(max(field_seq),0)+1 field_seq "+
					"  from tcb_order_field where member_no = '"+_member_no+"'"
	);

	dao.item("member_no", _member_no);
	dao.item("field_seq", id);
	dao.item("order_name", f.get("order_name"));
	dao.item("field_name", f.get("field_name"));
	dao.item("field_loc", f.get("field_loc"));
	dao.item("del_yn", "Y");

	if(!dao.insert()){
		u.jsError("처리중 오류가 발생 하였습니다. ");
		return;
	}

	u.jsAlert("정상적으로 저장 되었습니다. ");
	u.jsReplace("construction_site.jsp");
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setVar("menu_cd","000117");
p.setBody("info.construction_site_view");
p.setVar("modify", false);
p.setVar("form_script", f.getScript());
p.display(out);
%>