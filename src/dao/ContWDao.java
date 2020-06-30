package dao;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import com.lowagie.text.Image;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.PdfStamper;

import crosscert.Hash;
import nicelib.db.DataObject;
import nicelib.db.DataSet;
import nicelib.pdf.PDFMaker;
import nicelib.util.Util;
import procure.common.conf.Startup;
import procure.common.utils.StrUtil;

public class ContWDao extends DataObject {

	public ContWDao() {
		this.table = "tcw_contmaster";
	}

	public String makeContNo() {
		String query = "";

		query += "select 'W'|| (to_number(to_char(sysdate, 'YYMM')) + 3300) || lpad((nvl(max(to_number(substr(cont_no, 6))), 0) + 1), 6, '0') as cont_no ";
		query += "from tcw_contmaster ";
		query += "where substr(cont_no, 2, 4) = (to_char(sysdate, 'YYMM') + 3300) ";

		String cont_no = this.getOne(query);

		return cont_no;
	}

	/**
	 * info (member_no, cont_no, cont_chasu, html)
	 * @param info
	 * @return
	 */
	public DataSet makePdf(DataSet info){
		DataSet pdf = null;
		String fontSize = "12px";

		if(!info.getString("font_size").equals("")) {
			fontSize = info.getString("font_size");
		}

		PDFMaker pdfMaker = new PDFMaker();
		String pdfDir = procure.common.conf.Startup.conf.getString("file.path.work.cont_pdf");
		String fileDir = Util.getTimeString("yyyy") + "/" + info.getString("member_no") + "/" + info.getString("cont_no") + "/";
		String fileName = info.getString("cont_no") + "_" + info.getString("cont_chasu") + "_" + info.getString("file_seq") + ".pdf";
		String path = pdfDir + fileDir + fileName;
		StringBuffer documentContentsBefore = new StringBuffer();

		documentContentsBefore.append("<!DOCTYPE html>");
		documentContentsBefore.append("<html lang=\"ko\">");
		documentContentsBefore.append("<head>");
		documentContentsBefore.append("<meta charset=\"EUC-KR\">");
		documentContentsBefore.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=EUC-KR\">");
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

		// 1 or null:전자계약,  2: 전자문서
		if(info.getString("doc_type").equals("2")) {
			pdfMaker.setFooter("*본 문서는 업체와 근로자 간에 전자서명법 등 관련법령에 근거하여 공인인증서로 전자서명한 전자문서입니다.<br>&nbsp;&nbsp;전자문서 진위여부는 나이스다큐(http://www.nicedocu.com,근로계약)에서 확인하실 수 있습니다.");
		}
		else {
			String footerMsg = "";

			//footerMsg += "<table width='100%' height='35px' border='0'><tr><td valign='bottom'><font size=1 color='#5B5B5B'>";
			footerMsg += "*본 계약서는 업체와 근로자 간에 전자서명법  등 관련법령에 근거하여 전자서명으로 체결한 전자계약서입니다.<br>&nbsp;&nbsp;전자계약 진위여부는 나이스다큐(http://www.nicedocu.com,근로계약)에서 확인하실 수 있습니다.";
			footerMsg += " (관리번호:" + pdfMaker.getContNo() + ")";
			//footerMsg += "</font></td></tr></table>";

			pdfMaker.setFooter(footerMsg);
		}

		boolean result = pdfMaker.generatePDF(documentContentsBefore.toString()+info.getString("html")+"</body></html>", pdfDir+fileDir, fileName);

		if(!result) {
			return null;
		}

		pdf = new DataSet();
		pdf.addRow();
		pdf.put("file_path", fileDir);
		pdf.put("file_name", fileName);
		pdf.put("file_size", new File(path).length());
		pdf.put("file_ext", "pdf");
		pdf.put("file_hash", getHash("file.path.work.cont_pdf", fileDir + fileName));

