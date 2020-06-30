package procure.common.utils;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.util.Random;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.Hex;

// TODO: Implement 256-bit version like: http://securejava.wordpress.com/2012/10/25/aes-256/
public class AesUtil {
    private final int keySize;
    private final int iterationCount;
    private final Cipher cipher;
    private static final String SALT = "4FF2EC019C627B945225DEBAD71A01B6985FE84C95A70EB132882F88C0A59A55";
    private static final String IV = "127D5C9927726BCEFE752eB1BDD3E138";

    public static void main(String[] args)
    {
        try {
        	AesUtil au = new AesUtil();
        	
        	System.out.println(au.encrypt("123467890123456890","1078814410"));
        	
        	System.out.println(au.decrypt("123467890123456890", "79bb2ed5d5b66b59630e6592f14c6674"));
        	
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    
    public AesUtil() {
        this(128,100);
    }
    public AesUtil(int keySize, int iterationCount) {
        this.keySize = keySize;
        this.iterationCount = iterationCount;
        try {
            cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        }
        catch (NoSuchAlgorithmException e){
            throw fail(e);
        } catch (NoSuchPaddingException e) {
                throw fail(e);
               }
    }
    public String encrypt(String passphrase, String plaintext) {
        return encrypt(SALT,IV,passphrase,plaintext);
    }
    public String encrypt(String salt, String iv, String passphrase, String plaintext) {
        try {
            SecretKey key = generateKey(salt, passphrase);
            byte[] encrypted = doFinal(Cipher.ENCRYPT_MODE, key, iv, plaintext.getBytes("UTF-8"));
            return hex(encrypted);
        }
        catch (UnsupportedEncodingException e) {
            throw fail(e);
        }
    }
    public String decrypt(String passphrase, String ciphertext) {
        return decrypt(SALT,IV,passphrase,ciphertext);
    }
    public String decrypt(String salt, String iv, String passphrase, String ciphertext) {
        try {
            SecretKey key = generateKey(salt, passphrase);
            byte[] decrypted = doFinal(Cipher.DECRYPT_MODE, key, iv, hex(ciphertext));
            return new String(decrypted, "UTF-8");
        }
        catch (UnsupportedEncodingException e) {
            throw fail(e);
        }
    }
    
 
    
    private byte[] doFinal(int encryptMode, SecretKey key, String iv, byte[] bytes) {
        try {
            cipher.init(encryptMode, key, new IvParameterSpec(hex(iv)));
            return cipher.doFinal(bytes);
        }
        catch (InvalidKeyException e) {
            throw fail(e);
        } catch (InvalidAlgorithmParameterException e) {
                throw fail(e);
               } catch (IllegalBlockSizeException e) {
                       throw fail(e);
               } catch (BadPaddingException e) {
                       throw fail(e);
               }
    }
    
    private SecretKey generateKey(String salt, String passphrase) {
        try {
            SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
            KeySpec spec = new PBEKeySpec(passphrase.toCharArray(), hex(salt), iterationCount, keySize);
            SecretKey key = new SecretKeySpec(factory.generateSecret(spec).getEncoded(), "AES");
            return key;
        }
        catch (NoSuchAlgorithmException e) {
            throw fail(e);
        } catch (InvalidKeySpecException e) {
               throw fail(e);
               }
    }


    public static String hex(byte[] bytes) {
        return byteArrayToHex(bytes);
        
    }
    
    public static byte[] hex(String str) {
        try {
            return Hex.decodeHex(str.toCharArray());
        }
        catch (DecoderException e) {
            throw new IllegalStateException(e);
        }
    }

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
    
    /*
    public static String hex(byte[] bytes) {
        return Hex.encodeHex(bytes).toString();
        
    }
    
    
    public static byte[] hex(String str) {
        try {
            return Hex.decodeHex(str.toCharArray());
        }
        catch (DecoderException e) {
            throw new IllegalStateException(e);
        }
    }
    */
    
    private IllegalStateException fail(Exception e) {
        return new IllegalStateException(e);
    }

}
