<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ּ���.");
	return;
}
if(u.isPost()){
	DataObject clientDao = new DataObject("tcb_client");
	DataObject clientDetailDao = new DataObject("tcb_client_detail");
	DataSet clientDs = clientDao.find("member_no = '"+member_no+"' and client_no = '"+_member_no+"' ");

	String client_seq = "";
	if(clientDs.next())
	{
		client_seq = clientDs.getString("client_seq");

		if(!clientDetailDao.delete(" member_no = '"+member_no+"' and client_seq = " + client_seq)){
			u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �� ���ͷ� ������ �ּ���.");
			return;
		}

		if(!clientDao.delete(" member_no = '"+member_no+"' and client_no = '"+_member_no+"' ")){
			u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �� ���ͷ� ������ �ּ���.");
			return;
		}
	}

}
u.redirect("cust_list.jsp?"+u.getQueryString("member_no"));
return;
%>