package procure.common.utils;

import java.io.UnsupportedEncodingException;

import crosscert.Base64;
import crosscert.Certificate;
import crosscert.Verifier;

public class SignManager {
	private	String		sSignData 		=	"";		//	������Ÿ
	private	Base64		CBase64			=	null;	//	base 64 ���ڵ�
	private	Verifier	CVerifier		=	null;	//	��������Ÿ ��ü
	private	Certificate CCertificate	=	null;	//	���������� ������
	
	/**
	 * ������
	 * @param sSignData	������Ÿ
	 */
	public SignManager(String sSignData)
	{
		this.sSignData	=	sSignData;
		this.setBase64();
		this.setVerifier();
		this.setCertificate();
	}
	
	/**
	 * base64 ���ڵ�
	 */
	public void	setBase64()
	{
		try {
			int	iRet	=	0;
			this.CBase64 = new Base64();
			iRet = CBase64.Decode(this.sSignData.getBytes("KSC5601"), this.sSignData.getBytes("KSC5601").length);
			if(iRet != 0)
			{
				System.out.println("���� Base64 Decode ��� : ����<br>") ;
			    System.out.println("�������� : " + CBase64.errmessage + "<br>");
			    System.out.println("�����ڵ� : " + CBase64.errcode + "<br>");
			}
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass()+".setBase64()] :" + e.toString());
		}
	}
	
	/**
	 * ���ڼ��� ������ü ��ȭ
	 * @param CBase64	���ڵ�
	 * @return
	 */
	public void setVerifier()
	{
		this.CVerifier 	= 	new Verifier();
		int	iRet	=	0;
			
		iRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen);
		if(iRet!=0) 
		{
			System.out.println("���ڼ��� ���� ��� : ����<br>") ;
			System.out.println("�������� : " + CVerifier.errmessage + "<br>");
			System.out.println("�����ڵ� : " + CVerifier.errcode + "<br>");
		}
	}
	
	/**
	 * ������ ���� ����
	 */
	public void setCertificate()
	{
		//������ ���� ���� ���	
		this.CCertificate = new Certificate();
		
		int	iRet	=	0;
		iRet	=	this.CCertificate.ExtractCertInfo(this.CVerifier.certbuf, CVerifier.certlen);
		if(iRet != 0)
		{
			System.out.println("������ ���� ��� : ����<br>") ;
			System.out.println("�������� : " + CCertificate.errmessage + "<br>");
			System.out.println("�����ڵ� : " + CCertificate.errcode + "<br>");
		}
	}
	
	/**
	 * ��������Ÿ ���
	 * @param CBase64	���ڵ�
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	public String	getOrgnData()
	{
		String sOrgData	=	"";
		try {
			sOrgData = new String(this.CVerifier.contentbuf, "KSC5601");
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass()+".getOrgnData()] :" + e.toString());
		} catch(NullPointerException e)
		{
			System.out.println("[ERROR "+this.getClass()+".getOrgnData()] :" + e.toString());
		}
		return sOrgData;
	}
	
	/**
	 * ����Ÿ ����
	 * @param sSignData	���� ����Ÿ
	 * @param sOrgnData	���� ����Ÿ
	 * @return
	 */
	public boolean	verifyData(String sOrgnData)
	{
		boolean	bCheck		=	false;
		String	_sOrgnData	=	this.getOrgnData();
		if(sOrgnData.equals(_sOrgnData))
		{
			bCheck	=	true;
		}else
		{
			System.out.println("���� ����ġ ������["+_sOrgnData+"] ����["+sOrgnData+"]");
		}
		return bCheck;
	}
	
	/**
	 * ������ DN�� ����
	 * @return
	 */
	public String	getDn()
	{
		String	sDn	=	this.CCertificate.subject;
		return sDn;
	}
}
