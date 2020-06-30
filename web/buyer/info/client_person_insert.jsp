<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_user_level =  codeDao.getCodeArray("M013", " and code in ('10','30')");

f.addElement("user_id", null, "hname:'아이디', required:'Y', option:'userid', func:'validChkId'");
f.addElement("passwd", null, "hname:'비밀번호',required:'Y', option:'userpw', match:'passwd2', minbyte:'8', mixbyte:'20'");
f.addElement("user_name", null, "hname:'담당자명',required:'Y'");
f.addElement("position", null, "hname:'직위'");
f.addElement("email", null, "hname:'이메일', required:'Y',option:'email'");
f.addElement("tel_num", null, "hname:'전화번호', required:'Y'");
f.addElement("fax_num", null, "hname:'팩스'");
f.addElement("hp1", null, "hname:'휴대전화', required:'Y'");
f.addElement("hp2", null, "hname:'휴대전화', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", null, "hname:'휴대전화', required:'Y', minbyte:'4', maxbyte:'4'");
f.addElement("division", null, "hname:'부서', required:'Y'");
f.addElement("user_level", "30", "hname:'사용자유형 ', required:'Y'");
f.addElement("use_yn", "Y", "hname:'사용여부', required:'Y'");

if(u.isPost()&&f.validate()){
	DataObject personDao = new DataObject("tcb_person");
	//personDao.setDebug(out);
	String person_seq = personDao.getOne("select nvl(max(person_seq),0)+1 person_seq from tcb_person where member_no = '"+_member_no+"' ");
	if(person_seq.equals("")){
		u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
		return;
	}

	personDao.item("member_no",_member_no);
	personDao.item("person_seq", person_seq);
	personDao.item("user_id", f.get("user_id"));
	//personDao.item("passwd", u.md5(f.get("passwd")));
	personDao.item("passwd", u.sha256(f.get("passwd")));
	personDao.item("passdate", u.getTimeString());  // 비밀번호 변경시간 기록
	personDao.item("user_name",f.get("user_name"));
	personDao.item("position",f.get("position"));
	personDao.item("division",f.get("division"));
	personDao.item("tel_num",f.get("tel_num"));
	personDao.item("fax_num",f.get("fax_num"));
	personDao.item("hp1",f.get("hp1"));
	personDao.item("hp2",f.get("hp2"));
	personDao.item("hp3",f.get("hp3"));
	personDao.item("email",f.get("email"));
	personDao.item("user_level", f.get("user_level"));
	personDao.item("default_yn", f.get("user_level").equals("10")?"Y":"N");
	personDao.item("use_yn", f.get("use_yn"));
	personDao.item("reg_date", u.getTimeString());
	personDao.item("reg_id", auth.getString("_USER_ID"));
	personDao.item("status","1");

	DB db = new DB();
	//db.setDebug(out);
	if(auth.getString("_DEFAULT_YN").equals("Y")){
		if(f.get("user_level").equals("10")){
			db.setCommand("update tcb_person set default_yn = 'N', user_level = '30' where member_no='"+_member_no+"' and default_yn = 'Y' ", null);
		}
	}
	db.setCommand(personDao.getInsertQuery(), personDao.record);
	if(!db.executeArray()){
		u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
		return;
	}
	if(auth.getString("_MEMBER_TYPE").equals("01")||auth.getString("_MEMBER_TYPE").equals("03")) {
		u.jsAlertReplace("저장 하였습니다.\\n\\n권한 부여는 담당자별 권한관리 메뉴에서 부여하세요.", "/web/buyer/info/person_list.jsp");
	}else{
		u.jsAlertReplace("저장 하였습니다.", "/web/buyer/info/person_list.jsp");
	}
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.client_person_modify");
p.setVar("menu_cd","000120");
p.setVar("modify", false);
p.setVar("default_yn", auth.getString("_DEFAULT_YN").equals("Y"));
p.setLoop("code_user_level", u.arr2loop(code_user_level));
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("person_seq"));
p.display(out);
%>