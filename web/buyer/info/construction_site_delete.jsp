<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String id = u.request("id");
String mode = u.request("mode");

if(id.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

DataObject oDao = new DataObject("tcb_contmaster");
DataSet ds = oDao.find("member_no = '"+_member_no+"' and order_field_seq > 0");
if(ds.next()){
	u.jsError("�ش� ������ ������� �����̶� ������ �� �� �����ϴ�.");
	return;
}

DataObject dao = new DataObject("tcb_order_field");

if(!dao.delete("member_no='"+_member_no+"' and field_seq="+id)){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("���� �Ǿ����ϴ�.", "./construction_site.jsp?"+u.getQueryString("id"));
%>