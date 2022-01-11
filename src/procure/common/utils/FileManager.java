package procure.common.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;

import org.apache.commons.configuration.CompositeConfiguration;
import org.apache.commons.configuration.ConfigurationException;

import crosscert.Hash;

//import crosscert.Hash;

import procure.common.conf.Config;
import procure.common.conf.Startup;
import procure.common.utils.StrUtil;

public class FileManager { 
	
	/**
	 * 첨부파일 업로드
	 * @param sInFullFile	Client 얻로드 대상파일 Full 경로
	 * @param sOutDir		Server 얻로드 대상파일 디렉토리 경로
	 * @param sOutFileNm	Server에 저장할 파일명
	 * @return
	 * @throws IOException 
	 */
	public boolean	uploadFile(String sInFullFile, String sOutDir, String sOutFileNm) throws IOException
	{
		boolean				bUpload	=	false;
		FileInputStream 	fis		=	null;
		FileOutputStream 	fos		=	null;
		try {
			sOutDir		=	StrUtil.replace(sOutDir,"\\",File.separator);
			sOutDir		=	StrUtil.replace(sOutDir,"/",File.separator);
			
			String	sOutFullFile	=	sOutDir	+	File.separator	+	sOutFileNm;
			
			File	fInFile		=	new	File(sInFullFile);
			
			fis = new FileInputStream(fInFile);
			
			File	fOutDir		=	new	File(sOutDir);
			if(!fOutDir.isDirectory())
			{
				fOutDir.mkdirs(); 
			}
			
			File	fOutFile	=	new	File(sOutFullFile);
			fos = new FileOutputStream(fOutFile);
			
			int	i	=	0;
			
			while((i = fis.read()) != -1)
			{
				fos.write(i);
			}
			
			bUpload	=	true;
		} catch (FileNotFoundException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".uploadFile()] :" + e.toString());
			throw new FileNotFoundException("[ERROR "+this.getClass().toString()+".uploadFile()] " + e.toString());
		} catch (IOException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".uploadFile()] :" + e.toString());
			throw new IOException("[ERROR "+this.getClass().toString()+".uploadFile()] " + e.toString());
		}finally
		{
			if(fos != null)	fos.close();
			if(fis != null)	fis.close();
		}
		return	bUpload;
	}
	
	/**
	 * 첨부파일 업로드
	 * @param sInFullFile	Client 얻로드 대상파일 Full 경로
	 * @param sOutDir		Server 얻로드 대상파일 디렉토리 경로
	 * @return
	 * @throws Exception 
	 */
	public boolean	uploadFile(String sInFullFile, String sOutDir) throws Exception
	{
		boolean	bUpload	=	false;

		try {
			String	sOutFileNm		=	"";
			if(sInFullFile.lastIndexOf("/") > -1)
			{
				sOutFileNm	=	sInFullFile.substring(sInFullFile.lastIndexOf("/")+1);
			}else
			{
				if(sInFullFile.lastIndexOf("\\") > -1)
				{
					sOutFileNm	=	sInFullFile.substring(sInFullFile.lastIndexOf("\\")+1);
				}
			}
			
			bUpload	=	this.uploadFile(sInFullFile, sOutDir, sOutFileNm);
		} catch (Exception e) 
		{
			System.out.println("[ERROR "+this.getClass().getName() + ".uploadFile()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".uploadFile()] " + e.toString());
		} 
		return	bUpload;
	}
	
	/**
	 * 파일 업로드
	 * @param in				gauce inputstream
	 * @param sOutFullFileName	Server 업로드 대상파일 디렉토리 경로(파일포함)
	 * @return
	 * @throws IOException 
	 */
	public boolean	uploadFile(InputStream in, String sOutFullFileName) throws IOException
	{
		boolean bUpload	=	false;
		try {
			sOutFullFileName	=	StrUtil.replace(sOutFullFileName,"\\",File.separator);
			sOutFullFileName	=	StrUtil.replace(sOutFullFileName,"/",File.separator);
			
			String	sOutDir	=	sOutFullFileName.substring(0,sOutFullFileName.lastIndexOf(File.separator));
			
			File file = new File(sOutDir);
			if(!file.isDirectory())
			{
				file.mkdirs();
			}
			
			FileOutputStream	fos	=	new FileOutputStream(sOutFullFileName);
			bUpload	=	this.copy(in, fos, 2048);
		} catch (FileNotFoundException e) {  
			System.out.println("[ERROR "+this.getClass().getName() + ".uploadFile()] :" + e.toString());
			throw new FileNotFoundException("[ERROR "+this.getClass().getName()+".copy()] " + e.toString());
		} catch (IOException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".uploadFile()] :" + e.toString());
			throw new IOException("[ERROR "+this.getClass().getName()+".copy()] " + e.toString());
		} 
		return	bUpload;
	}
	
	/**
	 * 첨부파일 업로드
	 * @param in		로컬 InputStream
	 * @param sKey		업로드 프로퍼티 경로
	 * @param sSubUrl	경로
	 * @return
	 * @throws ConfigurationException 
	 * @throws IOException 
	 */
	public boolean	uploadFile(InputStream in, String sKey, String sSubUrl) throws ConfigurationException, IOException
	{
		boolean	bUpload	=	false;
		try {
			CompositeConfiguration  conf 			= 	Config.getInstance();
			String					sProDir			=	conf.getString(sKey);
			String					sMakeFullURL	=	sProDir	+	sSubUrl;
			bUpload	=	this.uploadFile(in, sMakeFullURL);
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".uploadFile()] :" + e.toString());
			throw new ConfigurationException("[ERROR "+this.getClass().getName()+".uploadFile()] " + e.toString());
		} catch (FileNotFoundException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".uploadFile()] :" + e.toString());
			throw new FileNotFoundException("[ERROR "+this.getClass().getName()+".uploadFile()] " + e.toString());
		} catch (IOException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".uploadFile()] :" + e.toString());
			throw new IOException("[ERROR "+this.getClass().getName()+".uploadFile()] " + e.toString());
		}
		return bUpload;
	}
	
	/**
	 * 파일 복사
	 * @param in			InputStream
	 * @param out			OutputStream
	 * @param bufferSize	
	 * @return
	 * @throws IOException 
	 */
	public boolean copy(InputStream in, OutputStream out, int bufferSize) throws IOException
	{
		boolean	bSuccess	=	false;
		try {
			synchronized (in) 
			{
				synchronized (out) 
				{
					byte[] buffer = new byte[bufferSize];
				    while (true) 
				    {
				    	int bytesRead;
						bytesRead = in.read(buffer);
						if (bytesRead == -1)
						{
							break;
						}else
						{
							out.write(buffer, 0, bytesRead);
						}
				    }
				}
			}
			bSuccess	=	true;
		} catch (IOException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".copy()] :" + e.toString());
			throw new IOException("[ERROR "+this.getClass().getName()+".copy()] " + e.toString());
		}finally
		{
			if(in 	!= null)	in.close();
			if(out 	!= null)	out.close();
		}
		return bSuccess;
	}
	
	public boolean copyFile(String sKey, String sOrigPath, String sCopyPath, String sCopyFileNm) throws ConfigurationException, IOException
	{
		boolean				bUpload	=	false;
		FileInputStream 	fis		=	null;
		FileOutputStream 	fos		=	null;
		try {
			CompositeConfiguration  conf 			= 	Config.getInstance();
			String					sProDir			=	conf.getString(sKey);
			String 					sOrigFile 		= 	sProDir + sOrigPath;
			String 					sCopyDir 		= 	sProDir + sCopyPath;
			
			bUpload	=	this.uploadFile(sOrigFile, sCopyDir, sCopyFileNm);	
			
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".uploadFile()] :" + e.toString());
			throw new ConfigurationException("[ERROR "+this.getClass().getName()+".uploadFile()] " + e.toString());
		} catch (FileNotFoundException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".uploadFile()] :" + e.toString());
			throw new FileNotFoundException("[ERROR "+this.getClass().getName()+".uploadFile()] " + e.toString());
		} catch (IOException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".uploadFile()] :" + e.toString());
			throw new IOException("[ERROR "+this.getClass().getName()+".uploadFile()] " + e.toString());
		}finally
		{
			if(fos != null)	fos.close();
			if(fis != null)	fis.close();
		}
		return	bUpload;
		
	}
	/**
	 * 첨부파일 삭제
	 * @param sOutFullFile	삭제대상 파일 Full 경로
	 * @return
	 */
	public boolean	delFile(String	sOutFullFile)
	{
		boolean	bDel			=	true;
		String	_sOutFullFile	=	"";
		
		_sOutFullFile	=	StrUtil.replace(sOutFullFile,"\\",File.separator);
		_sOutFullFile	=	StrUtil.replace(sOutFullFile,"/",File.separator);
		
		File	file	=	new	File(_sOutFullFile);
		
		if(!file.isDirectory())
		{
			if(file.exists())
			{
				bDel	=	file.delete();
			}
		}
		
		return	bDel;
	}
	
	/**
	 * 첨부파일 삭제
	 * @param sKey		삭제할 파일의 프로파티명
	 * @param sSubURL	나머지 경로
	 * @return
	 * @throws ConfigurationException 
	 */
	public boolean	delFile(String sKey, String	sSubURL) throws ConfigurationException
	{
		boolean	bDel	=	false;

		try {
			CompositeConfiguration 	conf 		= 	Config.getInstance();
			String					sProDir		=	conf.getString(sKey);
			String					sDelFullURL	=	sProDir	+	sSubURL;
			bDel	=	this.delFile(sDelFullURL);
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".delFile()] :" + e.toString());
			throw new ConfigurationException("[ERROR "+this.getClass().getName()+".delFile()] " + e.toString());
		}
		return bDel;
	}
	

	/**
	 * 디렉토리 삭제
	 * @param sKey		삭제할 파일의 프로파티명 
	 * @param sDir
	 */
	public boolean delDir(String sKey, String sDir)
	{
		String sMergeDir = "";
		
		sDir	=	StrUtil.replace(sDir,"\\",File.separator);
		sDir	=	StrUtil.replace(sDir,"/",File.separator);

		CompositeConfiguration conf;
		try {
			conf = Config.getInstance();
			String sProDir		=	conf.getString(sKey);
			sMergeDir = sProDir + sDir;
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".delFile()] :" + e.toString());
		}
		
		return	delDir(sMergeDir);
	}		
	
	/**
	 * 디렉토리 삭제
	 * @param sDir
	 */
	public boolean delDir(String sDir)
	{
		sDir	=	StrUtil.replace(sDir,"\\",File.separator);
		sDir	=	StrUtil.replace(sDir,"/",File.separator);
		
		boolean	bDel	=	true;
		File	file	=	new	File(sDir);
		if(file.exists())
		{
			File[]	fList	=	file.listFiles();
			for(int i=0; i<fList.length; i++)
			{
				if(fList[i].isFile())
				{
					if(!fList[i].delete())
					{
						bDel	=	false;
						break;
					}
				}else
				{
					if(!delAllFile(fList[i]))
					{
						bDel	=	false;
						break;
					}
				}
			}
			if(file.exists())
			{
				if(!file.delete())	bDel	=	false;
			}
		}else
		{
			bDel	=	false;
		}
		return	bDel;
	}
	
	/**
	 * 하위폴더 및 파일 모두 삭제
	 * @param file	삭제할 폴더 및 파일
	 * @return
	 */
	public boolean	delAllFile(File file)
	{
		boolean	bDel	=	true;
		File[]	fList	=	file.listFiles();
		for(int i=0; i<fList.length; i++)
		{
			if(fList[i].isFile())
			{
				if(!fList[i].delete())
				{
					bDel	=	false;
					break;
				}
			}else
			{
				if(!this.delAllFile(fList[i]))
				{
					bDel	=	false;
					break;
				}
			}
		}
		if(file.exists())
		{
			if(!file.delete())	bDel	=	false;
		}
		return	bDel;
	}

	/**
	 * Hash 정보 가져오기
	 * @param sXpath		경로
	 * @param sOtherFullDir
	 * @return
	 * @throws ConfigurationException 
	 * @throws ConfigurationException 
	 * @throws IOException 
	 */
	public String	getHash(String	sXpath,	String	sOtherFullDir)
	{
		FileInputStream	fis		=	null;
		String 			sHash	=	"";
		try {
			String	sBaseDir	=	Startup.conf.getString(sXpath);
			
			if(sBaseDir.lastIndexOf("/") == sBaseDir.length() - 1)
			{
				sBaseDir	=	sBaseDir.substring(0,sBaseDir.length()-1);
			}
			
			if(sOtherFullDir.indexOf("/") == 0)
			{
				sOtherFullDir	=	sOtherFullDir.substring(1);
			}
			
			String	sFullFilePath	=	sBaseDir	+	"/"	+	sOtherFullDir;
			sFullFilePath	=	StrUtil.replace(sFullFilePath,"\\",File.separator);
			sFullFilePath	=	StrUtil.replace(sFullFilePath,"/",File.separator);
			
			System.out.println("getHash : " + sFullFilePath);
			
			fis					=	new FileInputStream(new File(sFullFilePath));
			int		iFileLen	=	fis.available();
			byte[]	b			=	new	byte[iFileLen];
			int		iRet		=	fis.read(b);
			Hash	hash		=	null;
			hash				=	new	Hash();
			
			iRet	=	hash.GetHash(b, b.length);
			if(iRet	==	0)
			{
				sHash	=	new	String(hash.contentbuf);
			}else
			{
				sHash	=	"";
			}
		} catch (FileNotFoundException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getHash()] :" + e.toString());
			//throw new FileNotFoundException("[ERROR "+this.getClass().getName()+".getHash()] " + e.toString());
		} catch (IOException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getHash()] :" + e.toString());
			//throw new IOException("[ERROR "+this.getClass().getName()+".getHash()] " + e.toString());
		} finally
		{
			try {
				if(fis != null) fis.close();
			} catch (IOException e) {
				System.out.println("[ERROR "+this.getClass().getName() + ".getHash()] :" + e.toString());
				//throw new IOException("[ERROR "+this.getClass().getName()+".getHash()] " + e.toString());
			}
		}
		return	sHash;
	}
	
	/**
	 * top 디렉토리 경로 가져오기
	 * @param _sDirPath
	 * @return
	 */
	public ArrayList	getArrDir(String _sDirPath)
	{
		ArrayList	al			=	new	ArrayList();
		String		sDirPath	=	"";	
				
		sDirPath	=	StrUtil.replace(_sDirPath,"\\",File.separator);
		sDirPath	=	StrUtil.replace(sDirPath,"/",File.separator);
		
		File	file	=	new	File(sDirPath);
		
		if(file.isDirectory())
		{
			File[]	fList	=	file.listFiles();
			
			for(int i=0; i < fList.length; i++)
			{
				if(fList[i].isDirectory())
				{
					String	sDir	=	fList[i].getName().toUpperCase();
					if(		!sDir.equals(".SVN") 
					   && 	!sDir.equals("HTML")
					    &&	!sDir.equals("HTML")
					    &&	!sDir.equals("MAIN")
					)
					{
						al.add(fList[i].getName());
					}
				}
			}
		}		
		return al;
	}
	
	/**
	 * 소스파일명 가져오기
	 * @param _sDirPath	대상경로
	 * @return
	 */
	public ArrayList	getArrFileNm(String _sDirPath)
	{
		ArrayList	al			=	new	ArrayList();
		String		sDirPath	=	"";	
				
		sDirPath	=	StrUtil.replace(_sDirPath,"\\",File.separator);
		sDirPath	=	StrUtil.replace(sDirPath,"/",File.separator);
		
		File	file	=	new	File(sDirPath);
		if(file.isDirectory())
		{
			File[]	fList	=	file.listFiles();
			
			for(int i=0; i < fList.length; i++)
			{
				if(fList[i].isFile())
				{
					String	sFileNm	=	fList[i].getName().toUpperCase();
					if(!sFileNm.equals("INIT.JSP"))
					{
						al.add(fList[i].getName());
					}
				}
			}
		}
		return al;
	}
}
