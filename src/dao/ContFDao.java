package dao;

import nicelib.util.*;
import nicelib.db.*;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

import org.apache.commons.configuration.ConfigurationException;

import procure.common.conf.Startup;
import procure.common.utils.StrUtil;
import crosscert.*;

public class ContFDao extends DataObject {

	
	public ContFDao() {
		this.table = "tcf_contmaster";
	}

	public ContFDao(String sTable) {
		this.table = sTable;
	}	
	
	
	public static void main(String args[]){
		
		try{
		File f = new File("C:/Users/Administrator/Desktop/���/�ű԰�༭��/", "��� ���Ͱ�༭.html");
		FileReader reader = new FileReader(f);
		BufferedReader buffer = new BufferedReader(reader);
		
		String html = "";
		String str = buffer.readLine();
		
		while(str!=null) {
			html += str;
			str =  buffer.readLine();
		}
		buffer.close();
		
		DataSet pdf = null;
		
		String fontSize = "12px";
	
		nicednb.bct.BCTPDFMaker pdfMaker = new nicednb.bct.BCTPDFMaker();
		String footer = "";
		
		footer="*�� ��༭�� ��� ��ü���� ���ڼ����  �� ���ù��ɿ� �ٰ��Ͽ� ���ڼ������� ü���� ���ڰ�༭�Դϴ�.<br>&nbsp;&nbsp;���ڰ�� �������δ� ���������� ���̽���ť(http://nfc.nicedocu.com)���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.";
		pdfMaker.setFooter(footer+"(������ȣ:00000000-0-00000)");
		String path = "c:/test.pdf";
		/*
		int i = 0 ; 
		while(new File(path).exists()){
			fileName = info.getString("cont_no")+"_"+info.getString("cont_chasu")+"_"+i+".pdf";
			path = pdfDir + fileDir+fileName;
			i++;
		}
		*/
		
		StringBuffer documentContentsBefore = new StringBuffer();
		//documentContentsBefore.append("<html><body>");

		documentContentsBefore.append("<html><head><style type=\"text/css\">");
		documentContentsBefore.append("<!--");
		documentContentsBefore.append("		td {  font-family: \"�������\",\"Arial\"; font-size: "+fontSize+"; font-style: normal; letter-spacing:0; color: black;line-height:150%}");
		documentContentsBefore.append("		.lineTable { border-collapse:collapse; border:1 solid black }");
		documentContentsBefore.append("		.lineTable td { border:1 solid black }");
		documentContentsBefore.append("		.lineTable .noborder { border:0 }");	
		documentContentsBefore.append("-->");
		documentContentsBefore.append("</style>");
		documentContentsBefore.append("</head><body>");
		
		pdfMaker.setContNo("00000000", "0", "00000");
		pdfMaker.setUserNo("test-��-123456");
		pdfMaker.setHtmlWidth(750);
		boolean result = pdfMaker.generatePDF(documentContentsBefore.toString()+html+"</body></html>", "c:/", "test.pdf");
		} catch( Exception e){}
	}
	
	
	public String makeContNo (){
		String query = "";
		query += "SELECT 'F'|| (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')) + 233300) || LPAD( (NVL(MAX(SUBSTR(cont_no, 8)), 0) + 1), 4, '0' ) cont_no ";
		query += "  FROM tcf_contmaster ";
		query += " WHERE cont_type = '10' and cont_no like 'F%' and  SUBSTR(cont_no, 2, 6) = (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')) + 233300) ";
		String cont_no = this.getOne(query);
		return cont_no;
	}
	
