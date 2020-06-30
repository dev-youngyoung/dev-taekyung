package procure.common.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

import javax.crypto.Cipher;
import javax.crypto.CipherOutputStream;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;

import org.apache.commons.configuration.CompositeConfiguration;
import org.apache.commons.configuration.ConfigurationException;

import procure.common.conf.Config;
import procure.common.utils.StrUtil;

public class EnDecryption {
	
	/**
	 * ���Ͼ�ȣȭ
	 * @param sInFilePath		��ȣȭ�������
	 * @param sOutFilePath	��ȣȭ������
	 * @param sPwd					��й�ȣ
	 * @return 
	 * @throws IOException 
	 * @throws InvalidKeyException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeySpecException 
	 * @throws NoSuchPaddingException 
	 */
	public boolean getEnDecryption(String sInFilePath, String sOutFilePath, String sPwd, String sDiv) throws IOException, InvalidKeyException, NoSuchAlgorithmException, InvalidKeySpecException, NoSuchPaddingException
	{
		boolean	bEnc	=	true;
		FileInputStream			fis			=	null;
		FileOutputStream		fos			=	null;
		CipherOutputStream	cipher1	=	null;
		try {
			sInFilePath		=	StrUtil.replace(sInFilePath,"\\",File.separator);
			sInFilePath		=	StrUtil.replace(sInFilePath,"/",File.separator);
			
			sOutFilePath	=	StrUtil.replace(sOutFilePath,"\\",File.separator);
			sOutFilePath	=	StrUtil.replace(sOutFilePath,"/",File.separator);
			
			if(sDiv.equals("ENC"))
			{
				sOutFilePath	=	sOutFilePath + ".env";
			}else
			{
				sInFilePath		=	sInFilePath + ".env";
			}
			
			File	fInFile		=	new	File(sInFilePath);
			fis = new FileInputStream(fInFile);
			
			String	sOutDir	=	sOutFilePath.substring(0,sOutFilePath.lastIndexOf(File.separator)+1);
			
			File	fOutDir		=	new	File(sOutDir);
			if(!fOutDir.isDirectory())
			{
				fOutDir.mkdir();
			}
			
			File	fOutFile	=	new	File(sOutFilePath);
			fos = new FileOutputStream(fOutFile);
			
			// Key ����
			byte[]						bKey				=	sPwd.getBytes();
			
			DESKeySpec				keySpec			=	new	DESKeySpec(bKey);
			SecretKeyFactory	skeyFactory	=	SecretKeyFactory.getInstance("DES");
			SecretKey					skey				=	skeyFactory.generateSecret(keySpec);
			
			//	cipher ����
			Cipher						ciper				=	Cipher.getInstance("DES/ECB/PKCS5Padding");
			if(sDiv.equals("ENC"))
			{
				ciper.init(Cipher.ENCRYPT_MODE,skey);
			}else
			{
				ciper.init(Cipher.DECRYPT_MODE,skey);
			}
			
			cipher1	=	new	CipherOutputStream(fos,ciper);
			
			// ������ ��ȣȭ�ؼ� ����
			int r = 0;
			while((r = fis.read()) != -1)
			{
				cipher1.write(r); 
			}
		} catch (IOException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
			throw new IOException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
			} catch (InvalidKeyException e) {
				System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
				throw new InvalidKeyException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
		} catch (NoSuchAlgorithmException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
			throw new NoSuchAlgorithmException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
		} catch (InvalidKeySpecException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
			throw new InvalidKeySpecException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
		} catch (NoSuchPaddingException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
			throw new NoSuchPaddingException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
		} finally
		{
			try {
				if(cipher1 != null) cipher1.close();
			} catch (IOException e) {
				bEnc	=	false;
				System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
				throw new IOException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
			}
			try {
				if(fos	!= null)	fos.close();
			} catch (IOException e) {
				bEnc	=	false;
				System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
				throw new IOException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
			}
			try {
				if(fis	!= null)	fis.close();
			} catch (IOException e) {
				bEnc	=	false;
				System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
				throw new IOException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
			}
		}
		return bEnc;
	}
	
