<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String email_random = u.request("email_random");
String rfile_seq = u.request("rfile_seq");

if(cont_no.equals("")||cont_chasu.equals("")||email_random.equals("")||rfile_seq.equals("")){
    out.println("<script>");
    out.println("parent.alert('정상적인 경로로 접근하세요.');");
    out.println("</script>");
    return;
}

String _member_no = "";
DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cont.next()){
    out.println("<script>");
    out.println("parent.alert('계약정보가 없습니다.');");
    out.println("</script>");
    return;
}

if(!u.inArray(cont.getString("status"), new String[]{"20","21","30","40","41"}) ){
    out.println("<script>");
    out.println("parent.alert('구비서류를 수정 가능한 단계가 아닙니다.');");
    out.println("</script>");
    return;
}

// 계약업체 조회
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and email_random = '"+email_random+"'  ");
if(!cust.next()){
    out.println("<script>");
    out.println("parent.alert('거래처 정보가 없습니다.');");
    out.println("</script>");
    return;
}
_member_no = cust.getString("member_no");


DataObject rfileCustDao  = new DataObject("tcb_rfile_cust");
DataSet rfileCust = rfileCustDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'and member_no = '"+_member_no+"' and rfile_seq = '"+rfile_seq+"' ");
if(!rfileCust.next()){
    out.println("<script>");
    out.println("parent.alert('구비서류 정보가 없습니다.');");
    out.println("</script>");
    return;
}
if(rfileCust.getString("file_name").equals("")){
    out.println("<script>");
    out.println("parent.alert('구비서류 저장 정보가 없습니다.');");
    out.println("</script>");
    return;
}
rfileCustDao.item("file_path","");
rfileCustDao.item("file_name","");
rfileCustDao.item("file_ext","");
rfileCustDao.item("file_size","");
rfileCustDao.item("reg_gubun","");
if(!rfileCustDao.update("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+_member_no+"'  and rfile_seq = '"+rfile_seq+"' ")){
    out.println("<script>");
    out.println("parent.alert('구비서류 삭제처리에 실패 하엿습니다.');");
    out.println("</script>");
    return;
}
out.println("<script>");
out.println("parent.rfileDelAfter('"+rfile_seq+"');");
out.println("</script>");
return;
%>