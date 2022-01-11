package nicelib.pdf;

import java.awt.Dimension;
import java.awt.Insets;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.StringReader;
import java.net.MalformedURLException;
import java.security.InvalidParameterException;

import org.zefer.pd4ml.PD4Constants;
import org.zefer.pd4ml.PD4ML;
import org.zefer.pd4ml.PD4PageMark;

public class PDFMaker {
	
	private int htmlWidth = 750;
	private String header = null;
	private String footer = null;
	private String footerDefault = "*본 계약서는 상기업체 간에 전자서명법  등 관련법령에 근거하여 전자서명으로 체결한 전자계약서입니다.";
	private String cont_no = "";
	private String cont_chasu = "";
	private String random_no = "";
	private String cont_userno = ""; // 사용자 계약번호


	public static void main(String[] args) throws InvalidParameterException, MalformedURLException, IOException{
		PDFMaker ed = new PDFMaker();
		//ed.generatePDF("file:///d:/CJ-GLS 택배대리점 계약서.html", new File("d:/CJ-GLS 택배대리점 계약서.pdf"), PD4Constants.A4);
		
		try {
			File f = new File("W:/개발문서/물류전자계약/CJ GLS/계약서양식_2012.06.13/b. 나이스다큐 적용/a. 대리점/d. 동의서/", "근저당권; 임대차 현황서.html");
			FileReader reader = new FileReader(f);
			BufferedReader buffer = new BufferedReader(reader);
			
			String html = "";
			String str = buffer.readLine();
			
			while(str!=null) {
				html += str;
				str =  buffer.readLine();
			}
			buffer.close();

			ed.generatePDF(html, "W:/개발문서/물류전자계약/CJ GLS/계약서양식_2012.06.13/b. 나이스다큐 적용/a. 대리점/d. 동의서/", "근저당권; 임대차 현황서.pdf"); 
		}
		catch(IOException e) {
			e.printStackTrace();			
		}
	}
	
	public String getContNo() {
		return cont_no+"-"+cont_chasu+"-"+random_no;
	}

	public void setContNo(String cont_no, String cont_chasu, String random_no) {
		this.cont_no = cont_no;
		this.cont_chasu = cont_chasu;
		this.random_no = random_no;
	}

	private String getUserContNo() {
		return this.cont_userno;
	}
	public void setUserNo(String cont_userno) {
		this.cont_userno = cont_userno;
	}
	
	public String getHeader() {
		return header;
	}

	public void setHeader(String header) {
		this.header = header;
	}

	public String getFooter() {
		return footer;
	}

	public void setFooter(String footer) {
		this.footer = footer;
	}
	
	public int getHtmlWidth() {
		return htmlWidth;
	}

	public void setHtmlWidth(int htmlWidth) {
		this.htmlWidth = htmlWidth;
	}
	