	/**
	 * ���Ͼ�ȣȭ
	 * @param sInFilePath		��ȣȭ�������
	 * @param sOutFilePath	��ȣȭ������
	 * @param sPwd					��й�ȣ
	 * @return 
	 * @throws IOException 
	 * @throws InvalidKeyException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeySpecException 
	 * @throws NoSuchPaddingException 
	 */
	public boolean getEnDecryption(InputStream in, String sOutFilePath, String sPwd, String sDiv) throws IOException, InvalidKeyException, NoSuchAlgorithmException, InvalidKeySpecException, NoSuchPaddingException
	{
		boolean	bEnc	=	true;
		FileInputStream			fis			=	null;
		FileOutputStream		fos			=	null;
		CipherOutputStream	cipher1	=	null;
		try {
			sOutFilePath	=	StrUtil.replace(sOutFilePath,"\\",File.separator);
			sOutFilePath	=	StrUtil.replace(sOutFilePath,"/",File.separator);
			
			if(sDiv.equals("ENC"))
			{
				sOutFilePath	=	sOutFilePath + ".env";
			}
			
			String	sOutDir	=	sOutFilePath.substring(0,sOutFilePath.lastIndexOf(File.separator));
			
			File file = new File(sOutDir);
			if(!file.isDirectory())
			{
				file.mkdirs();
			}
			
			fos	=	new FileOutputStream(sOutFilePath);
			fis	=	(FileInputStream)in;
			
			// Key ����
			byte[]						bKey				=	sPwd.getBytes();
			
			DESKeySpec				keySpec			=	new	DESKeySpec(bKey);
			SecretKeyFactory	skeyFactory	=	SecretKeyFactory.getInstance("DES");
			SecretKey					skey				=	skeyFactory.generateSecret(keySpec);
			
			//	cipher ����
			Cipher						ciper				=	Cipher.getInstance("DES/ECB/PKCS5Padding");
			if(sDiv.equals("ENC"))
			{
				ciper.init(Cipher.ENCRYPT_MODE,skey);
			}else
			{
				ciper.init(Cipher.DECRYPT_MODE,skey);
			}
			
			cipher1	=	new	CipherOutputStream(fos,ciper);
			
			// ������ ��ȣȭ�ؼ� ����
			int r = 0;
			while((r = fis.read()) != -1)
			{
				cipher1.write(r); 
			}
		} catch (IOException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
			throw new IOException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
			} catch (InvalidKeyException e) {
				System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
				throw new InvalidKeyException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
		} catch (NoSuchAlgorithmException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
			throw new NoSuchAlgorithmException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
		} catch (InvalidKeySpecException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
			throw new InvalidKeySpecException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
		} catch (NoSuchPaddingException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
			throw new NoSuchPaddingException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
		} finally
		{
			try {
				if(cipher1 != null) cipher1.close();
			} catch (IOException e) {
				bEnc	=	false;
				System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
				throw new IOException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
			}
			try {
				if(fos	!= null)	fos.close();
			} catch (IOException e) {
				bEnc	=	false;
				System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
				throw new IOException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
			}
			try {
				if(fis	!= null)	fis.close();
			} catch (IOException e) {
				bEnc	=	false;
				System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
				throw new IOException("[ERROR "+this.getClass().toString()+".getEncrypion()] " + e.toString());
			}
		}
		return bEnc;
	}
	
