<%@ page import="com.google.zxing.qrcode.QRCodeWriter" %>
<%@ page import="com.google.zxing.common.BitMatrix" %>
<%@ page import="com.google.zxing.BarcodeFormat" %>
<%@ page import="com.google.zxing.MatrixToImageConfig" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="com.google.zxing.MatrixToImageWriter" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

//git�� ����
//zxing-2.3.0.jar
	try {
		File file = null;
		// ť���̹����� ������ ���丮 ����
		file = new File("D:\\");
		if (!file.exists()) {
			file.mkdirs();
		}
		// �ڵ��νĽ� ��ũ�� URL�ּ�
		String codeurl = new String("https://www.kakaocorp.com/service/KakaoTalk?lang=en".getBytes("UTF-8"), "ISO-8859-1");
		// ť���ڵ� ���ڵ� ����
		int qrcodeColor = 0xFF2e4e96;
		// ť���ڵ� ������
		int backgroundColor = 0xFFFFFFFF;

		QRCodeWriter qrCodeWriter = new QRCodeWriter();
		// 3,4��° parameter�� : width/height�� ����
		BitMatrix bitMatrix = qrCodeWriter.encode(codeurl, BarcodeFormat.QR_CODE, 200, 200);
		MatrixToImageConfig matrixToImageConfig = new MatrixToImageConfig(); //new MatrixToImageConfig(qrcodeColor, backgroundColor);
		BufferedImage bufferedImage = MatrixToImageWriter.toBufferedImage(bitMatrix, matrixToImageConfig);
		// ImageIO�� ����� ���ڵ� ���Ͼ���
		ImageIO.write(bufferedImage, "png", new File("D:\\qrcode.png"));

	} catch (Exception e) {
		e.printStackTrace();
	}
%>