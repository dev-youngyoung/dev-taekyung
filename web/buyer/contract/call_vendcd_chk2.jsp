<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String vendcd = u.request("vendcd");
if(vendcd.equals("")){
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao .find(" vendcd = '"+vendcd+"' ");
if(!member.next()){
	out.print("<script language=\"javascript\">");
	out.print(" alert('��ϰ����� ����� ��� ��ȣ �Դϴ�.');");
	out.print(" document.forms['form1']['chk_vendcd'].value='1';");
	out.print("</script>");
}else{
	if(member.getString("status").equals("01") || member.getString("status").equals("02")){  // ��ȸ�� �Ǵ� ��ȸ������ ��ü ���� ����.
		/*
		DataObject clientDao = new DataObject("tcb_client");
		int client_cnt = clientDao.findCount(" client_no = '"+member.getString("member_no")+"' ");
		if(client_cnt > 0){
			out.print("<script>");
			out.print("alert('���¾�ü�� ��ϵ� ��ü �Դϴ�.\\n\\n��ü�˻��� ���� ��ü�� �߰��� �ּ���.'); self.close();");
			out.print("</script>");
			return;
		}
		*/


		DataObject personDao = new DataObject("tcb_person");
		DataSet person = personDao.find(" member_no = '"+member.getString("member_no")+"' and default_yn = 'Y' ");
		if(!person.next()){
		}
		out.print("<script>");
		out.print(" document.forms['form1']['chk_vendcd'].value='2';");
		out.print(" if(confirm('������ ��ϵ� ��ü ������ �ֽ��ϴ�.\\n\\n���� ������ �ڵ����� �Է� �Ͻðڽ��ϱ�?')){");
		out.print("	document.forms['form1']['chk_member_no'].value='"+member.getString("member_no")+"';");
		out.print("	document.forms['form1']['member_name'].value='"+member.getString("member_name")+"';");
		out.print("	document.forms['form1']['boss_name'].value='"+member.getString("boss_name")+"';");
		out.print("	document.forms['form1']['post_code'].value='"+member.getString("post_code")+"';");
		out.print("	document.forms['form1']['address'].value='"+member.getString("address")+"';");
		out.print("	document.forms['form1']['user_name'].value='"+person.getString("user_name")+"';");
		out.print("	document.forms['form1']['tel_num'].value='"+person.getString("tel_num")+"';");
		out.print("	document.forms['form1']['hp1'].value='"+person.getString("hp1")+"';");
		out.print("	document.forms['form1']['hp2'].value='"+person.getString("hp2")+"';");
		out.print("	document.forms['form1']['hp3'].value='"+person.getString("hp3")+"';");
		out.print("	document.forms['form1']['email'].value='"+person.getString("email")+"';");
		out.print("	}");
		out.print("</script>");
	}
	if(member.getString("status").equals("00")){//DB�� �Ⱥ��̰� ó�� �ѳ�
		out.print("<script>");
		out.print(" document.forms['form1']['chk_vendcd'].value='';");
		out.print(" alert('����� �� ���� ��ü �Դϴ�.\\n\\n�����ͷ� ������ �ּ���.');");
		out.print("</script>");
	}

}




%>