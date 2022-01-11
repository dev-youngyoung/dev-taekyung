package procure.common.utils;

import java.io.UnsupportedEncodingException;

import crosscert.Base64;
import crosscert.Certificate;
import crosscert.Verifier;

public class SignManager {
	private	String		sSignData 		=	"";		//	서명데이타
	private	Base64		CBase64			=	null;	//	base 64 인코딩
	private	Verifier	CVerifier		=	null;	//	검증테이타 객체
	private	Certificate CCertificate	=	null;	//	인증서정보 추출결과
	
	/**
	 * 생성자
	 * @param sSignData	서명데이타
	 */
	public SignManager(String sSignData)
	{
		this.sSignData	=	sSignData;
		this.setBase64();
		this.setVerifier();
		this.setCertificate();
	}
	
	/**
	 * base64 인코딩
	 */
	public void	setBase64()
	{
		try {
			int	iRet	=	0;
			this.CBase64 = new Base64();
			iRet = CBase64.Decode(this.sSignData.getBytes("KSC5601"), this.sSignData.getBytes("KSC5601").length);
			if(iRet != 0)
			{
				System.out.println("서명값 Base64 Decode 결과 : 실패<br>") ;
			    System.out.println("에러내용 : " + CBase64.errmessage + "<br>");
			    System.out.println("에러코드 : " + CBase64.errcode + "<br>");
			}
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass()+".setBase64()] :" + e.toString());
		}
	}
	
	/**
	 * 전자서명 검증객체 반화
	 * @param CBase64	인코딩
	 * @return
	 */
	public void setVerifier()
	{
		this.CVerifier 	= 	new Verifier();
		int	iRet	=	0;
			
		iRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen);
		if(iRet!=0) 
		{
			System.out.println("전자서명 검증 결과 : 실패<br>") ;
			System.out.println("에러내용 : " + CVerifier.errmessage + "<br>");
			System.out.println("에러코드 : " + CVerifier.errcode + "<br>");
		}
	}
	
	/**
	 * 인증서 정보 추출
	 */
	public void setCertificate()
	{
		//인증서 정보 추출 결과	
		this.CCertificate = new Certificate();
		
		int	iRet	=	0;
		iRet	=	this.CCertificate.ExtractCertInfo(this.CVerifier.certbuf, CVerifier.certlen);
		if(iRet != 0)
		{
			System.out.println("인증서 검증 결과 : 실패<br>") ;
			System.out.println("에러내용 : " + CCertificate.errmessage + "<br>");
			System.out.println("에러코드 : " + CCertificate.errcode + "<br>");
		}
	}
	
	/**
	 * 원문데이타 얻기
	 * @param CBase64	인코딩
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
	 * 데이타 검증
	 * @param sSignData	서명 데이타
	 * @param sOrgnData	원문 데이타
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
			System.out.println("원문 불일치 검증값["+_sOrgnData+"] 원문["+sOrgnData+"]");
		}
		return bCheck;
	}
	
	/**
	 * 인증서 DN값 추출
	 * @return
	 */
	public String	getDn()
	{
		String	sDn	=	this.CCertificate.subject;
		return sDn;
	}
}
