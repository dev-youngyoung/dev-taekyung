<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
f.addElement("title", null, "hname:'����', required:'Y', maxbyte:'255'");
f.addElement("open_date", null, "hname:'��������', required:'Y'");
f.addElement("open_yn", null, "hname:'��������'");
f.addElement("reg_id", null, "hname:'�����', required:'Y', maxbyte:'12'");
f.addElement("contents", null, "hname:'��������', required:'Y'");


// �Է¼���
if(u.isPost() && f.validate())
{
	DataObject dao = new DataObject("tcb_board");

	String id = dao.getOne(
		"select nvl(max(board_id),0)+1 board_id "+
		"  from tcb_board where category = 'faq'"
	);

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

	if(!dao.insert()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. ");
		return;
	}

	u.jsAlert("���������� ���� �Ǿ����ϴ�. ");
	u.jsReplace("faq_list.jsp");
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.faq_modify");
p.setVar("menu_cd","000051");
p.setVar("modify", false);
p.setVar("form_script", f.getScript());
p.display(out);
%>