package procure.common.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.configuration.CompositeConfiguration;
import org.apache.commons.configuration.ConfigurationException;

import com.josephoconnell.html.HTMLInputFilter;
import com.oreilly.servlet.MultipartRequest;

import procure.common.conf.Config;
import procure.common.utils.StrUtil;
import procure.common.value.ResultSetValue;

public class MultiPartManager {
	private	HttpServletRequest 	request		=	null;
	private	MultipartRequest	mr			=	null;
	private	String				sDir		=	"";
	private	String				sBaseDir	=	"";	//프로퍼티 정의 경로
	private	String				sXpath		=	"";	//	프로퍼티 Xpath
	
	/**
	 * 생성자
	 * @param request
	 * @param sContDiv
	 */
	public MultiPartManager(HttpServletRequest request, String sOtherDir)
	{
		try {
			this.init(request, sOtherDir);
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".MultiPartManager()] :" + e.toString());
		}
	}
	
	/**
	 * 생성자
	 * @param request
	 * @param sXpath
	 * @param sOtherDir
	 */
	public MultiPartManager(HttpServletRequest request, String sXpath, String sOtherDir)
	{
		try {
			this.sXpath	=	sXpath;
			this.init(request, sOtherDir);
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".MultiPartManager()] :" + e.toString());
		}
	}
	
	/**
	 * 초기화
	 * @param request		HttpServletRequest
	 * @param sXpath		파일 경로 xpath
	 * @param sOtherDir		나머지 경로
	 * @throws ConfigurationException 
	 * @throws IOException 
	 */
	public void init(HttpServletRequest request, String sOtherDir) throws ConfigurationException, IOException
	{
		try {
			this.request	=	request;
			this.sDir		=	this.getDir(sOtherDir);
			
			File file = new File(this.sDir);
			if(!file.isDirectory())
			{
				file.mkdirs();
			}
			
			int	iFileSize	=	1024 * 1024 * 300;
			
			this.mr	=	new	MultipartRequest(this.request, this.sDir, iFileSize, request.getCharacterEncoding(), new UploadRenamePolicy()); 
		} catch (IOException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".init()] :" + e.toString());
			throw new IOException("[ERROR "+this.getClass().toString()+".init()] " + e.toString());
		}	
	}
	
	/**
	 * insert 할 데이타
	 * @return
	 */
	public ResultSetValue getData(String sMoveDir)
	{	
		Enumeration		e	=	this.getFileNames();
		ResultSetValue	rsv	=	new	ResultSetValue();
		
		ArrayList		al	=	new	ArrayList();
		HashMap			hm	=	null;
		
		while(e.hasMoreElements())
		{			
			String	sKey	=	e.nextElement().toString();
			
			String	sOrgFileNm	=	"";		//	오리지날 파일명
			String	sReFileUrl	=	"";		//	rename 파일명
			String	sFileSize	=	"";		//	file size
			String	sJobType	=	"";	//	업무구분 I : INSERT
			if(this.mr.getFilesystemName(sKey) != null)
			{
				System.out.println("sKey["+sKey+"]");
				
				String	sSeq	=	"";
				if(sKey.indexOf("_") > 0)
				{
					
					Matcher m = Pattern.compile("[0-9]+").matcher(sKey.substring(sKey.indexOf("_")+1));
					if(m.matches())
					{
						sSeq	=	sKey.substring(sKey.indexOf("_")+1);
					}
				}
				
				hm	=	new	HashMap();
				
				sOrgFileNm	=	this.getOriginalFileName(sKey);			//	실제업로드 파일명
				System.out.println("sOrgFileNm["+sOrgFileNm+"]");
				System.out.println("sMoveDir["+sMoveDir+"]");
				sFileSize	=	this.getFileSize(sOrgFileNm) + "";		//	파일크기
				if(sMoveDir == null || sMoveDir.length() == 0)
				{
					sReFileUrl	=	this.getRenameFileName(sOrgFileNm);				//	변경할 파일명
				}else
				{
					sReFileUrl	=	this.getRenameFileName(sOrgFileNm,sMoveDir);	//	변경할 파일명
				}
				sJobType	=	"I";									//	업무타입(I:INSERT, D:DELETE)
				
				String	sReFileNm	=	sReFileUrl.substring(sReFileUrl.lastIndexOf(File.separator)+1);	//	파일명
				String	sFileExt	=	sReFileNm.substring(sReFileNm.lastIndexOf(".")+1);				//	확장자
				
				int		iLength		=	this.sBaseDir.length();

				String	sFilePath	=	sReFileUrl.substring(iLength);	//	파일경로
				
				sFilePath	=	StrUtil.replace(sFilePath,File.separator,"/");
				
				hm.put("DOCU_NM", 	sOrgFileNm);	//	문서명
				hm.put("FILE_NM", 	sReFileNm);		//	파일명
				hm.put("FILE_PATH",	sFilePath);		//	파일경로
				hm.put("FILE_EXT",	sFileExt);		//	파일확장자
				hm.put("FILE_SIZE",	sFileSize);		//	파일크기
				hm.put("JOB_TYPE", 	sJobType);		//	업무타입(I:INSERT, D:DELETE)
				hm.put("FILE_SEQ", 	sSeq);			//	파일순번
				
				al.add(hm);
			}
		}
		
		e	=	this.getParameterNames();
		while(e.hasMoreElements())
		{
			String	sKey	=	e.nextElement().toString();
			if(sKey.indexOf("del_file_seq") != -1)
			{
				hm	=	new	HashMap();
				hm.put("DOCU_NM", 	"");					//	문서명
				hm.put("FILE_NM", 	"");					//	파일명
				hm.put("FILE_PATH",	"");					//	파일경로
				hm.put("FILE_EXT",	"");					//	파일확장자
				hm.put("FILE_SIZE",	"");					//	파일크기
				hm.put("JOB_TYPE", 	"D");					//	업무타입(I:INSERT, D:DELETE)
				hm.put("FILE_SEQ", 	this.getString(sKey));	//	파일순번
				
				al.add(hm);
			}
			if(sKey.indexOf("del_file_path") != -1)
			{				
				String	sDelUrl	=	this.sBaseDir	+	this.getString(sKey);
				sDelUrl	=	StrUtil.replace(sDelUrl,"\\",File.separator);
				sDelUrl	=	StrUtil.replace(sDelUrl,"/",File.separator);
				
				System.out.println("sDelUrl["+sDelUrl+"]");
				
				this.deleteFile(sDelUrl);
			}
		}
		
		System.out.println("al["+al+"]");
		if(al != null && al.size() != 0)
		{
			rsv.getData(al);
		}
		
		System.out.println("rsv["+rsv+"]");
		return rsv;
	}
	
	/**
	 * insert 할 데이타
	 * @return
	 */
	public ResultSetValue getData()
	{
		return this.getData("");
	}
	
	/**
	 * parameter 값 반환
	 * @param sParam
	 * @return
	 */
	public String getParameter(String sParam)
	{
		return this.mr.getParameter(sParam);
	}
	
	/**
	 * parameter 값 반환(배열) 
	 * @param sParam
	 * @return
	 */
	public String[] getParameterValues(String sParam)
	{
		return this.mr.getParameterValues(sParam);
	}
	
	/**
	 * 값 반환
	 * @param sParam
	 * @return
	 */
	public String getString(String sParam)
	{
		return this.getString(sParam,"");
	}
	
	/**
	 * null 값 대체 반환
	 * @param sParam	키
	 * @param sNullVal	값
	 * @return
	 */
	public String getString(String sParam, String sNullVal)
	{
		String	sRtnVal	=	"";
		if(this.mr.getParameter(sParam) == null || this.mr.getParameter(sParam).length() == 0)
		{
			sRtnVal	=	sNullVal;
		}else
		{
			sRtnVal	=	filter(this.mr.getParameter(sParam));
		}
		return sRtnVal;
	}
	
	/**
	 * null 값 대체 반환
	 * @param sParam	키
	 * @param sNullVal	값
	 * @return
	 */
	public String[]	getArrString(String sParam, String sNullVal)
	{
		String[]	saRtnVal	=	null;
		saRtnVal	=	this.getParameterValues(sParam);
		
		if(saRtnVal == null) return saRtnVal;
		
		for(int i=0; i < saRtnVal.length; i++)
		{
			if(saRtnVal[i] == null || saRtnVal[i].length() == 0)
			{
				saRtnVal[i]	=	filter(sNullVal);
			}
		}
		
		return saRtnVal;
	}
	
	/**
	 * 값 반환
	 * @param sParam	키
	 * @return
	 */
	public int	getInt(String sParam)
	{
		int	iRtnVal	=	0;
		try{
			iRtnVal	=	Integer.parseInt(this.getString(sParam));
		}catch(NumberFormatException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return iRtnVal;
	}
	
	/**
	 * 값 반환
	 * @param sParam	키
	 * @param iNullVal	대처 값
	 * @return
	 */
	public int getInt(String sParam, int iNullVal)
	{
		int	iRtnVal	=	0;
		try{			
			if(this.mr.getParameter(sParam) != null && this.mr.getParameter(sParam).length() > 0)
			{
				iRtnVal	=	Integer.parseInt(this.getString(sParam));
			}else
			{
				iRtnVal	=	iNullVal;			
			}
		}catch(NumberFormatException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return iRtnVal;
	}
	
    private String filter(String input) {
        if(input==null) {
            return null;
        }
        String clean = new HTMLInputFilter().
        	filter(input.replaceAll("\"", "%22").
                    replaceAll("\'","%27"));
        return clean.replaceAll("<", "%3C").replaceAll(">", "%3E");
    }	
	
	/**
	 * Parameter 값 반환
	 * @return
	 */
	public	Enumeration	getParameterNames()
	{		
		return this.mr.getParameterNames();
	}
	
	/**
	 * 파일명 반환
	 * @return
	 */
	public Enumeration getFileNames()
	{
		return this.mr.getFileNames();
	}
	
	/**
	 * 
	 * @param sParam
	 * @return
	 */
	public String getFilesystemName(String sParam)
	{
		return this.mr.getFilesystemName(sParam);
	}
	
	/**
	 * 
	 * @param sParam
	 * @return
	 */
	public String getOriginalFileName(String sParam)
	{
		return this.mr.getOriginalFileName(sParam);
	}
	
	/**
	 * file 객체 반환
	 * @param sParam	키
	 * @return
	 */
	public File	getFile(String sParam)
	{
		return this.mr.getFile(sParam);
	}
	
	/**
	 * 파일 크기 반환
	 * @param sFileNm
	 * @return
	 */
	public long	getFileSize(String	sFileNm)
	{
		String		sFileUrl	=	this.sDir	+	"/"	+	sFileNm;
		
		sFileUrl	=	StrUtil.replace(sFileUrl,"\\",File.separator);
		sFileUrl	=	StrUtil.replace(sFileUrl,"/",File.separator);
		
		File	file	=	new	File(sFileUrl);
		return file.length();
	}
	
	/**
	 * 파일이름변경
	 * @param sFileName	원본 파일명
	 * @return
	 */
	public String getRenameFileName(String sFileName)
	{	
		Calendar 	cal 		= 	Calendar.getInstance();
		String 		sReFile		=	cal.getTimeInMillis()+"";
		String		sExt		=	sFileName.substring(sFileName.lastIndexOf(".")+1);
		String		sReFileNm	=	sReFile	+	"."	+	sExt;
		
		String		sFileUrl	=	this.sDir	+	"/"	+	sFileName;
		
		sFileUrl	=	StrUtil.replace(sFileUrl,"\\",File.separator);
		sFileUrl	=	StrUtil.replace(sFileUrl,"/",File.separator);
		
		String		sReFileUrl	=	this.sDir	+	"/"	+ sReFileNm;
		
		sReFileUrl	=	StrUtil.replace(sReFileUrl,"\\",File.separator);
		sReFileUrl	=	StrUtil.replace(sReFileUrl,"/",File.separator);
		
		File	fileOld	=	new	File(sFileUrl);
		File	fileNew =	new File(sReFileUrl);

		// 변경하려는 파일명이 기존에 존재하는 파일명일 경우에 파일명 마지막에 "0" 붙임
		// 동시에 여러개의 (확장자가 같은) 파일을 첨부하는 경우에 getTimeInMillis()가 일치 할수도 있으므로 중복을 확인해야 한다
		while (fileNew.exists())
		{
			sReFile		=	sReFile + "0";
			sReFileUrl	=	this.sDir + "/" + sReFile + "." + sExt;
			fileNew		=	new File(sReFileUrl);
		}
		
		fileOld.renameTo(fileNew);
		
		return	sReFileUrl;
	}

	/**
	 * 첨부파일의 이름을 현재 시각을 기준으로 변경하여 반환
	 * @param sParam	원본 파일을 획득하기 위한 parameter
	 * @return
	 */
	public String getRenameFileNameWithParam(String sParam)
	{
		Calendar 	cal 		= 	Calendar.getInstance();

		String		sFileName	=	this.getFilesystemName(sParam);
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
		
		sFileUrl	=	this.sDir	+	"/"	+	sFileName;
		sFileUrl	=	StrUtil.replace(sFileUrl,"\\",File.separator);
		sFileUrl	=	StrUtil.replace(sFileUrl,"/",File.separator);
		
		sReFileUrl	=	this.sDir	+	"/"	+ sReFileNm;
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
			sReFileUrl	=	this.sDir + "/" + sReFileNm;
			fileNew		=	new File(sReFileUrl);
		}
		
		fileOld.renameTo(fileNew);
		
		return	sReFileNm;	// ※ 주의 : 전체 경로가 아닌 파일명만 반환
	}

	/**
	 * 파일이름 변경	(경로도 변경)
	 * @param sFileName	원본 파일명
	 * @param sMoveDir	이동 경로
	 * @return
	 * @throws IOException 
	 */
	public String getRenameFileName(String sFileName, String sMoveDir)
	{
		FileInputStream 	fin = null ;
		FileOutputStream 	fos = null ;
		int 				i 	= 0 ;
		int 				len = 0 ;
		
		String				sReFileUrl	=	"";
		String				sFileUrl	=	"";
		try {
			Calendar 	cal 		= 	Calendar.getInstance();
			String 		sReFile		=	cal.getTimeInMillis()+"";
			String		sExt		=	sFileName.substring(sFileName.lastIndexOf(".")+1);
			String		sReFileNm	=	sReFile	+	"."	+	sExt;
			
			sFileUrl	=	this.sDir	+	"/"	+	sFileName;
			sFileUrl	=	StrUtil.replace(sFileUrl,"\\",File.separator);
			sFileUrl	=	StrUtil.replace(sFileUrl,"/",File.separator);
			
			sReFileUrl	=	sMoveDir	+	"/"	+ sReFileNm;
			
			sReFileUrl	=	StrUtil.replace(sReFileUrl,"\\",File.separator);
			sReFileUrl	=	StrUtil.replace(sReFileUrl,"/",File.separator);
			
			File file = new File(sMoveDir);
			if(!file.isDirectory())
			{
				file.mkdirs();
			}
			
			fin = new FileInputStream( new File( sFileUrl ) );
			fos = new FileOutputStream( sReFileUrl ) ;
			
			while( ( i = fin.read()) != -1 ){
				fos.write(i);
				len++;
			}
		} catch (FileNotFoundException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getRenameFileName()] :" + e.toString());
		} catch (IOException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getRenameFileName()] :" + e.toString());
		}finally
		{
			try {
				if(fos != null)	fos.close();
			} catch (IOException e) {
				System.out.println("[ERROR "+this.getClass().getName() + ".getRenameFileName()] :" + e.toString());
			}
			try {
				if(fin != null)	fin.close();
			} catch (IOException e) {
				System.out.println("[ERROR "+this.getClass().getName() + ".getRenameFileName()] :" + e.toString());
			}
			this.deleteFile(sFileUrl);
		}
		return	sReFileUrl;
	}
	
	/**
	 * 파일 경로 가져오기
	 * @param sXpath	프로퍼티 xpath
	 * @param sOtherDir	나머지 경로
	 * @return
	 * @throws ConfigurationException 
	 */
	public String getDir(String sOtherDir)
	{
		String	sDir	=	"";
		try {
			if(this.sXpath	 != null && this.sXpath	.length() > 0)
			{
				CompositeConfiguration conf = Config.getInstance();
				this.sBaseDir	=	conf.getString(this.sXpath);
				this.sBaseDir	=	StrUtil.replace(this.sBaseDir,"\\",File.separator);
				this.sBaseDir	=	StrUtil.replace(this.sBaseDir,"/",File.separator);
				sDir	=	this.sBaseDir;
			}
			sDir	=	sDir	+	sOtherDir;
			
			sDir	=	StrUtil.replace(sDir,"\\",File.separator);
			sDir	=	StrUtil.replace(sDir,"/",File.separator);
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getDir()] :" + e.toString());
		}
		return sDir;
	}
	
	/**
	 * 파일 삭제
	 * @param sFileUrl
	 */
	public void	deleteFile(String sFileUrl)
	{
		File	file	=	new	File(sFileUrl);
		if(file.exists())
		{
			file.delete();
		}
	}
}
