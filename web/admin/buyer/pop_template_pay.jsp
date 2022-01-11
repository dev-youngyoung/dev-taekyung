<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
String useseq = u.request("useseq");

DataObject templateDao = new DataObject("tcb_cont_template tt");
DataSet template = templateDao.find(" status>0 and tt.member_no like '%"+member_no+"%' and tt.template_cd not in (select template_cd from tcb_useinfo_add where member_no='"+member_no+"' ) and use_yn = 'Y'", "template_cd, nvl(display_name,template_name) template_name", "display_seq asc, template_cd desc");

f.addElement("template_cd", null, "hname:'계약서 종류', required:'Y'");
f.addElement("recpmoneyamt", null, "hname:'원사업자 이용요금', required:'Y', option:'money'");
f.addElement("suppmoneyamt", null, "hname:'수급사업자 이용요금', required:'Y', option:'money'");
f.addElement("insteadyn", null, "hname:'수급사업자 요금 처리', required:'Y'");

if(u.isPost()&&f.validate()){

	DB db = new DB();
	DataObject dao = new DataObject("tcb_useinfo_add");

	dao.item("member_no", member_no);
	dao.item("useseq", useseq);
	dao.item("template_cd", f.get("template_cd"));
	dao.item("recpmoneyamt", f.get("recpmoneyamt").replaceAll(",", ""));
	dao.item("suppmoneyamt", f.get("suppmoneyamt").replaceAll(",", ""));
	dao.item("insteadyn", f.get("insteadyn"));
	db.setCommand(dao.getInsertQuery(), dao.record);
	
	if(!db.executeArray()){
		u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
		return;
	}

	out.print("<script>alert('추가 되었습니다.');opener.location.reload();window.close();</script>");
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("buyer.pop_template_pay");
p.setVar("popup_title","요금정보");
p.setLoop("template", template);
p.setVar("form_script", f.getScript());
p.display(out);
%>