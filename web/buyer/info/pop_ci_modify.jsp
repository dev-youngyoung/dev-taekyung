<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");

if(member_no.equals(""))
	member_no = _member_no;

f.maxPostSize = 1;
f.uploadDir = Startup.conf.getString("file.path.bcont_logo")+member_no;

f.addElement("ci_file", null, "hname:'CI�̹�������', required:'Y',allow:'jpg|gif|png'");


DataObject dao = new DataObject("tcb_member");
DataSet member = dao.find("member_no = '"+member_no+"'");
if(!member.next()){
	u.jsErrClose("ȸ�������� ���� ���� �ʽ��ϴ�.");
	return;
}

// ����
if(u.isPost()&&f.validate()){

String path = Startup.conf.getString("file.path.bcont_logo")+member_no;
File file = f.saveFileTime("ci_file");

ImageUtil iu = new ImageUtil();
String file_name = iu.resizeToFile(file.getAbsolutePath(), 240, 20);

DataObject memberDao = new DataObject("tcb_member");
memberDao.item("ci_img_path", member_no+"/"+file_name);
if(!memberDao.update("member_no = '"+member_no+"'")){
	u.jsError("���忡 ���� �Ͽ����ϴ�.");
	return;
}

if(!member.getString("ci_img_path").equals("")){
	u.delFile(Startup.conf.getString("file.path.bcont_logo")+member.getString("ci_img_path"));
}

out.print("<script typt='text/javascript'>");
out.print(" alert('���������� ó���Ǿ����ϴ�.');");
out.print(" opener.location.reload(); ");
out.print(" self.close(); ");
out.print("</script>");
return;
}


p.setLayout("popup");
//p.setDebug(out);
p.setBody("info.pop_ci_modify");
p.setVar("popup_title","ȸ�� CI����");
p.setVar("member", member);
p.setVar("form_script", f.getScript());
p.display(out);
%>