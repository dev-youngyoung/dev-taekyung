package procure.common.utils;

import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

public class StringCrypto {
	
	private static volatile StringCrypto INSTANCE;
	private static final String aegisKey = "aegis&nicePwd123AesKey";
	private final String key = "AES";
	
    public static StringCrypto getInstance(){
    	if( INSTANCE == null ){
    		synchronized(StringCrypto.class){
    			if( INSTANCE == null )
    				INSTANCE = new StringCrypto();
    		}
    	}
    	return INSTANCE;
    }

	public static void main(String[] args) {
		try {
			StringCrypto aes128 = StringCrypto.getInstance();

			String a = aes128.encrypt("aegis");
			System.out.println(a);
			String b = aes128.decrypt(a);
			System.out.println(b);
			String c = aes128.encrypt("95001");
			System.out.println(c);
			String d = aes128.decrypt("b28d8fa34884a5612796694fb4b9eb01");
			System.out.println(d);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String encrypt(String cleartext) throws Exception{
		return encrypt(aegisKey, cleartext);
	}
	public String decrypt(String encrypted) throws Exception{
		return decrypt(aegisKey, encrypted);
	}
	
	
	private String encrypt(String seed, String cleartext) throws Exception
	{
		byte[] rawKey = getRawKey(seed.getBytes());
		byte[] result = encrypt(rawKey, cleartext.getBytes());
		return toHex(result);
	}
	
	private String decrypt(String seed, String encrypted) throws Exception
	{
		byte[] rawKey = getRawKey(seed.getBytes());
		byte[] enc = toByte(encrypted);
		byte[] result = decrypt(rawKey, enc);
		return new String(result);
	}

	private byte[] getRawKey(byte[] seed) throws Exception
	{
		KeyGenerator kgen = KeyGenerator.getInstance(key);
		SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
		sr.setSeed(seed);
	    kgen.init(128, sr); // 192 and 256 bits may not be available
	    SecretKey skey = kgen.generateKey();
	    byte[] raw = skey.getEncoded();
	    return raw;
	}

	
	private byte[] encrypt(byte[] raw, byte[] clear) throws Exception
	{
	    SecretKeySpec skeySpec = new SecretKeySpec(raw, key);
		Cipher cipher = Cipher.getInstance(key);
	    cipher.init(Cipher.ENCRYPT_MODE, skeySpec);
	    byte[] encrypted = cipher.doFinal(clear);
		return encrypted;
	}

	private byte[] decrypt(byte[] raw, byte[] encrypted) throws Exception
	{
	    SecretKeySpec skeySpec = new SecretKeySpec(raw, key);
		Cipher cipher = Cipher.getInstance(key);
	    cipher.init(Cipher.DECRYPT_MODE, skeySpec);
	    byte[] decrypted = cipher.doFinal(encrypted);
		return decrypted;
	}

	private byte[] toByte(String hex){
        if (hex == null || hex.length() == 0) {
            return null;
        }

        byte[] ba = new byte[hex.length() / 2];
        for (int i = 0; i < ba.length; i++) {
            ba[i] = (byte) Integer.parseInt(hex.substring(2 * i, 2 * i + 2), 16);
        }
        return ba;
	}

	private String toHex(byte[] buf){

        if (buf == null || buf.length == 0) {
            return null;
        }

        StringBuffer sb = new StringBuffer(buf.length * 2);
        String hexNumber;
        for (int x = 0; x < buf.length; x++) {
            hexNumber = "0" + Integer.toHexString(0xff & buf[x]);

            sb.append(hexNumber.substring(hexNumber.length() - 2));
        }
        return sb.toString();
	}
}
