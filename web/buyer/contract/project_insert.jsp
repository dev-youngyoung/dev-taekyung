<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
f.addElement("order_name", null, "hname:'������', required:'Y', maxbyte:'100'");
f.addElement("field_name", null, "hname:'������Ʈ��', required:'Y', maxbyte:'200'");
f.addElement("del_yn", "Y", "hname:'�������', required:'Y'");

// �Է¼���
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
	dao.item("del_yn", f.get("del_yn"));

	if(!dao.insert()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. ");
		return;
	}

	u.jsAlert("���������� ���� �Ǿ����ϴ�. ");
	u.jsReplace("project_list.jsp");
	return;
}


p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.project_modify");
p.setVar("popup_title","������Ʈ ����");
p.setVar("modify", false);
p.setVar("form_script", f.getScript());
p.display(out);
%>