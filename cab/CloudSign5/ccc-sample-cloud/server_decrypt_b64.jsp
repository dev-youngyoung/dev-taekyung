<%@ page language="java" import="java.io.*,java.util.*,crosscert.*" %>
<%@ page contentType = "text/html; charset=euc-kr" %>

<%
	String EncString = request.getParameter("encryptedText");		// 암호화 값


	//String EncString = "MIIBygYJKoZIhvcNAQcDoIIBuzCCAbcCAQAxggFzMIIBbwIBADBXME8xCzAJBgNVBAYTAktSMRIwEAYDVQQKDAlDcm9zc0NlcnQxFTATBgNVBAsMDEFjY3JlZGl0ZWRDQTEVMBMGA1UEAwwMQ3Jvc3NDZXJ0Q0EyAgQBEBWzMA0GCSqGSIb3DQEBAQUABIIBAJzpR2R3O9hkZUMFC3DZYWHCo6r21Dpd3hKo2bLDeh+IKIyiPDGYEd/pxw2qXpOrHbibafucLXeZhC5+f2dO/3aPx6jG4Nnam3S7MR5P+Maad3S7/ESP4SgGqoiHcLuWZ36xWpXSaqeCswphoInAOIJZ8uc/puCeONh8oL2krs375U9lA+KVZVUFjA4CJrEUWjj7vTCGnHP9P2VJzT+D6AYkqKNxFMmveO+KMq4Uja5epZx4Esr5+4BUO4a6/27QdCxVieFiUBlU1cWuFU/L20pK+IV4PA0ETWE8c148efYLJG7/o/Y6sqY57cO6azCs+R3JjRDnbEdnF/FoDIX4cEowOwYJKoZIhvcNAQcBMBwGCCqDGoyaRAEEBBBRqE7udad2BZRBujk4w8idgBCG8gdqh3Q1iYBksZ7ElmWa";
	out.println("암호화된 암호화값(클라이언트에서 넘어옴) : " + EncString);

	int nRet=0;
	InputStream inPri=null;
	InputStream inCert=null;
	byte[] Prifilebuf, Certfilebuf;
	String sOrgData = ""; //복호화된 후의 값

	//복호화용 개인키 읽기 start
	int nPrilen ,nCertlen ;
	String p  =  "C:\\Program Files\\NPKI\\cn=기술지원테스트서버,ou=테스트,ou=등록기관,ou=AccreditedCA,o=CrossCert,c=KR\\";
	//String p  =  "/usr/local/NPKI/cn=기술지원테스트서버,ou=테스트,ou=등록기관,ou=AccreditedCA,o=CrossCert,c=KR/";
	try 
	{	
		inPri =  new FileInputStream(new File(p + "kmPri.key"));
		inCert = new FileInputStream(new File(p + "kmCert.der"));
		//inPri =  new FileInputStream(new File(CertPath + "kmPri.key"));
		//inCert = new FileInputStream(new File(Certpath + "kmCert.der"));
	}
	catch (FileNotFoundException e) 
	{
		System.out.println(e);
	}
	catch (IOException e) 
	{
		System.out.println(e);
	}
	
	nPrilen = inPri.available();
	Prifilebuf = new byte[nPrilen];
	nRet = inPri.read(Prifilebuf);
	nCertlen = inCert.available();
	Certfilebuf = new byte[nCertlen];
	nRet = inCert.read(Certfilebuf);
	//복호화용 개인키 읽기 end

				
	
	//서버에서 개인키 읽어오기
	PrivateKey CPrivateKey = new PrivateKey();  //개인키 추출 클래스
	Base64 CBase64 = new Base64();				//base64 인코딩 디코딩
	Decrypt decrypt = new Decrypt();			//복호화 클래스 


	// 개인키 추출
	nRet = CPrivateKey.DecryptPriKey("crosscert12!@", Prifilebuf, nPrilen);
	if (nRet != 0)
	{
		out.println("에러내용 : " + CPrivateKey.errmessage + "<br>");
		out.println("에러코드 : " + CPrivateKey.errcode + "<br>");
		return;
	}else{
		nRet = CBase64.Decode(EncString.getBytes(), EncString.length());
		if (nRet != 0)
		{
			out.println("base64디코드 에러내용 : " + CBase64.errmessage);
			out.println("base64디코드 에러코드 : " + CBase64.errcode);
			return;
		}else{
			nRet = decrypt.DecEnvelopedData(CPrivateKey.prikeybuf, CPrivateKey.prikeylen, Certfilebuf, nCertlen, CBase64.contentbuf, CBase64.contentlen);		//인증서 복호화
			if (nRet != 0)
			{
				out.println("복호화 에러내용 : " + decrypt.errmessage);
				out.println("복호화 에러코드 : " + decrypt.errcode);
				//return;
			}
			else
			{
				sOrgData = new String(decrypt.contentbuf, "UTF-8");
				out.println("서버인증서로 복호화 된 원문 : " + sOrgData + "<br>");

				nRet = CBase64.Decode(sOrgData.getBytes("KSC5601"), sOrgData.length());
				if (nRet != 0)
				{
					out.println("base64디코드 에러내용 : " + CBase64.errmessage + "<br>");
					out.println("base64디코드 에러코드 : " + CBase64.errcode + "<br>");
					return;
				}else{
					out.println("Base64 Decoding : 성공<br>");
					//String OrignData = new String(base64.contentbuf);
					String OrignData = new String(CBase64.contentbuf, "UTF-8");
					out.println("Base64 Decoding : " + OrignData + "<br>");
				}
				
			}		
		}
		
	}

	/***********************

	nRet이 0이면 모든 검증 성공

	***********************/

%>
