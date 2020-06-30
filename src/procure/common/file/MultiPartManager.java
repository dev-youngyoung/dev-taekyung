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
	private	String				sBaseDir	=	"";	//������Ƽ ���� ���
	private	String				sXpath		=	"";	//	������Ƽ Xpath
	
	/**
	 * ������
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
	 * ������
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
	 * �ʱ�ȭ
	 * @param request		HttpServletRequest
	 * @param sXpath		���� ��� xpath
	 * @param sOtherDir		������ ���
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
	 * insert �� ����Ÿ
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
			
			String	sOrgFileNm	=	"";		//	�������� ���ϸ�
			String	sReFileUrl	=	"";		//	rename ���ϸ�
			String	sFileSize	=	"";		//	file size
			String	sJobType	=	"";	//	�������� I : INSERT
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
				
				sOrgFileNm	=	this.getOriginalFileName(sKey);			//	�������ε� ���ϸ�
				System.out.println("sOrgFileNm["+sOrgFileNm+"]");
				System.out.println("sMoveDir["+sMoveDir+"]");
				sFileSize	=	this.getFileSize(sOrgFileNm) + "";		//	����ũ��
				if(sMoveDir == null || sMoveDir.length() == 0)
				{
					sReFileUrl	=	this.getRenameFileName(sOrgFileNm);				//	������ ���ϸ�
				}else
				{
					sReFileUrl	=	this.getRenameFileName(sOrgFileNm,sMoveDir);	//	������ ���ϸ�
				}
				sJobType	=	"I";									//	����Ÿ��(I:INSERT, D:DELETE)
				
				String	sReFileNm	=	sReFileUrl.substring(sReFileUrl.lastIndexOf(File.separator)+1);	//	���ϸ�
				String	sFileExt	=	sReFileNm.substring(sReFileNm.lastIndexOf(".")+1);				//	Ȯ����
				
				int		iLength		=	this.sBaseDir.length();

				String	sFilePath	=	sReFileUrl.substring(iLength);	//	���ϰ��
				
				sFilePath	=	StrUtil.replace(sFilePath,File.separator,"/");
				
				hm.put("DOCU_NM", 	sOrgFileNm);	//	������
				hm.put("FILE_NM", 	sReFileNm);		//	���ϸ�
				hm.put("FILE_PATH",	sFilePath);		//	���ϰ��
				hm.put("FILE_EXT",	sFileExt);		//	����Ȯ����
				hm.put("FILE_SIZE",	sFileSize);		//	����ũ��
				hm.put("JOB_TYPE", 	sJobType);		//	����Ÿ��(I:INSERT, D:DELETE)
				hm.put("FILE_SEQ", 	sSeq);			//	���ϼ���
				
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
				hm.put("DOCU_NM", 	"");					//	������
				hm.put("FILE_NM", 	"");					//	���ϸ�
				hm.put("FILE_PATH",	"");					//	���ϰ��
				hm.put("FILE_EXT",	"");					//	����Ȯ����
				hm.put("FILE_SIZE",	"");					//	����ũ��
				hm.put("JOB_TYPE", 	"D");					//	����Ÿ��(I:INSERT, D:DELETE)
				hm.put("FILE_SEQ", 	this.getString(sKey));	//	���ϼ���
				
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
	 * insert �� ����Ÿ
	 * @return
	 */
	public ResultSetValue getData()
	{
		return this.getData("");
	}
	
	/**
	 * parameter �� ��ȯ
	 * @param sParam
	 * @return
	 */
	public String getParameter(String sParam)
	{
		return this.mr.getParameter(sParam);
	}
	
	/**
	 * parameter �� ��ȯ(�迭) 
	 * @param sParam
	 * @return
	 */
	public String[] getParameterValues(String sParam)
	{
		return this.mr.getParameterValues(sParam);
	}
	
	/**
	 * �� ��ȯ
	 * @param sParam
	 * @return
	 */
	public String getString(String sParam)
	{
		return this.getString(sParam,"");
	}
	
	/**
	 * null �� ��ü ��ȯ
	 * @param sParam	Ű
	 * @param sNullVal	��
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
	 * null �� ��ü ��ȯ
	 * @param sParam	Ű
	 * @param sNullVal	��
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
	 * �� ��ȯ
	 * @param sParam	Ű
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
	 * �� ��ȯ
	 * @param sParam	Ű
	 * @param iNullVal	��ó ��
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
	 * Parameter �� ��ȯ
	 * @return
	 */
	public	Enumeration	getParameterNames()
	{		
		return this.mr.getParameterNames();
	}
	
	/**
	 * ���ϸ� ��ȯ
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
	 * file ��ü ��ȯ
	 * @param sParam	Ű
	 * @return
	 */
	public File	getFile(String sParam)
	{
		return this.mr.getFile(sParam);
	}
	
	/**
	 * ���� ũ�� ��ȯ
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
	 * �����̸�����
	 * @param sFileName	���� ���ϸ�
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

		// �����Ϸ��� ���ϸ��� ������ �����ϴ� ���ϸ��� ��쿡 ���ϸ� �������� "0" ����
		// ���ÿ� �������� (Ȯ���ڰ� ����) ������ ÷���ϴ� ��쿡 getTimeInMillis()�� ��ġ �Ҽ��� �����Ƿ� �ߺ��� Ȯ���ؾ� �Ѵ�
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
	 * ÷�������� �̸��� ���� �ð��� �������� �����Ͽ� ��ȯ
	 * @param sParam	���� ������ ȹ���ϱ� ���� parameter
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

		// �����Ϸ��� ���ϸ��� ������ �����ϴ� ���ϸ��� ��쿡 ���ϸ� �������� "0" ����
		// ���ÿ� �������� (Ȯ���ڰ� ����) ������ ÷���ϴ� ��쿡 getTimeInMillis()�� ��ġ �Ҽ��� �����Ƿ� �ߺ��� Ȯ���ؾ� �Ѵ�
		while (fileNew.exists())
		{
			sReFile		=	sReFile + "0";
			sReFileNm	=	sReFile + "." + sExt;
			sReFileUrl	=	this.sDir + "/" + sReFileNm;
			fileNew		=	new File(sReFileUrl);
		}
		
		fileOld.renameTo(fileNew);
		
		return	sReFileNm;	// �� ���� : ��ü ��ΰ� �ƴ� ���ϸ� ��ȯ
	}

	/**
	 * �����̸� ����	(��ε� ����)
	 * @param sFileName	���� ���ϸ�
	 * @param sMoveDir	�̵� ���
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
	 * ���� ��� ��������
	 * @param sXpath	������Ƽ xpath
	 * @param sOtherDir	������ ���
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
	 * ���� ����
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
