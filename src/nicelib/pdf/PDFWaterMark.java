package nicelib.pdf;

import java.io.File;
import java.io.FileOutputStream;

import javax.servlet.ServletOutputStream;

import com.lowagie.text.Image;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.PdfStamper;




public class PDFWaterMark {
	

	public static void main(String[] args){
		try {
			PDFWaterMark pdf = new PDFWaterMark();
			Image imgCi = Image.getInstance("D:/project/spc/WebContent/file/ci/20150100001/201502111531007.png");
			Image imgStamp = Image.getInstance("D:/project/spc/WebContent/web/html/images/instore_stamp_20.gif");
			imgStamp.scaleAbsolute(60,60);
			//pdf.setPDFBackgroundImage("D:/project/spc/WebContent/file/contract/2015/20150100001/F4348010021/201501191632058.pdf",imgCi,imgStamp);
		}
		catch(Exception e) {
			e.printStackTrace();			
		}
	}
	
	
	/**
     * ����̹��� �߰��ϱ�
     * @param  sPdfPath ��� �̹��� ������ PDF ���ϰ��
     * @param  imgBack    ��� �̹���
     * @throws Exception
     */
    public void setImage(String pdf_path, String ci_img_path, String stamp_img_path, String sign_img_path, String footer_img_path, ServletOutputStream ouputStream) throws Exception
    {
    	System.out.println("----------------------pdf.setImage-------------------------------");
    	System.out.println("pdf_path=>"+pdf_path);
    	System.out.println("ci_img_path=>"+ci_img_path);
    	System.out.println("stamp_img_path=>"+stamp_img_path);
    	System.out.println("sign_img_path=>"+sign_img_path);
    	System.out.println("footer_img_path=>"+footer_img_path);
        String sReaderPath = pdf_path;              // ��� �̹��� ������ PDF ���ϰ��
        
        Image imgCi = null;
        if(!ci_img_path.equals("")){
        	if(new File(ci_img_path).exists()) {
        		imgCi = Image.getInstance(ci_img_path);
        	}
        	
        }
		Image imgStamp = null;
		if(!stamp_img_path.equals("")){
			if(new File(stamp_img_path).exists()) {
				imgStamp = Image.getInstance(stamp_img_path);
				imgStamp.scaleAbsolute(60,60);
			}
		}
		
		
		Image imgSign = null;
		if(!sign_img_path.equals("")){
			if(new File(sign_img_path).exists()) {
				imgSign = Image.getInstance(sign_img_path);
			}
        }
		Image footerImg = null;
		if(!footer_img_path.equals("")){
			if(new File(footer_img_path).exists()) {
				footerImg = Image.getInstance(footer_img_path);
			}
		}
		
        
        File fileReader = new java.io.File(sReaderPath);
        

        PdfReader reader = new PdfReader(sReaderPath);
        PdfStamper stamper = new PdfStamper(reader, ouputStream);
        
        Rectangle rectangle =  reader.getPageSizeWithRotation(1);//getPageSize(1);
        
        float pageWidth = rectangle.getWidth();
        float pageHeight = rectangle.getHeight();
        
        
        //A4 ���� 595.0x842.0
        if(imgCi!=null){
	        float fImgPosX = (pageWidth - imgCi.getWidth()) / 2;    // ��� �̹��� x ��ǥ
	        float fImgPosY = (pageHeight - imgCi.getHeight()) / 2;  // ��� �̹��� y ��ǥ
	        imgCi.setAbsolutePosition(fImgPosX, fImgPosY);  // ����� ��ġ
        }
        
        if(imgStamp!= null){
	        imgStamp.setAbsolutePosition(pageWidth -70, 10);// �����ϴ�
        }
        
        if(imgSign!= null){
        	imgSign.setAbsolutePosition(10 , 800);  // �������
        }
        
        if(footerImg!= null){
        	footerImg.scaleToFit(500, 40);
        	footerImg.setAbsolutePosition(10, 10);  // �ϴ�
        }

        PdfContentByte under = null;
        PdfContentByte over = null;
        
        int iTotalPage = reader.getNumberOfPages();
        for (int i = 1; i <= iTotalPage; i++)   // ��ü page
        {
            under = stamper.getUnderContent(i); // i page��
        	over = stamper.getOverContent(i); // i page��
        	if(imgCi!=null) under.addImage(imgCi);
            if(imgStamp != null)over.addImage(imgStamp);
            if(imgSign!=null)over.addImage(imgSign);
            if(footerImg!=null)over.addImage(footerImg);
        }
        stamper.close();
        reader.close();
        return;
    }
    
