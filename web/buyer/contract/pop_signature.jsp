<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%@page import="org.jsoup.*"%>
<%@page import="org.jsoup.nodes.*"%>
<%@ page import="org.jsoup.select.Elements" %>
<%!
public String setHtmlValueSignature(String html, String signature, String signature_resize){
    String cont_html = "";
    Document cont_doc = Jsoup.parse(html);

    for( Element elem : cont_doc.select("span.signature_image") ){
        elem.html("<img width=150 height=120 src=\""+signature+"\"/>");
    }

    for( Element elem : cont_doc.select("span.signature_image_resize") ){
        elem.html("<img width=150 height=120 src=\""+signature_resize+"\"/>");
    }

    return cont_doc.getElementsByTag("body").html();
}
%>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
    u.jsError("정상적인 경로로 접근 하세요.");
    return;
}

ContractDao contractDao = new ContractDao();
DataSet cont = contractDao.find("cont_no= '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cont.next()){
    u.jsError("문서정보가 없습니다.");
    return;
}

if(u.isPost() && f.validate()) {

    String encode_image = f.get("signature_image").split(",")[1];
    byte[] decode_image = Base64Coder.decode(encode_image);

    ByteArrayInputStream bis = null;
    try {
        bis = new ByteArrayInputStream(decode_image);

        //File file = new File("d:/test.png");
        ImageUtil iu = new ImageUtil();
        String encode_resize = iu.resizeQulityToFile(bis, 150, 120);
        System.out.println("encode_resize="+encode_resize);

        DB db = new DB();
        contractDao = new ContractDao();
        contractDao.item("cont_html", setHtmlValueSignature(cont.getString("cont_html"), f.get("signature_image"), "data:image/jpeg;base64,"+encode_resize));
        System.out.println(f.get("signature_image"));
        db.setCommand(contractDao.getUpdateQuery("cont_no = '"+cont_no+"'  and cont_chasu = '"+cont_chasu+"' "), contractDao.record);

        if(!db.executeArray()){
            u.jsError("저장에 실패 하였습니다.");
            return;
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        bis.close();
    }

}

p.setLayout("noquirk_popup");
//p.setDebug(out);
p.setVar("popup_title","나이스다큐 서명");
p.setBody("contract.pop_signature");
p.setVar("cont_no", cont_no);
p.setVar("cont_chasu", cont_chasu);
p.display(out);
%>