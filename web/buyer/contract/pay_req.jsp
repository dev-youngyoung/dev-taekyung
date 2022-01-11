<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
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
	u.jsErrClose("정상적인 경로로 접근하세요.");
	return;
}
if(!_member_no.equals(member_no)){
	u.jsErrClose("로그인사용자가 변경 되었습니다.\\n\\n결제를 다시 진행 하세요.");
	return;
}

int pay_money = Integer.parseInt(s_pay_money);
int pay_vat = pay_money/10;
String where = " cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' ";

//계약정보 확인 
ContractDao contDao = new ContractDao("tcb_contmaster");
DataSet cont = contDao.find(where);
if(!cont.next()){
	u.jsAlert("계약정보가 없습니다");
	return;
}

//사용자 추가 정보
DataObject personDao = new DataObject("tcb_person");
DataSet person = personDao.find("member_no='"+_member_no+"' and user_id='"+auth.getString("_USER_ID")+"' ");
if(!person.next()){
 u.jsError("사용자정보가 존재하지 않습니다.");
 return;
}

//모든 결제에 공통적으로 필요한 데이터
String nice_ordervendcd  = auth.getString("_VENDCD");// 주문자 사업자번호
String nice_ordername    = getLimitString(auth.getString("_MEMBER_NAME"), 20);// 주문자 성명 (20자리)
String nice_orderphone   = person.getString("hp1")+person.getString("hp2")+person.getString("hp3");// 주문자 전화번호 (20자리)
String nice_orderemail   = person.getString("email");// 주문자 이메일
String nice_orderno      = cont_no + cont_chasu;// 주문번호 20자리 매 거래시마다 유일해야함 (20자리 고정)
String nice_good_name    = "나이스다큐 임대 이용 수수료";// 상품명 (40자리)
String nice_amount		= (pay_money+pay_vat)+"";// 구매가격

//주문번호 20자리 고정
int iOrdernoLen = nice_orderno.length();
RandomString rndStr = new RandomString();
nice_orderno += rndStr.getString(20-iOrdernoLen, "a");// 영문소문자로 생성된 임의문자열을 붙임

NicePayParamSetter paramSetter = new NicePayParamSetter();

//서버 IP 가져오기
InetAddress inet = InetAddress.getLocalHost();

//가상계좌 입금만료일
Timestamp toDay = new Timestamp((new Date()).getTime());
Timestamp nxDay = paramSetter.getTimestampWithSpan(toDay, 1);
String VbankExpDate = nxDay.toString();
VbankExpDate = VbankExpDate.substring(0, 10);
VbankExpDate = VbankExpDate.replaceAll("-", "");

String ediDate = paramSetter.getyyyyMMddHHmmss(); // 전문생성일시

//상점서명키 (꼭 해당 상점키로 바꿔주세요)
//String merchantKey = "33F49GnCMS1mFYlGXisbUDzVf2ATWCl9k3R++d5hDd3Frmuos/XLx8XhXpe+LDYAbpGKZYSwtlyyLOtS/8aD7A==";
//String merchantKey		= "q7LNeQuqUrQxRiKfG1tZ4nMFSytahkVr6rAnRh5DpmFsOZ3EbFNiBtrdCxQRkxRx6FR4RjOAC58bGZzW5GPE+w==";		// 상점서명키 (실제-나이스디앤비)
String merchantKey		= "lxHiWRNaNLAShqnlgw0ZXIdvTKVE+qty/ZNoEk73JEGukRR7OacU5aB6+gWFI/mhxJ2LWBKLXkrAXbIztLyUNA==";		// 상점서명키 (실제-나이스데이터)
// 상점 MID
//String merchantID = "nictest00m";
//String merchantID = "2543mmmmmm";						// 실제 상점 아이디(나이스디앤비)
String merchantID = "docu00002m";						// 실제 상점 아이디(나이스데이터)
//hash 처리
String md_src = ediDate + merchantID + nice_amount + merchantKey;
String hash_String  = paramSetter.encrypt(md_src);

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>NICEPAY :: 결제 요청</title>
<link rel="stylesheet" href="/pay/css/basic.css" type="text/css" />
<link rel="stylesheet" href="/pay/css/style.css" type="text/css" />
<script src="https://web.nicepay.co.kr/flex/js/nicepay_tr.js" language="javascript"></script>
<script language="javascript">
NicePayUpdate();	//Active-x Control 초기화

