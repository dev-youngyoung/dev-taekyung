import java.io.*;
import crosscert.*;

public class jCert 
{
	public static void main(String[] args) 
	{
		int nPrilen=0, nCertlen=0, nRet;
		InputStream inPri=null;
		InputStream inCert=null;
		
		//OutputStream out=null;
		byte[] Prifilebuf;
		byte[] Certfilebuf;

/*
		String DN_names[] = {  "cn=�������հ����繫��,ou=����,ou=�ѱ���������,ou=AccreditedCA,o=CrossCert,c=KR",
                      "cn=�ѱ濣���Ͼ(CHO SAENG SU)0020681201104122453021,ou=CHO SAENG SU,ou=WOORI,ou=xUse4Esero,o=yessign,c=kr",
                      "cn=(��)û�����հǼ�,ou=HTS,ou=���,ou=����,o=SignKorea,c=KR",
                      "cn=��ȭ����,ou=RA����,ou=��ü��(Ȯ�����),ou=��ϱ��,ou=licensedCA,o=KICA,c=KR",
                      "cn=�ڿ�����Ǽ�_0000148508,ou=myca,ou=AccreditedCA,o=TradeSign,c=KR"};
*/

		String DN_names[] = {  
						"cn=�����77,ou=RA����,ou=��ü��(Ȯ�����),ou=��ϱ��,ou=licensedCA,o=KICA,c=KR",
						"cn=�������հ����繫��,ou=����,ou=�ѱ���������,ou=AccreditedCA,o=CrossCert,c=KR",
                      "CN=�ѱ漼��ȸ��繫(06156)0003681201004161630041,OU=06156,OU=IBK,OU=xUse4Esero,O=yessign,C=kr",
                      "CN=û�����̿ϵ������ֽ�ȸ��,OU=ITNade RA,O=SignKorea,C=KR",
                      "CN=����žû�ҳ⹮ȭ����,OU=�ǰ�����,OU=MOHW RA����,OU=��ϱ��,OU=licensedCA,O=KICA,C=KR",
                      "cn=�ڿ�����Ǽ�_0000148508,ou=myca,ou=AccreditedCA,o=TradeSign,c=KR"
		};
		
		String sInput = "01:506-81-32479+02:(��)������+03:����,���Ҹ�+04:��� ���׽� ���� ������ ��õ�� 634-4����+05:506-81-00017+06:����������ö(��)+07:����,����,���Ҹ�,�ε���+08:��� ���׽� ���� ������ 1����+10:10,790,420+11:1,079,042+12:2001-07-02+13:Cutting Fluid/Oil K MSDS DONG HO DAICOOL,200 L��+14:+15:+16:2001-07-02+30:";
		
		System.out.println("�������� : " + sInput.length() );
		
		try 
		{
			inPri =  new FileInputStream(new File("./Cert/signPri.key"));
			inCert = new FileInputStream(new File("./Cert/signCert.der"));
		}
		catch (FileNotFoundException e) 
		{
			System.out.println(e);
			return;
		}
		catch (IOException e) 
		{
			System.out.println(e);
			return;
		}
		
		try 
		{
			nPrilen=inPri.available();
			Prifilebuf=new byte[nPrilen];
			
			nRet=inPri.read(Prifilebuf);
			
			// ����Ű ����
			PrivateKey privateKey = new PrivateKey();
			nRet=privateKey.DecryptPriKey( "88888888", Prifilebuf, nPrilen);
			
			if ( nRet !=0)
			{
				System.out.println("PrivateKey Class=> " + privateKey.errmessage);
				return;
			}			
			System.out.println("����Ű ���� : " + privateKey.prikeylen);

			nCertlen=inCert.available();
			Certfilebuf = new byte[nCertlen];
		
			nRet=inCert.read(Certfilebuf);
		
			// ���ڼ���
			Signer signer = new Signer();
			nRet=signer.GetSignedData(privateKey.prikeybuf, privateKey.prikeylen, Certfilebuf, nCertlen, sInput.getBytes("KSC5601"), sInput.getBytes("KSC5601").length);
			
			System.out.println("���ڼ��� ���� : " + signer.signedlen);

			
			// ���� ����
			Verifier verifier = new Verifier();
			nRet = verifier.VerSignedData(signer.signedbuf, signer.signedlen);

			System.out.println("���� ���� ��� : " + Integer.toHexString(nRet));
			String sOrgData = new String( verifier.contentbuf, "KSC5601");
			
			System.out.println("���� : " + sOrgData);
			System.out.println("�������� : String - " + sOrgData.length() + ", byte - " + verifier.contentlen );
			
			// ������ ���� ���ڼ���
			nRet=signer.GetSignedDataNoContent(privateKey.prikeybuf, privateKey.prikeylen, Certfilebuf, nCertlen, sInput.getBytes("KSC5601"), sInput.getBytes("KSC5601").length);
			
			System.out.println("������ ���� ���ڼ��� ���� : " + signer.signedlen);

			
			// ������ ���� ���� ����
			nRet = verifier.VerSignedDataNoContent(signer.signedbuf, signer.signedlen, sInput.getBytes("KSC5601"), sInput.getBytes("KSC5601").length);

			System.out.println("������ ���� ���� ���� ��� : " + Integer.toHexString(nRet));
						
		
			// ������ ���� ����
			Certificate certificate = new Certificate();
			nRet = certificate.ExtractCertInfo(verifier.certbuf, verifier.certlen);
			
			System.out.println("������ ���� ���� ��� : " + Integer.toHexString(nRet));
			System.out.println("############################");	
			System.out.println("version : " + certificate.version);
			System.out.println("serial : " + certificate.serial);
			System.out.println("issuer : " + certificate.issuer);
			System.out.println("subject : " + certificate.subject);
			System.out.println("subjectAlgId : " + certificate.subjectAlgId);
			System.out.println("from : " + certificate.from);
			System.out.println("to : " + certificate.to);
			System.out.println("signatureAlgId : " + certificate.signatureAlgId);
			System.out.println("pubkey : " + certificate.pubkey);
			System.out.println("signature : " + certificate.signature);
			System.out.println("issuerAltName : " + certificate.issuerAltName);
			System.out.println("subjectAltName : " + certificate.subjectAltName);
			System.out.println("keyusage : " + certificate.keyusage);
			System.out.println("policy : " + certificate.policy);
			System.out.println("basicConstraint : " + certificate.basicConstraint);
			System.out.println("policyConstraint : " + certificate.policyConstraint);
			System.out.println("distributionPoint : " + certificate.distributionPoint);
			System.out.println("authorityKeyId : " + certificate.authorityKeyId);
			System.out.println("subjectKeyId : " + certificate.subjectKeyId);
			System.out.println("############################");	
			
			String Policies = "1.2.410.200004.5.4.1.1|1.2.410.200004.5.4.1.2|1.2.410.200004.5.4.1.3|1.2.410.200004.5.4.1.4|1.2.410.200004.5.4.1.5";
			certificate.SetConfPath("/home/srmadm/CrossCert/NPKI");
			nRet = certificate.ValidateCert(verifier.certbuf, verifier.certlen, Policies , 1);
			//
			System.out.println("������ ���� ��� : " + Integer.toHexString(nRet));
			System.out.println("errcode : " + Integer.toHexString(certificate.errcode));
			System.out.println("errmessage : " + certificate.errmessage);

			
			// ��ȣȭ (PKCS#7)
			Encrypt encrypt = new Encrypt();
			nRet = encrypt.EncEnvelopedData(Certfilebuf, nCertlen, sInput.getBytes("KSC5601"), sInput.getBytes("KSC5601").length);
			
			System.out.println("��ȣ��(PKCS) ���� : " + encrypt.envelopedlen);
			
			// ��ȣȭ (PKCS#7)

			Decrypt decrypt = new Decrypt();
			nRet = decrypt.DecEnvelopedData(privateKey.prikeybuf, privateKey.prikeylen, Certfilebuf, nCertlen, encrypt.envelopedbuf, encrypt.envelopedlen);
			//nRet = decrypt.DecEnvelopedData(privateKey.prikeybuf, privateKey.prikeylen, certificate.contentbuf, certificate.contentlen, encrypt.envelopedbuf, encrypt.envelopedlen);

			System.out.println("��ȣ��(PKCS) ��� : " + Integer.toHexString(nRet));
			String sOrgData2 = new String( decrypt.contentbuf, "KSC5601");
			System.out.println("���� : " + sOrgData2);
			System.out.println("�������� : String - " + sOrgData2.length() + ", byte - " + decrypt.contentlen );

			// ��ȣȭ (SEED)
			nRet = encrypt.EncryptData(sInput.getBytes("KSC5601"), sInput.getBytes("KSC5601").length, "8888888888888888");
			
			System.out.println("��ȣ��(SEED) ���� : " + encrypt.envelopedlen);
			
			// Base64 Encoding
			Base64 base64 = new Base64();
			base64.Encode(decrypt.contentbuf, decrypt.contentlen);
			String sEncData = new String(base64.contentbuf, "KSC5601");
			System.out.println("��ȣ��(SEED) ( Base64 Encoding) : " + sEncData);
			
			// Base64 Decoding
			base64.Decode(base64.contentbuf, base64.contentlen);
			System.out.println("��ȣ��(SEED) ���� (Base64 Decoding) : " + base64.contentlen);
		
			
			// ��ȣȭ (SEED)
			nRet = decrypt.DecryptData(encrypt.envelopedbuf, encrypt.envelopedlen, "8888888888888888");

			System.out.println("��ȣȭ(SEED) ��� : " + Integer.toHexString(nRet));
			String sOrgData3 = new String( decrypt.contentbuf, "KSC5601");
			System.out.println("���� : " + sOrgData3);
			System.out.println("�������� : String - " + sOrgData3.length() + ", byte - " + decrypt.contentlen );

			System.out.println("############################");	
			System.out.println("         GetCertFromLdap start");	
			System.out.println("############################");	
		for(int k = 0; k < DN_names.length;k++)
		{
			System.out.println("DN_names[" + k + "] : " + DN_names[k]);
			nRet = certificate.GetCertFromLdap(DN_names[k], 0);
			if (nRet == 0)
			{
				
				System.out.println("GetCertFromLdap  OK nRet:" + nRet + " [ " + DN_names.length + " / " + (k + 1) + " ]");
				System.out.println("GetCertFromLdap :" + DN_names[k] );
				//DN_ArrayList.add(certificate.contentbuf);
				
				nRet = certificate.ExtractCertInfo(certificate.contentbuf, certificate.contentbuf.length);
				
				System.out.println("GetCertFromLdap ExtractCertInfo nRet : " + Integer.toHexString(nRet));
				System.out.println("############################");	
				System.out.println("version : " + certificate.version);
				System.out.println("serial : " + certificate.serial);
				System.out.println("issuer : " + certificate.issuer);
				System.out.println("subject : " + certificate.subject);
				/*
				System.out.println("subjectAlgId : " + certificate.subjectAlgId);
				System.out.println("from : " + certificate.from);
				System.out.println("to : " + certificate.to);
				System.out.println("signatureAlgId : " + certificate.signatureAlgId);
				System.out.println("pubkey : " + certificate.pubkey);
				System.out.println("signature : " + certificate.signature);
				System.out.println("issuerAltName : " + certificate.issuerAltName);
				System.out.println("subjectAltName : " + certificate.subjectAltName);
				System.out.println("keyusage : " + certificate.keyusage);
				System.out.println("policy : " + certificate.policy);
				System.out.println("basicConstraint : " + certificate.basicConstraint);
				System.out.println("policyConstraint : " + certificate.policyConstraint);
				System.out.println("distributionPoint : " + certificate.distributionPoint);
				System.out.println("authorityKeyId : " + certificate.authorityKeyId);
				System.out.println("subjectKeyId : " + certificate.subjectKeyId);
				*/
				System.out.println("############################");	
				
				
			}
			else
			{
				System.out.println("GetCertFromLdap nRet fail" );
				System.out.println("GetCertFromLdap errmsg:"+certificate.errmessage);
				System.out.println("GetCertFromLdap errmsg:"+certificate.errdetailmessage);
				System.out.println("GetCertFromLdap :" + DN_names[k] );
			}
			System.out.println("\n\n");
		}
		System.out.println("############################");	
		System.out.println("         GetCertFromLdap end");	
		System.out.println("############################");	
		
		

									
		}
		catch(IOException e1) 
		{
			System.out.println(e1); 
		}
		

	}
}
