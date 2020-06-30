<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String qnaseq = u.request("qnaseq");
if(qnaseq.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

String[] gubun = {"01=>���๮��","02=>������û"};

DataObject qnaDao = new DataObject("tcb_qna");
DataSet qna = qnaDao.find("qnaseq = '"+qnaseq+"' ", "qnaseq,companynm,personnm,mobile,contents,to_char(insertdate,'YYYY-MM-DD HH24:MI:SS') insertdate,gubun");
if(qna.next()){
    qna.put("gubun_nm", u.getItem(qna.getString("gubun"), gubun));
    qna.put("contents", qna.getString("contents").replaceAll("&quot;", "\"").replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("\r\n","<br>"));
} else {
    u.jsError("�ý��۱��๮�� ������ �����ϴ�.");
    return;
}

// �Է¼���
if(u.isPost() && f.validate()){
}

p.setLayout("default");
p.setDebug(out);
p.setBody("mgr.si_qna_view");
p.setVar("menu_cd","000037");
p.setVar("qna", qna);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("qnaseq"));
p.display(out);
%>