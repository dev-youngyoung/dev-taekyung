<%@ page language="java" import="java.io.*,java.util.*,crosscert.*" %>
<%@ page contentType = "text/html; charset=euc-kr" %>

<%
	String EncString = request.getParameter("encryptedText");		// ��ȣȭ ��


	//String EncString = "MIIBygYJKoZIhvcNAQcDoIIBuzCCAbcCAQAxggFzMIIBbwIBADBXME8xCzAJBgNVBAYTAktSMRIwEAYDVQQKDAlDcm9zc0NlcnQxFTATBgNVBAsMDEFjY3JlZGl0ZWRDQTEVMBMGA1UEAwwMQ3Jvc3NDZXJ0Q0EyAgQBEBWzMA0GCSqGSIb3DQEBAQUABIIBAJzpR2R3O9hkZUMFC3DZYWHCo6r21Dpd3hKo2bLDeh+IKIyiPDGYEd/pxw2qXpOrHbibafucLXeZhC5+f2dO/3aPx6jG4Nnam3S7MR5P+Maad3S7/ESP4SgGqoiHcLuWZ36xWpXSaqeCswphoInAOIJZ8uc/puCeONh8oL2krs375U9lA+KVZVUFjA4CJrEUWjj7vTCGnHP9P2VJzT+D6AYkqKNxFMmveO+KMq4Uja5epZx4Esr5+4BUO4a6/27QdCxVieFiUBlU1cWuFU/L20pK+IV4PA0ETWE8c148efYLJG7/o/Y6sqY57cO6azCs+R3JjRDnbEdnF/FoDIX4cEowOwYJKoZIhvcNAQcBMBwGCCqDGoyaRAEEBBBRqE7udad2BZRBujk4w8idgBCG8gdqh3Q1iYBksZ7ElmWa";
	out.println("��ȣȭ�� ��ȣȭ��(Ŭ���̾�Ʈ���� �Ѿ��) : " + EncString);

	int nRet=0;
	InputStream inPri=null;
	InputStream inCert=null;
	byte[] Prifilebuf, Certfilebuf;
	String sOrgData = ""; //��ȣȭ�� ���� ��

	//��ȣȭ�� ����Ű �б� start
	int nPrilen ,nCertlen ;
	String p  =  "C:\\Program Files\\NPKI\\cn=��������׽�Ʈ����,ou=�׽�Ʈ,ou=��ϱ��,ou=AccreditedCA,o=CrossCert,c=KR\\";
	//String p  =  "/usr/local/NPKI/cn=��������׽�Ʈ����,ou=�׽�Ʈ,ou=��ϱ��,ou=AccreditedCA,o=CrossCert,c=KR/";
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
	//��ȣȭ�� ����Ű �б� end

				
	
	//�������� ����Ű �о����
	PrivateKey CPrivateKey = new PrivateKey();  //����Ű ���� Ŭ����
	Base64 CBase64 = new Base64();				//base64 ���ڵ� ���ڵ�
	Decrypt decrypt = new Decrypt();			//��ȣȭ Ŭ���� 


	// ����Ű ����
	nRet = CPrivateKey.DecryptPriKey("crosscert12!@", Prifilebuf, nPrilen);
	if (nRet != 0)
	{
		out.println("�������� : " + CPrivateKey.errmessage + "<br>");
		out.println("�����ڵ� : " + CPrivateKey.errcode + "<br>");
		return;
	}else{
		nRet = CBase64.Decode(EncString.getBytes(), EncString.length());
		if (nRet != 0)
		{
			out.println("base64���ڵ� �������� : " + CBase64.errmessage);
			out.println("base64���ڵ� �����ڵ� : " + CBase64.errcode);
			return;
		}else{
			nRet = decrypt.DecEnvelopedData(CPrivateKey.prikeybuf, CPrivateKey.prikeylen, Certfilebuf, nCertlen, CBase64.contentbuf, CBase64.contentlen);		//������ ��ȣȭ
			if (nRet != 0)
			{
				out.println("��ȣȭ �������� : " + decrypt.errmessage);
				out.println("��ȣȭ �����ڵ� : " + decrypt.errcode);
				//return;
			}
			else
			{
				sOrgData = new String(decrypt.contentbuf, "UTF-8");
				out.println("������������ ��ȣȭ �� ���� : " + sOrgData + "<br>");

				nRet = CBase64.Decode(sOrgData.getBytes("KSC5601"), sOrgData.length());
				if (nRet != 0)
				{
					out.println("base64���ڵ� �������� : " + CBase64.errmessage + "<br>");
					out.println("base64���ڵ� �����ڵ� : " + CBase64.errcode + "<br>");
					return;
				}else{
					out.println("Base64 Decoding : ����<br>");
					//String OrignData = new String(base64.contentbuf);
					String OrignData = new String(CBase64.contentbuf, "UTF-8");
					out.println("Base64 Decoding : " + OrignData + "<br>");
				}
				
			}		
		}
		
	}

	/***********************

	nRet�� 0�̸� ��� ���� ����

	***********************/

%>
