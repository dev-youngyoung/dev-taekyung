<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String sMemberNo = u.request("member_no");	//	ȸ����ȣ
if(sMemberNo.equals("")){
	u.jsError("�������� ��� �����ϼ���.");
	return;	
}

DataObject doTM = new DataObject("tcb_member");
DataSet dsTM = doTM.find("	member_no = '"+sMemberNo+"'");
if(!dsTM.next()){
	u.jsError("��ü������ �����ϴ�.");
	return;
}else
{
	dsTM.put("vendcd2",u.getBizNo(dsTM.getString("vendcd")));
}

p.setLayout("popup");
p.setVar(dsTM);
//p.setDebug(out);
p.setBody("buyer.pop_src_insert");
p.setVar("popup_title","��ü�� �ҽ̰���");
p.setVar("form_script", f.getScript());
p.display(out);

%>