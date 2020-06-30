<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");

if(member_no.equals(""))
	member_no = _member_no;

f.maxPostSize = 1;
f.uploadDir = Startup.conf.getString("file.path.bcont_logo")+member_no;

f.addElement("ci_file", null, "hname:'CI이미지파일', required:'Y',allow:'jpg|gif|png'");


DataObject dao = new DataObject("tcb_member");
DataSet member = dao.find("member_no = '"+member_no+"'");
if(!member.next()){
	u.jsErrClose("회원정보가 존재 하지 않습니다.");
	return;
}

// 저장
if(u.isPost()&&f.validate()){

String path = Startup.conf.getString("file.path.bcont_logo")+member_no;
File file = f.saveFileTime("ci_file");

ImageUtil iu = new ImageUtil();
String file_name = iu.resizeToFile(file.getAbsolutePath(), 240, 20);

DataObject memberDao = new DataObject("tcb_member");
memberDao.item("ci_img_path", member_no+"/"+file_name);
if(!memberDao.update("member_no = '"+member_no+"'")){
	u.jsError("저장에 실패 하였습니다.");
	return;
}

if(!member.getString("ci_img_path").equals("")){
	u.delFile(Startup.conf.getString("file.path.bcont_logo")+member.getString("ci_img_path"));
}

out.print("<script typt='text/javascript'>");
out.print(" alert('정상적으로 처리되었습니다.');");
out.print(" opener.location.reload(); ");
out.print(" self.close(); ");
out.print("</script>");
return;
}


p.setLayout("popup");
//p.setDebug(out);
p.setBody("info.pop_ci_modify");
p.setVar("popup_title","회사 CI관리");
p.setVar("member", member);
p.setVar("form_script", f.getScript());
p.display(out);
%>