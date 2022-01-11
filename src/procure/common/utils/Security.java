package procure.common.utils;

import org.apache.commons.codec.binary.Base64;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import java.security.*;

public class Security {
	public static String aeskey = "nicednb passwd12";  // AES의 key는 16(128),24(192),32(256)byte중 하나로 이루어져야 한다.

    public static void main(String[] args)
    {
        try {
        	
        	/*
        	String[] test = "N4348050534,N4348050535,N4348050536,N4348050537,N4348050538,N4348050539,N4348050540,N4348050541,N4348050542,N4348050543,N4348050544,N4348050545,N4348050546,N4348050547,N4348050548,N4348050549,N4348050550,N4348050551,N4348050552,N4348050553,N4348050554,N4348050555,N4348050556,N4348050557,N4348050607,N4348050608,N4348050609,N4348050610,N4348050611,N4348050612,N4348050613,N4348050614,N4348050615,N4348050616,N4348050617,N4348050618,N4348050619,N4348050620,N4348050621,N4348050622,N4348050623,N4348050624,N4348050625,N4348050626,N4348050627,N4348050628,N4348050629,N4348050630,N4348050631,N4348050632,N4348050633,N4348050634,N4348050635,N4348050636,N4348050637,N4348050638,N4348050639,N4348050640,N4348050641,N4348050642,N4348050643,N4348050644,N4348050645,N4348050646,N4348050647,N4348050648,N4348050649,N4348050650,N4348050651,N4348050652,N4348050653,N4348050654,N4348050655,N4348050656,N4348050657,N4348050658,N4348050659,N4348050660,N4348050661,N4348050662,N4348050663,N4348050664,N4348050665,N4348050666,N4348050667,N4348050668,N4348050669,N4348050670,N4348050671,N4348050672,N4348050673,N4348050674,N4348050675,N4348050676,N4348050677,N4348050678,N4348050679,N4348050680,N4348050681,N4348050682,N4348050683,N4348050684,N4348050685,N4348050686,N4348050687,N4348050688,N4348050689,N4348050690,N4348050691,N4348050692,N4348050693,N4348050694,N4348050695,N4348050696,N4348050697,N4348050698,N4348050699,N4348050700,N4348050701,N4348050702,N4348050703,N4348050704,N4348050705,N4348050706,N4348050707,N4348050708,N4348050709,N4348050710,N4348050711,N4348050712,N4348050713,N4348050714,N4348050715,N4348050716,N4348050717,N4348050718,N4348050719,N4348050720,N4348050721,N4348050722,N4348050723,N4348050724,N4348050725,N4348050726,N4348050727,N4348050728,N4348050729,N4348050730,N4348050731,N4348050732,N4348050733,N4348050734,N4348050735,N4348050736,N4348050737,N4348050738,N4348050739,N4348050740,N4348050818".split(",");
        	
        	for(int i=0; i<test.length; i++)
        	{
        		  System.out.println("encrypt str = "+AESencrypt(test[i]));
        	}
        	*/
        	
            String encrypt = AESencrypt("docu");
          // String encrypt = SHA256encrypt("niceapt03!");
            
            //System.out.println("origin str = "+"a");
            System.out.println("encrypt str = "+encrypt);

            String decrypt = AESdecrypt("23b7b76379cdba8d5e0f2038e78ee88c");
            System.out.println("decrypt str = "+decrypt);

/*        	
        	java.security.Provider pro[] = java.security.Security.getProviders();
            
        	for(int i=0; i<pro.length; i++)
        	{
        		Provider provider = pro[i];
        		String sProviderName = provider.getName();
        		
        		// 시스템에서 참조하는 Provider들을 모두 출력한다.
        		System.out.println("---------------------------------" + sProviderName + "[" + i + "]" + "----------------------------");

        		Iterator iter = provider.entrySet().iterator();
        		while (iter.hasNext()) {
        			Map.Entry entry = (Map.Entry) iter.next();
        			System.out.println("\t" + entry.getKey() + " = "+ entry.getValue());
        		}

        		System.out.println("\n\n\n");
        	}
        	
        	// Default provider가 Sun께 아니면 Sun꺼로 변경한다.
        	Provider sunProv = null;
        	
        	sunProv = new sun.security.provider.Sun();
        	if ( (null != sunProv) && (1 != java.security.Security.insertProviderAt(sunProv, 1)) ) 
        	{
        		java.security.Security.removeProvider(sunProv.getName());
        		if(java.security.Security.insertProviderAt(sunProv, 1) == 1)
        			System.out.println("Default Provier 복원성공");
        		else
        			System.out.println("Default Provier 복원실패");
        	}
*/


        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
	
    /**
     * hex to byte[] : 16진수 문자열을 바이트 배열로 변환한다.
     * 
     * @param hex    hex string
     * @return
     */
    public static byte[] hexToByteArray(String hex) {
        if (hex == null || hex.length() == 0) {
            return null;
        }

        byte[] ba = new byte[hex.length() / 2];
        for (int i = 0; i < ba.length; i++) {
            ba[i] = (byte) Integer.parseInt(hex.substring(2 * i, 2 * i + 2), 16);
        }
        return ba;
    }

    /**
     * byte[] to hex : unsigned byte(바이트) 배열을 16진수 문자열로 바꾼다.
     * 
     * @param ba        byte[]
     * @return
     */
    public static String byteArrayToHex(byte[] ba) {
        if (ba == null || ba.length == 0) {
            return null;
        }

        StringBuffer sb = new StringBuffer(ba.length * 2);
        String hexNumber;
        for (int x = 0; x < ba.length; x++) {
            hexNumber = "0" + Integer.toHexString(0xff & ba[x]);

            sb.append(hexNumber.substring(hexNumber.length() - 2));
        }
        return sb.toString();
    } 

    /**
     * AES 방식의 암호화
     * 
     * @param message
     * @return
     * @throws Exception
     */
    public static String AESencrypt(String message) throws Exception {

        // use key coss2
        SecretKeySpec skeySpec = new SecretKeySpec(aeskey.getBytes(), "AES");

        // Instantiate the cipher
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec);

        byte[] encrypted = cipher.doFinal(message.getBytes());
        return byteArrayToHex(encrypted);
    }

    /**
     * AES 방식의 복호화
     * 
     * @param
     * @return
     * @throws Exception
     */
    public static String AESdecrypt(String encrypted) throws Exception {

        // use key coss2
        SecretKeySpec skeySpec = new SecretKeySpec(aeskey.getBytes(), "AES");

        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, skeySpec);
        byte[] original = cipher.doFinal(hexToByteArray(encrypted));
        String originalString = new String(original);
        return originalString;
    }