/**
nicepay	를 통해 결제를 시작합니다.
@param	form :	결제 Form
*/
function nicepay() {
 if(checkedButtonValue('selectType')==null || checkedButtonValue('selectType')=='') {
     alert('결제수단을 선택해 주세요.');
     return;
 }

	var payForm		= document.payForm;


	// 필수 사항들을 체크하는 로직을 삽입해주세요.
	//alert(payForm.BuyerAuthNum.value);

	goPay(payForm);
}

function nicepaySubmit(){
	document.payForm.submit();
}


/**
결제를 취소 할때 호출됩니다.
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
       <td>나이스다큐 이용 수수료 결제</td>
       <td>&nbsp;</td>
     </tr>
   </table>
 </td>
</tr>
<tr>
 <td align="left" valign="top" background="/pay/images/bodyMiddle.gif">
 <table width="632" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td width="35" height="10">&nbsp;</td> <!--상단여백 높이 10px -->
     <td width="562">&nbsp;</td>
     <td width="35">&nbsp;</td>
   </tr>
   <tr>
     <td height="30">&nbsp;</td>
     <td>계약서에 서명하기 위해서는 서비스 이용수수료를 결제하셔야 합니다.</td>
     <td>&nbsp;</td>
   </tr>
   <tr>
     <td height="15">&nbsp;</td> <!--컨텐츠와 컨텐츠 사이 간격 15px-->
     <td>&nbsp;</td>
     <td>&nbsp;</td>
   </tr>
   <tr>
     <td height="30">&nbsp;</td>
     <td class="bold"><img src="/pay/images/bullet.gif" /> 정보를 확인 하신 후 결제하기 버튼을 눌러주십시오.
     <td>&nbsp;</td>
   </tr>
   <tr>
     <td>&nbsp;</td>
     <td>
		  <table width="562" border="0" cellspacing="0" cellpadding="0" class="talbeBorder" >
       <tr>
         <td width="100" height="30" id="borderBottom" class="thead01">결제 수단</td>
         <td id="borderBottom">
           <input type="radio" name="selectType" value="CARD" style="border:0" onClick="chkPayType(this)">[신용카드]
			  <input type="radio" name="selectType" value="BANK" style="border:0" onClick="chkPayType(this)">[계좌이체]
			</td>
       </tr>
		  <tr>
         <td width="100" height="30" id="borderBottom" class="thead01">* 상품명</td>
         <td id="borderBottom">&nbsp;<%=nice_good_name%></td>
       </tr>
       <tr>
         <td width="100" height="30" id="borderBottom" class="thead02">* 상품가격</td>
         <td id="borderBottom">&nbsp;<%=nice_amount%> 원</td>
       </tr>
       <tr>
         <td width="100" height="30" id="borderBottom" class="thead02">* 구매자명</td>
         <td id="borderBottom">&nbsp;<%=nice_ordername%></td>
       </tr>
       <tr>
         <td width="100" height="30" id="borderBottom" class="thead01">* 이메일</td>
         <td id="borderBottom">&nbsp;<%=nice_orderemail%></td>
       </tr>
       <tr>
         <td width="100" height="30" id="borderBottom" class="thead02">* 전화번호</td>
         <td id="borderBottom">&nbsp;<%=nice_orderphone%></td>
       </tr>
     </table></td>
     <td height="15">&nbsp;</td>
   </tr>
   <tr>
   	<td height="60"></td>
     <td class="btnCenter"><input type="button" value="결제하기" onClick="nicepay();"></td> <!-- 하단에 버튼이 있는경우 버튼포함 여백 높이 30px -->
     <td>&nbsp;</td>
   </tr>
   <tr>
     <td height="10"></td>  <!--하단여백 높이 10px -->
     <td >&nbsp;</td>
     <td>&nbsp;</td>
   </tr>
 </table></td>
</tr>
<tr>
 <td><img src="/pay/images/bodyBottom.gif" /></td>
</tr>
</table>
<!-- 입찰 정보 -->
<input type="hidden" name="cont_no" value="<%= u.aseEnc(cont_no) %>">
<input type="hidden" name="cont_chasu" value="<%= cont_chasu %>">
<input type="hidden" name="insteadyn" value="<%= insteadyn %>">
<input type="hidden" name="member_no" value="<%= _member_no %>">

<!-- 기본 정보 -->
<input type="hidden" name="GoodsName" value="<%=nice_good_name%>"/>
<input type="hidden" name="Amt" value="<%=nice_amount%>"/>
<input type="hidden" name="BuyerName" value="<%=nice_ordername%>"/>
<input type="hidden" name="BuyerEmail" value="<%=nice_orderemail%>"/>
<input type="hidden" name="BuyerTel" value="<%=nice_orderphone%>"/>


<!-- 상점아이디 -->
<input type="hidden" name="MID" value="<%=merchantID%>"/>
<!-- 스킨 타입 -->
<input type="hidden" name="SkinType" value="blue"/>
<!-- 상품주문번호 -->
<input type="hidden" name="Moid" value="<%=nice_orderno%>"/>


<!-- 휴대폰결제 상품구분 1:실물, 0:컨텐츠-->
<input type="hidden" name="GoodsCl" value="1"/>


<!-- Mall Parameters -->
<input type="hidden" name="PayMethod" value="BANK">
<!-- 상품 갯수 -->
<input type="hidden" name="GoodsCnt" value="1">
<input type="hidden" name="ParentEmail" value="">
<!-- 주소 -->
<input type="hidden" name="BuyerAddr" value="">
<!-- 우편 번호 -->
<input type="hidden" name="BuyerPostNo" value="">
<input type="hidden" name="UserIP" value="<%=request.getRemoteAddr()%>">
<input type="hidden" name="MallIP" value="<%=inet.getHostAddress()%>">

<!-- 절대 경로 주소의 proxyFrame.jsp 를 설정하십시요  -->
<input type="hidden" name="ProxyFrameURL" value="">

<!-- 결제 타입 0:일반, 1:에스크로 -->
<input type="hidden" name="TransType" value="0">

<!-- 결제 옵션  -->
<input type="hidden" name="OptionList" value="">

<!-- 가상계좌 입금예정 만료일  -->
<input type="hidden" name="VbankExpDate" value="<%=VbankExpDate%>">

<!-- 구매자 고객 ID -->
<input type="hidden" name="MallUserID" value="">

<!-- 서브몰 아이디 -->
<input type="hidden" name="SUB_ID" value="">

<!-- 구매자 인증 번호(주민번호/사업자번호)  -->
<input type="hidden" name="BuyerAuthNum" value="<%=_member_no%>">
<!-- 상점 고객아이디 -->
<input type="hidden" name="MallUserID" value="">
<!-- 암호화 항목 -->
<input type="hidden" name="EncodeParameters" value="CardNo,CardExpire,CardPwd"/>

<!-- 변경 불가 -->
<input type="hidden" name="EdiDate" value="<%=ediDate%>">
<input type="hidden" name="EncryptData" value="<%=hash_String%>" >
<input type="hidden" name="SocketYN" value="Y">
<input type="hidden" name="TrKey" value="">


</form>
</body>
</html>

<%!
/**
* 기능 : 제한 크기를 초과하면 제한 크기까지만 String을 자른다
* @param  sOrgString 대상 String
* @param  iMaxLength 제한(최대)크기
* @return String     지정된 크기만큼 제한된 String
*/
String getLimitString(String sOrgString, int iMaxLength)
{
 String sLimitString = "";
 byte[] bString = null;
 int iLimitLength = 0;
 int iMinusCount = 0;    // byte[] 값이 음수인 갯수 <- 2byte 문자일 경우 음수값을 갖는다

 if ( (sOrgString != null) && !sOrgString.equals("") && (iMaxLength > 0) )
 {
     bString = sOrgString.getBytes();                            // 한글이 포함된 String의 크기를 제대로 계산하기 위해서 byte[]로 변환
     iLimitLength = iMaxLength;

     if (bString.length > iLimitLength)                          // 지정된 크기를 초과하면
     {
         for (int i = 0; i < iLimitLength; i++)                  // 지정된 크기내에서 byte[] 값이 음수인 갯수를 계산
         {
             if (bString[i] < 0)
             {
                 iMinusCount++;
             }
         }

         // 지정된 크기내에서 음수 값이 홀수개 이면 2byte 문자가 짤렸다는 의미이므로, 지정된 크기를 1감소 시킨다
         if ( (iMinusCount%2) == 1 )
         {
             iLimitLength--;
         }

         sLimitString = new String(bString, 0, iLimitLength);    // 지정된 크기까지만 자른다
     }
     else                                                        // 지정된 크기를 초과하지 않으면
     {
         sLimitString = sOrgString;                              // 원래 String
     }
 }

 return sLimitString;
}
%>