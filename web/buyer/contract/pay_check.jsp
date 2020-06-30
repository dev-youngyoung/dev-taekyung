<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no")); 
String cont_chasu = u.request("cont_chasu");

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsAlert("�������� ��η� �����ϼ���.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' ";

//������� Ȯ�� 
ContractDao contDao = new ContractDao("tcb_contmaster");
DataSet cont = contDao.find(where);
if(!cont.next()){
	u.jsAlert("��������� �����ϴ�");
	return;
}

//�������� Ȯ��
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(where + " and member_no = '"+_member_no+"' ");
if(!cust.next()){
	u.jsAlert("�������� ������ �����ϴ�.");
	return;
}


if(cust.getString("pay_yn").equals("Y")){
	out.println("<script>");
	out.println("parent.fSign();");
	out.println("</script>");
	return;
}

DataObject useInfoDao = new DataObject("tcb_useinfo");
DataSet useInfo = useInfoDao.find("member_no = '"+cont.getString("member_no")+"' ");
if(!useInfo.next()){
	u.jsAlert("�� ����ڰ� ���̽���ť ������� ���ԵǾ� ���� �ʽ��ϴ�. \\n\\n���̽���ť ������(02-788-9097)�� �����ϼ���");
	return;
}
//�̿�Ⱓ ����Ȯ��
if(useInfo.getLong("useendday")<Long.parseLong(u.getTimeString("yyyyMMdd"))){ 
	if(cont.getString("member_no").equals(_member_no)){
		u.jsAlert("���� �̿�Ⱓ�� ����Ǿ� �� �̻� ����� ������ �� �����ϴ�.\\n\\���̽���ť ������(02-788-9097)�� �����ϼ���.");
		return;
	}else{
		u.jsAlert("�� ������� ���̽���ť ���Ⱓ�� ����Ǿ����ϴ�. \\n\\n���̽���ť ������(02-788-9097)�� �����ϼ���");
		return;
	}
}
/*
paytypecd M006
10	����(����)
20	����(��)
30	�Ǻ���
40	����Ʈ�� -->������.
50	�ĺ���
*/
 
if(cont.getString("member_no").equals(_member_no)){//����
	if(u.inArray(useInfo.getString("paytypecd"), new String[]{"10","20","50"})){
		out.println("<script>");
		out.println("parent.fSign();");
		out.println("</script>");
		return;
	}
}else{//����

	DataObject useInfoAddDao = new DataObject("tcb_useinfo_add");
	DataSet useInfoAdd = useInfoAddDao.find(" member_no = '"+cont.getString("member_no")+"' and template_cd = '"+cont.getString("template_cd")+"' ");
	if(useInfoAdd.next()){
		useInfo.put("insteadyn", useInfoAdd.getString("insteadyn"));
	}
	if(useInfo.getString("insteadyn").equals("Y")){//�볳�ΰ�� ��� ����
		out.println("<script>");
		out.println("parent.fSign();");
		out.println("</script>");
		return;
	}
}


String cont_name = "";
/*���� �ݾ� ���� Ȯ�� START*/
int pay_money = 0;// �����ݾ�
String insteadyn = useInfo.getString("insteadyn");//�볳����

if(cont.getString("member_no").equals(_member_no)){
	pay_money = useInfo.getInt("recpmoneyamt");
	if(insteadyn.equals("Y")){
		pay_money += useInfo.getInt("suppmoneyamt");
	}
}else{
	pay_money = useInfo.getInt("suppmoneyamt");
}

DataObject useInfoAddDao = new DataObject("tcb_useinfo_add");
DataSet useInfoAdd = useInfoAddDao.find(" member_no = '"+cont.getString("member_no")+"' and template_cd = '"+cont.getString("template_cd")+"' ");
if(useInfoAdd.next()){
	cont_name = "";
	pay_money = 0;

	insteadyn = useInfoAdd.getString("insteadyn");
	if(cont.getString("member_no").equals(_member_no)){
		pay_money = useInfoAdd.getInt("recpmoneyamt");
		if(insteadyn.equals("Y")){
			pay_money += useInfoAdd.getInt("suppmoneyamt");
		}
	}else{
		pay_money = useInfoAdd.getInt("suppmoneyamt");
	}
}

/*���� �ݾ� ���� Ȯ�� END*/

//�����ݾ��� 0���̰ų� �볳�̰� ���� ������ ��� ��� ����
if(pay_money==0||(insteadyn.equals("Y")&&!cont.getString("member_no").equals(_member_no)) ){
	out.println("<script>");
	out.println("parent.fSign();");
	out.println("</script>");
	return;
}


out.println("<form name='pay_form' method='post' target='pop_pay' action='pay_req.jsp'>");
out.println("<input type='hidden' name='cont_no' value='"+u.aseEnc(cont_no)+"'>");
out.println("<input type='hidden' name='cont_chasu' value='"+cont_chasu+"'>");
out.println("<input type='hidden' name='pay_money' value='"+u.aseEnc(pay_money+"")+"'>");
out.println("<input type='hidden' name='insteadyn' value='"+insteadyn+"'>");
out.println("<input type='hidden' name='member_no' value='"+_member_no+"'>");
out.println("</form>");
out.println("<script>");
out.println("try{");
out.println("parent.OpenWindow('','pop_pay','670','520');");
out.println("}catch(e){");
out.println(" alert('�˾��� ���ܵǾ����ϴ�.\\n\\n�˾� ��� �� �ٽ� �õ� �Ͻñ� �ٶ��ϴ�.');");
out.println("}");
out.println("");
out.println("document.forms['pay_form'].submit();");
out.println("");
out.println("</script>");
%>	

