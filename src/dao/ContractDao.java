package dao;

import crosscert.Hash;
import nicelib.db.DataObject;
import nicelib.db.DataSet;
import nicelib.pdf.PDFMaker;
import nicelib.util.Util;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import procure.common.conf.Startup;
import procure.common.utils.StrUtil;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

public class ContractDao extends DataObject {

	
	public ContractDao() {
		this.table = "tcb_contmaster";
	}

	public ContractDao(String sTable) {
		this.table = sTable;
	}	
	
	public String makeContNo (){
		String query = "";
		/* 20180320 �� 9999�� �Ѿ���.
		query += "SELECT 'N'|| (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')) + 233300) || LPAD( (NVL(MAX(SUBSTR(cont_no, 8)), 0) + 1), 4, '0' ) cont_no ";
		query += "  FROM tcb_contmaster ";
		query += " WHERE SUBSTR(cont_no, 2, 6) = (TO_CHAR(SYSDATE, 'YYYYMM') + 233300) ";
		*/

		/* ��뷮 ������ �ߺ������� seq�� ����
		query += "SELECT 'N'|| (TO_NUMBER(TO_CHAR(SYSDATE, 'YYMM')) + 3300) || LPAD( (NVL(MAX(TO_NUMBER(SUBSTR(cont_no, 6))), 0) + 1), 6, '0' ) cont_no";
		query += "  FROM tcb_contmaster ";
		query += " WHERE SUBSTR(cont_no, 2, 4) = (TO_CHAR(SYSDATE, 'YYMM') + 3300) ";

		String cont_no = this.getOne(query);
		*/
		query += "SELECT 'N'|| (TO_NUMBER(TO_CHAR(SYSDATE, 'YYMM')) + 3300) || LPAD( TCB_CONT_NO_SEQ.nextval, 6, '0' ) cont_no";
		query += "  FROM dual ";

		DataSet ds = this.query(query);

		String cont_no = "";
		if(ds.next()) {
			cont_no = ds.getString("cont_no");
		}

		return cont_no;
	}
	
	public String makeContNoK (){
		String query = "";
		query +="SELECT ( to_number(TO_CHAR(SYSDATE, 'YYYY')) + 2333) || LPAD( (to_number(NVL(MAX(SUBSTR(cont_no, 5)), 0)) + 1), 8, '0' ) cont_no"; 
        query +="  FROM tck_contmaster                                                                                                           ";
        query +=" WHERE SUBSTR(cont_no, 1, 4) = (to_number(TO_CHAR(SYSDATE, 'YYYY')) + 2333)                                                     ";
		String cont_no = this.getOne(query);
		return cont_no;
	}
	
	public String makeContNoL (){
		String query = "";
		query += "SELECT 'L'|| (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')) + 233300) || LPAD( (NVL(MAX(SUBSTR(cont_no, 8)), 0) + 1), 4, '0' ) cont_no ";
		query += "  FROM tcl_contmaster ";
		query += " WHERE SUBSTR(cont_no, 2, 6) = (TO_CHAR(SYSDATE, 'YYYYMM') + 233300) ";
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
		PDFMaker pdfMaker = new PDFMaker(); 
		String pdfDir = procure.common.conf.Startup.conf.getString("file.path.bcont_pdf");
		String fileDir = Util.getTimeString("yyyy")+"/"+info.getString("member_no")+"/"+info.getString("cont_no")+"/";
		String fileName = info.getString("cont_no")+"_"+info.getString("cont_chasu")+"_"+info.getString("file_seq")+".pdf";
		String path = pdfDir + fileDir+fileName;
		/*
		int i = 0 ; 
		while(new File(path).exists()){
			fileName = info.getString("cont_no")+"_"+info.getString("cont_chasu")+"_"+i+".pdf";
			path = pdfDir + fileDir+fileName;
			i++;
		}
		*/
		
		StringBuffer documentContentsBefore = new StringBuffer();
		//documentContentsBefore.append("<html><head>");
		documentContentsBefore.append("<!DOCTYPE html>");
		documentContentsBefore.append("<html lang=\"ko\">");
		documentContentsBefore.append("<head>");
		documentContentsBefore.append("<meta charset=\"EUC-KR\">");
		documentContentsBefore.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=EUC-KR\">");
		documentContentsBefore.append("<style type=\"text/css\">");
		documentContentsBefore.append("<!--");
		documentContentsBefore.append("		td {  font-family: \"�������\",\"Arial\"; font-size: "+fontSize+"; font-style: normal; letter-spacing:0; color: black;line-height:150%}");
		documentContentsBefore.append("		.lineTable { border-collapse:collapse; border:1 solid black }");
		documentContentsBefore.append("		.lineTable td { border:1px solid black }");
		documentContentsBefore.append("		.lineTable .noborder { border:0px }");	
		documentContentsBefore.append("-->");
		documentContentsBefore.append("</style>");
		documentContentsBefore.append("</head><body>");
		
