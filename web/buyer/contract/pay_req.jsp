<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="
                 java.util.Date,
                 java.sql.Timestamp,
                 java.net.InetAddress,
				 nicelib.util.*,
				 kr.co.nicepay.module.lite.util.NicePayParamSetter
                 " %>
<%

String cont_no = u.aseDec(u.request("cont_no")); 
String cont_chasu = u.request("cont_chasu");
String s_pay_money =  u.aseDec(u.request("pay_money"));
String insteadyn = u.request("insteadyn");
String member_no = u.request("member_no");
if(cont_no.equals("")||cont_chasu.equals("")||s_pay_money.equals("")||insteadyn.equals("")||member_no.equals("")){
	u.jsErrClose("�������� ��η� �����ϼ���.");
	return;
}
if(!_member_no.equals(member_no)){
	u.jsErrClose("�α��λ���ڰ� ���� �Ǿ����ϴ�.\\n\\n������ �ٽ� ���� �ϼ���.");
	return;
}

int pay_money = Integer.parseInt(s_pay_money);
int pay_vat = pay_money/10;
String where = " cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' ";

//������� Ȯ�� 
ContractDao contDao = new ContractDao("tcb_contmaster");
DataSet cont = contDao.find(where);
if(!cont.next()){
	u.jsAlert("��������� �����ϴ�");
	return;
}

//����� �߰� ����
DataObject personDao = new DataObject("tcb_person");
DataSet person = personDao.find("member_no='"+_member_no+"' and user_id='"+auth.getString("_USER_ID")+"' ");
if(!person.next()){
 u.jsError("����������� �������� �ʽ��ϴ�.");
 return;
}

//��� ������ ���������� �ʿ��� ������
String nice_ordervendcd  = auth.getString("_VENDCD");// �ֹ��� ����ڹ�ȣ
String nice_ordername    = getLimitString(auth.getString("_MEMBER_NAME"), 20);// �ֹ��� ���� (20�ڸ�)
String nice_orderphone   = person.getString("hp1")+person.getString("hp2")+person.getString("hp3");// �ֹ��� ��ȭ��ȣ (20�ڸ�)
String nice_orderemail   = person.getString("email");// �ֹ��� �̸���
String nice_orderno      = cont_no + cont_chasu;// �ֹ���ȣ 20�ڸ� �� �ŷ��ø��� �����ؾ��� (20�ڸ� ����)
String nice_good_name    = "���̽���ť �Ӵ� �̿� ������";// ��ǰ�� (40�ڸ�)
String nice_amount		= (pay_money+pay_vat)+"";// ���Ű���

//�ֹ���ȣ 20�ڸ� ����
int iOrdernoLen = nice_orderno.length();
RandomString rndStr = new RandomString();
nice_orderno += rndStr.getString(20-iOrdernoLen, "a");// �����ҹ��ڷ� ������ ���ǹ��ڿ��� ����

NicePayParamSetter paramSetter = new NicePayParamSetter();

//���� IP ��������
InetAddress inet = InetAddress.getLocalHost();

//������� �Աݸ�����
Timestamp toDay = new Timestamp((new Date()).getTime());
Timestamp nxDay = paramSetter.getTimestampWithSpan(toDay, 1);
String VbankExpDate = nxDay.toString();
VbankExpDate = VbankExpDate.substring(0, 10);
VbankExpDate = VbankExpDate.replaceAll("-", "");

String ediDate = paramSetter.getyyyyMMddHHmmss(); // ���������Ͻ�

//��������Ű (�� �ش� ����Ű�� �ٲ��ּ���)
//String merchantKey = "33F49GnCMS1mFYlGXisbUDzVf2ATWCl9k3R++d5hDd3Frmuos/XLx8XhXpe+LDYAbpGKZYSwtlyyLOtS/8aD7A==";
//String merchantKey		= "q7LNeQuqUrQxRiKfG1tZ4nMFSytahkVr6rAnRh5DpmFsOZ3EbFNiBtrdCxQRkxRx6FR4RjOAC58bGZzW5GPE+w==";		// ��������Ű (����-���̽���غ�)
String merchantKey		= "lxHiWRNaNLAShqnlgw0ZXIdvTKVE+qty/ZNoEk73JEGukRR7OacU5aB6+gWFI/mhxJ2LWBKLXkrAXbIztLyUNA==";		// ��������Ű (����-���̽�������)
// ���� MID
//String merchantID = "nictest00m";
//String merchantID = "2543mmmmmm";						// ���� ���� ���̵�(���̽���غ�)
String merchantID = "docu00002m";						// ���� ���� ���̵�(���̽�������)
//hash ó��
String md_src = ediDate + merchantID + nice_amount + merchantKey;
String hash_String  = paramSetter.encrypt(md_src);

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>NICEPAY :: ���� ��û</title>
<link rel="stylesheet" href="/pay/css/basic.css" type="text/css" />
<link rel="stylesheet" href="/pay/css/style.css" type="text/css" />
<script src="https://web.nicepay.co.kr/flex/js/nicepay_tr.js" language="javascript"></script>
<script language="javascript">
NicePayUpdate();	//Active-x Control �ʱ�ȭ