		return pdf;
	}

	public String makeDisCertNo() {
		String query = "";

		query += "select 'D'|| (to_number(to_char(sysdate, 'YYMM')) + 3300) || lpad((nvl(max(to_number(substr(dis_cert_no, 6))), 0) + 1), 6, '0') as dis_cert_no ";
		query += "from tcw_dis_cert ";
		query += "where substr(dis_cert_no, 2, 4) = (to_char(sysdate, 'YYMM') + 3300) ";

		String dis_cert_no = this.getOne(query);

		return dis_cert_no;
	}

	/**
	 * 해촉증명서 pdf생성
	 * info (member_no, cont_no, cont_chasu, html)
	 * @param info
	 * @return
	 */
	public DataSet makeDisCertPdf(DataSet info, String fileName) {
		DataSet pdf = null;
		String fontSize = "12px";

		if(!info.getString("font_size").equals("")) {
			fontSize = info.getString("font_size");
		}

		PDFMaker pdfMaker = new PDFMaker();
		String pdfDir = procure.common.conf.Startup.conf.getString("file.path.work.dis_pdf");
		String fileDir = Util.getTimeString("yyyy") + "/" + info.getString("member_no") + "/" + info.getString("dis_cert_no") + "/";

		if (fileName == null || fileName.contentEquals("")) {
			fileName = info.getString("dis_cert_no") + "_" + info.getString("file_seq");
		}

		fileName += ".pdf";

		String filepath = pdfDir + fileDir + fileName;
		StringBuffer documentContentsBefore = new StringBuffer();

		documentContentsBefore.append("<!DOCTYPE html>");
		documentContentsBefore.append("<html lang=\"ko\">");
		documentContentsBefore.append("<head>");
		documentContentsBefore.append("<meta charset=\"EUC-KR\">");
		documentContentsBefore.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=EUC-KR\">");
		documentContentsBefore.append("<style type=\"text/css\">");
		documentContentsBefore.append("<!--");
		documentContentsBefore.append("		td {  font-family: \"나눔고딕\",\"Arial\"; font-size: "+fontSize+"; font-style: normal; letter-spacing:0; color: black;line-height:150%}");
		documentContentsBefore.append("		.lineTable { border-collapse:collapse; border:1 solid black }");
		documentContentsBefore.append("		.lineTable td { border:1px solid black }");
		documentContentsBefore.append("		.lineTable .noborder { border:0px }");
		documentContentsBefore.append("-->");
		documentContentsBefore.append("</style>");
		documentContentsBefore.append("</head><body>");

		pdfMaker.setUserNo("");
		pdfMaker.setHtmlWidth(750);
		pdfMaker.setFooter("*본 전자문서의 진위여부는 나이스다큐(http://www.nicedocu.com,근로계약)에서 확인하실 수 있습니다. (발급번호:" + info.getString("dis_cert_no") + "-" + info.getString("random_no") + ")");
		//pdfMaker.setFooter("");

		boolean result = pdfMaker.generatePDF(documentContentsBefore.toString()+info.getString("html")+"</body></html>", pdfDir + fileDir, fileName);

		if(!result) {
			return null;
		}

		pdf = new DataSet();
		pdf.addRow();
		pdf.put("file_path", fileDir);
		pdf.put("file_name", fileName);
		pdf.put("file_size", new File(filepath).length());
		pdf.put("file_ext", "pdf");
		pdf.put("file_hash", getHash("file.path.work.dis_pdf", fileDir + fileName));

		return pdf;
	}

    public void setCiImage(String pdf_path, String ci_img_path, FileOutputStream ouputStream) throws Exception {
    	System.out.println("---------------------- setCiImage -------------------------------");
    	System.out.println("pdf_path=>"+pdf_path);
    	System.out.println("ci_img_path=>"+ci_img_path);

        String sReaderPath = pdf_path;              // 배경 이미지 적용할 PDF 파일경로

        Image imgCi = null;

        if(!ci_img_path.equals("")){
        	if(new File(ci_img_path).exists()) {
        		imgCi = Image.getInstance(ci_img_path);
        	}
        }

        //File fileReader = new java.io.File(sReaderPath);
        PdfReader reader = new PdfReader(sReaderPath);
        PdfStamper stamper = new PdfStamper(reader, ouputStream);
        Rectangle rectangle =  reader.getPageSizeWithRotation(1);//getPageSize(1);

        float pageWidth = rectangle.getWidth();
        float pageHeight = rectangle.getHeight();

        //A4 세로 595.0x842.0
        if(imgCi!=null) {
	        float fImgPosX = (pageWidth - imgCi.getWidth()) / 2;    // 배경 이미지 x 좌표
	        float fImgPosY = (pageHeight - imgCi.getHeight()) / 2;  // 배경 이미지 y 좌표

	        imgCi.setAbsolutePosition(fImgPosX, fImgPosY);  // 가운데에 위치
        }

        PdfContentByte under = null;

        int iTotalPage = reader.getNumberOfPages();

        for (int i = 1; i <= iTotalPage; i++) {   // 전체 page
            under = stamper.getUnderContent(i); // i page에

            if(imgCi!=null) {
        		under.addImage(imgCi);
        	}
        }

        stamper.close();
        reader.close();
    }

	/**
	 * Hash 정보 가져오기
	 * @param sXpath		경로
	 * @param sOtherFullDir
	 * @return
	 * @throws IOException
	 */
	public String getHash(String sXpath, String sOtherFullDir) {
		FileInputStream	fis = null;
		String sHash = "";

		try {
			String sBaseDir = Startup.conf.getString(sXpath);

			if(sBaseDir.lastIndexOf("/") == sBaseDir.length() - 1) {
				sBaseDir = sBaseDir.substring(0,sBaseDir.length()-1);
			}

			if(sOtherFullDir.indexOf("/") == 0) {
				sOtherFullDir = sOtherFullDir.substring(1);
			}

			String	sFullFilePath = sBaseDir + "/" + sOtherFullDir;

			sFullFilePath = StrUtil.replace(sFullFilePath,"\\",File.separator);
			sFullFilePath = StrUtil.replace(sFullFilePath,"/",File.separator);
			fis = new FileInputStream(new File(sFullFilePath));

			int iFileLen = fis.available();
			byte[] b = new byte[iFileLen];
			int iRet = fis.read(b);
			Hash hash = new Hash();

			iRet = hash.GetHash(b, b.length);
			if(iRet	== 0) {
				sHash = new String(hash.contentbuf);
			}
			else {
				sHash = "";
			}
		} catch (FileNotFoundException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getHash()] :" + e.toString());
		} catch (IOException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getHash()] :" + e.toString());
		} finally {
			try {
				if(fis != null) fis.close();
			} catch (IOException e) {
				System.out.println("[ERROR "+this.getClass().getName() + ".getHash()] :" + e.toString());
			}
		}

		return sHash;
	}

	/**
	 *
	 * @param byteFileData
	 * @return
	 */
	public String getHash(byte[] byteFileData) {
		String sHash = "";
		Hash hash = new Hash();

		try {
			int iRet = hash.GetHash(byteFileData, byteFileData.length);

			if(iRet	==	0) {
				sHash = new String(hash.contentbuf);
			}
			else {
				sHash = "";
			}
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getHash()] :" + e.toString());
		}

		return sHash;
	}

}