	public String makeGContNo (){
		String query = "";
		query += "SELECT 'G'|| (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')) + 233300)::INT || LPAD( (NVL(MAX(SUBSTR(cont_no, 8)), 0) + 1), 4, '0' ) cont_no ";
		query += "  FROM tcf_contmaster ";
		query += " WHERE cont_type = '20' and cont_no like 'G%' and SUBSTR(cont_no, 2, 6) = (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')) + 233300) ";
		String cont_no = this.getOne(query);
		return cont_no;
	}

	
	/**
	 * info (member_no, cont_no,cont_chasu, html  )
	 * @param info
	 * @return
	 */
	public DataSet makePdf(DataSet info){
		DataSet pdf = null;
		
		String fontSize = "12px";
		if(!info.getString("font_size").equals("")){
			fontSize = info.getString("font_size");
		}
		nicednb.bct.BCTPDFMaker pdfMaker = new nicednb.bct.BCTPDFMaker();
		String footer = "";
		if(Util.inArray(info.getString("cont_gubun"), new String[]{"10","20","30","40"}) ){
			footer="*�� ������ ��� ��ü���� ���ڼ����  �� ���ù��ɿ� �ٰ��Ͽ� ���ڼ������� ü���� ���ڹ����Դϴ�.<br>&nbsp;&nbsp;�� ������ ���������� ���̽���ť(http://nfc.nicedocu.com)�� ���� ���� �Ǿ����ϴ�.";
		}else if(Util.inArray(info.getString("cont_gubun"), new String[]{"50","70","90"})){
			footer="*�� ��༭�� ��� ��ü���� ���ڼ����  �� ���ù��ɿ� �ٰ��Ͽ� ���ڼ������� ü���� ���ڰ�༭�Դϴ�.<br>&nbsp;&nbsp;�� ��༭�� ���������� ���̽���ť(http://nfc.nicedocu.com)�� ���� ���� �Ǿ����ϴ�.";
		}
		pdfMaker.setFooter(footer+"(������ȣ:"+info.getString("cont_no")+"-"+info.getString("cont_chasu")+"-"+info.getString("random_no")+")");
		String pdfDir = procure.common.conf.Startup.conf.getString("file.path.fc.contract");
		String fileDir = Util.getTimeString("yyyy")+"/"+info.getString("member_no")+"/"+info.getString("cont_no")+"/";
		String fileName = info.getString("cont_no")+"_"+info.getString("cont_chasu")+"_"+info.getString("file_seq")+".pdf";
		String path = pdfDir + fileDir+fileName;
		String html = info.getString("html");
		//pd4ml�� ssl������
		html = html.replaceAll("https://", "http://");//���������� �̹������� connection time out case �߻� ���Ͽ��� ���� ��η� ����
		
		String[] img_urls = Startup.conf.getString("pd4ml_replace.img_url").split(",");
		String img_paht = Startup.conf.getString("pd4ml_replace.img_path");
		for(int i = 0 ; i< img_urls.length; i ++){
			html = html.replaceAll(img_urls[i], img_paht);
		}
		
		
		/*
		int i = 0 ; 
		while(new File(path).exists()){
			fileName = info.getString("cont_no")+"_"+info.getString("cont_chasu")+"_"+i+".pdf";
			path = pdfDir + fileDir+fileName;
			i++;
		}
		*/
		
		StringBuffer documentContentsBefore = new StringBuffer();

		documentContentsBefore.append("<!DOCTYPE html>");
		documentContentsBefore.append("<html lang=\"ko\">");
		documentContentsBefore.append("<head>");
		documentContentsBefore.append("<style>");
		documentContentsBefore.append("<!--");
		documentContentsBefore.append("		td {  font-family: \"�������\",\"Arial\"; font-size: "+fontSize+"; font-style: normal; letter-spacing:0px; color: black;line-height:150%}");
		documentContentsBefore.append("		.lineTable { border-collapse:collapse; border:1px solid black }");
		documentContentsBefore.append("		.lineTable td { border:1px solid black }");
		documentContentsBefore.append("		.lineTable .noborder { border:0px }");	
		documentContentsBefore.append("-->");
		documentContentsBefore.append("</style>");
		documentContentsBefore.append("</head><body>");
		
		pdfMaker.setContNo(info.getString("cont_no"), info.getString("cont_chasu"), info.getString("random_no"));
		pdfMaker.setUserNo(info.getString("cont_userno"));
		pdfMaker.setHtmlWidth(750);
		boolean result = pdfMaker.generatePDFF(documentContentsBefore.toString()+html+"</body></html>", pdfDir+fileDir, fileName);
		if(!result){
			return null;
		}
		
		pdf = new DataSet();
		pdf.addRow();
		pdf.put("file_path", fileDir);
		pdf.put("file_name", fileName);
		pdf.put("file_size", new File(path).length());
		pdf.put("file_ext", "pdf");
		pdf.put("file_hash", getHash("file.path.fc.contract",  fileDir+fileName));
		return pdf;
	}
	
	/**
	 * info (member_no, cont_no,cont_chasu, html  )
	 * @param info
	 * @return
	 */
	public DataSet makePersonInfoPdf(DataSet info){
		DataSet pdf = null;
		
		String fontSize = "12px";
		if(!info.getString("font_size").equals("")){
			fontSize = info.getString("font_size");
		}
		nicednb.bct.BCTPDFMaker pdfMaker = new nicednb.bct.BCTPDFMaker();
		String footer = "*�� ������ ��� ��ü���� ���ڼ����  �� ���ù��ɿ� �ٰ��Ͽ� ���ڼ������� ü���� ���ڹ����Դϴ�.<br>&nbsp;&nbsp;�� ������ ���������� ���̽���ť(http://nfc.nicedocu.com)�� ���� ���� �Ǿ����ϴ�.";

		pdfMaker.setFooter(footer);
		
		String pdfDir = Startup.conf.getString("file.path.fc.person_consent");
		String fileDir = Util.getTimeString("yyyy")+"/"+Util.getTimeString("MM")+"/";
		String fileName = Util.getTimeString("yyyyMMddHHmmsss")+".pdf";
		String path = pdfDir + fileDir+fileName;
		
		int i = 0 ; 
		while(new File(path).exists()){
			fileName = Util.getTimeString("yyyyMMddHHmmsss")+"_"+i+".pdf";
			path = pdfDir + fileDir+fileName;
			i++;
		}
		
		
		StringBuffer documentContentsBefore = new StringBuffer();
		//documentContentsBefore.append("<html><body>");

		documentContentsBefore.append("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><style type=\"text/css\">");
		documentContentsBefore.append("<!--");
		documentContentsBefore.append("		td {  font-family:\"nanum gothic\",\"�������\",\"Arial\"; font-size: "+fontSize+"; font-style: normal; letter-spacing:0; color: black;line-height:150%;}");
		documentContentsBefore.append("		.lineTable { border-collapse:collapse;}");
		documentContentsBefore.append("		.lineTable td { border:1 solid black }");
		documentContentsBefore.append("		.lineTable .noborder { border:0 }");	
		documentContentsBefore.append("-->");
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
		pdf.put("file_hash", getHash("file.path.fc.person_consent",  fileDir+fileName));
		return pdf;
	}
	
	/**
	 * Hash ���� ��������
	 * @param sXpath		���
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