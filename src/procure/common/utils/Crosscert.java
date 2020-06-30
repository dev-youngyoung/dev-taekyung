package procure.common.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

import procure.common.conf.Startup;
import crosscert.Base64;
import crosscert.Certificate;
import crosscert.Decrypt;
import crosscert.PrivateKey;
import crosscert.Signer;
import crosscert.Verifier;
import nicelib.db.DataSet;
import nicelib.util.Util;

public class Crosscert {
	private	String sOrgData = "";	//	����Ÿ ����
	private	String sDn = "";	//	������DN��
	private String encoding = "KSC5601";// ���� encoding �ý��� ��ü ������ �Ϸ��� UTF-8�� ���� ����
	
	public void setEncoding(String webEncoding){
		this.encoding = webEncoding;
	}
	
	/**
	 * ��ȣȭ �ϱ� ���� ����Ű�� ����
	 * @param sDerFileNm	Ű��
	 * @return
	 * @throws Exception
	 */
	public String getBase64EncodeCert(String sDerFileNm) 
	{
		String 					sBase64EncodeCert	=	"";
		FileInputStream inCert 						= null;
		try {
			//������������ �д´�.  : ������ ��ȣȭ �ϱ� ����
			int 						nCertlen		=	0;
			int							nRet				=	0;
			byte[] 					Certfilebuf = null;
			
			String	sDerFullPath	=	"";	
			sDerFullPath	=	Startup.conf.getString("servercert.crosscert");
			sDerFullPath	=	sDerFullPath	+	sDerFileNm;
			sDerFullPath	=	StrUtil.replace(sDerFullPath,"\\",File.separator);
			sDerFullPath	=	StrUtil.replace(sDerFullPath,"/",File.separator);
			
			inCert = new FileInputStream(new File(sDerFullPath));

			nCertlen 		= inCert.available();
			Certfilebuf = new byte[nCertlen];
			nRet 				= inCert.read(Certfilebuf);

			Base64 base64 = new Base64();
			nRet = base64.Encode(Certfilebuf, nCertlen);
			if (nRet != 0)
			{
				System.out.println("base���ڵ� �������� 	: " + base64.errmessage);
				System.out.println("base���ڵ忡���ڵ� 		: " + base64.errcode); 
			}
			sBase64EncodeCert =  new String(base64.contentbuf);
		} catch (FileNotFoundException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getBase64EncodeCert()] :" + e.toString());
		} catch (IOException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getBase64EncodeCert()] :" + e.toString());
		}finally
		{
			try {
				if(inCert != null)	inCert.close();
			} catch (IOException e) {
				System.out.println("[ERROR "+this.getClass().getName() + ".getBase64EncodeCert()] :" + e.toString());
			}
		}
		
		return sBase64EncodeCert;
	}

	
	/**
	 * ���ڼ��� ����, ������ ������ ���� ����.
	 * @param sSignData	������Ÿ
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public String chkSignData(String sSignData) throws UnsupportedEncodingException
	{
		String sMsg	= "SIGN_SUCCESS";
		
		try {
			int nRet = 0;
			
			Base64 CBase64 = new Base64();  
			nRet = CBase64.Decode(sSignData.getBytes("KSC5601"), sSignData.getBytes("KSC5601").length);
			
			if(nRet==0) 
			{
				System.out.println("���� Base64 Decode ��� : ����") ;
			}
			else
			{
				System.out.println("���� Base64 Decode ��� : ����") ;
				System.out.println("�������� : " + CBase64.errmessage);
				System.out.println("�����ڵ� : " + CBase64.errcode);
				sMsg = "SIGN_ERROR";
			}
				
			Verifier CVerifier = new Verifier();
			
			nRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen);

			
			if(nRet==0) 
			{
				this.setOrgData(CVerifier);
				
				System.out.println("���ڼ��� ���� ��� : ����") ;
				System.out.println("���� : " + this.getOrgData());
			}
			else
			{
				System.out.println("���ڼ��� ���� ��� : ����") ;
				System.out.println("�������� : " + CVerifier.errmessage);
				System.out.println("�����ڵ� : " + CVerifier.errcode);
				sMsg = "SIGN_ERROR";
			}
		} catch (UnsupportedEncodingException e) {
			sMsg = "SIGN_ERROR";
			System.out.println("[ERROR "+this.getClass().getName() + ".getBase64EncodeCert()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getBase64EncodeCert()] :" + e.toString());
		}
		
		return sMsg;
	}
	
	/**
	 * ���ڼ��� ����
	 * @param sSignData	������Ÿ
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public String chkSignVerify(String sSignData) throws UnsupportedEncodingException
	{
		String sMsg	= "SIGN_SUCCESS";
		
		try {
			int nRet = 0;
			
			Base64 CBase64 = new Base64();  
			nRet = CBase64.Decode(sSignData.getBytes("KSC5601"), sSignData.getBytes("KSC5601").length);
			
			if(nRet==0) 
			{
				System.out.println("���� Base64 Decode ��� : ����") ;
			}
			else
			{
				System.out.println("���� Base64 Decode ��� : ����") ;
				System.out.println("�������� : " + CBase64.errmessage);
				System.out.println("�����ڵ� : " + CBase64.errcode);
				System.out.println("signdata : " + sSignData);
				sMsg = "SIGN_ERROR";
			}
				
			Verifier CVerifier = new Verifier();
			
			nRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen);

			
			if(nRet==0) 
			{
				this.setOrgData(CVerifier);
				
				System.out.println("���ڼ��� ���� ��� : ����") ;
				System.out.println("���� : " + this.getOrgData());
			}
			else
			{
				System.out.println("���ڼ��� ���� ��� : ����") ;
				System.out.println("�������� : " + CVerifier.errmessage);
				System.out.println("�����ڵ� : " + CVerifier.errcode);
				System.out.println("signdata : " + sSignData);
				sMsg = "SIGN_ERROR";
			}

			//������ ���� ���� ���	
			Certificate CCertificate = new Certificate();
			nRet=CCertificate.ExtractCertInfo(CVerifier.certbuf, CVerifier.certlen);
			if (nRet ==0)
			{
				this.setDn(CCertificate);
			
				System.out.println("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
				System.out.println("serial;           "+  CCertificate.serial);
				System.out.println("issuer;           "+  CCertificate.issuer);
				System.out.println("subject;          "+  CCertificate.subject);
				System.out.println("from;             "+  CCertificate.from);
				System.out.println("to;               "+  CCertificate.to);
				System.out.println("policy;           "+  CCertificate.policy);
				
				/**
				System.out.println("version;          "+  CCertificate.version);
				System.out.println("serial;           "+  CCertificate.serial);
				System.out.println("issuer;           "+  CCertificate.issuer);
				System.out.println("subject;          "+  CCertificate.subject);
				System.out.println("subjectAlgId;     "+  CCertificate.subjectAlgId);
				System.out.println("from;             "+  CCertificate.from);
				System.out.println("to;               "+  CCertificate.to);
				System.out.println("signatureAlgId;   "+  CCertificate.signatureAlgId);
				System.out.println("pubkey;           "+  CCertificate.pubkey);
				System.out.println("signature;        "+  CCertificate.signature);
				System.out.println("issuerAltName;    "+  CCertificate.issuerAltName);
				System.out.println("subjectAltName;   "+  CCertificate.subjectAltName);
				System.out.println("keyusage;         "+  CCertificate.keyusage);
				System.out.println("policy;           "+  CCertificate.policy);
				System.out.println("basicConstraint;  "+  CCertificate.basicConstraint);
				System.out.println("policyConstraint; "+  CCertificate.policyConstraint);
				System.out.println("distributionPoint;"+  CCertificate.distributionPoint);
				System.out.println("authorityKeyId;   "+  CCertificate.authorityKeyId);
				System.out.println("subjectKeyId;     "+  CCertificate.subjectKeyId);
				**/

			}else
			{
				System.out.println("������ ���� ��� : ����") ;
				System.out.println("�������� : " + CCertificate.errmessage);
				System.out.println("�����ڵ� : " + CCertificate.errcode);
				System.out.println("signdata : " + sSignData);
				sMsg = "SIGN_ERROR";
			}

			// ������ ���� 
			String Policies = "1.2.410.200004.5.2.1.1|"	     +          // �ѱ���������              ����
								"1.2.410.200004.5.1.1.7|"    +          // �ѱ���������              ����, ��ü, ���λ����
								"1.2.410.200005.1.1.5|"      +          // ����������                ����, ���Ǵ�ü, ���λ����
								"1.2.410.200004.5.3.1.1|"    +          // �ѱ������                ���(������� �� �񿵸����)
								"1.2.410.200004.5.3.1.2|"    +          // �ѱ������                ����(������� �� �񿵸������  ������ �������, ����)
								"1.2.410.200004.5.4.1.2|"    +          // �ѱ���������              ����, ��ü, ���λ����
								"1.2.410.200012.1.1.3|"      +          // �ѱ������������           ����
								"1.2.410.200004.5.5.1.2|"    +          // �̴���                    ����
								"1.2.410.200004.5.4.2.369|"  +          // ���̽���غ�����           ����(���̽���ť)
								"1.2.410.200004.5.4.2.427|"  +          // ���̽���غ�����           ����(����Ʈ ��������)

								"1.2.410.200004.5.2.1.2|"    +          // �ѱ���������               ����
								"1.2.410.200004.5.1.1.5|"    +          // �ѱ���������               ����
								"1.2.410.200005.1.1.1|"      +          // ����������                 ����
								"1.2.410.200004.5.3.1.9|"    +          // �ѱ������                 ����
								"1.2.410.200004.5.4.1.1|"    +          // �ѱ���������               ����
								"1.2.410.200012.1.1.1|"      +          // �ѱ������������            ����
								"1.2.410.200004.5.5.1.1|"    +        // �̴���                     ����
								"1.2.410.200005.1.1.4|"      +          // ����� �Ǽ��������� ������           ����
								"";
			CCertificate.errmessage = "";

			nRet=CCertificate.ValidateCert(CVerifier.certbuf, CVerifier.certlen, Policies, 1);
			if(nRet==0) 
			{
				System.out.println("������ ���� ��� : ����") ;
			}
			else
			{
				System.out.println("������ ���� ��� : ���� �̤�") ;
				System.out.println("�������� : " + CCertificate.errmessage);
				System.out.println("�����ڵ� : " + CCertificate.errcode);
				System.out.println("�����ڵ� : " + Integer.toHexString(CCertificate.errcode));
				System.out.println("�������� : " + CCertificate.errdetailmessage);
				System.out.println("signdata : " + sSignData);
				sMsg = "SIGN_ERROR";
			}
		} catch (UnsupportedEncodingException e) {
			sMsg = "SIGN_ERROR";
			System.out.println("[ERROR "+this.getClass().getName() + ".getBase64EncodeCert()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getBase64EncodeCert()] :" + e.toString());
		}
		
		return sMsg;
	}
	
	/**
	 * ����Ÿ ��ȣȭ
	 * @param sSignData	��ȣȭ����Ÿ
	 * @return
	 * @throws IOException 
	 */
	public String decryptData(String sSignData) throws IOException
	{
		String sOrgData = "";
		try {
			int 				nRet		=	0;
			InputStream inPri		=	null;
			InputStream inCert	=	null;
			byte[] 			Prifilebuf;
			byte[]			Certfilebuf;

			//��ȣȭ�� ����Ű �б� start
			int nPrilen; 
			int	nCertlen;
			
			String	sDerFullPath	=	"";
			String	sKeyFullPath	=	"";
			String	sCertDir			=	Startup.conf.getString("servercert.crosscert");
			
			sDerFullPath	=	sCertDir	+	"signCert.der";
			sKeyFullPath	=	sCertDir	+	"signPri.key";
			
			sDerFullPath	=	StrUtil.replace(sDerFullPath,"\\",File.separator);
			sDerFullPath	=	StrUtil.replace(sDerFullPath,"/",File.separator);
			
			sKeyFullPath	=	StrUtil.replace(sKeyFullPath,"\\",File.separator);
			sKeyFullPath	=	StrUtil.replace(sKeyFullPath,"/",File.separator);
			
			inPri =  new FileInputStream(new File(sKeyFullPath));
			inCert = new FileInputStream(new File(sDerFullPath));
			
			nPrilen 		= inPri.available();
			Prifilebuf 	= new byte[nPrilen];
			nRet 				= inPri.read(Prifilebuf);
			nCertlen 		= inCert.available();
			Certfilebuf = new byte[nCertlen];
			nRet 				= inCert.read(Certfilebuf);
			//��ȣȭ�� ����Ű �б� end


			//������ ��å
			String policies = "";
			// ���λ�ȣ������(����)
			policies +="1.2.410.200004.5.2.1.1"    + "|";          // �ѱ���������               ����
			policies +="1.2.410.200004.5.1.1.7"    + "|";          // �ѱ���������               ����, ��ü, ���λ����
			policies +="1.2.410.200005.1.1.5"      + "|";          // ����������                 ����, ���Ǵ�ü, ���λ����
			policies +="1.2.410.200004.5.3.1.1"    + "|";          // �ѱ������                 ���(������� �� �񿵸����)
			policies +="1.2.410.200004.5.3.1.2"    + "|";          // �ѱ������                 ����(������� �� �񿵸������  ������ �������, ����)
			policies +="1.2.410.200004.5.4.1.2"    + "|";          // �ѱ���������               ����, ��ü, ���λ����
			policies +="1.2.410.200012.1.1.3"      + "|";          // �ѱ������������           ����
			policies +="1.2.410.200004.5.4.2.369"  + "|";          // ���̽���غ�		         ����

			//�������� ����Ű �о����
			PrivateKey 	CPrivateKey = new PrivateKey(); //����Ű ���� Ŭ����
			Base64 			CBase64 		= new Base64();			//base64 ���ڵ� ���ڵ�
			Decrypt 		decrypt 		= new Decrypt();		//��ȣȭ Ŭ����
			//Certificate CCertificate = new Certificate();	//������ ���� �� ����
			Verifier CVerifier = new Verifier();			// ��������� ���� Ŭ����
	    
	    String sSignPwd = Startup.conf.getString("servercert.pwd");

	    // ����Ű ����
	    nRet = CPrivateKey.DecryptPriKey(sSignPwd, Prifilebuf, nPrilen);

			if (nRet != 0)
			{
				System.out.println("�������� : " + CPrivateKey.errmessage);
				System.out.println("�����ڵ� : " + CPrivateKey.errcode);
				sOrgData =	"";
			}

			// ���� base64 ���ڵ�
			nRet = CBase64.Decode(sSignData.getBytes(), sSignData.getBytes().length);
			if (nRet != 0)
			{
				System.out.println("base64���ڵ� ��������(����) : " + CBase64.errmessage);
				System.out.println("base64���ڵ� �����ڵ� : " + CBase64.errcode);
				sOrgData =	"";
			}

			// ���ڼ��� ����
			nRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen);
			if(nRet != 0)
			{
				System.out.println("���ڼ��� ���� ��� : ����") ;
				System.out.println("�������� : " + CVerifier.errmessage);
				System.out.println("�����ڵ� : " + CVerifier.errcode);
				sOrgData =	"";
			}

			// ���� ��ȣȭ�� base64 ���ڵ�
			nRet = CBase64.Decode(CVerifier.contentbuf, CVerifier.contentlen);
			if (nRet != 0)
			{
				System.out.println("base64���ڵ� ��������(���� ��ȣȭ��) : " + CBase64.errmessage);
				System.out.println("base64���ڵ� �����ڵ� : " + CBase64.errcode);
				sOrgData =	"";
			}

			//������ ��ȣȭ
			nRet = decrypt.DecEnvelopedData(CPrivateKey.prikeybuf, CPrivateKey.prikeylen, Certfilebuf, nCertlen, CBase64.contentbuf, 
																			CBase64.contentlen);
			if (nRet != 0)
			{
				System.out.println("��ȣȭ �������� : " + decrypt.errmessage);
				System.out.println("��ȣȭ �����ڵ� : " + decrypt.errcode);
				sOrgData =	"";
			}

			sOrgData = new String(decrypt.contentbuf);
		} catch (FileNotFoundException e) {
			System.out.println("[ERROR Config.decryptData()] :" + e.toString());
			throw new FileNotFoundException("[ERROR Config.decryptData()] :" + e.toString());
		} catch (IOException e) {
			System.out.println("[ERROR Config.decryptData()] :" + e.toString());
			throw new IOException("[ERROR Config.decryptData()] :" + e.toString());
		}
		return sOrgData;
	}
	
	/**
	 * ��������Ÿ �ֱ�
	 * @param verifier
	 */
	public	void setOrgData(Verifier verifier)
	{
		try {
			this.sOrgData	=	new String(verifier.contentbuf, encoding);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * ��������Ÿ ��������
	 * @return
	 */
	public String getOrgData()
	{
		return this.sOrgData;
	}
	
	/**
	 * DN�� ��������
	 * @param //verifier
	 */
	public	void setDn(Certificate certificate)
	{
		this.sDn	=	certificate.subject;
	}
	
	/**
	 * DN�� ��������
	 * @return
	 */
	public String getDn()
	{
		return this.sDn;
	}
	
	/**
	 * ���� ����
	 * @return
	 */
	public DataSet serverSign(String memberNo, String passWd, String org_data) {
		
		DataSet signDs = new DataSet();
		String CertPath = Startup.conf.getString("file.path")+"/NPKI/"+memberNo+"/";
		
		int nPrilen=0, nCertlen=0, nRet;
		InputStream inPri=null;
		InputStream inCert=null;
		
		byte[] Prifilebuf;
		byte[] Certfilebuf;
		
		signDs.addRow();

		try{
			inPri =  new FileInputStream(new File(CertPath + "signPri.key"));
			inCert = new FileInputStream(new File(CertPath + "signCert.der"));
		}catch (FileNotFoundException e){
			signDs.put("err", "���� �������� ã�� �� �����ϴ�.");
			return signDs;
		}catch (Exception e){
			signDs.put("err", "�� �� ���� ������ �߻��Ͽ����ϴ�.");
			e.printStackTrace();
			return signDs;
		}

		try{
			nPrilen=inPri.available();
			Prifilebuf=new byte[nPrilen];
			
			nRet=inPri.read(Prifilebuf);

			// ����Ű ����
			PrivateKey privateKey = new PrivateKey();
			
			nRet=privateKey.DecryptPriKey(passWd, Prifilebuf, nPrilen);

			if (nRet != 0){
				
				signDs.put("err", "����Ű ���⿡ ���� �Ͽ����ϴ�.");
				return signDs;
			
			}else{
					
				Certificate CCertificate = new Certificate();
				long from = 0;
				long to = 0;
				long now = Long.parseLong(Util.getTimeString());
				
				nCertlen=inCert.available();
				Certfilebuf = new byte[nCertlen];
			
				nRet=inCert.read(Certfilebuf);

				CCertificate.ExtractCertInfo(Certfilebuf, nCertlen);
				
				if(CCertificate.subject == null || "".equals(CCertificate.subject)){
					signDs.put("err", "������ DN �� ã�� �� �����ϴ�.");
					return signDs;
				}
				
				signDs.put("signDn", CCertificate.subject);

				from = Long.parseLong(CCertificate.from.replaceAll("[^0-9]", ""));
				to = Long.parseLong(CCertificate.to.replaceAll("[^0-9]", ""));
				
				if(!(from < now && now <= to)) { 
					signDs.put("err", "�������� ����Ǿ����ϴ�.");
					return signDs;
				}
				
				// ���ڼ���
				Signer signer = new Signer();
				nRet=signer.GetSignedData(privateKey.prikeybuf, privateKey.prikeylen, Certfilebuf, nCertlen, org_data.getBytes("KSC5601"), org_data.getBytes("KSC5601").length);
				
				if (nRet != 0){					
					signDs.put("err", "���ڼ��� ���� �Ͽ����ϴ�.");
					return signDs;					
				}

				// ���̳ʸ� ����Ÿ base64���ڵ�
				Base64 CBase64 = new Base64();
				nRet = CBase64.Encode(signer.signedbuf, signer.signedlen);

				if(nRet==0){
					signDs.put("signData", new String(CBase64.contentbuf)); //signData
				}else{					
					signDs.put("err", "������ ã�� �� �����ϴ�.");
					return signDs;					
				}

			}

		}catch(Exception e1){
			e1.printStackTrace();
		}finally {
			if(inCert != null) try{ inCert.close();} catch (Exception e) {}
			if(inPri != null) try{ inPri.close();} catch (Exception e) {}
		}
		
		return signDs;
	}
	
}