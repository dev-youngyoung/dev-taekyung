package com.nicedocu;


import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

public class Password {
	private String aeskey = "nicednb passwd12";  // AES�� key�� 16(128),24(192),32(256)byte�� �ϳ��� �̷������ �Ѵ�.
	private String _value; 
	 
	public void addText(String value) 
	{ 
		_value = value; 
	} 
	 
	public Object replaceObject() 
	{ 
		return decrypt(_value); 
	} 

	private String decrypt(String encrypted)
	{
		String decrypt = "";
        try {		
			decrypt = AESdecrypt(encrypted);
        } catch (Exception e) {
            e.printStackTrace();
        }
		return decrypt;
	}
	
    /**
     * hex to byte[] : 16���� ���ڿ��� ����Ʈ �迭�� ��ȯ�Ѵ�.
     * 
     * @param hex    hex string
     * @return
     */
    private byte[] hexToByteArray(String hex) {
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
     * byte[] to hex : unsigned byte(����Ʈ) �迭�� 16���� ���ڿ��� �ٲ۴�.
     * 
     * @param ba        byte[]
     * @return
     */
    private String byteArrayToHex(byte[] ba) {
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
     * AES ����� ��ȣȭ
     * 
     * @param message
     * @return
     * @throws Exception
     */
    private String AESencrypt(String message) throws Exception {

        // use key coss2
        SecretKeySpec skeySpec = new SecretKeySpec(aeskey.getBytes(), "AES");

        // Instantiate the cipher
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec);

        byte[] encrypted = cipher.doFinal(message.getBytes());
        return byteArrayToHex(encrypted);
    }

    /**
     * AES ����� ��ȣȭ
     * 
     * @param message
     * @return
     * @throws Exception
     */
    private String AESdecrypt(String encrypted) throws Exception {

        // use key coss2
        SecretKeySpec skeySpec = new SecretKeySpec(aeskey.getBytes(), "AES");

        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, skeySpec);
        byte[] original = cipher.doFinal(hexToByteArray(encrypted));
        String originalString = new String(original);
        return originalString;
    }
    
    /** ����
     * 
     * 
     * @param args 
     */
    public static void main(String[] args)
    {
        try {

        		Password pw = new Password();
        		String encrypt = pw.AESencrypt("naftal");
        		System.out.println("encrypt str = "+encrypt);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }    
}
