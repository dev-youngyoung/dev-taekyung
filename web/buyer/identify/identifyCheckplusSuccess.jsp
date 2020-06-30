<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ include file="../init.jsp" %>
<%	//���� �� ������� null�� ������ �κ��� ��������ڿ��� ���� �ٶ��ϴ�.

/*
������ 
������ �븮��
2122-4527
benecia17@nice.co.kr

������
������
(02) 2122-4873
leejc12@nice.co.kr

*/
    NiceID.Check.CPClient niceCheck = new  NiceID.Check.CPClient();

    String sEncodeData = requestReplace(request.getParameter("EncodeData"), "encodeData");

    String sSiteCode = "BE065";				// NICE�κ��� �ο����� ����Ʈ �ڵ�
    String sSitePassword = "CSgXDvODNC9D";			// NICE�κ��� �ο����� ����Ʈ �н�����

    String sCipherTime = "";			// ��ȣȭ�� �ð�
    String sRequestNumber = "";			// ��û ��ȣ
    String sResponseNumber = "";		// ���� ������ȣ
    String sAuthType = "";				// ���� ����
    String sName = "";					// ����
    String sDupInfo = "";				// �ߺ����� Ȯ�ΰ� (DI_64 byte)
    String sConnInfo = "";				// �������� Ȯ�ΰ� (CI_88 byte)
    String sBirthDate = "";				// �������(YYYYMMDD)
    String sGender = "";				// ����
    String sNationalInfo = "";			// ��/�ܱ������� (���߰��̵� ����)
	String sMobileNo = "";				// �޴�����ȣ
	String sMobileCo = "";				// ��Ż�
    String sMessage = "";
    String sPlainData = "";
    
    int iReturn = niceCheck.fnDecode(sSiteCode, sSitePassword, sEncodeData);

    if( iReturn == 0 )
    {
        sPlainData = niceCheck.getPlainData();
        sCipherTime = niceCheck.getCipherDateTime();
        
        // ����Ÿ�� �����մϴ�.
        java.util.HashMap mapresult = niceCheck.fnParse(sPlainData);
        
        sRequestNumber  = (String)mapresult.get("REQ_SEQ");
        sResponseNumber = (String)mapresult.get("RES_SEQ");
        sAuthType		= (String)mapresult.get("AUTH_TYPE");
        sName			= (String)mapresult.get("NAME");
		//sName			= (String)mapresult.get("UTF8_NAME"); //charset utf8 ���� �ּ� ���� �� ���
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
            sMessage = "���ǰ��� �ٸ��ϴ�. �ùٸ� ��η� �����Ͻñ� �ٶ��ϴ�.";
            sResponseNumber = "";
            sAuthType = "";
        }
    }
    else if( iReturn == -1)
    {
        sMessage = "��ȣȭ �ý��� �����Դϴ�.";
    }    
    else if( iReturn == -4)
    {
        sMessage = "��ȣȭ ó�������Դϴ�.";
    }    
    else if( iReturn == -5)
    {
        sMessage = "��ȣȭ �ؽ� �����Դϴ�.";
    }    
    else if( iReturn == -6)
    {
        sMessage = "��ȣȭ ������ �����Դϴ�.";
    }    
    else if( iReturn == -9)
    {
        sMessage = "�Է� ������ �����Դϴ�.";
    }    
    else if( iReturn == -12)
    {
        sMessage = "����Ʈ �н����� �����Դϴ�.";
    }    
    else
    {
        sMessage = "�˼� ���� ���� �Դϴ�. iReturn : " + iReturn;
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
    identifyDao.setInsert("checkplus", cont_no, cont_chasu, member_no, text, "checkplus ��������");
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
    if(typeof opener.identifyDocCallback == 'function' || typeof opener.identifyDocCallback == 'object') { // ���������� �ϱ� �� ��༭ ���뿡 �������� �ϴ� �κ��� �� �ִ� ���( ��:�¸��� )
        opener.identifyDocCallback("<%=sConnInfo%>", "<%=sName%>", "<%=sBirthDate%>", "<%=sMobileNo%>", "<%=text.replace("\n", "").replace("\"", "\\\"")%>");
        window.close();
    } else if(typeof opener.identifyCallback == 'function' || typeof opener.identifyCallback == 'object') {
        opener.identifyCallback("<%=sConnInfo%>", "<%=sName%>", "<%=sBirthDate%>", "<%=sMobileNo%>", "<%=text.replace("\n", "").replace("\"", "\\\"")%>", "<%=sGender%>");
        window.close();
    }
</script>