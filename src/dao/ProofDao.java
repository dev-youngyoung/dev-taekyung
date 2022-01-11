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
		documentContentsBefore.append("		td {  font-family: \"나눔고딕\",\"Arial\"; font-size: "+fontSize+"; font-style: normal; letter-spacing:0px; color: black;line-height:150%}");
		documentContentsBefore.append("		.lineTable { border-collapse:collapse; border:1px solid black }");
		documentContentsBefore.append("		.lineTable td { border:1px solid black }");
		documentContentsBefore.append("		.lineTable .noborder { border:0px }");	
		documentContentsBefore.append("-->");
		documentContentsBefore.append("</style>");
		documentContentsBefore.append("</head><body>");
		
		pdfMaker.setHeader("<table border=0 width=100%><tr><td align=\"right\" valign=\"top\" ><font size=1 color=\"#5B5B5B\">* 발급번호: "+info.getString("proof_no")+"</font></td></tr></table>");
		pdfMaker.setHtmlWidth(750);
		
		  
		//pdfMaker.setFooter("*본 문서는 상기업체 간에 전자서명법  등 관련법령에 근거하여 전자서명으로 완료된 전자문서입니다.<br>&nbsp;&nbsp;전자문서 진위여부는 나이스다큐(건설기업용)(http://www.nicedocu.com)에서 확인하실 수 있습니다.");
		pdfMaker.setFooter("*본 문서는 상기업체 간에 전자서명법  등 관련법령에 근거하여 전자서명으로 완료된 전자문서입니다.");
		
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
		documentContentsBefore.append("		td {  font-family: \"나눔고딕\",\"Arial\"; font-size: "+fontSize+"; font-style: normal; letter-spacing:0px; color: black;line-height:150%}");
		documentContentsBefore.append("		.lineTable { border-collapse:collapse; border:1px solid black }");
		documentContentsBefore.append("		.lineTable td { border:1px solid black }");
		documentContentsBefore.append("		.lineTable .noborder { border:0px }");
		documentContentsBefore.append("-->");
		documentContentsBefore.append("</style>");
		documentContentsBefore.append("</head><body>");

		pdfMaker.setHeader("<table border=0 width=100%><tr><td align=\"right\" valign=\"top\" ><font size=1 color=\"#5B5B5B\">* 발급번호: "+info.getString("proof_no")+"</font></td></tr></table>");
		pdfMaker.setHtmlWidth(750);


//		pdfMaker.setFooter("*본 문서는 상기업체 간에 전자서명법  등 관련법령에 근거하여 전자서명으로 완료된 전자문서입니다.<br>&nbsp;&nbsp;전자문서 진위여부는 나이스다큐(일반기업용)(http://www.nicedocu.com)에서 확인하실 수 있습니다.");
		pdfMaker.setFooter("*본 문서는 상기업체 간에 전자서명법  등 관련법령에 근거하여 전자서명으로 완료된 전자문서입니다.");

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
	 * 실적증명 HASH정보 가져오기
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