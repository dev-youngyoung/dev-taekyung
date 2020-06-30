package procure.common.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Calendar;

import procure.common.conf.Startup;

public class FileUtil {
	/**
	 * ���丮 üũ�� �ϰ� ������ �����Ѵ�.
	 * @param dir üũ�� ���丮
	 * @throws IOException
	 */
	public static void checkDirectory( String dir ) throws IOException
	{
		String curDir;
		if(dir.charAt(dir.length()-1)!='/'){
			int po = dir.lastIndexOf("/");
			curDir = dir.substring(0,po+1);
		}else{
			curDir = dir;
			//System.out.println("curDir:" + curDir);
		}
		File f = new File( curDir );
		if(!f.isDirectory())
		if(!f.mkdirs())
			throw new IOException("[error:FileUtil] directory creation failure:" + dir);
	}
	
	public static boolean checkFile(String dir, String fileName) throws IOException
	{
		File file = new File(dir + fileName);
		if(file.exists()){
			return true;
		}else{
			return false;
		}
	}
	
	public static boolean delDir(String dir) throws  IOException
	{
		File file = new File(dir);
		return file.delete();
	}
	
	/**
	 * ������ �̵���Ų��.
	 * @param srcFullPath ������ ��ü���
	 * @param targetDir ��� ���丮
	 * @param trargetFile ��� ���ϸ�
	 * @throws IOException
	 */
	public static void moveFile(String srcFullPath, String targetDir, String trargetFile) throws IOException{
		checkDirectory(targetDir);
		File file = new File(srcFullPath);
		if(!file.exists()){
			System.out.println(srcFullPath + "[ ���Ͼ���]");
			return;
		}
		if(!isEndCharSlash(targetDir)){
			if(File.separatorChar=='/')
				targetDir +=  '/';
			else
				targetDir +=  '\\';
		}
		System.out.println(targetDir + trargetFile + "[ �� �̵���]");
		file.renameTo(new File(targetDir + trargetFile));	
	}

	/**
	 * ÷�������� �̸��� ���� �ð��� �������� �����Ͽ� ��ȯ
	 * @param sPath			���� ���ϰ��
	 * @param sOrgFileName	���� ���ϸ�
	 * @return
	 */
	public static String getRenameFileNameWithParam(String sPath, String sOrgFileName)
	{
		Calendar 	cal 		= 	Calendar.getInstance();

		String		sFileName	=	sOrgFileName;
		String		sFileUrl	=	"";
		String		sReFileNm	=	"";
		String		sReFileUrl	=	"";
		
		String 		sReFile		=	cal.getTimeInMillis()+"";	
		String		sExt		=	"";

		if ( (sFileName == null) || sFileName.equals("") )
		{
			return null;
		}
		
		sExt		=	sFileName.substring(sFileName.lastIndexOf(".")+1);
		sReFileNm	=	sReFile	+	"."	+	sExt;
		
		sFileUrl	=	sPath	+	"/"	+	sFileName;
		sFileUrl	=	StrUtil.replace(sFileUrl,"\\",File.separator);
		sFileUrl	=	StrUtil.replace(sFileUrl,"/",File.separator);
		
		sReFileUrl	=	sPath	+	"/"	+ sReFileNm;
		sReFileUrl	=	StrUtil.replace(sReFileUrl,"\\",File.separator);
		sReFileUrl	=	StrUtil.replace(sReFileUrl,"/",File.separator);
		
		File	fileOld	=	new	File(sFileUrl);
		File	fileNew =	new File(sReFileUrl);

		// �����Ϸ��� ���ϸ��� ������ �����ϴ� ���ϸ��� ��쿡 ���ϸ� �������� "0" ����
		// ���ÿ� �������� (Ȯ���ڰ� ����) ������ ÷���ϴ� ��쿡 getTimeInMillis()�� ��ġ �Ҽ��� �����Ƿ� �ߺ��� Ȯ���ؾ� �Ѵ�
		while (fileNew.exists())
		{
			sReFile		=	sReFile + "0";
			sReFileNm	=	sReFile + "." + sExt;
			sReFileUrl	=	sPath + "/" + sReFileNm;
			fileNew		=	new File(sReFileUrl);
		}
		
		fileOld.renameTo(fileNew);
		
		return	sReFileNm;	// �� ���� : ��ü ��ΰ� �ƴ� ���ϸ� ��ȯ
	}	

	/*
	 * ���� ũ�� ���ϱ�
	 */
	public static long getFileSize(String sPath, String sFileName)
	{
		String sFileUrl	=	sPath	+	"/"	+	sFileName;
		File file	=	new	File(sFileUrl);
		
		return file.length();
	}
	
	/**
	 * ���� �̸��� ���� '/'�� ������ �� �Ǵ��Ѵ�.
	 * @param path �����̳� ���丮
	 * @return
	 */
	public static boolean isEndCharSlash(String path){
		if(path==null || path.equals("")) return false;
		int strLength = path.length();
		if(path.charAt(strLength-1)==File.separatorChar) return true;
		
		return false;
	}
	
	/**
	 * ÷������ ���ε�
	 * @param sInFullFile	Client ��ε� ������� Full ���
	 * @param sOutDir		Server ��ε� ������� ���丮 ���
	 * @param sOutFileNm	Server�� ������ ���ϸ�
	 * @return
	 * @throws IOException 
	 */
	public static boolean	uploadFile(String sInFullFile, String sOutDir, String sOutFileNm) throws IOException
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
			System.out.println("[ERROR uploadFile()] :" + e.toString());
			throw new FileNotFoundException("[ERROR uploadFile()] " + e.toString());
		} catch (IOException e) {
			System.out.println("[ERROR uploadFile()] :" + e.toString());
			throw new IOException("[ERROR uploadFile()] " + e.toString());
		}finally
		{
			if(fos != null)	fos.close();
			if(fis != null)	fis.close();
		}
		return	bUpload;
	}
	
	/**
	 * 
	 * @param sKey
	 * @param sOrigPath
	 * @param sCopyPath
	 * @param sCopyFileNm
	 * @return
	 * @throws IOException
	 */
	public static boolean copyFile(String sKey, String sOrigPath, String sCopyPath, String sCopyFileNm) throws IOException
	{
		boolean				bUpload	=	false;
		FileInputStream 	fis		=	null;
		FileOutputStream 	fos		=	null;
		try {
			String					sProDir			=	Startup.conf.getString(sKey);
			String 					sOrigFile 		= 	sProDir + sOrigPath;
			String 					sCopyDir 		= 	sProDir + sCopyPath;
			
			bUpload	= uploadFile(sOrigFile, sCopyDir, sCopyFileNm);	
			
		} catch (FileNotFoundException e) {
			System.out.println("[ERROR copyFile()] :" + e.toString());
			throw new FileNotFoundException("[ERROR copyFile()] " + e.toString());
		} catch (IOException e) {
			System.out.println("[ERROR copyFile()] :" + e.toString());
			throw new IOException("[ERROR copyFile()] " + e.toString());
		}finally
		{
			if(fos != null)	fos.close();
			if(fis != null)	fis.close();
		}
		return	bUpload;
		
	}
}
