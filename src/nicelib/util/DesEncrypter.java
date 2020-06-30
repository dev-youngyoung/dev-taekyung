package nicelib.util;

import java.security.MessageDigest;
import java.security.spec.KeySpec;
import java.util.*;
import javax.crypto.*;
import javax.crypto.spec.*;

public class DesEncrypter {

	private String passPhrase = "malgnsoft_20372340_alsdf";

    // 8-byte Salt
    private byte[] salt = {
        (byte)0xA9, (byte)0x9B, (byte)0xC8, (byte)0x32,
        (byte)0x56, (byte)0x35, (byte)0xE3, (byte)0x03
    };

    // Iteration count
    private int iterationCount = 19;

	public DesEncrypter(String str) {
		passPhrase = str;
	}

	public DesEncrypter() {

	}

	private SecretKey getSecretKey() throws Exception {
		KeySpec keySpec = new PBEKeySpec(passPhrase.toCharArray(), salt, iterationCount);
        SecretKey key = SecretKeyFactory.getInstance("PBEWithMD5AndDES").generateSecret(keySpec);
		return key;
	}

	public String encrypt(String str) throws Exception {
		// Encode the string into bytes using utf-8
		byte[] utf8 = str.getBytes("UTF8");

		// Encrypt
		Cipher ecipher = Cipher.getInstance("DES");
		ecipher.init(Cipher.ENCRYPT_MODE, getSecretKey());
		byte[] enc = ecipher.doFinal(utf8);

		// Encode bytes to base64 to get a string
		return new sun.misc.BASE64Encoder().encode(enc);
	}

	public String decrypt(String str) throws Exception {
		// Decode base64 to get bytes
		byte[] dec = new sun.misc.BASE64Decoder().decodeBuffer(str);

		// Decrypt
		Cipher dcipher = Cipher.getInstance("DES");
		dcipher.init(Cipher.DECRYPT_MODE, getSecretKey());

		byte[] utf8 = dcipher.doFinal(dec);

		// Decode using utf-8
		return new String(utf8, "UTF8");
	}
}
