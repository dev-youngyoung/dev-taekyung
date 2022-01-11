package dao;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import nicelib.db.DataObject;
import nicelib.db.DataSet;
import nicelib.pdf.PDFMaker;
import nicelib.util.Util;
import procure.common.conf.Startup;
import procure.common.utils.StrUtil;
import crosscert.Hash;

public class ContractDao extends DataObject {

	
	public ContractDao() {
		this.table = "tcb_contmaster";
	}

	public ContractDao(String sTable) {
		this.table = sTable;
	}
	
	public String makeContNo(String type) {
		DataSet ds = this.query("select f_tec_maxcontnumb('"+ type +"') cont_no from dual");
		String cont_no = "";
		if (ds.next()) cont_no = ds.getString("cont_no");
		return cont_no;
	}
	
	public String makeContNo() {
		DataSet ds = this.query("select f_tec_maxcontnumb('P') cont_no from dual");
		String cont_no = "";
		if (ds.next()) cont_no = ds.getString("cont_no");
		return cont_no;
	}
	
	public String makeContNoK() {
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
		documentContentsBefore.append("<meta charset=\"UTF-8\">");
		documentContentsBefore.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
		documentContentsBefore.append("<style type=\"text/css\">");
		documentContentsBefore.append("<!--");
		documentContentsBefore.append("		td {  font-family: \"나눔고딕\",\"Arial\"; font-size: "+fontSize+"; font-style: normal; letter-spacing:0; color: black;line-height:150%}");
		documentContentsBefore.append("		.lineTable { border-collapse:collapse; border:1 solid black }");
		documentContentsBefore.append("		.lineTable td { border:1px solid black }");
		documentContentsBefore.append("		.lineTable .noborder { border:0px }");	
		documentContentsBefore.append("-->");
		documentContentsBefore.append("</style>");
		documentContentsBefore.append("</head><body>");
		
		pdfMaker.setContNo(info.getString("cont_no"), info.getString("cont_chasu"), info.getString("random_no"));
		pdfMaker.setUserNo(info.getString("cont_userno"));
		pdfMaker.setHtmlWidth(750);
		if(info.getString("doc_type").equals("2"))  // 1 or null:전자계약,  2: 전자문서
//			pdfMaker.setFooter("*본 문서는 상기업체 간에 전자서명법 등 관련법령에 근거하여 공인인증서로 전자서명한 전자문서입니다.<br>&nbsp;&nbsp;전자문서 진위여부는 나이스다큐(http://www.nicedocu.com,일반기업용)에서 확인하실 수 있습니다.");
			pdfMaker.setFooter("*본 문서는 상기업체 간에 전자서명법 등 관련법령에 근거하여 공인인증서로 전자서명한 전자문서입니다.");
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
		documentContentsBefore.append("		td {  font-family: \"나눔고딕\",\"Arial\"; font-size: "+fontSize+"; font-style: normal; letter-spacing:0px; color: black;line-height:150%}");
		documentContentsBefore.append("		.lineTable { border-collapse:collapse; border:1px solid black }");
		documentContentsBefore.append("		.lineTable td { border:1px solid black }");
		documentContentsBefore.append("		.lineTable .noborder { border:0px }");	
		documentContentsBefore.append("-->");
		documentContentsBefore.append("</style>");
		documentContentsBefore.append("</head><body>");
		
		pdfMaker.setContNo(info.getString("cont_no"), info.getString("cont_chasu"), info.getString("random_no"));
		pdfMaker.setUserNo(info.getString("cont_userno"));
		pdfMaker.setHtmlWidth(750);
		
		  
//		pdfMaker.setFooter("*본 계약서는 상기업체 간에 전자서명법  등 관련법령에 근거하여 전자서명으로 체결한 전자계약서입니다.<br>&nbsp;&nbsp;전자계약 진위여부는 건설 나이스다큐(http://www.nicedocu.com)에서 확인하실 수 있습니다. (관리번호:"+pdfMaker.getContNo()+")");
		pdfMaker.setFooter("*본 계약서는 상기업체 간에 전자서명법  등 관련법령에 근거하여 전자서명으로 체결한 전자계약서입니다. (관리번호:"+pdfMaker.getContNo()+")");
		
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
	 * Hash 정보 가져오기
	 * @param sXpath 경로
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