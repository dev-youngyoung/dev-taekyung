<%@ page language="java" import="java.io.*,java.util.*,crosscert.*" %>
<%@ page contentType = "text/html; charset=utf-8" %>

<%  
	/*-------------------------시작----------------------------*/ 
	response.setDateHeader("Expires",0); 
	response.setHeader("Prama","no-cache"); 

	if(request.getProtocol().equals("HTTP/1.1")) 
	{ 
		response.setHeader("Cache-Control","no-cache"); 
	} 
	/*------------------------- 끝----------------------------*/ 
	
	String signeddata = request.getParameter("signedText");		// 서명된 값	
	//String signeddata = "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";
	
	int nRet = 0;
	
	Base64 CBase64 = new Base64();  
	nRet = CBase64.Decode(signeddata.getBytes("KSC5601"), signeddata.getBytes("KSC5601").length);
	if(nRet==0) 
	{
		out.println("서명값 Base64 Decode 결과 : 성공<br>") ;

		Verifier CVerifier = new Verifier();
		nRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen); 
		if(nRet==0) 
		{
			String sOrgData = new String(CVerifier.contentbuf, "UTF-8" );

			out.println("전자서명 검증 결과 : 성공<br>") ;
			out.println("<b><font color=blue>");
			out.println("원문 : " + sOrgData + "<br>");
			out.println("</font></b>");
				
			//인증서 정보 추출 결과	
			Certificate CCertificate = new Certificate();
			nRet=CCertificate.ExtractCertInfo(CVerifier.certbuf, CVerifier.certlen);
			out.println("인증서 정보 추출 결과: 성공 <br>");
			
			out.println("DN : " + CCertificate.subject +"<br>");
			out.print("serial : "+  CCertificate.serial                + "<br>");
			out.print("issuer : "+  CCertificate.issuer                + "<br>");
			out.print("from : "+  CCertificate.from                  + "<br>");
			out.print("to : "+  CCertificate.to                    + "<br>");
			out.print("policy : "+  CCertificate.policy                + "<br>");

			
			// 인증서 검증
			String policies = "";
			
			// 개인상호연동용(범용)                            //
			policies +="1.2.410.200004.5.2.1.2"    + "|";          // 한국정보인증               개인                                             
			policies +="1.2.410.200004.5.1.1.5"    + "|";          // 한국증권전산               개인                                             
			policies +="1.2.410.200005.1.1.1"      + "|";          // 금융결제원                 개인                                             
			policies +="1.2.410.200004.5.4.1.1"    + "|";          // 한국전자인증               개인                                             
			policies +="1.2.410.200012.1.1.1"      + "|";          // 한국무역정보통신           개인 

			// 법인상호연동용(범용)    				
			policies +="1.2.410.200004.5.2.1.1"    + "|";          // 한국정보인증               법인
			policies +="1.2.410.200004.5.1.1.7"    + "|";          // 한국증권전산               법인, 단체, 개인사업자
			policies +="1.2.410.200005.1.1.5"      + "|";          // 금융결제원                 법인, 임의단체, 개인사업자
			policies +="1.2.410.200004.5.4.1.2"    + "|";          // 한국전자인증               법인, 단체, 개인사업자
			policies +="1.2.410.200012.1.1.3"      + "|";          // 한국무역정보통신           법인
			policies +="1.2.410.200004.5.4.1.3"      + "|";

			
			// 개인 용도제한용 인증서정책(OID)                 용도                    공인인증기관
			policies += "1.2.410.200004.5.4.1.101|";        // 은행거래용/보험용       한국전자인증
			policies += "1.2.410.200004.5.4.1.102|";        // 증권거래용              한국전자인증
			policies += "1.2.410.200004.5.4.1.103|";        // 신용카드용              한국전자인증
			policies += "1.2.410.200004.5.4.1.104|";        // 전자민원용              한국전자인증
			policies += "1.2.410.200004.5.2.1.7.1|";        // 은행거래용/보험용       한국정보인증
			policies += "1.2.410.200004.5.2.1.7.2|";        // 증권거래용/보험용       한국정보인증
			policies += "1.2.410.200004.5.2.1.7.3|";        // 신용카드용              한국정보인증
			policies += "1.2.410.200004.5.1.1.9|";          // 증권거래용/보험용       한국증전산
			policies += "1.2.410.200004.5.1.1.9.2|";        // 신용카드용              한국증전산
			policies += "1.2.410.200005.1.1.4|";            // 은행거래용/보험용       금융결제원
			policies += "1.2.410.200005.1.1.6.2|";          // 신용카드용              금융결제원
			policies += "1.2.410.200012.1.1.101|";          // 은행거래용/보험용       한국무역정보통신
			policies += "1.2.410.200012.1.1.103|";          // 증권거래용/보험용       한국무역정보통신
			policies += "1.2.410.200012.1.1.105|";           // 신용카드용              한국무역정보통신
			
			
			//CCertificate.errmessage = "";
			//CCertificate.errcode = 0;
			nRet=CCertificate.ValidateCert(CVerifier.certbuf, CVerifier.certlen, policies, 1);			
			if(nRet==0) 
			{
				out.println("인증서 검증 결과 : 성공<br>") ;

			}
			else
			{
				out.println("인증서 검증 결과 : 실패<br>") ;
				out.println("에러내용 : " + CCertificate.errmessage + "<br>");
				out.println("에러코드 : " + CCertificate.errcode + "<br>");
			}
		}
		else
		{
			out.println("전자서명 검증 결과 : 실패<br>") ;
			out.println("에러내용 : " + CVerifier.errmessage + "<br>");
			out.println("에러코드 : " + CVerifier.errcode + "<br>");
			return;
		}
	}
	else
	{
		out.println("서명값 Base64 Decode 결과 : 실패<br>") ;
		out.println("에러내용 : " + CBase64.errmessage + "<br>");
		out.println("에러코드 : " + CBase64.errcode + "<br>");
	}
		
	
	
%>
