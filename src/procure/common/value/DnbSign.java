package procure.common.value;

import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;

import org.apache.commons.configuration.CompositeConfiguration;
import org.apache.commons.configuration.ConfigurationException;

import 	procure.common.conf.Config;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import	java.io.ObjectInputStream;

import javax.crypto.Cipher;
import javax.crypto.NoSuchPaddingException;

import	sun.misc.BASE64Encoder;

public class DnbSign {
	/**
     * ������ ���Ű�� ������ ���� �޼���
     * @return  Key ���Ű Ŭ����
	 * @throws IOException 
	 * @throws ClassNotFoundException 
	 * @throws ConfigurationException 
	 * @exception Exception
     */
	public static Key getKey() throws Exception{
		Key					key	=	null;
		ObjectInputStream 	in	=	null;
		try {
			CompositeConfiguration  conf = Config.getInstance();
    		
			String FileURL = conf.getString("sign_key");  //key ���� ��� �����ʿ�
        
			in = new ObjectInputStream(new FileInputStream(FileURL));
			key = (java.security.Key)in.readObject();
		} catch (FileNotFoundException e) {
			throw new	FileNotFoundException("[ERROR DnbSign.getKey()] :" + e.toString());
		} catch (IOException e) {
			throw new	IOException("[ERROR DnbSign.getKey()] :" + e.toString());
		} catch (ClassNotFoundException e) {
			throw new	ClassNotFoundException("[ERROR DnbSign.getKey()] :" + e.toString());
		}catch (ConfigurationException e) {
			throw new	ConfigurationException("[ERROR DnbSign.getKey()] :" + e.toString());
		}finally
		{
			if(in != null)
			{
				in.close();
			}
		}
		return key;
   }
	
	/**
     * ���ڿ� ��Ī ��ȣȭ
     * @param   ID  ���Ű ��ȣȭ�� ����ϴ� ���ڿ�
     * @return  String  ��ȣȭ�� ID
	 * @throws Exception 
     * @exception Exception
     */
	public  static String encrypt(String ID) throws Exception
	{
		String outputStr1 = "";
		
		try {
			if(ID != null && ID.length() > 0)
			{
				Cipher cipher = Cipher.getInstance("DES/ECB/PKCS5Padding");
				cipher.init(Cipher.ENCRYPT_MODE,DnbSign.getKey());
			    String amalgam = ID;

			    byte[] inputBytes1 = amalgam.getBytes("UTF8");
			    byte[] outputBytes1 = cipher.doFinal(inputBytes1);

			    BASE64Encoder encoder = new BASE64Encoder();
			    outputStr1 = encoder.encode(outputBytes1);
			}
		} catch (NoSuchAlgorithmException e) {
			throw new	NoSuchAlgorithmException("[ERROR DnbSign.encrypt()] :" + e.toString());
		} catch (NoSuchPaddingException e) {
			throw new	NoSuchPaddingException("[ERROR DnbSign.encrypt()] :" + e.toString());
		} catch (InvalidKeyException e) {
			throw new	InvalidKeyException("[ERROR DnbSign.encrypt()] :" + e.toString());
		} catch (Exception e) {
			throw new	Exception("[ERROR DnbSign.encrypt()] :" + e.toString());
		}
		  
	    return outputStr1;
	}
}
