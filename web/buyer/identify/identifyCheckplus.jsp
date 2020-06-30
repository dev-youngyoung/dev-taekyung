<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ include file="../init.jsp" %>
<%
    NiceID.Check.CPClient niceCheck = new  NiceID.Check.CPClient();

    String sSiteCode = "BE065";			// NICE로부터 부여받은 사이트 코드
    String sSitePassword = "CSgXDvODNC9D";		// NICE로부터 부여받은 사이트 패스워드

    String sRequestNumber = niceCheck.getRequestNO(sSiteCode);   	// 요청 번호, 이는 성공/실패후에 같은 값으로 되돌려주게 되므로
    String member_no = u.request("member_no");
    String cont_no = u.aseDec(u.request("cont_no"));
    String cont_chasu = u.request("cont_chasu");

    session.setAttribute("REQ_SEQ" , sRequestNumber);	// 해킹등의 방지를 위하여 세션을 쓴다면, 세션에 요청번호를 넣는다.
    session.setAttribute("member_no", member_no);
    session.setAttribute("cont_no", cont_no);
    session.setAttribute("cont_chasu", cont_chasu);
    
    /*
    sRequestNumber = sRequestNumber + ((member_no.equals(""))?"":member_no+"-");
    sRequestNumber = sRequestNumber + ((cont_no.equals(""))?"":cont_no+"-");
    sRequestNumber = sRequestNumber + ((cont_chasu.equals(""))?"":cont_chasu+"-");

    System.out.println("start="+sRequestNumber);
    */

    // 업체에서 적절하게 변경하여 쓰거나, 아래와 같이 생성한다.
    //member_no|cont_no|contchasu 방식으로 변경
    //if(sRequestNumber.equals("")){//회원가입시에는 정보 신규 생성
    //	sRequestNumber = niceCheck.getRequestNO(sSiteCode);
    //}
    
    //session.setAttribute("REQ_SEQ" , sRequestNumber);	// 해킹등의 방지를 위하여 세션을 쓴다면, 세션에 요청번호를 넣는다.

    String sAuthType = "";      	// 없으면 기본 선택화면, M: 핸드폰, C: 신용카드, X: 공인인증서

    String popgubun 	= "N";		//Y : 취소버튼 있음 / N : 취소버튼 없음
    String customize 	= "";		//없으면 기본 웹페이지 / Mobile : 모바일페이지

    String sGender = ""; 			//없으면 기본 선택 값, 0 : 여자, 1 : 남자

    // CheckPlus(본인인증) 처리 후, 결과 데이타를 리턴 받기위해 다음예제와 같이 http부터 입력합니다.
    //리턴url은 인증 전 인증페이지를 호출하기 전 url과 동일해야 합니다. ex) 인증 전 url : http://www.~ 리턴 url : http://www.~
    String url = request.getRequestURL().toString().replace(request.getRequestURI(), "");
    String sReturnUrl = url + "/web/buyer/identify/identifyCheckplusSuccess.jsp";      // 성공시 이동될 URL
    String sErrorUrl = url + "/web/buyer/identify/identifyCheckplusFail.jsp";       // 실패시 이동될 URL

    // 입력될 plain 데이타를 만든다.n
    String sPlainData = "7:REQ_SEQ" + sRequestNumber.getBytes().length + ":" + sRequestNumber +
            "8:SITECODE" + sSiteCode.getBytes().length + ":" + sSiteCode +
            "9:AUTH_TYPE" + sAuthType.getBytes().length + ":" + sAuthType +
            "7:RTN_URL" + sReturnUrl.getBytes().length + ":" + sReturnUrl +
            "7:ERR_URL" + sErrorUrl.getBytes().length + ":" + sErrorUrl +
            "11:POPUP_GUBUN" + popgubun.getBytes().length + ":" + popgubun +
            "9:CUSTOMIZE" + customize.getBytes().length + ":" + customize +
            "6:GENDER" + sGender.getBytes().length + ":" + sGender;

    String sMessage = "";
    String sEncData = "";

    int iReturn = niceCheck.fnEncode(sSiteCode, sSitePassword, sPlainData);
    if( iReturn == 0 )
    {
        sEncData = niceCheck.getCipherData();
    }
    else if( iReturn == -1)
    {
        sMessage = "암호화 시스템 에러입니다.";
    }
    else if( iReturn == -2)
    {
        sMessage = "암호화 처리오류입니다.";
    }
    else if( iReturn == -3)
    {
        sMessage = "암호화 데이터 오류입니다.";
    }
    else if( iReturn == -9)
    {
        sMessage = "입력 데이터 오류입니다.";
    }
    else
    {
        sMessage = "알수 없는 에러 입니다. iReturn : " + iReturn;
    }
%>
<html>
<head>
    <title>NICE평가정보 - CheckPlus</title>
    <script language='javascript'>
        window.name ="Parent_window";
        /*
        function fnPopup(){
            window.open('', 'popupChk', 'width=500, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
            document.form_chk.action = "https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb";
            document.form_chk.target = "popupChk";
            document.form_chk.submit();
        }
        */
        window.onload = function(){
            var f = document.forms['form1'];
            f.action = "https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb";
            f.submit();
        }
    </script>
</head>
<body>
<!--
<%= sMessage %><br><br>
업체정보 암호화 데이타 : [<%= sEncData %>]<br><br>
-->
<!-- 본인인증 서비스 팝업을 호출하기 위해서는 다음과 같은 form이 필요합니다. -->
<form name="form1" method="post">
    <input type="hidden" name="m" value="checkplusSerivce">				<!-- 필수 데이타로, 누락하시면 안됩니다. -->
<input type="hidden" name="EncodeData" value="<%= sEncData %>">		<!-- 위에서 업체정보를 암호화 한 데이타입니다. -->
</form>
</body>
</html>