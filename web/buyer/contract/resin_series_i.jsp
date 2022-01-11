<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

String[] code_status = new String[] {"10=>연재예정","20=>연재중","30=>장기휴재중","40=>연재완료"};
String cont_no = u.aseDec(u.request("cont_no"));
String type = u.request("type");

f.addElement("status", null, null);
f.addElement("sday", null, "hname:'연재 개시일', required:'Y'");
f.addElement("eday", null, "hname:'연재 완료일'");
f.addElement("fday", null, "hname:'서비스권 만료일'");
f.addElement("auto", null, null);
f.addElement("etc", null, null);

// 입력수정
if(u.isPost() && f.validate())
{
	DataObject dao = new DataObject("tcb_cont_resin");
	DataSet ds = dao.find("cont_no='"+cont_no+"'");
	boolean bUpdate = false;
	if(ds.next()) {
        bUpdate = true;
    }

    dao.item(type+"_status", f.get("status"));
    dao.item(type+"_sday", f.get("sday").replaceAll("-",""));
    dao.item(type+"_eday", f.get("eday").replaceAll("-",""));
    dao.item(type+"_fday", f.get("fday").replaceAll("-",""));
    dao.item(type+"_auto", f.get("auto"));
    dao.item(type+"_etc", f.get("etc"));

    if(bUpdate) {
        if (!dao.update("cont_no='"+cont_no+"'") ){
            u.jsError("처리중 오류가 발생 하였습니다. ");
            return;
        }
    } else {
        dao.item("cont_no", cont_no);
        if (!dao.insert()) {
            u.jsError("처리중 오류가 발생 하였습니다. ");
            return;
        }
    }

    u.jsAlert("정상적으로 저장 되었습니다. ");
    out.print("<script>");
    out.print("opener.location.reload();");
    out.print("window.close();");
    out.print("</script>");
	return;
}

String sTitle = "";
if(type.equals("e")) {
    sTitle = "영어번역";
} else if(type.equals("j")) {
    sTitle = "일본어번역 ";
} else if(type.equals("c")) {
    sTitle = "중국어번역 ";
}


p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.resin_series");
p.setVar("popup_title", sTitle + "연재정보");
p.setVar("modify", false);
p.setLoop("code_status", u.arr2loop(code_status));
p.setVar("form_script", f.getScript());
p.display(out);
%>