	/**
	 * PDF 문서 생성
	 * @param url
	 * @param outputPDFFile
	 * @param format
	 * @return
	 */
	public boolean generatePDF(String url, File outputPDFFile, Dimension format) {
		FileOutputStream fos = null;
		

		try{
			fos = new FileOutputStream(outputPDFFile);
			PD4ML pd4ml = new PD4ML();
			
			PD4PageMark headerMark = new PD4PageMark();
			headerMark.setAreaHeight( 30 );				//header 영역 설정
			
			//header 데이터 셋팅
			if(header == null){
				if(!this.getUserContNo().equals(""))
					headerMark.setHtmlTemplate("<table border=0 width=100%><tr><td align=\"right\" valign=\"top\" ><font size=1 color=\"#5B5B5B\">* 계약번호: "+this.getUserContNo()+"</font></td></tr></table>");
				else
					headerMark.setHtmlTemplate("");
			}else{
				headerMark.setHtmlTemplate(header);
			}
			pd4ml.setPageHeader(headerMark);
			
			//footer 영역설정
			PD4PageMark footerMark = new PD4PageMark();
			footerMark.setAreaHeight( 40 );
			
			//footer 데이터 셋팅
			if(footer == null){
				footerMark.setHtmlTemplate("<table width='100%' height='35' border='0'><tr><td valign='bottom'><font size=1 color=\"#5B5B5B\">"+footerDefault+ " (관리번호:"+this.getContNo()+")</font></td></tr></table>");
			}else{
				footerMark.setHtmlTemplate("<span><font size=1 color=\"#5B5B5B\">"+ getFooter() +"</font></span>");
			}
			pd4ml.setPageFooter(footerMark);
			
			pd4ml.setPageInsets(new Insets(10,20,5,20));						//여백설정
			pd4ml.setHtmlWidth(getHtmlWidth());									//변환할 html의 width 정보
			pd4ml.setPageSize(PD4Constants.A4);									//용지모양 A4설정
			//pd4ml.setPageSize(pd4ml.changePageOrientation(PD4Constants.A4));	//가로로 설정
			pd4ml.useTTF("java:", true);									//지정한 폰트 사용
			//pd4ml.setDefaultTTFs("Nanum Gothic", "Times New Roman", "Arial");	//default 폰트 설정
			pd4ml.setDefaultTTFs("Nanum Gothic", "Times New Roman", "Arial");	//default 폰트 설정
			pd4ml.enableDebugInfo();
			pd4ml.render(new java.net.URL(url), fos);
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}finally{
			if(fos != null)
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
	}

	
	
	/**
	 * PDF 문서 생성
	 * @param html
	 * @param outputDir
	 * @param outputFileName
	 * @return
	 */
	public boolean generatePDF(String html, String outputDir, String outputFileName) {
		FileOutputStream fos = null;
		
		try{
			System.out.println(outputDir+outputFileName);
			File outputDirFile = new File(outputDir);
			if(outputDirFile.exists() == false) outputDirFile.mkdirs();
			fos = new FileOutputStream(new File(outputDir+outputFileName));
			
			PD4ML pd4ml = new PD4ML();

			
			PD4PageMark headerMark = new PD4PageMark();
			headerMark.setAreaHeight( 30 );				//header 영역 설정
			
			//header 데이터 셋팅
			if(header == null){
				if(!this.getUserContNo().equals(""))
					headerMark.setHtmlTemplate("<table border=0 width=100%><tr><td align=\"left\" valign=\"top\" ><font size=1 color=\"#5B5B5B\">* 계약번호: "+this.getUserContNo()+"</font></td></tr></table>");
				else
					headerMark.setHtmlTemplate("");
			}else{
				headerMark.setHtmlTemplate(header);
			}
			pd4ml.setPageHeader(headerMark);
			
			//footer 영역설정
			PD4PageMark footerMark = new PD4PageMark();
			footerMark.setAreaHeight( 40 );
			
			//footer 데이터 셋팅
			if(footer == null){
				footerMark.setHtmlTemplate("<table width='100%' height='35px' border='0' style=\"padding-top:-10px;\"><tr><td valign='bottom'><font size=1 color=\"#5B5B5B\">"+footerDefault+ " (관리번호:"+this.getContNo()+")</font></td></tr></table>");
			}else{
				footerMark.setHtmlTemplate("<span style=\"padding-top:-10px;\"><font size=1 color=\"#5B5B5B\">"+ getFooter() +"</font></span>");
			}
			pd4ml.setPageFooter(footerMark);
			
			pd4ml.setPageInsets(new Insets(10,20,5,20));						//여백설정
			pd4ml.setHtmlWidth(getHtmlWidth());									//변환할 html의 width 정보
			pd4ml.setPageSize(PD4Constants.A4);									//용지모양 A4설정
			//pd4ml.setPageSize(pd4ml.changePageOrientation(PD4Constants.A4));	//가로로 설정
			pd4ml.useTTF("java:", true);									//지정한 폰트 사용
			pd4ml.setDefaultTTFs("Nanum Gothic", "Times New Roman", "Arial");	//default 폰트 설정
			pd4ml.enableDebugInfo();
			
			pd4ml.render(new StringReader(html), fos);
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}finally{
			if(fos != null)
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
	}
	
}
