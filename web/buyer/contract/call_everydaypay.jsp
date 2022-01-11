<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
//케이솔루션 가상계좌 번호 연동 
String vendcd = u.request("vendcd");
if(vendcd.equals("")){
	out.println("<script>");
	out.println("alert('연동대상 사업자 등록번호가 없습니다.\\n\\n가상계좌번호가 자동 등록되지 않았습니다.');");
	out.println("</script>");
	return;
}

DataSet data = getData(vendcd);
if(data.getString("result").equals("false")){
	out.println("<script>");
	out.println("alert('시스템 연동에 실패 하였습니다.\\n\\n고객센터로 문의 하사기 바랍니다.');");
	out.println("</script>");
	return;
}
if(!data.getString("resultCode").equals("01")){
	out.println("<script>");
	out.println("alert('가상계좌 연동에 실패 하였습니다.\\n\\n사업자등록번호:"+u.getBizNo(vendcd)+"\\n\\n(RESULTCODE:"+data.getString("resultCode")+",MSG:"+data.getString("message")+")');");
	out.println("</script>");	
	return;
}

out.println("<script>");
out.println("alert('해당사업자의 가상계좌번호가 자동 입력 됩니다.\\n(사업자등록번호:"+u.getBizNo(vendcd)+"\\n가상계좌:"+data.getString("accno")+")');");
out.println("document.forms['form1']['v_account'].value='"+data.getString("accno")+"';");
out.println("replaceInput(document.forms['form1']['v_account'], document.forms['form1']['v_account'].name, document.all.__html)");
out.println("</script>");

%>
<%!
public DataSet getData(String vendcd){
	DataSet data = null;
	String url = "http://everydaypay.co.kr/Nice/getAccno";
	try{
		System.out.println("연동 URL=>"+url+"?vendcd="+vendcd);
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