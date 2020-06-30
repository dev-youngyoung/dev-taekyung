<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ include file="../init.jsp" %>
<%
    NiceID.Check.CPClient niceCheck = new  NiceID.Check.CPClient();

    String sSiteCode = "BE065";			// NICE�κ��� �ο����� ����Ʈ �ڵ�
    String sSitePassword = "CSgXDvODNC9D";		// NICE�κ��� �ο����� ����Ʈ �н�����

    String sRequestNumber = niceCheck.getRequestNO(sSiteCode);   	// ��û ��ȣ, �̴� ����/�����Ŀ� ���� ������ �ǵ����ְ� �ǹǷ�
    String member_no = u.request("member_no");
    String cont_no = u.aseDec(u.request("cont_no"));
    String cont_chasu = u.request("cont_chasu");

    session.setAttribute("REQ_SEQ" , sRequestNumber);	// ��ŷ���� ������ ���Ͽ� ������ ���ٸ�, ���ǿ� ��û��ȣ�� �ִ´�.
    session.setAttribute("member_no", member_no);
    session.setAttribute("cont_no", cont_no);
    session.setAttribute("cont_chasu", cont_chasu);
    
    /*
    sRequestNumber = sRequestNumber + ((member_no.equals(""))?"":member_no+"-");
    sRequestNumber = sRequestNumber + ((cont_no.equals(""))?"":cont_no+"-");
    sRequestNumber = sRequestNumber + ((cont_chasu.equals(""))?"":cont_chasu+"-");

    System.out.println("start="+sRequestNumber);
    */

    // ��ü���� �����ϰ� �����Ͽ� ���ų�, �Ʒ��� ���� �����Ѵ�.
    //member_no|cont_no|contchasu ������� ����
    //if(sRequestNumber.equals("")){//ȸ�����Խÿ��� ���� �ű� ����
    //	sRequestNumber = niceCheck.getRequestNO(sSiteCode);
    //}
    
    //session.setAttribute("REQ_SEQ" , sRequestNumber);	// ��ŷ���� ������ ���Ͽ� ������ ���ٸ�, ���ǿ� ��û��ȣ�� �ִ´�.

    String sAuthType = "";      	// ������ �⺻ ����ȭ��, M: �ڵ���, C: �ſ�ī��, X: ����������

    String popgubun 	= "N";		//Y : ��ҹ�ư ���� / N : ��ҹ�ư ����
    String customize 	= "";		//������ �⺻ �������� / Mobile : �����������

    String sGender = ""; 			//������ �⺻ ���� ��, 0 : ����, 1 : ����

    // CheckPlus(��������) ó�� ��, ��� ����Ÿ�� ���� �ޱ����� ���������� ���� http���� �Է��մϴ�.
    //����url�� ���� �� ������������ ȣ���ϱ� �� url�� �����ؾ� �մϴ�. ex) ���� �� url : http://www.~ ���� url : http://www.~
    String url = request.getRequestURL().toString().replace(request.getRequestURI(), "");
    String sReturnUrl = url + "/web/buyer/identify/identifyCheckplusSuccess.jsp";      // ������ �̵��� URL
    String sErrorUrl = url + "/web/buyer/identify/identifyCheckplusFail.jsp";       // ���н� �̵��� URL

    // �Էµ� plain ����Ÿ�� �����.n
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
        sMessage = "��ȣȭ �ý��� �����Դϴ�.";
    }
    else if( iReturn == -2)
    {
        sMessage = "��ȣȭ ó�������Դϴ�.";
    }
    else if( iReturn == -3)
    {
        sMessage = "��ȣȭ ������ �����Դϴ�.";
    }
    else if( iReturn == -9)
    {
        sMessage = "�Է� ������ �����Դϴ�.";
    }
    else
    {
        sMessage = "�˼� ���� ���� �Դϴ�. iReturn : " + iReturn;
    }
%>
<html>
<head>
    <title>NICE������ - CheckPlus</title>
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
��ü���� ��ȣȭ ����Ÿ : [<%= sEncData %>]<br><br>
-->
<!-- �������� ���� �˾��� ȣ���ϱ� ���ؼ��� ������ ���� form�� �ʿ��մϴ�. -->
<form name="form1" method="post">
    <input type="hidden" name="m" value="checkplusSerivce">				<!-- �ʼ� ����Ÿ��, �����Ͻø� �ȵ˴ϴ�. -->
<input type="hidden" name="EncodeData" value="<%= sEncData %>">		<!-- ������ ��ü������ ��ȣȭ �� ����Ÿ�Դϴ�. -->
</form>
</body>
</html>