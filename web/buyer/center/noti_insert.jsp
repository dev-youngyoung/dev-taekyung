<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

DataObject personDao = new DataObject("tcb_person a");
DataSet person = personDao.find(
			 " a.member_no = '"+auth.getString("_MEMBER_NO")+"' " 
			+" and a.person_seq = '"+auth.getString("_PERSON_SEQ")+"' " 
			+" and a.status > 0 " 
			, " a.* "
		);
if(!person.next()){
	u.jsError("담당자 정보가 없습니다.");
	return;
}
f.uploadDir=Startup.conf.getString("file.path.noti");
f.maxPostSize= 10*1024;

f.addElement("title", null, "hname:'제목', required:'Y', maxbyte:'255'");
f.addElement("open_date", null, "hname:'공지일자', required:'Y'");
f.addElement("open_yn", null, "hname:'공개여부'");
f.addElement("reg_id", person.getString("user_id"), "hname:'등록자아이디'");
f.addElement("reg_name", person.getString("user_name"), "hname:'등록자', required:'Y', maxbyte:'12'");
f.addElement("contents", null, "hname:'공지내용', required:'Y'");

//공지일자는  현재날짜 default
Calendar cal = Calendar.getInstance();
int year = cal.get(Calendar.YEAR);
int month = cal.get(Calendar.MONTH) + 1;
int day = cal.get(Calendar.DAY_OF_MONTH);
String sysDate = year + "-" + String.format("%02d", month)  + "-" + String.format("%02d", day);

// 입력수정
if(u.isPost() && f.validate())
{
	DataObject dao = new DataObject("tcb_board");

	String id = dao.getOne(
		"select nvl(max(board_id),0)+1 board_id "+
		"  from tcb_board where category = 'noti'"
	);

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
		dao.item("file_path", "/");
		dao.item("file_name", file_name);
		dao.item("file_ext", u.getFileExt(file_name));
		dao.item("file_size", file.length());
	}

	if(!dao.insert()){
		u.jsError("처리중 오류가 발생 하였습니다. ");
		return;
	}

	u.jsAlert("정상적으로 저장 되었습니다. ");
	u.jsReplace("noti_list.jsp");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("center.noti_modify");
p.setVar("menu_cd","000125");
p.setVar("modify", false);
p.setVar("form_script", f.getScript());
p.setVar("sysdate", sysDate);
p.display(out);
%>