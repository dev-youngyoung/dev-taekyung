<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String client_seq = u.request("client_seq");
String person_seq = u.request("person_seq");

if(client_seq.equals("") || person_seq.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

if(u.isPost()){
	// ����� ��ü ���
	DataObject dao = new DataObject("tcb_client_detail");
	//dao.setDebug(out);

	dao.item("member_no", _member_no);
	dao.item("client_seq", client_seq);
	dao.item("person_seq", person_seq);
	if(!dao.insert()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �� ���ͷ� ������ �ּ���.");
		return;
	}
}
u.redirect("ifm_person_cust.jsp?"+u.getQueryString("client_seq"));
return;
%>