    /**
     * ����̹��� �߰��ϱ�
     * @param  sPdfPath ��� �̹��� ������ PDF ���ϰ��
     * @param  imgBack    ��� �̹���
     * @throws Exception
     */
    public void setImage(byte[] pdfbyte, String ci_img_path, String stamp_img_path, String sign_img_path, String footer_img_path, ServletOutputStream ouputStream) throws Exception
    {
    	System.out.println("----------------------pdf.setImage-------------------------------");
    	System.out.println("ci_img_path=>"+ci_img_path);
    	System.out.println("stamp_img_path=>"+stamp_img_path);
    	System.out.println("sign_img_path=>"+sign_img_path);
    	System.out.println("footer_img_path=>"+footer_img_path);
        
        Image imgCi = null;
        if(!ci_img_path.equals("")){
        	if(new File(ci_img_path).exists()) {
        		imgCi = Image.getInstance(ci_img_path);
        	}
        	
        }
		Image imgStamp = null;
		if(!stamp_img_path.equals("")){
			if(new File(stamp_img_path).exists()) {
				imgStamp = Image.getInstance(stamp_img_path);
				imgStamp.scaleAbsolute(60,60);
			}
		}
		
		
		Image imgSign = null;
		if(!sign_img_path.equals("")){
			if(new File(sign_img_path).exists()) {
				imgSign = Image.getInstance(sign_img_path);
			}
        }
		Image footerImg = null;
		if(!footer_img_path.equals("")){
			if(new File(footer_img_path).exists()) {
				footerImg = Image.getInstance(footer_img_path);
			}
		}
		

        PdfReader reader = new PdfReader(pdfbyte);
        PdfStamper stamper = new PdfStamper(reader, ouputStream);
        
        Rectangle rectangle =  reader.getPageSize(1);
        
        float pageWidth = rectangle.getWidth();
        float pageHeight = rectangle.getHeight();
        
        
        //A4 ���� 595.0x842.0
        if(imgCi!=null){
	        float fImgPosX = (pageWidth - imgCi.getWidth()) / 2;    // ��� �̹��� x ��ǥ
	        float fImgPosY = (pageHeight - imgCi.getHeight()) / 2;  // ��� �̹��� y ��ǥ
	        imgCi.setAbsolutePosition(fImgPosX, fImgPosY);  // ����� ��ġ
        }
        
        if(imgStamp!= null){
	        imgStamp.setAbsolutePosition(pageWidth -70, 10);// �����ϴ�
        }
        
        if(imgSign!= null){
        	imgSign.setAbsolutePosition(10 , 800);  // �������
        }
        
        if(footerImg!= null){
        	footerImg.scaleToFit(500, 40);
        	footerImg.setAbsolutePosition(10, 10);  // �ϴ�
        }

        PdfContentByte under = null;
        PdfContentByte over = null;
        
        int iTotalPage = reader.getNumberOfPages();
        for (int i = 1; i <= iTotalPage; i++)   // ��ü page
        {
            under = stamper.getUnderContent(i); // i page��
        	over = stamper.getOverContent(i); // i page��
        	if(imgCi!=null) under.addImage(imgCi);
            if(imgStamp != null)over.addImage(imgStamp);
            if(imgSign!=null)over.addImage(imgSign);
            if(footerImg!=null)over.addImage(footerImg);
        }
        stamper.close();
        reader.close();
        return;
    }
    
    /**
     * ����̹��� �߰��ϱ�
     * @param  sPdfPath ��� �̹��� ������ PDF ���ϰ��
     * @param  imgBack    ��� �̹���
     * @throws Exception
     */
    public void setImageNhqv(byte[] pdfbyte, String ci_img_path, String stamp_img_path, ServletOutputStream ouputStream) throws Exception
    {
    	System.out.println("----------------------pdf.setImage-------------------------------");
    	System.out.println("ci_img_path=>"+ci_img_path);
    	System.out.println("stamp_img_path=>"+stamp_img_path);
        
        Image imgCi = null;
        if(!ci_img_path.equals("")){
        	if(new File(ci_img_path).exists()) {
        		imgCi = Image.getInstance(ci_img_path);
        	}
        	
        }
		Image imgStamp = null;
		if(!stamp_img_path.equals("")){
			if(new File(stamp_img_path).exists()) {
				imgStamp = Image.getInstance(stamp_img_path);
				imgStamp.scaleAbsolute(60,60);
			}
		}
		

        PdfReader reader = new PdfReader(pdfbyte);
        PdfStamper stamper = new PdfStamper(reader, ouputStream);
        
        Rectangle rectangle =  reader.getPageSize(1);
        
        float pageWidth = rectangle.getWidth();
        float pageHeight = rectangle.getHeight();
        
        
        //A4 ���� 595.0x842.0
        if(imgCi!=null){
	        float fImgPosX = (pageWidth - imgCi.getWidth()) / 2;    // ��� �̹��� x ��ǥ
	        float fImgPosY = (pageHeight - imgCi.getHeight()) / 2;  // ��� �̹��� y ��ǥ
	        imgCi.setAbsolutePosition(fImgPosX, fImgPosY);  // ����� ��ġ
        }
        
        if(imgStamp!= null){
	        imgStamp.setAbsolutePosition(pageWidth -90, 50);// �����ϴ�
        }
       

        PdfContentByte under = null;
        PdfContentByte over = null;
        
        int iTotalPage = reader.getNumberOfPages();
        for (int i = 1; i <= iTotalPage; i++)   // ��ü page
        {
            under = stamper.getUnderContent(i); // i page��
        	over = stamper.getOverContent(i); // i page��
        	if(imgCi!=null) under.addImage(imgCi);
            if(imgStamp != null)over.addImage(imgStamp);
        }
        stamper.close();
        reader.close();
        return;
    }
    
}