    /***
     * Md5 암호화 
     */
    public static String MD5encrypt(String src){
          java.security.MessageDigest md5 = null;
          try{
                 md5 = java.security.MessageDigest.getInstance("MD5");
          }catch(Exception e){
                 return "";
          }
          String eip;
          byte[] bip;
          String temp="";
          String tst = src;
          bip = md5.digest(tst.getBytes());
          for(int i = 0 ; i<bip.length; i++){
                 eip = ""+Integer.toHexString((int)bip[i] & 0x000000ff);
                 if(eip.length()<2){
                        eip = "0"+eip;
                 }
                 temp = temp+eip;
                 
          }
          return temp;
    }

    /**
     * sha256 암호화
     * @param src
     * @return
     */
    public static String SHA256encrypt(String src)
    {
    	String	sRtnVal	=	"";
    	try {
    		java.security.MessageDigest sha256 = null;
			sha256 = java.security.MessageDigest.getInstance("SHA-256");

			byte[] b	=	sha256.digest(src.getBytes());
			StringBuffer	sb	=	new	StringBuffer();
			String			_s	=	"";
			for(int i=0; i < b.length; i++)
			{
				_s = Integer.toHexString((int)b[i] & 0x000000ff);
				if(_s.length()<2)
				{
					_s = "0"+_s;
				}
				sb.append(_s);
			}
			sRtnVal	=	sb.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return	sRtnVal;
    }

    /*
    *  nicepay 1원인증에서 사용
    * */
	public static String SHA256encrypt(String rawString, String salt) {

		MessageDigest digest = null;
		try {
			digest = MessageDigest.getInstance("SHA-256");
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		digest.reset();
		digest.update(salt.getBytes());
		byte[] input = digest.digest(rawString.getBytes());
		StringBuffer sb = new StringBuffer();
		for(int i=0; i<input.length; i++) {
			sb.append(Integer.toString((input[i] & 0xff) + 0x100, 16).substring(1));
		}

		return sb.toString();
	}

	/*
	 *  nicepay 1원인증에서 사용
	 * */
	public static String Nicepay_AES_Encode(String str, String key) throws java.io.UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		key = key.substring(0, 16);
		Base64 base64 = new Base64();
		byte[] textBytes = str.getBytes();
		Key newKey = new SecretKeySpec(key.getBytes(), "AES");
		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.ENCRYPT_MODE, newKey);
		return new String(base64.encode(cipher.doFinal(textBytes)));
	}


}
