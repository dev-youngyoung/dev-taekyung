package nicednb.bct;

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

public class BCTPDFMaker {
	
	private int htmlWidth = 750;
	private String header = null;
	private String footer = null;
	private String footerDefault = "*�� ��༭�� ����ü ���� ���ڼ����  �� ���ù��ɿ� �ٰ��Ͽ� ���ڼ������� ü���� ���ڰ�༭�Դϴ�.<br>&nbsp;&nbsp;���ڰ�� �������δ� ���̽���ť(http://www.nicedocu.com,�Ϲݱ����)���� Ȯ���Ͻ� �� �ֽ��ϴ�.";
	private String cont_no = "";
	private String cont_chasu = "";
	private String random_no = "";
	private String cont_userno = ""; // ����� ����ȣ


	public static void main(String[] args) throws InvalidParameterException, MalformedURLException, IOException{
		BCTPDFMaker ed = new BCTPDFMaker();
		//ed.generatePDF("file:///d:/CJ-GLS �ù�븮�� ��༭.html", new File("d:/CJ-GLS �ù�븮�� ��༭.pdf"), PD4Constants.A4);
		
		try {
			File f = new File("c:/", "tmon_test.html");
			FileReader reader = new FileReader(f);
			BufferedReader buffer = new BufferedReader(reader);
			
			String html = "";
			String str = buffer.readLine();
			
			while(str!=null) {
				html += str;
				str =  buffer.readLine();
			}
			buffer.close();

			ed.generatePDF(html, "c:/", "tmon_test.pdf"); 
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
	 * PDF ���� ����
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
			headerMark.setAreaHeight( 30 );				//header ���� ����
			
			//header ������ ����
			if(header == null){
				if(!this.getUserContNo().equals(""))
					headerMark.setHtmlTemplate("<table border=0 width=100%><tr><td align=\"right\" valign=\"top\" ><font size=1 color=\"#5B5B5B\">* ����ȣ: "+this.getUserContNo()+"</font></td></tr></table>");
				else
					headerMark.setHtmlTemplate("");
			}else{
				headerMark.setHtmlTemplate(header);
			}
			pd4ml.setPageHeader(headerMark);
			
			//footer ��������
			PD4PageMark footerMark = new PD4PageMark();
			footerMark.setAreaHeight( 40 );
			
			//footer ������ ����
			if(footer == null){
				footerMark.setHtmlTemplate("<table width='100%' height='35' border='0'><tr><td valign='bottom'><font size=1 color=\"#5B5B5B\">"+footerDefault+ " (������ȣ:"+this.getContNo()+")</font></td></tr></table>");
			}else{
				footerMark.setHtmlTemplate("<span><font size=1 color=\"#5B5B5B\">"+ getFooter() +"</font></span>");
			}
			pd4ml.setPageFooter(footerMark);
			
			pd4ml.setPageInsets(new Insets(10,20,5,20));						//���鼳��
			pd4ml.setHtmlWidth(getHtmlWidth());									//��ȯ�� html�� width ����
			pd4ml.setPageSize(PD4Constants.A4);									//������� A4����
			//pd4ml.setPageSize(pd4ml.changePageOrientation(PD4Constants.A4));	//���η� ����
			pd4ml.useTTF("java:fonts", true);									//������ ��Ʈ ���
			//pd4ml.setDefaultTTFs("Nanum Gothic", "Times New Roman", "Arial");	//default ��Ʈ ����
			pd4ml.setDefaultTTFs("Nanum Gothic", "Times New Roman", "Arial");	//default ��Ʈ ����
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
	 * PDF ���� ����
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
			headerMark.setAreaHeight( 30 );				//header ���� ����
			
			//header ������ ����
			if(header == null){
				if(!this.getUserContNo().equals(""))
					headerMark.setHtmlTemplate("<table border=0 width=100%><tr><td align=\"right\" valign=\"top\" ><font size=1 color=\"#5B5B5B\">* ����ȣ: "+this.getUserContNo()+"</font></td></tr></table>");
				else
					headerMark.setHtmlTemplate("");
			}else{
				headerMark.setHtmlTemplate(header);
			}
			pd4ml.setPageHeader(headerMark);
			
			//footer ��������
			PD4PageMark footerMark = new PD4PageMark();
			footerMark.setAreaHeight( 40 );
			
			//footer ������ ����
			if(footer == null){
				footerMark.setHtmlTemplate("<table width='100%' height='35' border='0'><tr><td valign='bottom'><font size=1 color=\"#5B5B5B\">"+footerDefault+ " (������ȣ:"+this.getContNo()+")<br>&nbsp;&nbsp;The contract has been signed electronically over www.nicedocu.com</font></td></tr></table>");
			}else{
				footerMark.setHtmlTemplate("<table width='100%' height='35' border='0'><tr><td valign='bottom'><font size=1 color=\"#5B5B5B\">"+ getFooter() +" (������ȣ:"+this.getContNo()+")<br>&nbsp;&nbsp;The contract has been signed electronically over www.nicedocu.com</font></td></tr></table>");
			}
			pd4ml.setPageFooter(footerMark);
			
			pd4ml.setPageInsets(new Insets(10,20,5,20));						//���鼳��
			pd4ml.setHtmlWidth(getHtmlWidth());									//��ȯ�� html�� width ����
			pd4ml.setPageSize(PD4Constants.A4);									//������� A4����
			//pd4ml.setPageSize(pd4ml.changePageOrientation(PD4Constants.A4));	//���η� ����
			pd4ml.useTTF("java:fonts", true);									//������ ��Ʈ ���
			pd4ml.setDefaultTTFs("Nanum Gothic", "Times New Roman", "Arial");	//default ��Ʈ ����
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
	
	/**
	 * PDF ���� ����
	 * @param html
	 * @param outputDir
	 * @param outputFileName
	 * @return
	 */
	public boolean generatePDFF(String html, String outputDir, String outputFileName) {
		FileOutputStream fos = null;
		
		try{
			System.out.println(outputDir+outputFileName);
			File outputDirFile = new File(outputDir);
			if(outputDirFile.exists() == false) outputDirFile.mkdirs();
			fos = new FileOutputStream(new File(outputDir+outputFileName));
			
			PD4ML pd4ml = new PD4ML();

			
			PD4PageMark headerMark = new PD4PageMark();
			headerMark.setAreaHeight( 30 );				//header ���� ����
			
			//header ������ ����
			if(header == null){
				if(!this.getUserContNo().equals(""))
					headerMark.setHtmlTemplate("<table border=0 width=100%><tr><td align=\"right\" valign=\"top\" ><font size=1 color=\"#5B5B5B\">* ����ȣ: "+this.getUserContNo()+"</font></td></tr></table>");
				else
					headerMark.setHtmlTemplate("");
			}else{
				headerMark.setHtmlTemplate(header);
			}
			pd4ml.setPageHeader(headerMark);
			
			//footer ��������
			PD4PageMark footerMark = new PD4PageMark();
			footerMark.setAreaHeight( 40 );
			
			//footer ������ ����
			String str_mgr_no = "";
			if(!cont_no.equals("")){
				str_mgr_no = " (������ȣ:"+this.getContNo()+")";
			}
			if(footer == null){
				footerMark.setHtmlTemplate("<table width='100%' height='35' border='0'><tr><td valign='bottom'><font size=1 color=\"#5B5B5B\">"+footerDefault+ str_mgr_no +"</font></td></tr></table>");
			}else{
				footerMark.setHtmlTemplate("<table width='100%' height='35' border='0'><tr><td valign='bottom'><font size=1 color=\"#5B5B5B\">"+ getFooter() +"</font></td></tr></table>");
			}
			pd4ml.setPageFooter(footerMark);
			
			pd4ml.setPageInsets(new Insets(10,20,5,20));						//���鼳��
			pd4ml.setHtmlWidth(getHtmlWidth());									//��ȯ�� html�� width ����
			pd4ml.setPageSize(PD4Constants.A4);									//������� A4����
			//pd4ml.setPageSize(pd4ml.changePageOrientation(PD4Constants.A4));	//���η� ����
			pd4ml.useTTF("java:fonts", true);									//������ ��Ʈ ���
			pd4ml.setDefaultTTFs("Nanum Gothic", "Times New Roman", "Arial");	//default ��Ʈ ����
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
