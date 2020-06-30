<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
// http://dev.nicedocu.com/web/buyer/contract/cin.jsp?key=910031eebfa3a97b52c7d44580bf4d66  ����
// http://www.nicedocu.com/web/buyer/contract/cin.jsp?key=a69b5e466231b9864c44e2ddb7abcef2  ����
if(!auth.isValid()){
	u.redirect("cin_login.jsp?"+u.getQueryString());
}


String key = u.request("key");
if(key.length() == 0)
{
	u.p("�߸��� �����Դϴ�.[1]");
	return;
}

String contstr = u.aseDec(key);  // ���ڵ�
if(contstr.length() != 12)
{
	u.p("�߸��� �����Դϴ�.[2]");
	return;
}
String cont_no = contstr.substring(0,11);
String cont_chasu = contstr.substring(11);

DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu="+cont_chasu, "member_no, template_cd, status, sign_types");

if(!cont.next())
{
	u.p("�߸��� �����Դϴ�.[3]");
	return;
}

if(!cont.getString("member_no").equals(auth.getString("_MEMBER_NO")))
{
	u.p("�߸��� �����Դϴ�.[4]");
	return;
}

if(auth.getString("_MEMBER_NO").equals("20150600110")){
	//Ƽ�˿��� ��ü�� �� ��ȸ ��.
}else if(!cont.getString("status").equals("50")){
	CodeDao codeDao = new CodeDao("tcb_comcode");
	String[] code_status = codeDao.getCodeArray("M008");
	
	u.p("�Ϸ�� ����� �ƴϹǷ� ��ȸ�Ͻ� �� �����ϴ�.<br><br>���� ��� ���´� <font color='red'>" + u.getItem(cont.getString("status"),code_status) + "</font>�Դϴ�.");
	return;
}

if(cont.getString("sign_types").equals("")){
	if(!cont.getString("template_cd").equals("")) {
		if(cont.getString("status").equals("10")) {//�ۼ���
			u.redirect("contract_modify.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // ���İ��
		}else if(cont.getString("status").equals("50")){//�Ϸ�
			u.redirect("contend_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // ���İ��
		}else{//������
			u.redirect("contract_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // ���İ��
		}
	}else {
		if(cont.getString("status").equals("10")) {//�ۼ���
			u.redirect("contract_free_modify.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // ���İ��
		}else if(cont.getString("status").equals("50")){//�Ϸ�
			u.redirect("contend_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // ���İ��
		}else{//������
			u.redirect("contract_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // ���İ��
		}
	}
}else{
	if(cont.getString("status").equals("10")) {//�ۼ���
		u.redirect("contract_msign_modify.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // ���İ��
	}else if(cont.getString("status").equals("50")){//�Ϸ�
		u.redirect("contend_msign_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // ���İ��
	}else{//������
		u.redirect("contract_msign_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);  // ���İ��
	}
}
%>