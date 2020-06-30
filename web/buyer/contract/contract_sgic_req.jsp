<%@page import="org.apache.commons.codec.binary.Base64"%>
<%@page import="javax.crypto.spec.IvParameterSpec"%>
<%@page import="javax.crypto.Cipher"%>
<%@page import="javax.crypto.spec.SecretKeySpec"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%!

public static String sgicKey = "N!ceDocu&N!ceDoc";
public static String iv = "reacTiveJava9Sep";

/**
 * �������� ��û ��ȣȭ
 * @param message
 * @return
 * @throws Exception
 */
 public static String AESencryptSgic(String message) throws Exception {
	
	SecretKeySpec skeySpec = new SecretKeySpec(sgicKey.getBytes(), "AES"); 
	
	Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
	cipher.init(Cipher.ENCRYPT_MODE, skeySpec, new IvParameterSpec(iv.getBytes("UTF-8")));
	
	byte[] encrypted = cipher.doFinal(message.getBytes("UTF-8"));
	String enStr = new String(Base64.encodeBase64(encrypted));
	
	return enStr;
} 

%>
<%
Security security = new Security();
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu =  u.request("cont_chasu");

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";

DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find(where);
if(!cont.next()){
	u.jsError("��������� �����ϴ�.");
	return;
}

DataObject custDao = new DataObject("tcb_cust");

// �Ǻ�����
DataSet cust1 = custDao.find(where + " and member_no = '"+cont.getString("member_no")+"' ");
if(!cust1.next()){
	u.jsError("�Ǻ����� ������ �����ϴ�.");
	return;
}

// ������
DataSet cust2 = custDao.find(where + " and member_no = '"+_member_no+"' ");
if(!cust2.next()){
	u.jsError("���谡���� ������ �����ϴ�.");
	return;
}
%>
<form  name="sgicForm" method="post"  action="https://www.nicedata.co.kr/as/AS_40602.do">
	<input type="hidden" name="appfCls" value="004" />
	<input type="hidden" name="cttName"  value="<%=AESencryptSgic(cont.getString("cont_name"))%>" />
	
	<input type="hidden" name="ispsShop"  value="<%=AESencryptSgic(cust1.getString("member_name"))%>" />
	<input type="hidden" name="ispsBizNo"  value="<%=AESencryptSgic(cust1.getString("vendcd"))%>" />
	<input type="hidden" name="ispsRpsrName"  value="<%=AESencryptSgic(cust1.getString("boss_name"))%>" />
	
 	<input type="hidden" name="shop"  value="<%=AESencryptSgic(cust2.getString("member_name"))%>" />
  	<input type="hidden" name="bizNo"  value="<%=AESencryptSgic(cust2.getString("vendcd"))%>" />
	<input type="hidden" name="rpsrName"  value="<%=AESencryptSgic(cust2.getString("boss_name"))%>" />
	<input type="hidden" name="telNo"  value="<%=AESencryptSgic(cust2.getString("tel_num").replaceAll("-", ""))%>" />
	<input type="hidden" name="hpNo"  value="<%=AESencryptSgic(cust2.getString("hp1")+"-"+cust2.getString("hp2")+"-"+cust2.getString("hp3"))%>" />
	<input type="hidden" name="email"  value="<%=AESencryptSgic(cust2.getString("email"))%>" />
	<input type="hidden" name="rsbmName"  value="<%=AESencryptSgic(cust2.getString("user_name"))%>" />
</form>

<script type="text/javascript">
	var f = document.forms['sgicForm'];
	f.target="_blank";
	f.submit();
</script>
