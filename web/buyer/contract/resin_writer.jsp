<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));

DataObject pDao = new DataObject("tcb_cust");
DataSet ds = pDao.find("cont_no='"+cont_no+"' and member_no <> '" + _member_no + "'");
if(!ds.next()){
    u.jsError("�ش� �۰������� �����ϴ�.");
    return;
}

if(!ds.getString("jumin_no").equals("")) {

    String birthday = u.aseDec(ds.getString("jumin_no"));

    ds.put("birthday",  birthday.substring(0,2)+"�� "+birthday.substring(2,4)+"�� "+birthday.substring(4)+ "��");

}


p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.resin_writer");
p.setVar("popup_title", "�۰�����");
p.setVar("cust", ds);
p.setVar("form_script", f.getScript());
p.display(out);
%>