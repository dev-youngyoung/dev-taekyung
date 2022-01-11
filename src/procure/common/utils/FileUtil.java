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
	 * 디렉토리 체크를 하고 없으면 생성한다.
	 * @param dir 체크할 디렉토리
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
	 * 파일을 이동시킨다.
	 * @param srcFullPath 파일의 전체경로
	 * @param targetDir 대상 디렉토리
	 * @param trargetFile 대상 파일명
	 * @throws IOException
	 */
	public static void moveFile(String srcFullPath, String targetDir, String trargetFile) throws IOException{
		checkDirectory(targetDir);
		File file = new File(srcFullPath);
		if(!file.exists()){
			System.out.println(srcFullPath + "[ 파일없음]");
			return;
		}
		if(!isEndCharSlash(targetDir)){
			if(File.separatorChar=='/')
				targetDir +=  '/';
			else
				targetDir +=  '\\';
		}
		System.out.println(targetDir + trargetFile + "[ 로 이동함]");
		file.renameTo(new File(targetDir + trargetFile));	
	}

	/**
	 * 첨부파일의 이름을 현재 시각을 기준으로 변경하여 반환
	 * @param sPath			원본 파일경로
	 * @param sOrgFileName	원본 파일명
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

		// 변경하려는 파일명이 기존에 존재하는 파일명일 경우에 파일명 마지막에 "0" 붙임
		// 동시에 여러개의 (확장자가 같은) 파일을 첨부하는 경우에 getTimeInMillis()가 일치 할수도 있으므로 중복을 확인해야 한다
		while (fileNew.exists())
		{
			sReFile		=	sReFile + "0";
			sReFileNm	=	sReFile + "." + sExt;
			sReFileUrl	=	sPath + "/" + sReFileNm;
			fileNew		=	new File(sReFileUrl);
		}
		
		fileOld.renameTo(fileNew);
		
		return	sReFileNm;	// ※ 주의 : 전체 경로가 아닌 파일명만 반환
	}	

	/*
	 * 파일 크기 구하기
	 */
	public static long getFileSize(String sPath, String sFileName)
	{
		String sFileUrl	=	sPath	+	"/"	+	sFileName;
		File file	=	new	File(sFileUrl);
		
		return file.length();
	}
	
	/**
	 * 파일 이름의 끝이 '/'로 끝나는 지 판단한다.
	 * @param path 파일이나 디렉토리
	 * @return
	 */
	public static boolean isEndCharSlash(String path){
		if(path==null || path.equals("")) return false;
		int strLength = path.length();
		if(path.charAt(strLength-1)==File.separatorChar) return true;
		
		return false;
	}
	
	/**
	 * 첨부파일 업로드
	 * @param sInFullFile	Client 얻로드 대상파일 Full 경로
	 * @param sOutDir		Server 얻로드 대상파일 디렉토리 경로
	 * @param sOutFileNm	Server에 저장할 파일명
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
