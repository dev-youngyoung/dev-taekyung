package dao;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.apache.commons.configuration.ConfigurationException;

import crosscert.Hash;
import nicelib.db.DataSet;
import nicelib.util.Util;
import procure.common.conf.Startup;
import procure.common.utils.StrUtil;

public class AptDao {
	
	
	/**
	 * info (member_no, cont_no,cont_chasu, html  )
	 * @param info
	 * @return
	 */
	public DataSet makeCommPdf(DataSet info){
		DataSet pdf = null;
		
		String fontSize = "10px";
		if(!info.getString("font_size").equals("")){
			fontSize = info.getString("font_size");
		}
		nicednb.bct.BCTPDFMaker pdfMaker = new nicednb.bct.BCTPDFMaker();
		
		String footer = info.getString("footer");
		String fileName = info.getString("fileName");
		String fileDir = info.getString("fileDir");
		
		if("".equals(footer)){
			footer = "*본 문서는 상기 업체간에 전자서명법  등 관련법령에 근거하여 전자서명으로 체결한 전자문서입니다.<br>&nbsp;&nbsp;본 문서는 나이스아파트(https://www.niceaptbid.com:444)를 통해 생성 되었습니다.";
		}
		pdfMaker.setFooter(footer);
		
		
		if("".equals(fileName)){
			fileName = Util.getTimeString("yyyyMMddHHmmsss");
		}
		if("".equals(fileDir)){
			fileDir = Util.getTimeString("yyyy")+"/";
		}
		fileName += ".pdf";
		
		String pdfDir = Startup.conf.getString(info.getString("pdfDir"));
		String path = pdfDir + fileDir+fileName;
		
		int i = 0 ; 
		while(new File(path).exists()){
			fileName = Util.getTimeString("yyyyMMddHHmmsss")+"_"+i+".pdf";
			path = pdfDir+fileDir+fileName;
			i++;
		}
		
		System.out.println(" PdfDao 파일 경로2 ==> :"+path);
		
		StringBuffer documentContentsBefore = new StringBuffer();
		
		documentContentsBefore.append("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><style type=\"text/css\">");
		documentContentsBefore.append(info.getString("css"));
		documentContentsBefore.append("</style>");
		documentContentsBefore.append("</head><body>");
		
		pdfMaker.setHtmlWidth(750);
		boolean result = pdfMaker.generatePDFF(documentContentsBefore.toString()+info.getString("html")+"</body></html>", pdfDir+fileDir, fileName);
		if(!result){
			return null;
		}
		
		pdf = new DataSet();
		pdf.addRow();
		pdf.put("file_path", fileDir);
		pdf.put("file_name", fileName);
		pdf.put("file_size", new File(path).length());
		pdf.put("file_ext", "pdf");
		pdf.put("file_hash", getHash(info.getString("pdfDir"),  fileDir+fileName));
		return pdf;
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
			Hash	hash		=	new	Hash();
			
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
}
