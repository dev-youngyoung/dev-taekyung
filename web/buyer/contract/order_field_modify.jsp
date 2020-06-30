<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String id = u.request("id");
if(id.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

DataObject pDao = new DataObject("tcb_order_field");
DataSet ds = pDao.find("field_seq=" + id + " and  member_no = '"+_member_no+"'");
if(!ds.next()){
	u.jsError("�ش� ������ �����ϴ�.");
	return;
}

f.addElement("order_name", ds.getString("order_name"), "hname:'������', required:'Y', maxbyte:'100'");
f.addElement("field_name", ds.getString("field_name"), "hname:'�����', required:'Y', maxbyte:'200'");
f.addElement("field_loc", ds.getString("field_loc"), "hname:'������ġ', required:'Y', maxbyte:'200'");
f.addElement("del_yn", ds.getString("del_yn"), "hname:'�������', required:'Y'");

// �Է¼���
if(u.isPost() && f.validate())
{
	DataObject dao = new DataObject("tcb_order_field");

	dao.item("order_name", f.get("order_name"));
	dao.item("field_name", f.get("field_name"));
	dao.item("field_loc", f.get("field_loc"));
	dao.item("del_yn", f.get("del_yn"));
	if(!dao.update("member_no='"+_member_no+"' and field_seq='"+id+"'")){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. ");
		return;
	}

	u.jsAlertReplace("���� �Ǿ����ϴ�.", "./order_field_modify.jsp?"+u.getQueryString());
	return;
}


p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.order_field_modify");
p.setVar("popup_title","���� ����");

p.setVar("modify", true);
p.setVar("ds", ds);
p.setVar("list_query", u.getQueryString("id"));
p.setVar("query",u.getQueryString());			// ����
p.setVar("form_script",f.getScript());
p.display(out);
%>