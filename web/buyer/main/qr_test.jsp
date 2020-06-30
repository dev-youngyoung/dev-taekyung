<%@ page import="com.google.zxing.qrcode.QRCodeWriter" %>
<%@ page import="com.google.zxing.common.BitMatrix" %>
<%@ page import="com.google.zxing.BarcodeFormat" %>
<%@ page import="com.google.zxing.MatrixToImageConfig" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="com.google.zxing.MatrixToImageWriter" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

//git을 통해
//zxing-2.3.0.jar
	try {
		File file = null;
		// 큐알이미지를 저장할 디렉토리 지정
		file = new File("D:\\");
		if (!file.exists()) {
			file.mkdirs();
		}
		// 코드인식시 링크걸 URL주소
		String codeurl = new String("https://www.kakaocorp.com/service/KakaoTalk?lang=en".getBytes("UTF-8"), "ISO-8859-1");
		// 큐알코드 바코드 생상값
		int qrcodeColor = 0xFF2e4e96;
		// 큐알코드 배경색상값
		int backgroundColor = 0xFFFFFFFF;

		QRCodeWriter qrCodeWriter = new QRCodeWriter();
		// 3,4번째 parameter값 : width/height값 지정
		BitMatrix bitMatrix = qrCodeWriter.encode(codeurl, BarcodeFormat.QR_CODE, 200, 200);
		MatrixToImageConfig matrixToImageConfig = new MatrixToImageConfig(); //new MatrixToImageConfig(qrcodeColor, backgroundColor);
		BufferedImage bufferedImage = MatrixToImageWriter.toBufferedImage(bitMatrix, matrixToImageConfig);
		// ImageIO를 사용한 바코드 파일쓰기
		ImageIO.write(bufferedImage, "png", new File("D:\\qrcode.png"));

	} catch (Exception e) {
		e.printStackTrace();
	}
%>