	public boolean getEncryption(InputStream in,String sKey, String sSubUrl, String sPwd)
	{
		boolean	bEnc	=	false;
		try {
			CompositeConfiguration conf = Config.getInstance();
			
			String	sProDir	=	conf.getString(sKey);
			String	sOutFilePath	=	sProDir	+	sSubUrl;
			
			bEnc	=	this.getEnDecryption(in, sOutFilePath, sPwd, "ENC");	
		} catch (ConfigurationException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (InvalidKeyException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (NoSuchAlgorithmException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (InvalidKeySpecException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (NoSuchPaddingException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (IOException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		}
		return bEnc;
	}
	
	public boolean getEncryption(InputStream in,String sKey, String sInOtherFilePath)
	{
		boolean	bEnc	=	false;
		try {
			CompositeConfiguration conf = Config.getInstance();
			
			String	sProDir	=	conf.getString(sKey);
			String	sOutFilePath	=	sProDir	+	sInOtherFilePath;
			
			String	sSecurityPw	=	conf.getString("security_pw");
			
			bEnc	=	this.getEnDecryption(in, sOutFilePath, sSecurityPw, "ENC");	
		} catch (ConfigurationException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (InvalidKeyException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (NoSuchAlgorithmException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (InvalidKeySpecException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (NoSuchPaddingException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (IOException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		}
		return bEnc;
	}
	
	/**
	 * ���Ͼ�ȣȭ
	 * @param sInFilePath		�������
	 * @param sOutFilePath	��ȣȭ����
	 * @param sPwd					��й�ȣ
	 * @return
	 */
	public boolean getEnDecryption(String sInFilePath, String sOutFilePath, String sPwd)
	{
		boolean	bEnc	=	false;
		try {
			bEnc	=	this.getEnDecryption(sInFilePath, sOutFilePath, sPwd, "ENC");
		} catch (InvalidKeyException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (NoSuchAlgorithmException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (InvalidKeySpecException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (NoSuchPaddingException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (IOException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		}
		return bEnc;
	}
	
	/**
	 * ���Ͼ�ȣȭ
	 * @param sKey							������ƼŰ
	 * @param sInOtherFilePath	���ϰ��
	 * @param sOutOtherFilePath	���ϰ��
	 * @param sPwd							��й�ȣ
	 * @return
	 */
	public boolean getEncryption(String sKey, String sInOtherFilePath, String sOutOtherFilePath, String sPwd)
	{
		boolean	bEnc	=	false;
		try {
			CompositeConfiguration	conf = Config.getInstance();
			
			String	sProDir				=	conf.getString(sKey);
			String	sInFilePath		=	sProDir	+	sInOtherFilePath;
			String	sOutFilePath	=	sProDir	+	sOutOtherFilePath;
			
			this.getEnDecryption(sInFilePath, sOutFilePath, sPwd, "ENC");
		} catch (ConfigurationException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (InvalidKeyException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (NoSuchAlgorithmException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (InvalidKeySpecException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (NoSuchPaddingException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (IOException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		}
		return bEnc;
	}
	
	/**
	 * ���Ϻ�ȣȭ
	 * @param sInFilePath		��ȣȭ����
	 * @param sOutFilePath	����
	 * @param sPwd					��й�ȣ
	 * @return
	 */
	public boolean getDecryption(String sInFilePath, String sOutFilePath, String sPwd)
	{
		boolean	bDec	=	false;
		try {
			bDec	=	this.getEnDecryption(sInFilePath, sOutFilePath, sPwd, "DEC");
		} catch (InvalidKeyException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (NoSuchAlgorithmException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (InvalidKeySpecException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (NoSuchPaddingException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (IOException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		}
		return bDec;
	}
	
	/**
	 * ���� ��ȣȭ
	 * @param sKey							������Ƽ Ű
	 * @param sInOtherFilePath	���ϰ��
	 * @param sOutOtherFilePath	���ϰ��
	 * @param sPwd							��й�ȣ
	 * @return
	 */
	public boolean getDecryption(String sKey, String sInOtherFilePath, String sOutOtherFilePath, String sPwd)
	{
		boolean	bDec	=	false;
		try {
			CompositeConfiguration	conf = Config.getInstance();
			
			String	sProDir				=	conf.getString(sKey);
			String	sInFilePath		=	sProDir	+	sInOtherFilePath;
			String	sOutFilePath	=	sProDir	+	sOutOtherFilePath;
			
			this.getEnDecryption(sInFilePath, sOutFilePath, sPwd, "DEC");
		} catch (ConfigurationException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (InvalidKeyException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (NoSuchAlgorithmException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (InvalidKeySpecException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (NoSuchPaddingException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (IOException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		}
		return bDec;
	}
	
	public boolean getDecryption(String sKey, String sInOtherFilePath)
	{
		boolean	bDec	=	false;
		try {
			CompositeConfiguration	conf = Config.getInstance();
			
			String	sProDir				=	conf.getString(sKey);
			String	sInFilePath		=	sProDir	+	sInOtherFilePath;
			String	sSecurityPw		=	conf.getString("security_pw");
			
			this.getEnDecryption(sInFilePath, sInFilePath, sSecurityPw, "DEC");
		} catch (ConfigurationException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (InvalidKeyException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (NoSuchAlgorithmException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (InvalidKeySpecException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (NoSuchPaddingException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		} catch (IOException e) {
			bDec	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getEncrypion()] :" + e.toString());
		}
		return bDec;
	}
	
	public boolean getDecryption(InputStream in,String sKey, String sSubUrl, String sPwd)
	{
		boolean	bEnc	=	false;
		try {
			CompositeConfiguration conf = Config.getInstance();
			
			String	sProDir	=	conf.getString(sKey);
			String	sOutFilePath	=	sProDir	+	sSubUrl;
			
			bEnc	=	this.getEnDecryption(in, sOutFilePath, sPwd, "DEC");	
		} catch (ConfigurationException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (InvalidKeyException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (NoSuchAlgorithmException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (InvalidKeySpecException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (NoSuchPaddingException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (IOException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		}
		return bEnc;
	}
	
	public boolean getDecryption(InputStream in,String sKey, String sSubUrl)
	{
		boolean	bEnc	=	false;
		try {
			CompositeConfiguration conf = Config.getInstance();
			
			String	sProDir			=	conf.getString(sKey);
			String	sSecurityPw	=	conf.getString("security_pw");	
			
			String	sOutFilePath	=	sProDir	+	sSubUrl;
			
			bEnc	=	this.getEnDecryption(in, sOutFilePath, sSecurityPw, "DEC");	
		} catch (ConfigurationException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (InvalidKeyException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (NoSuchAlgorithmException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (InvalidKeySpecException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (NoSuchPaddingException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		} catch (IOException e) {
			bEnc	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDecrypion()] :" + e.toString());
		}
		return bEnc;
	}
}
