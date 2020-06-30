<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String id = u.request("id");
if(id.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

DataObject pDao = new DataObject("tcb_board");
DataSet ds = pDao.find("board_id=" + id + " and category = 'faq'");
if(!ds.next()){
	u.jsError("�ش� ���ù��� �����ϴ�.");
	return;
}

f.addElement("title", ds.getString("title"), "hname:'����', required:'Y', maxbyte:'255'");
f.addElement("open_date", u.getTimeString("yyyy-MM-dd", ds.getString("open_date")), "hname:'��������', required:'Y'");
f.addElement("open_yn", ds.getString("open_yn"), "hname:'��������'");
f.addElement("reg_id", ds.getString("reg_id"), "hname:'�����', required:'Y', maxbyte:'12'");
f.addElement("contents", ds.getString("contents"), "hname:'��������', required:'Y'");


// �Է¼���
if(u.isPost() && f.validate())
{
	DataObject dao = new DataObject("tcb_board");

	String sContents = f.get("contents");
	sContents = sContents.replaceAll("&quot;", "\"");
	sContents = sContents.replaceAll("&lt;", "<");
	sContents = sContents.replaceAll("&gt;", ">");

	dao.item("board_id", id);
	dao.item("category", "faq");
	dao.item("reg_id", f.get("reg_id"));
	dao.item("open_date", f.get("open_date").replaceAll("-", ""));
	if(f.get("open_yn").equals("Y"))
		dao.item("open_yn", "Y");
	else
		dao.item("open_yn", "N");
	dao.item("title", f.get("title"));
	dao.item("contents", sContents);
	dao.item("reg_date", u.getTimeString());

	if(!dao.update("category='faq' and board_id='"+id+"'")){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. ");
		return;
	}

	u.jsAlertReplace("���� �Ǿ����ϴ�.", "./faq_modify.jsp?"+u.getQueryString());
	//u.redirect("./place_modify.jsp?"+u.getQueryString());
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.faq_modify");
p.setVar("menu_cd","000051");
p.setVar("modify", true);
p.setVar("ds", ds);
p.setVar("list_query", u.getQueryString("id"));
p.setVar("query",u.getQueryString());			// ����
p.setVar("form_script",f.getScript());
p.display(out);
%>