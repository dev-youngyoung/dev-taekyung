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
	private	String sOrgData = "";	//	데이타 원문
	private	String sDn = "";	//	인증서DN값
	private String encoding = "KSC5601";// 원문 encoding 시스템 전체 리뉴얼 완료후 UTF-8로 변경 예정
	
	public void setEncoding(String webEncoding){
		this.encoding = webEncoding;
	}
	
	/**
	 * 암호화 하기 위한 인증키값 리턴
	 * @param sDerFileNm	키값
	 * @return
	 * @throws Exception
	 */
	public String getBase64EncodeCert(String sDerFileNm) 
	{
		String 					sBase64EncodeCert	=	"";
		FileInputStream inCert 						= null;
		try {
			//서버인증서를 읽는다.  : 원문을 암호화 하기 위함
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
				System.out.println("base인코드 에러내용 	: " + base64.errmessage);
				System.out.println("base인코드에러코드 		: " + base64.errcode); 
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
	 * 전자서명만 검증, 인증서 검증은 하지 않음.
	 * @param sSignData	서명데이타
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
				System.out.println("서명값 Base64 Decode 결과 : 성공") ;
			}
			else
			{
				System.out.println("서명값 Base64 Decode 결과 : 실패") ;
				System.out.println("에러내용 : " + CBase64.errmessage);
				System.out.println("에러코드 : " + CBase64.errcode);
				sMsg = "SIGN_ERROR";
			}
				
			Verifier CVerifier = new Verifier();
			
			nRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen);

			
			if(nRet==0) 
			{
				this.setOrgData(CVerifier);
				
				System.out.println("전자서명 검증 결과 : 성공") ;
				System.out.println("원문 : " + this.getOrgData());
			}
			else
			{
				System.out.println("전자서명 검증 결과 : 실패") ;
				System.out.println("에러내용 : " + CVerifier.errmessage);
				System.out.println("에러코드 : " + CVerifier.errcode);
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
	 * 전자서명 검증
	 * @param sSignData	서명데이타
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
				System.out.println("서명값 Base64 Decode 결과 : 성공") ;
			}
			else
			{
				System.out.println("서명값 Base64 Decode 결과 : 실패") ;
				System.out.println("에러내용 : " + CBase64.errmessage);
				System.out.println("에러코드 : " + CBase64.errcode);
				System.out.println("signdata : " + sSignData);
				sMsg = "SIGN_ERROR";
			}
				
			Verifier CVerifier = new Verifier();
			
			nRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen);

			
			if(nRet==0) 
			{
				this.setOrgData(CVerifier);
				
				System.out.println("전자서명 검증 결과 : 성공") ;
				System.out.println("원문 : " + this.getOrgData());
			}
			else
			{
				System.out.println("전자서명 검증 결과 : 실패") ;
				System.out.println("에러내용 : " + CVerifier.errmessage);
				System.out.println("에러코드 : " + CVerifier.errcode);
				System.out.println("signdata : " + sSignData);
				sMsg = "SIGN_ERROR";
			}

			//인증서 정보 추출 결과	
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
				System.out.println("인증서 검증 결과 : 실패") ;
				System.out.println("에러내용 : " + CCertificate.errmessage);
				System.out.println("에러코드 : " + CCertificate.errcode);
				System.out.println("signdata : " + sSignData);
				sMsg = "SIGN_ERROR";
			}

			// 인증서 검증 
			String Policies = "1.2.410.200004.5.2.1.1|"	     +          // 한국정보인증              법인
								"1.2.410.200004.5.1.1.7|"    +          // 한국증권전산              법인, 단체, 개인사업자
								"1.2.410.200005.1.1.5|"      +          // 금융결제원                법인, 임의단체, 개인사업자
								"1.2.410.200004.5.3.1.1|"    +          // 한국전산원                기관(국가기관 및 비영리기관)
								"1.2.410.200004.5.3.1.2|"    +          // 한국전산원                법인(국가기관 및 비영리기관을  제외한 공공기관, 법인)
								"1.2.410.200004.5.4.1.2|"    +          // 한국전자인증              법인, 단체, 개인사업자
								"1.2.410.200012.1.1.3|"      +          // 한국무역정보통신           법인
								"1.2.410.200004.5.5.1.2|"    +          // 이니텍                    법인
								"1.2.410.200004.5.4.2.369|"  +          // 나이스디앤비전용           법인(나이스다큐)
								"1.2.410.200004.5.4.2.427|"  +          // 나이스디앤비전용           법인(아파트 전자입찰)

								"1.2.410.200004.5.2.1.2|"    +          // 한국정보인증               개인
								"1.2.410.200004.5.1.1.5|"    +          // 한국증권전산               개인
								"1.2.410.200005.1.1.1|"      +          // 금융결제원                 개인
								"1.2.410.200004.5.3.1.9|"    +          // 한국전산원                 개인
								"1.2.410.200004.5.4.1.1|"    +          // 한국전자인증               개인
								"1.2.410.200012.1.1.1|"      +          // 한국무역정보통신            개인
								"1.2.410.200004.5.5.1.1|"    +        // 이니텍                     개인
								"1.2.410.200005.1.1.4|"      +          // 은행용 실서버에스는 제거필           개인
								"";
			CCertificate.errmessage = "";

			nRet=CCertificate.ValidateCert(CVerifier.certbuf, CVerifier.certlen, Policies, 1);
			if(nRet==0) 
			{
				System.out.println("인증서 검증 결과 : 성공") ;
			}
			else
			{
				System.out.println("인증서 검증 결과 : 실패 ㅜㅜ") ;
				System.out.println("에러내용 : " + CCertificate.errmessage);
				System.out.println("에러코드 : " + CCertificate.errcode);
				System.out.println("에러코드 : " + Integer.toHexString(CCertificate.errcode));
				System.out.println("에러내용 : " + CCertificate.errdetailmessage);
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
	 * 데이타 복호화
	 * @param sSignData	암호화데이타
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

			//복호화용 개인키 읽기 start
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
			//복호화용 개인키 읽기 end


			//인증서 정책
			String policies = "";
			// 법인상호연동용(범용)
			policies +="1.2.410.200004.5.2.1.1"    + "|";          // 한국정보인증               법인
			policies +="1.2.410.200004.5.1.1.7"    + "|";          // 한국증권전산               법인, 단체, 개인사업자
			policies +="1.2.410.200005.1.1.5"      + "|";          // 금융결제원                 법인, 임의단체, 개인사업자
			policies +="1.2.410.200004.5.3.1.1"    + "|";          // 한국전산원                 기관(국가기관 및 비영리기관)
			policies +="1.2.410.200004.5.3.1.2"    + "|";          // 한국전산원                 법인(국가기관 및 비영리기관을  제외한 공공기관, 법인)
			policies +="1.2.410.200004.5.4.1.2"    + "|";          // 한국전자인증               법인, 단체, 개인사업자
			policies +="1.2.410.200012.1.1.3"      + "|";          // 한국무역정보통신           법인
			policies +="1.2.410.200004.5.4.2.369"  + "|";          // 나이스디앤비		         법인

			//서버에서 개인키 읽어오기
			PrivateKey 	CPrivateKey = new PrivateKey(); //개인키 추출 클래스
			Base64 			CBase64 		= new Base64();			//base64 인코딩 디코딩
			Decrypt 		decrypt 		= new Decrypt();		//복호화 클래스
			//Certificate CCertificate = new Certificate();	//인증서 추출 및 검증
			Verifier CVerifier = new Verifier();			// 서명검증을 위한 클래스
	    
	    String sSignPwd = Startup.conf.getString("servercert.pwd");

	    // 개인키 추출
	    nRet = CPrivateKey.DecryptPriKey(sSignPwd, Prifilebuf, nPrilen);

			if (nRet != 0)
			{
				System.out.println("에러내용 : " + CPrivateKey.errmessage);
				System.out.println("에러코드 : " + CPrivateKey.errcode);
				sOrgData =	"";
			}

			// 서명값 base64 디코딩
			nRet = CBase64.Decode(sSignData.getBytes(), sSignData.getBytes().length);
			if (nRet != 0)
			{
				System.out.println("base64디코드 에러내용(서명값) : " + CBase64.errmessage);
				System.out.println("base64디코드 에러코드 : " + CBase64.errcode);
				sOrgData =	"";
			}

			// 전자서명 검증
			nRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen);
			if(nRet != 0)
			{
				System.out.println("전자서명 검증 결과 : 실패") ;
				System.out.println("에러내용 : " + CVerifier.errmessage);
				System.out.println("에러코드 : " + CVerifier.errcode);
				sOrgData =	"";
			}

			// 원문 암호화값 base64 디코딩
			nRet = CBase64.Decode(CVerifier.contentbuf, CVerifier.contentlen);
			if (nRet != 0)
			{
				System.out.println("base64디코드 에러내용(원문 암호화값) : " + CBase64.errmessage);
				System.out.println("base64디코드 에러코드 : " + CBase64.errcode);
				sOrgData =	"";
			}

			//인증서 복호화
			nRet = decrypt.DecEnvelopedData(CPrivateKey.prikeybuf, CPrivateKey.prikeylen, Certfilebuf, nCertlen, CBase64.contentbuf, 
																			CBase64.contentlen);
			if (nRet != 0)
			{
				System.out.println("복호화 에러내용 : " + decrypt.errmessage);
				System.out.println("복호화 에러코드 : " + decrypt.errcode);
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
	 * 원문데이타 넣기
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
	 * 원문데이타 가져오기
	 * @return
	 */
	public String getOrgData()
	{
		return this.sOrgData;
	}
	
	/**
	 * DN값 가져오기
	 * @param //verifier
	 */
	public	void setDn(Certificate certificate)
	{
		this.sDn	=	certificate.subject;
	}
	
	/**
	 * DN값 가져오기
	 * @return
	 */
	public String getDn()
	{
		return this.sDn;
	}
	
	/**
	 * 서버 서명
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
			signDs.put("err", "서버 인증서를 찾을 수 없습니다.");
			return signDs;
		}catch (Exception e){
			signDs.put("err", "알 수 없는 오류가 발생하였습니다.");
			e.printStackTrace();
			return signDs;
		}

		try{
			nPrilen=inPri.available();
			Prifilebuf=new byte[nPrilen];
			
			nRet=inPri.read(Prifilebuf);

			// 개인키 추출
			PrivateKey privateKey = new PrivateKey();
			
			nRet=privateKey.DecryptPriKey(passWd, Prifilebuf, nPrilen);

			if (nRet != 0){
				
				signDs.put("err", "개인키 추출에 실패 하였습니다.");
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
					signDs.put("err", "인증서 DN 을 찾을 수 없습니다.");
					return signDs;
				}
				
				signDs.put("signDn", CCertificate.subject);

				from = Long.parseLong(CCertificate.from.replaceAll("[^0-9]", ""));
				to = Long.parseLong(CCertificate.to.replaceAll("[^0-9]", ""));
				
				if(!(from < now && now <= to)) { 
					signDs.put("err", "인증서가 만료되었습니다.");
					return signDs;
				}
				
				// 전자서명
				Signer signer = new Signer();
				nRet=signer.GetSignedData(privateKey.prikeybuf, privateKey.prikeylen, Certfilebuf, nCertlen, org_data.getBytes("KSC5601"), org_data.getBytes("KSC5601").length);
				
				if (nRet != 0){					
					signDs.put("err", "전자서명에 실패 하였습니다.");
					return signDs;					
				}

				// 바이너리 테이타 base64인코딩
				Base64 CBase64 = new Base64();
				nRet = CBase64.Encode(signer.signedbuf, signer.signedlen);

				if(nRet==0){
					signDs.put("signData", new String(CBase64.contentbuf)); //signData
				}else{					
					signDs.put("err", "서명값을 찾을 수 없습니다.");
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