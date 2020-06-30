<%@ page import="java.net.URLDecoder" %>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
String sigm_img_data = f.get("sign_img_data");
String encode_type = sigm_img_data.split(",")[0];
String encode_image = sigm_img_data.split(",")[1];
String sign_object_name = f.get("sign_object_name");
String width = f.get("width");
String height = f.get("height");
u.sp();
byte[] decode_image = Base64Coder.decode(encode_image);

ByteArrayInputStream bis = null;
String encode_resize = "";
try {
    bis = new ByteArrayInputStream(decode_image);
    ImageUtil iu = new ImageUtil();
    encode_resize = iu.resizeQulityToFile(bis, Integer.parseInt(width) , Integer.parseInt(height));
    System.out.println("encode_resize="+encode_resize);
} catch (Exception e) {
    e.printStackTrace();
} finally {
    bis.close();
}
%>
<%
    out.print("{\"resize_image\": \""+encode_type+","+encode_resize+"\""+", \"signature_object_name\":\""+sign_object_name+"\"}");
%>