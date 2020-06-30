<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
DataObject mdao = new DataObject("tcb_member tm inner join tcb_person tp on tm.member_no=tp.member_no");
//mdao.setDebug(out);
DataSet member = mdao.find("tm.member_no = '"+_member_no+"' and tp.default_yn='Y'", "tm.member_gubun, tm.cert_end_date, tp.jumin_no, tm.vendcd");
if(!member.next()){
	u.jsError("ȸ�������� �����ϴ�.");
	return;
}else{
	if(member.getString("member_gubun").equals("04")) //����ȸ��
	{
		Security	security	=	new	Security();
		member.put("jumin_no", security.AESdecrypt(member.getString("jumin_no")).substring(0, 6));
	} 
	
	member.put("cert_end_date", u.getTimeString("yyyy-MM-dd",member.getString("cert_end_date")));
}

DataObject clientDao = new DataObject("tcb_client");
//ktm&s ���λ������ ���
if(clientDao.findCount(" client_no = '"+_member_no+"' and member_no = '20140900004' ")>0&&auth.getString("_MEMBER_GUBUN").equals("03")){
	u.jsError("���������ȳ�\\n\\nktm&s�� �ŷ��Ͻô� ���λ�����̽� ���\\n\\n������ ��Ͼ��� ��ǥ�ں��� ���ι��� ���� ��������\\n\\n��༭�� ���� �ϼž� �մϴ�.\\n\\n���ι��� �������� ��ǥ�ں��� ��������\\n\\n�ŷ��Ͻô� ���� �����������Ϳ��� �߱� �����մϴ�.\\n\\n(���ι������������ �߱޺�� :4,400��-�ΰ�������)");
	return;
}else if(clientDao.findCount(" client_no = '"+_member_no+"' and member_no = '20130400333' ")>0&&auth.getString("_MEMBER_GUBUN").equals("03")){
	u.jsAlert("���������ȳ�\\n\\n�����̴������� �ŷ��Ͻô� ���λ�����̽� ���\\n���ǿ� ���� ��밡�� �������� �ٸ��ϴ�.\\n�Ʒ� ������ �� ���� �ϼ���.\\n\\n*���ۺ� ���ð�� : ��ǥ���� ���ι������������( ��������� ���ʿ� / �߱޺�� :4,400��-�ΰ�������)\\n*������/������ �����ð�� : ����ڿ�������(��������� �ʿ�)");
// �ư����� ��ǰ��༭�� ��� '�����'�������� ('���ؽ�'����԰� ��ȭ �� ������. (���ؽ� ����Ե� �� �𸣽�.. �Ф�;; ))
//}else if(clientDao.findCount(" client_no = '"+_member_no+"' and member_no = '20151101164' ")>0&&auth.getString("_MEMBER_GUBUN").equals("03")){
//	u.jsError("���������ȳ�\\n\\n(��)�ư�������۴Ͽ� �ŷ��Ͻô� ���λ�����̽� ���\\n\\n������ ��Ͼ��� ��ǥ�ں��� ���ι��� ���� ��������\\n\\n��༭�� ���� �ϼž� �մϴ�.\\n\\n���ι��� �������� ��ǥ�ں��� ��������\\n\\n�ŷ��Ͻô� ���� �����������Ϳ��� �߱� �����մϴ�.\\n\\n(���ι������������ �߱޺�� :4,400��-�ΰ�������)");
}else if(clientDao.findCount(" client_no = '"+_member_no+"' and member_no = '20171100251' ")>0&&auth.getString("_MEMBER_GUBUN").equals("03")){
	u.jsError("���������ȳ�\\n\\n����ī����� �ŷ��Ͻô� ���λ�����̽� ���\\n\\n������ ��Ͼ��� ��ǥ�ں��� ���ι��� ���� ��������\\n\\n��༭�� ���� �ϼž� �մϴ�.\\n\\n���ι��� �������� ��ǥ�ں��� ��������\\n\\n�ŷ��Ͻô� ���� �����������Ϳ��� �߱� �����մϴ�.\\n\\n(���ι������������ �߱޺�� :4,400��-�ΰ�������)");
	return;
}else if(clientDao.findCount(" client_no = '"+_member_no+"' and member_no = '20191101572' ")>0&&auth.getString("_MEMBER_GUBUN").equals("03")){
	u.jsError("���������ȳ�\\n\\n�������(��)�� �ŷ��Ͻô� ���λ�����̽� ���\\n\\n������ ��Ͼ��� ��ǥ�ں��� ���ι��� ���� ��������\\n\\n��༭�� ���� �ϼž� �մϴ�.\\n\\n���ι��� �������� ��ǥ�ں��� ��������\\n\\n�ŷ��Ͻô� ���� �����������Ϳ��� �߱� �����մϴ�.\\n\\n(���ι������������ �߱޺�� :4,400��-�ΰ�������)");
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("info.cert_info");
p.setVar("menu_cd","000109");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000108", "btn_auth").equals("10"));
p.setVar("member",member);
p.setVar("person_yn", member.getString("member_gubun").equals("04"));
p.setVar("sys_date", u.getTimeString());
p.setVar("form_script", f.getScript());
p.display(out);
%>