/**
nicepay	�� ���� ������ �����մϴ�.
@param	form :	���� Form
*/
function nicepay() {
 if(checkedButtonValue('selectType')==null || checkedButtonValue('selectType')=='') {
     alert('���������� ������ �ּ���.');
     return;
 }

	var payForm		= document.payForm;


	// �ʼ� ���׵��� üũ�ϴ� ������ �������ּ���.
	//alert(payForm.BuyerAuthNum.value);

	goPay(payForm);
}

function nicepaySubmit(){
	document.payForm.submit();
}


/**
������ ��� �Ҷ� ȣ��˴ϴ�.
*/
function nicepayClose()
{
	//window.close();
}

function chkPayType(obj)
{
	document.payForm.PayMethod.value = checkedButtonValue('selectType');
}

</script>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<br>
<form name="payForm" method="post" action="pay_res.jsp">
<table width="632" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
	<td >
	  <table width="632" border="0" cellspacing="0" cellpadding="0" class="title">
     <tr>
       <td width="35">&nbsp;</td>
       <td>���̽���ť �̿� ������ ����</td>
       <td>&nbsp;</td>
     </tr>
   </table>
 </td>
</tr>
<tr>
 <td align="left" valign="top" background="/pay/images/bodyMiddle.gif">
 <table width="632" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td width="35" height="10">&nbsp;</td> <!--��ܿ��� ���� 10px -->
     <td width="562">&nbsp;</td>
     <td width="35">&nbsp;</td>
   </tr>
   <tr>
     <td height="30">&nbsp;</td>
     <td>��༭�� �����ϱ� ���ؼ��� ���� �̿�����Ḧ �����ϼž� �մϴ�.</td>
     <td>&nbsp;</td>
   </tr>
   <tr>
     <td height="15">&nbsp;</td> <!--�������� ������ ���� ���� 15px-->
     <td>&nbsp;</td>
     <td>&nbsp;</td>
   </tr>
   <tr>
     <td height="30">&nbsp;</td>
     <td class="bold"><img src="/pay/images/bullet.gif" /> ������ Ȯ�� �Ͻ� �� �����ϱ� ��ư�� �����ֽʽÿ�.
     <td>&nbsp;</td>
   </tr>
   <tr>
     <td>&nbsp;</td>
     <td>
		  <table width="562" border="0" cellspacing="0" cellpadding="0" class="talbeBorder" >
       <tr>
         <td width="100" height="30" id="borderBottom" class="thead01">���� ����</td>
         <td id="borderBottom">
           <input type="radio" name="selectType" value="CARD" style="border:0" onClick="chkPayType(this)">[�ſ�ī��]
			  <input type="radio" name="selectType" value="BANK" style="border:0" onClick="chkPayType(this)">[������ü]
			</td>
       </tr>
		  <tr>
         <td width="100" height="30" id="borderBottom" class="thead01">* ��ǰ��</td>
         <td id="borderBottom">&nbsp;<%=nice_good_name%></td>
       </tr>
       <tr>
         <td width="100" height="30" id="borderBottom" class="thead02">* ��ǰ����</td>
         <td id="borderBottom">&nbsp;<%=nice_amount%> ��</td>
       </tr>
       <tr>
         <td width="100" height="30" id="borderBottom" class="thead02">* �����ڸ�</td>
         <td id="borderBottom">&nbsp;<%=nice_ordername%></td>
       </tr>
       <tr>
         <td width="100" height="30" id="borderBottom" class="thead01">* �̸���</td>
         <td id="borderBottom">&nbsp;<%=nice_orderemail%></td>
       </tr>
       <tr>
         <td width="100" height="30" id="borderBottom" class="thead02">* ��ȭ��ȣ</td>
         <td id="borderBottom">&nbsp;<%=nice_orderphone%></td>
       </tr>
     </table></td>
     <td height="15">&nbsp;</td>
   </tr>
   <tr>
   	<td height="60"></td>
     <td class="btnCenter"><input type="button" value="�����ϱ�" onClick="nicepay();"></td> <!-- �ϴܿ� ��ư�� �ִ°�� ��ư���� ���� ���� 30px -->
     <td>&nbsp;</td>
   </tr>
   <tr>
     <td height="10"></td>  <!--�ϴܿ��� ���� 10px -->
     <td >&nbsp;</td>
     <td>&nbsp;</td>
   </tr>
 </table></td>
</tr>
<tr>
 <td><img src="/pay/images/bodyBottom.gif" /></td>
</tr>
</table>
<!-- ���� ���� -->
<input type="hidden" name="cont_no" value="<%= u.aseEnc(cont_no) %>">
<input type="hidden" name="cont_chasu" value="<%= cont_chasu %>">
<input type="hidden" name="insteadyn" value="<%= insteadyn %>">
<input type="hidden" name="member_no" value="<%= _member_no %>">

