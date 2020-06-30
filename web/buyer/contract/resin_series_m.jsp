<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String[] code_status = new String[] {"10=>���翹��","20=>������","30=>���������","40=>����Ϸ�"};
String cont_no = u.aseDec(u.request("cont_no"));
String type = u.request("type");

DataObject pDao = new DataObject("tcb_cont_resin");
DataSet ds = pDao.find("cont_no='"+cont_no+"'");
if(!ds.next()){
    u.jsError("�ش� ���������� �����ϴ�.");
    return;
}

f.addElement("status", ds.getString(type+"_status"), null );
f.addElement("sday", u.getTimeString("yyyy-MM-dd", ds.getString(type+"_sday")), "hname:'���� ������', required:'Y'");
f.addElement("eday", u.getTimeString("yyyy-MM-dd",ds.getString(type+"_eday")), "hname:'���� �Ϸ���'");
f.addElement("fday", u.getTimeString("yyyy-MM-dd",ds.getString(type+"_fday")), "hname:'���񽺱� ������'");
f.addElement("auto", ds.getString(type+"_auto"), null);
f.addElement("etc", ds.getString(type+"_etc"), null);

// �Է¼���
if(u.isPost() && f.validate())
{
	DataObject dao = new DataObject("tcb_cont_resin");

    dao.item(type+"_status", f.get("status"));
    dao.item(type+"_sday", f.get("sday").replaceAll("-",""));
    dao.item(type+"_eday", f.get("eday").replaceAll("-",""));
    dao.item(type+"_fday", f.get("fday").replaceAll("-",""));
    dao.item(type+"_auto", f.get("auto"));
    dao.item(type+"_etc", f.get("etc"));
    if (!dao.update("cont_no='"+cont_no+"'") ){
        u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. ");
        return;
    }

	u.jsAlert("���������� ���� �Ǿ����ϴ�. ");
	out.print("<script>");
	out.print("opener.location.reload();");
	out.print("window.close();");
	out.print("</script>");
	return;
}

String sTitle = "";
if(type.equals("e")) {
    sTitle = "�������";
} else if(type.equals("j")) {
    sTitle = "�Ϻ������ ";
} else if(type.equals("c")) {
    sTitle = "�߱������ ";
}


p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.resin_series");
p.setVar("popup_title", sTitle + "��������");
p.setVar("modify", false);
p.setLoop("code_status", u.arr2loop(code_status));
p.setVar("form_script", f.getScript());
p.display(out);
%>