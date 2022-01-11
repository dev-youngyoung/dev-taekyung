<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] code_field_gubun = {"01=>부서","02=>지점"};

String id = u.request("id");
if(id.equals("")){
	//u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}


DataObject fieldDao = new DataObject("tcb_field");
DataSet field = fieldDao.find(" status > 0 and member_no="+_member_no+" and field_seq="+id);
if(!field.next()){
	u.jsError("부서/지점 정보가 없습니다.");
	return;
}

f.addElement("field_gubun", field.getString("field_gubun"), "hname:'구분'");
f.addElement("field_name", field.getString("field_name"), "hname:'부서/지점명', required:'Y'");
f.addElement("boss_name", field.getString("boss_name"), "hname:'대표자명'");
f.addElement("telnum", field.getString("telnum"), "hname:'전화번호'");
f.addElement("post_code", field.getString("post_code"), "hname:'우편번호', option:'number'");
f.addElement("address", field.getString("address"), "hname:'주소'");
f.addElement("use_yn", field.getString("use_yn"), "hname:'사용여부', required:'Y'");


// 입력수정
if(u.isPost() && f.validate())
{
	fieldDao = new DataObject("tcb_field");

	fieldDao.item("member_no", _member_no);
	fieldDao.item("field_seq", id);
	fieldDao.item("field_name", f.get("field_name"));
	if(f.get("field_gubun").equals("02")){
		fieldDao.item("post_code", f.get("post_code"));
		fieldDao.item("address", f.get("address"));
		fieldDao.item("telnum", f.get("telnum"));
		fieldDao.item("boss_name", f.get("boss_name"));
	}
	fieldDao.item("use_yn", f.get("use_yn"));
	fieldDao.item("field_gubun", f.get("field_gubun"));
	if(!fieldDao.update("member_no='"+_member_no+"' and field_seq="+id)){
		u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
		return;
	}

	u.jsAlertReplace("저장 되었습니다.", "./place_modify.jsp?"+u.getQueryString());
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("info.place_modify");
p.setVar("menu_cd","000110");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000110", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setVar("field", field);
p.setLoop("code_field_gubun",u.arr2loop(code_field_gubun));
p.setVar("list_query",u.getQueryString("id"));	// 리스트로 돌아갈때
p.setVar("query",u.getQueryString());			// 삭제
p.setVar("form_script", f.getScript());
p.display(out);
%>