<!-- �⺻ ���� -->
<input type="hidden" name="GoodsName" value="<%=nice_good_name%>"/>
<input type="hidden" name="Amt" value="<%=nice_amount%>"/>
<input type="hidden" name="BuyerName" value="<%=nice_ordername%>"/>
<input type="hidden" name="BuyerEmail" value="<%=nice_orderemail%>"/>
<input type="hidden" name="BuyerTel" value="<%=nice_orderphone%>"/>


<!-- �������̵� -->
<input type="hidden" name="MID" value="<%=merchantID%>"/>
<!-- ��Ų Ÿ�� -->
<input type="hidden" name="SkinType" value="blue"/>
<!-- ��ǰ�ֹ���ȣ -->
<input type="hidden" name="Moid" value="<%=nice_orderno%>"/>


<!-- �޴������� ��ǰ���� 1:�ǹ�, 0:������-->
<input type="hidden" name="GoodsCl" value="1"/>


<!-- Mall Parameters -->
<input type="hidden" name="PayMethod" value="BANK">
<!-- ��ǰ ���� -->
<input type="hidden" name="GoodsCnt" value="1">
<input type="hidden" name="ParentEmail" value="">
<!-- �ּ� -->
<input type="hidden" name="BuyerAddr" value="">
<!-- ���� ��ȣ -->
<input type="hidden" name="BuyerPostNo" value="">
<input type="hidden" name="UserIP" value="<%=request.getRemoteAddr()%>">
<input type="hidden" name="MallIP" value="<%=inet.getHostAddress()%>">

<!-- ���� ��� �ּ��� proxyFrame.jsp �� �����Ͻʽÿ�  -->
<input type="hidden" name="ProxyFrameURL" value="">

<!-- ���� Ÿ�� 0:�Ϲ�, 1:����ũ�� -->
<input type="hidden" name="TransType" value="0">

<!-- ���� �ɼ�  -->
<input type="hidden" name="OptionList" value="">

<!-- ������� �Աݿ��� ������  -->
<input type="hidden" name="VbankExpDate" value="<%=VbankExpDate%>">

<!-- ������ �� ID -->
<input type="hidden" name="MallUserID" value="">

<!-- ����� ���̵� -->
<input type="hidden" name="SUB_ID" value="">

<!-- ������ ���� ��ȣ(�ֹι�ȣ/����ڹ�ȣ)  -->
<input type="hidden" name="BuyerAuthNum" value="<%=_member_no%>">
<!-- ���� �����̵� -->
<input type="hidden" name="MallUserID" value="">
<!-- ��ȣȭ �׸� -->
<input type="hidden" name="EncodeParameters" value="CardNo,CardExpire,CardPwd"/>

<!-- ���� �Ұ� -->
<input type="hidden" name="EdiDate" value="<%=ediDate%>">
<input type="hidden" name="EncryptData" value="<%=hash_String%>" >
<input type="hidden" name="SocketYN" value="Y">
<input type="hidden" name="TrKey" value="">


</form>
</body>
</html>

<%!
/**
* ��� : ���� ũ�⸦ �ʰ��ϸ� ���� ũ������� String�� �ڸ���
* @param  sOrgString ��� String
* @param  iMaxLength ����(�ִ�)ũ��
* @return String     ������ ũ�⸸ŭ ���ѵ� String
*/
String getLimitString(String sOrgString, int iMaxLength)
{
 String sLimitString = "";
 byte[] bString = null;
 int iLimitLength = 0;
 int iMinusCount = 0;    // byte[] ���� ������ ���� <- 2byte ������ ��� �������� ���´�

 if ( (sOrgString != null) && !sOrgString.equals("") && (iMaxLength > 0) )
 {
     bString = sOrgString.getBytes();                            // �ѱ��� ���Ե� String�� ũ�⸦ ����� ����ϱ� ���ؼ� byte[]�� ��ȯ
     iLimitLength = iMaxLength;

     if (bString.length > iLimitLength)                          // ������ ũ�⸦ �ʰ��ϸ�
     {
         for (int i = 0; i < iLimitLength; i++)                  // ������ ũ�⳻���� byte[] ���� ������ ������ ���
         {
             if (bString[i] < 0)
             {
                 iMinusCount++;
             }
         }

         // ������ ũ�⳻���� ���� ���� Ȧ���� �̸� 2byte ���ڰ� ©�ȴٴ� �ǹ��̹Ƿ�, ������ ũ�⸦ 1���� ��Ų��
         if ( (iMinusCount%2) == 1 )
         {
             iLimitLength--;
         }

         sLimitString = new String(bString, 0, iLimitLength);    // ������ ũ������� �ڸ���
     }
     else                                                        // ������ ũ�⸦ �ʰ����� ������
     {
         sLimitString = sOrgString;                              // ���� String
     }
 }

 return sLimitString;
}
%>