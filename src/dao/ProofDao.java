package dao;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import nicelib.db.DataObject;
import nicelib.db.DataSet;
import nicelib.pdf.PDFMaker;
import procure.common.conf.Startup;
import procure.common.utils.StrUtil;
import crosscert.Hash;

public class ProofDao extends DataObject {


	public ProofDao() {
		this.table = "tck_proof";
	}

	public ProofDao(String sTable) {
		this.table = sTable;
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

		String proof_no = info.getString("proof_no");

		String yyyy = proof_no.split("-")[0];

		PDFMaker pdfMaker = new PDFMaker();
		String pdfDir = Startup.conf.getString("file.path.supplier.proof");
		String fileDir = info.getString("member_no")+"/"+yyyy+"/"+info.getString("proof_no")+"/";
		String fileName = info.getString("proof_no")+"_"+info.getString("file_seq")+".pdf";
		String path = pdfDir + fileDir+fileName;

		StringBuffer documentContentsBefore = new StringBuffer();
		documentContentsBefore.append("<!DOCTYPE html>");
		documentContentsBefore.append("<html lang=\"ko\">");
		documentContentsBefore.append("<head>");
		documentContentsBefore.append("<style>");
		documentContentsBefore.append("<!--");
		documentContentsBefore.append("		td {  font-family: \"ëëęł ë\",\"Arial\"; font-size: "+fontSize+"; font-style: normal; letter-spacing:0px; color: black;line-height:150%}");
		documentContentsBefore.append("		.lineTable { border-collapse:collapse; border:1px solid black }");
		documentContentsBefore.append("		.lineTable td { border:1px solid black }");
		documentContentsBefore.append("		.lineTable .noborder { border:0px }");	
		documentContentsBefore.append("-->");
		documentContentsBefore.append("</style>");
		documentContentsBefore.append("</head><body>");
		
		pdfMaker.setHeader("<table border=0 width=100%><tr><td align=\"right\" valign=\"top\" ><font size=1 color=\"#5B5B5B\">* ë°ę¸ë˛í¸: "+info.getString("proof_no")+"</font></td></tr></table>");
		pdfMaker.setHtmlWidth(750);
		
		  
		//pdfMaker.setFooter("*ëł¸ ëŹ¸ěë ěę¸°ěě˛´ ę°ě ě ěěëŞë˛  ëą ę´ë ¨ë˛ë šě ęˇźęą°íěŹ ě ěěëŞěźëĄ ěëŁë ě ěëŹ¸ěěëë¤.<br>&nbsp;&nbsp;ě ěëŹ¸ě ě§ěěŹëśë ëě´ě¤ë¤í(ęą´ě¤ę¸°ěěŠ)(http://www.nicedocu.com)ěě íě¸íě¤ ě ěěľëë¤.");
		pdfMaker.setFooter("*ëł¸ ëŹ¸ěë ěę¸°ěě˛´ ę°ě ě ěěëŞë˛  ëą ę´ë ¨ë˛ë šě ęˇźęą°íěŹ ě ěěëŞěźëĄ ěëŁë ě ěëŹ¸ěěëë¤.");
		
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
		pdf.put("file_hash", getHash("file.path.supplier.proof",  fileDir+fileName));
		return pdf;
	}

	/**
	 * info (member_no, cont_no,cont_chasu, html  )
	 * @param info
	 * @return
	 */
	public DataSet makePdfB(DataSet info){
		DataSet pdf = null;

		String fontSize = "12px";
		if(!info.getString("font_size").equals("")){
			fontSize = info.getString("font_size");
		}

		String proof_no = info.getString("proof_no");

		String yyyy = proof_no.split("-")[0];

		PDFMaker pdfMaker = new PDFMaker();
		String pdfDir = Startup.conf.getString("file.path.bcont_proof");
		String fileDir = info.getString("member_no")+"/"+yyyy+"/"+info.getString("proof_no")+"/";
		String fileName = info.getString("proof_no")+"_"+info.getString("file_seq")+".pdf";
		String path = pdfDir + fileDir+fileName;

		StringBuffer documentContentsBefore = new StringBuffer();
		documentContentsBefore.append("<!DOCTYPE html>");
		documentContentsBefore.append("<html lang=\"ko\">");
		documentContentsBefore.append("<head>");
		documentContentsBefore.append("<style>");
		documentContentsBefore.append("<!--");
		documentContentsBefore.append("		td {  font-family: \"ëëęł ë\",\"Arial\"; font-size: "+fontSize+"; font-style: normal; letter-spacing:0px; color: black;line-height:150%}");
		documentContentsBefore.append("		.lineTable { border-collapse:collapse; border:1px solid black }");
		documentContentsBefore.append("		.lineTable td { border:1px solid black }");
		documentContentsBefore.append("		.lineTable .noborder { border:0px }");
		documentContentsBefore.append("-->");
		documentContentsBefore.append("</style>");
		documentContentsBefore.append("</head><body>");

		pdfMaker.setHeader("<table border=0 width=100%><tr><td align=\"right\" valign=\"top\" ><font size=1 color=\"#5B5B5B\">* ë°ę¸ë˛í¸: "+info.getString("proof_no")+"</font></td></tr></table>");
		pdfMaker.setHtmlWidth(750);


//		pdfMaker.setFooter("*ëł¸ ëŹ¸ěë ěę¸°ěě˛´ ę°ě ě ěěëŞë˛  ëą ę´ë ¨ë˛ë šě ęˇźęą°íěŹ ě ěěëŞěźëĄ ěëŁë ě ěëŹ¸ěěëë¤.<br>&nbsp;&nbsp;ě ěëŹ¸ě ě§ěěŹëśë ëě´ě¤ë¤í(ěźë°ę¸°ěěŠ)(http://www.nicedocu.com)ěě íě¸íě¤ ě ěěľëë¤.");
		pdfMaker.setFooter("*ëł¸ ëŹ¸ěë ěę¸°ěě˛´ ę°ě ě ěěëŞë˛  ëą ę´ë ¨ë˛ë šě ęˇźęą°íěŹ ě ěěëŞěźëĄ ěëŁë ě ěëŹ¸ěěëë¤.");

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
		pdf.put("file_hash", getHash("file.path.bcont_proof",  fileDir+fileName));
		return pdf;
	}

	/**
	 * ě¤ě ěŚëŞ HASHě ëł´ ę°ě ¸ě¤ę¸°
	 * @param sXpath
	 * @param sOtherFullDir
	 * @return
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