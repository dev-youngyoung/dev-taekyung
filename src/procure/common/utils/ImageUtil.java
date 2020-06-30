package procure.common.utils;

import nicelib.util.Base64Coder;
import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.awt.image.PixelGrabber;
import java.io.*;
import javax.imageio.ImageIO;

public class ImageUtil {

	/**
     * �̹��� ������ ũ��� ������ �����Ͽ� png���Ϸ� �����. (png���� ������ �����ϴ� Ÿ����)
     * 
     * @param srcImageFilePath ���� �̹��� ���� ���
     * @param nTargetSize ��ȯ�̹��� ���� ũ��
     * @param nOpacity ���� %  1~100 ����  (���� �������� �� ��������, 100�� ������ ����)
     * @return ��ȯ�� ���ϸ�
     * @throws Exception
     */
	
    public String resizeToFile(String srcImageFilePath, int nTargetSize, int nOpacity) throws Exception
    {
        File in = new File(srcImageFilePath);
        
        try {
        	BufferedImage image = ImageIO.read(in);
            String sFileName = in.getName();
            //String sExt = sFileName.substring(sFileName.lastIndexOf(".")+1, sFileName.length());
            String sName = sFileName.substring(0, sFileName.lastIndexOf("."));
            
            String sTargetPath = srcImageFilePath.substring(0, srcImageFilePath.lastIndexOf(sFileName));
            String sTargetFile = sTargetPath + sName + ".png";

            BufferedImage resultImage2 = ImageToBufferedImage(image, nTargetSize, nOpacity);
            File outFile2 = new File(sTargetFile);
            ImageIO.write(resultImage2, "PNG", outFile2);
            
            return sName + ".png";        	
        }
        catch(Exception e)	// ��ȯ�� �� ���� �����̸� �׳� �������
        {
        	return in.getName();
        }
    }
    
    
    private BufferedImage ImageToBufferedImage(BufferedImage image, int nTargetSize, int nOpacity)
    {
      double resizeRatio = 1.0;
      resizeRatio = (double)nTargetSize / image.getWidth();
      
      int width = (int)(image.getWidth() * resizeRatio);
      int height = (int)(image.getHeight() * resizeRatio);
      
      //int type = (image.getTransparency() == Transparency.OPAQUE) ? BufferedImage.TYPE_INT_RGB : BufferedImage.TYPE_INT_ARGB;
      BufferedImage dest = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
      
      Graphics2D g2 = dest.createGraphics();
      g2.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER,(float) nOpacity / 100));
      g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
      
      AffineTransform xform = AffineTransform.getScaleInstance(resizeRatio, resizeRatio);
      g2.drawImage(image, xform, null);
      g2.dispose();
      return dest;
    }

    /**
     * �̹��� ũ�� ���� �� ǰ�� ����
     * @param srcImageFileStream
     * @param destWidth
     * @param destHeight
     * @return ��ȯ�� �̹����� base64���ڵ�
     * @throws Exception
     */
    public String resizeQulityToFile(InputStream srcImageFileStream, int destWidth, int destHeight) throws Exception
    {
        //File in = new File(srcImageFilePath);
        ByteArrayOutputStream os = null;
        ByteArrayInputStream bis = null;
        try {
            //String sFileName = in.getName();
            //String sName = sFileName.substring(0, sFileName.lastIndexOf("."));

            //String sTargetPath = srcImageFilePath.substring(0, srcImageFilePath.lastIndexOf(sFileName));
            //String sTargetFile = sTargetPath + sName + "2.jpg";

            BufferedImage srcImg = ImageIO.read(srcImageFileStream);
            Image imgTarget = srcImg.getScaledInstance(destWidth, destHeight, Image.SCALE_SMOOTH);
            int pixels[] = new int[destWidth * destHeight];
            PixelGrabber pg = new PixelGrabber(imgTarget, 0, 0, destWidth, destHeight, pixels, 0, destWidth);
            try {
                pg.grabPixels(); // JEPG ������ ��� ���� �ð��� �ɸ���.
            } catch (InterruptedException e) {

            }
            BufferedImage destImg = new BufferedImage(destWidth, destHeight, BufferedImage.TYPE_INT_ARGB);
            destImg.setRGB(0, 0, destWidth, destHeight, pixels, 0, destWidth);

            os = new ByteArrayOutputStream();
            ImageIO.write(destImg, "PNG", os);

            byte[] buffer = new byte[4096];
            bis = new ByteArrayInputStream(os.toByteArray());
            os = new ByteArrayOutputStream();

            int read = 0;
            while ((read = bis.read(buffer)) != -1) {
                os.write(buffer, 0, read);
            }

            String result = new String(Base64Coder.encode(os.toByteArray()));
            return result;

        } catch(Exception e) {
            return null;
        } finally {
            os.close();
            bis.close();
        }
    }

    public static void main(String[] args) throws Exception {

    	ImageUtil at = new ImageUtil();
    	at.resizeToFile("d:\\����Ǽ�CI(500p).jpg", 240, 20);

    }
}
