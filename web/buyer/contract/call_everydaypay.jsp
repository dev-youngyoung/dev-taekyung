<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
//���ַ̼�� ������� ��ȣ ���� 
String vendcd = u.request("vendcd");
if(vendcd.equals("")){
	out.println("<script>");
	out.println("alert('������� ����� ��Ϲ�ȣ�� �����ϴ�.\\n\\n������¹�ȣ�� �ڵ� ��ϵ��� �ʾҽ��ϴ�.');");
	out.println("</script>");
	return;
}

DataSet data = getData(vendcd);
if(data.getString("result").equals("false")){
	out.println("<script>");
	out.println("alert('�ý��� ������ ���� �Ͽ����ϴ�.\\n\\n�����ͷ� ���� �ϻ�� �ٶ��ϴ�.');");
	out.println("</script>");
	return;
}
if(!data.getString("resultCode").equals("01")){
	out.println("<script>");
	out.println("alert('������� ������ ���� �Ͽ����ϴ�.\\n\\n����ڵ�Ϲ�ȣ:"+u.getBizNo(vendcd)+"\\n\\n(RESULTCODE:"+data.getString("resultCode")+",MSG:"+data.getString("message")+")');");
	out.println("</script>");	
	return;
}

out.println("<script>");
out.println("alert('�ش������� ������¹�ȣ�� �ڵ� �Է� �˴ϴ�.\\n(����ڵ�Ϲ�ȣ:"+u.getBizNo(vendcd)+"\\n�������:"+data.getString("accno")+")');");
out.println("document.forms['form1']['v_account'].value='"+data.getString("accno")+"';");
out.println("replaceInput(document.forms['form1']['v_account'], document.forms['form1']['v_account'].name, document.all.__html)");
out.println("</script>");

%>
<%!
public DataSet getData(String vendcd){
	DataSet data = null;
	String url = "http://everydaypay.co.kr/Nice/getAccno";
	try{
		System.out.println("���� URL=>"+url+"?vendcd="+vendcd);
		Http hp = new Http();
		hp.setUrl(url);
		hp.setEncoding("UTF-8");
		hp.setParam("bizRegNo", vendcd);
		String msg_body = hp.send();
		// print result
		System.out.println(msg_body);
		
		data = Util.json2Dataset(msg_body);
		if(!data.next()){
			data.put("result", "true");
		}
	}catch(Exception e){
		e.printStackTrace(System.out);
		data = new DataSet();
		data.addRow();
		data.put("result", "false");
	}
	
	return data;
}

%>