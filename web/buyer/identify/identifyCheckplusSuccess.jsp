<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ include file="../init.jsp" %>
<%	//인증 후 결과값이 null로 나오는 부분은 관리담당자에게 문의 바랍니다.

/*
관리팀 
이은주 대리님
2122-4527
benecia17@nice.co.kr

전산팀
이진찬
(02) 2122-4873
leejc12@nice.co.kr

*/
    NiceID.Check.CPClient niceCheck = new  NiceID.Check.CPClient();

    String sEncodeData = requestReplace(request.getParameter("EncodeData"), "encodeData");

    String sSiteCode = "BE065";				// NICE로부터 부여받은 사이트 코드
    String sSitePassword = "CSgXDvODNC9D";			// NICE로부터 부여받은 사이트 패스워드

    String sCipherTime = "";			// 복호화한 시간
    String sRequestNumber = "";			// 요청 번호
    String sResponseNumber = "";		// 인증 고유번호
    String sAuthType = "";				// 인증 수단
    String sName = "";					// 성명
    String sDupInfo = "";				// 중복가입 확인값 (DI_64 byte)
    String sConnInfo = "";				// 연계정보 확인값 (CI_88 byte)
    String sBirthDate = "";				// 생년월일(YYYYMMDD)
    String sGender = "";				// 성별
    String sNationalInfo = "";			// 내/외국인정보 (개발가이드 참조)
	String sMobileNo = "";				// 휴대폰번호
	String sMobileCo = "";				// 통신사
    String sMessage = "";
    String sPlainData = "";
    
    int iReturn = niceCheck.fnDecode(sSiteCode, sSitePassword, sEncodeData);

    if( iReturn == 0 )
    {
        sPlainData = niceCheck.getPlainData();
        sCipherTime = niceCheck.getCipherDateTime();
        
        // 데이타를 추출합니다.
        java.util.HashMap mapresult = niceCheck.fnParse(sPlainData);
        
        sRequestNumber  = (String)mapresult.get("REQ_SEQ");
        sResponseNumber = (String)mapresult.get("RES_SEQ");
        sAuthType		= (String)mapresult.get("AUTH_TYPE");
        sName			= (String)mapresult.get("NAME");
		//sName			= (String)mapresult.get("UTF8_NAME"); //charset utf8 사용시 주석 해제 후 사용
        sBirthDate		= (String)mapresult.get("BIRTHDATE");
        sGender			= (String)mapresult.get("GENDER");
        sNationalInfo  	= (String)mapresult.get("NATIONALINFO");
        sDupInfo		= (String)mapresult.get("DI");
        sConnInfo		= (String)mapresult.get("CI");
        sMobileNo		= (String)mapresult.get("MOBILE_NO");
        sMobileCo		= (String)mapresult.get("MOBILE_CO");

        String session_sRequestNumber = (String)session.getAttribute("REQ_SEQ");
        if(!sRequestNumber.equals(session_sRequestNumber))
        {
            sMessage = "세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다.";
            sResponseNumber = "";
            sAuthType = "";
        }
    }
    else if( iReturn == -1)
    {
        sMessage = "복호화 시스템 에러입니다.";
    }    
    else if( iReturn == -4)
    {
        sMessage = "복호화 처리오류입니다.";
    }    
    else if( iReturn == -5)
    {
        sMessage = "복호화 해쉬 오류입니다.";
    }    
    else if( iReturn == -6)
    {
        sMessage = "복호화 데이터 오류입니다.";
    }    
    else if( iReturn == -9)
    {
        sMessage = "입력 데이터 오류입니다.";
    }    
    else if( iReturn == -12)
    {
        sMessage = "사이트 패스워드 오류입니다.";
    }    
    else
    {
        sMessage = "알수 없는 에러 입니다. iReturn : " + iReturn;
    }

    //String[] arrRequestNumber = sRequestNumber.split("\\-");
    String member_no = (String)session.getAttribute("member_no");
    String cont_no = (String)session.getAttribute("cont_no");
    String cont_chasu = (String)session.getAttribute("cont_chasu");
    
    /* if(arrRequestNumber.length > 0) {
        member_no = arrRequestNumber[0];
        if(arrRequestNumber.length > 1) {
            cont_no = arrRequestNumber[1];
            cont_no = u.aseDec(cont_no);
        }
        if(arrRequestNumber.length > 2) cont_chasu = arrRequestNumber[2];
    } */
    
    DataSet content = new DataSet();
    content.addRow();

    content.put("sRequestNumber", sRequestNumber);
    content.put("sResponseNumber", sResponseNumber);
    content.put("sAuthType", sAuthType);
    content.put("sName", sName);
    content.put("sGender", sGender);
    content.put("sBirthDate", sBirthDate);
    content.put("sDupInfo", sDupInfo);
    content.put("sConnInfo", sConnInfo);
    content.put("sMobileNo", sMobileNo);
    content.put("sSuccDate",u.getTimeString("yyyy-MM-dd HH:mm:ss"));

    IdentifyDao identifyDao = new IdentifyDao();
    String text = Util.loop2json(content);
    identifyDao.setInsert("checkplus", cont_no, cont_chasu, member_no, text, "checkplus 본인인증");
%>
<%!

	public String requestReplace (String paramValue, String gubun) {

        String result = "";
        
        if (paramValue != null) {
        	
        	paramValue = paramValue.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

        	paramValue = paramValue.replaceAll("\\*", "");
        	paramValue = paramValue.replaceAll("\\?", "");
        	paramValue = paramValue.replaceAll("\\[", "");
        	paramValue = paramValue.replaceAll("\\{", "");
        	paramValue = paramValue.replaceAll("\\(", "");
        	paramValue = paramValue.replaceAll("\\)", "");
        	paramValue = paramValue.replaceAll("\\^", "");
        	paramValue = paramValue.replaceAll("\\$", "");
        	paramValue = paramValue.replaceAll("'", "");
        	paramValue = paramValue.replaceAll("@", "");
        	paramValue = paramValue.replaceAll("%", "");
        	paramValue = paramValue.replaceAll(";", "");
        	paramValue = paramValue.replaceAll(":", "");
        	paramValue = paramValue.replaceAll("-", "");
        	paramValue = paramValue.replaceAll("#", "");
        	paramValue = paramValue.replaceAll("--", "");
        	paramValue = paramValue.replaceAll("-", "");
        	paramValue = paramValue.replaceAll(",", "");
        	
        	if(gubun != "encodeData"){
        		paramValue = paramValue.replaceAll("\\+", "");
        		paramValue = paramValue.replaceAll("/", "");
            paramValue = paramValue.replaceAll("=", "");
        	}
        	
        	result = paramValue;
            
        }
        return result;
  }
%>
<script>
    if(typeof opener.identifyDocCallback == 'function' || typeof opener.identifyDocCallback == 'object') { // 공인인증을 하기 전 계약서 내용에 본인인증 하는 부분이 들어가 있는 경우( 예:온리원 )
        opener.identifyDocCallback("<%=sConnInfo%>", "<%=sName%>", "<%=sBirthDate%>", "<%=sMobileNo%>", "<%=text.replace("\n", "").replace("\"", "\\\"")%>");
        window.close();
    } else if(typeof opener.identifyCallback == 'function' || typeof opener.identifyCallback == 'object') {
        opener.identifyCallback("<%=sConnInfo%>", "<%=sName%>", "<%=sBirthDate%>", "<%=sMobileNo%>", "<%=text.replace("\n", "").replace("\"", "\\\"")%>", "<%=sGender%>");
        window.close();
    }
</script>