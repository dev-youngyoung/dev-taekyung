<%
/*************************************************************************
* �� �� �� : emailReadCheck.jsp
* �� �� �� : ������
* �� �� �� : 2014-08-21
* ��    �� : �̸��� ���� Ȯ��(�Ϲݱ����)
*            �̸��� �ȿ� <img width="0" height="0" src="http://www.nicedocu.com/web/buyer/contract/emailReadCheck.jsp?cont_no=200810020001&cont_chasu=xxx&member_no=xxxxxxx&num=1" /> �߰�
* ---------------------------- �� �� �� �� -------------------------------
* ��ȣ �� �� ��   ��      ��     ��   ���泻��                       ���
* ------------------------------------------------------------------------
*   1  ������     2014-08-21          �ű��ۼ�
*************************************************************************/
%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>

<%
	boolean bSuccess = false;
    String cont_no = u.request("cont_no");
    String cont_chasu = u.request("cont_chasu");
    String member_no = u.request("member_no");
    String email_seq = u.request("num");

	if(!cont_no.equals("") && !cont_chasu.equals("") && !member_no.equals("") && !email_seq.equals(""))
	{
		System.out.println("�̸��� ���� Ȯ��");
		System.out.println("cont_no : " + cont_no);
		System.out.println("cont_chasu : " + cont_chasu);
		System.out.println("member_no : " + member_no);
		System.out.println("email_seq : " + email_seq);

		DataObject emailDao = new DataObject("tcb_cont_email");

		emailDao.item("recv_dete", u.getTimeString());
		emailDao.item("status", "03");
		if(!emailDao.update(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+member_no+"' and email_seq = '"+email_seq+"' and recv_dete is null"))
			System.out.print("�Ϲݱ���� ���ڰ�� �̸��� ���� Ȯ�� ���� - cont_no : " + cont_no + ", cont_chasu : " + cont_chasu);
		else
			System.out.print("�Ϲݱ���� ���ڰ�� �̸��� ���� Ȯ�� ����");
	}

%>

