<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String member_no = u.request("member_no");
String useseq = u.request("useseq");
String template_cd = u.request("template_cd");

if(member_no.equals("") || useseq.equals("") || template_cd.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

DataObject dao = new DataObject("tcb_useinfo_add");
//dao.setDebug(out);
if(!dao.delete("template_cd='"+template_cd+"' and member_no='"+member_no+"' and useseq='"+useseq+"'")){
	u.jsError("ó���� ���� �Ͽ����ϴ�.");
	return;
}


u.jsAlertReplace("���� �Ǿ����ϴ�.", "./pay_useinfo_modify.jsp?"+u.getQueryString("template_cd,useseq"));

%>