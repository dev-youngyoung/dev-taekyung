<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String email_random = u.request("email_random");
String rfile_seq = u.request("rfile_seq");
String file_path = f.get("file_path");

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
DataObject custDao = new DataObject("tcb_cust a");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and email_random = '"+email_random+"'  ");
if(!cust.next()){
    out.println("<script>");
    out.println("parent.alert('거래처 정보가 없습니다.');");
    out.println("</script>");
    return;
}
_member_no = cust.getString("member_no");

f.uploadDir = Startup.conf.getString("file.path.bcont_pdf")+file_path;
File file = f.saveFileTime("rfile_"+rfile_seq);

DataObject rfileDao = new DataObject("tcb_rfile");
String doc_name = rfileDao.getOne("select doc_name from tcb_rfile where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and rfile_seq = '"+rfile_seq+"' ");

DataObject rfileCustDao  = new DataObject("tcb_rfile_cust");
DataSet rfileCust = rfileCustDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'and member_no = '"+_member_no+"' and rfile_seq = '"+rfile_seq+"' ");
if(rfileCust.next()){
    rfileCustDao.item("file_path", file_path);
    rfileCustDao.item("file_name", file.getName());
    rfileCustDao.item("file_ext", u.getFileExt(file.getName()));
    rfileCustDao.item("file_size", file.length());
    rfileCustDao.item("reg_gubun",cont.getString("member_no").equals(_member_no)?"10":"20");
    if(!rfileCustDao.update("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+_member_no+"'  and rfile_seq = '"+rfile_seq+"' ")){
        out.println("<script>");
        out.println("parent.alert('등록처리에 실패하였습니다.');");
        out.println("</script>");
        return;
    }
}else{
    rfileCustDao.item("cont_no", cont_no);
    rfileCustDao.item("cont_chasu", cont_chasu);
    rfileCustDao.item("rfile_seq", rfile_seq);
    rfileCustDao.item("member_no", _member_no);
    rfileCustDao.item("file_path", file_path);
    rfileCustDao.item("file_name", file.getName());
    rfileCustDao.item("file_ext", u.getFileExt(file.getName()));
    rfileCustDao.item("file_size", file.length());
    rfileCustDao.item("reg_gubun",cont.getString("member_no").equals(_member_no)?"10":"20");
    if(!rfileCustDao.insert()){
        out.println("<script>");
        out.println("parent.alert('등록처리에 실패하였습니다.');");
        out.println("</script>");
        return;
    }
}
out.println("<script>");
out.println("parent.rfileUploadAfter('"+rfile_seq+"','"+u.getFileSize(file.length())+"','"+file_path+file.getName()+"','"+ doc_name+"."+u.getFileExt(file.getName())+"');");
out.println("</script>");
return;
%>