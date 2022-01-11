<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] code_field_gubun = {"01=>부서","02=>지점"};

f.addElement("field_gubun", null, "hname:'구분', required:'Y'");
f.addElement("field_name", null, "hname:'부서/지점명', required:'Y'");
f.addElement("boss_name", null, "hname:'대표자명'");
f.addElement("telnum", null, "hname:'전화번호'");
f.addElement("post_code1", null, "hname:'우편번호', option:'number'");
f.addElement("post_code2", null, "hname:'우편번호', option:'number'");
f.addElement("address", null, "hname:'주소'");
f.addElement("use_yn", null, "hname:'사용여부', required:'Y'");

// 입력수정
if(u.isPost() && f.validate())
{
	DataObject fieldDao = new DataObject("tcb_field");

	//String field_seq = fieldDao.getOne("select nvl(max(field_seq),0)+1 field_seq from tcb_field where member_no = '"+_member_no+"'");
	String field_seq = fieldDao.getOne("select LPAD((NVL(MAX(field_seq), 0) + 1),4,'0') field_seq from tcb_field where member_no = '"+_member_no+"'");

	fieldDao.item("member_no", _member_no);
	fieldDao.item("field_seq", field_seq);
	fieldDao.item("field_name", f.get("field_name"));
	if(f.get("field_gubun").equals("02")){
		fieldDao.item("post_code", f.get("post_code1")+f.get("post_code2"));
		fieldDao.item("address", f.get("address"));
		fieldDao.item("telnum", f.get("telnum"));
		fieldDao.item("boss_name", f.get("boss_name"));
	}
	fieldDao.item("use_yn", f.get("use_yn"));
	fieldDao.item("status","1");
	fieldDao.item("field_gubun", f.get("field_gubun"));
	if(!fieldDao.insert()){
		u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
		return;
	}

	u.jsAlert("정상적으로 저장 되었습니다. ");
	u.jsReplace("place_list.jsp");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.place_modify");
p.setVar("menu_cd","000110");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000110", "btn_auth").equals("10"));
p.setVar("modify", false);
p.setLoop("code_field_gubun",u.arr2loop(code_field_gubun));
p.setVar("form_script", f.getScript());
p.display(out);
%>