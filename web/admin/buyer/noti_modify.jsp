<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
f.uploadDir=Startup.conf.getString("file.path.noti");
f.maxPostSize= 10*1024;

String id = u.request("id");
if(id.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

DataObject pDao = new DataObject("tcb_board");
DataSet ds = pDao.find("board_id=" + id + " and category = 'noti'");
if(!ds.next()){
	u.jsError("�ش� ���ù��� �����ϴ�.");
	return;
}

ds.put("file_size", u.getFileSize(ds.getLong("file_size")));

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
	dao.item("category", "noti");
	dao.item("reg_id", f.get("reg_id"));
	dao.item("open_date", f.get("open_date").replaceAll("-", ""));
	if(f.get("open_yn").equals("Y"))
		dao.item("open_yn", "Y");
	else
		dao.item("open_yn", "N");
	dao.item("title", f.get("title"));
	dao.item("contents", sContents);
	dao.item("reg_date", u.getTimeString());

	File file = f.saveFileTime("file_pds");
    if(file != null)
	{
		String file_name = file.getName();
		dao.item("doc_name", f.get("doc_name"));
		dao.item("file_path","/");
		dao.item("file_name",file_name);
		dao.item("file_ext", u.getFileExt(file_name));
		dao.item("file_size", file.length());
	}

	if(!dao.update("category='noti' and board_id='"+id+"'")){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. ");
		return;
	}

	u.jsAlertReplace("���� �Ǿ����ϴ�.", "./noti_modify.jsp?"+u.getQueryString());
	//u.redirect("./place_modify.jsp?"+u.getQueryString());
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.noti_modify");
p.setVar("menu_cd","000050");
p.setVar("modify", true);
p.setVar("ds", ds);
p.setVar("list_query", u.getQueryString("id"));
p.setVar("query",u.getQueryString());			// ����
p.setVar("form_script",f.getScript());
p.display(out);
%>