		pdfMaker.setContNo(info.getString("cont_no"), info.getString("cont_chasu"), info.getString("random_no"));
		pdfMaker.setUserNo(info.getString("cont_userno"));
		pdfMaker.setHtmlWidth(750);
		if(info.getString("doc_type").equals("2"))  // 1 or null:���ڰ��,  2: ���ڹ���  
			pdfMaker.setFooter("*�� ������ ����ü ���� ���ڼ���� �� ���ù��ɿ� �ٰ��Ͽ� ������������ ���ڼ����� ���ڹ����Դϴ�.<br>&nbsp;&nbsp;���ڹ��� �������δ� ���̽���ť(http://www.nicedocu.com,�Ϲݱ����)���� Ȯ���Ͻ� �� �ֽ��ϴ�.");
		boolean result = pdfMaker.generatePDF(documentContentsBefore.toString()+info.getString("html")+"</body></html>", pdfDir+fileDir, fileName);
		if(!result){
			return null;
		}
		
		pdf = new DataSet();
		pdf.addRow();
		pdf.put("file_path", fileDir);
		pdf.put("file_name", fileName);
		pdf.put("file_size", new File(path).length());
		pdf.put("file_ext", "pdf");
		pdf.put("file_hash", getHash("file.path.bcont_pdf",  fileDir+fileName));
		return pdf;
	}
	
	
	/**
	 * info (member_no, cont_no,cont_chasu, html  )
	 * @param info
	 * @return
	 */
	public DataSet makePdfK(DataSet info){
		DataSet pdf = null;
		
		String fontSize = "12px";
		if(!info.getString("font_size").equals("")){
			fontSize = info.getString("font_size");
		}
		PDFMaker pdfMaker = new PDFMaker(); 
		String pdfDir = procure.common.conf.Startup.conf.getString("file.path.supplier.contract");
		String fileDir = info.getString("member_no")+"/"+info.getString("cont_no").substring(0,4)+"/"+info.getString("cont_no")+"/";
		String fileName = info.getString("cont_no")+"_"+info.getString("cont_chasu")+"_"+info.getString("file_seq")+".pdf";
		String path = pdfDir + fileDir+fileName;
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
		
		  
		pdfMaker.setFooter("*�� ��༭�� ����ü ���� ���ڼ����  �� ���ù��ɿ� �ٰ��Ͽ� ���ڼ������� ü���� ���ڰ�༭�Դϴ�.<br>&nbsp;&nbsp;���ڰ�� �������δ� �Ǽ� ���̽���ť(http://www.nicedocu.com)���� Ȯ���Ͻ� �� �ֽ��ϴ�. (������ȣ:"+pdfMaker.getContNo()+")");
		
		String html = documentContentsBefore.toString()+info.getString("html")+"</body></html>";
		boolean result = pdfMaker.generatePDF(html, pdfDir+fileDir, fileName);
		if(!result){
			return null;
		}
		
		pdf = new DataSet();
		pdf.addRow();
		pdf.put("file_path", fileDir);
		pdf.put("file_name", fileName);
		pdf.put("file_size", new File(path).length());
		pdf.put("file_ext", "pdf");
		pdf.put("file_hash", getHash("file.path.supplier.contract",  fileDir+fileName));
		return pdf;
	}





	
	/**
	 * Hash ���� ��������
	 * @param sXpath		���
	 * @param sOtherFullDir
	 * @return
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

	/**
	 *
	 * @param byteFileData
	 * @return
	 */
	public String	getHash(byte[] byteFileData)
	{
		String 			sHash	=	"";
		Hash	hash		=	new	Hash();
		try {
			int iRet	=	hash.GetHash(byteFileData, byteFileData.length);
			if(iRet	==	0)
			{
				sHash	=	new	String(hash.contentbuf);
			}else
			{
				sHash	=	"";
			}
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getHash()] :" + e.toString());
			//throw new IOException("[ERROR "+this.getClass().getName()+".getHash()] " + e.toString());
		} finally {

		}
		return	sHash;
	}

}