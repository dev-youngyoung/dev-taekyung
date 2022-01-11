<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
if (auth.getString("_FIELD_SEQ") == null || auth.getString("_FIELD_SEQ").equals("")) {
	if (auth.getString("_DEFAULT_YN").equals("Y")) {
		u.jsError("담당부서 정보가 없습니다.\\n\\n상단의 회사정보수정 -> 담당자 관리 메뉴에서 부서 정보를 입력 하여 주세요.");
		return;
	} else {
		u.jsError("담당부서 정보가 없습니다.\\n\\n기본 관리자에게 부서 정보 입력을 요청 하세요.");
		return;
	}
}

// 카카오, kt m&s, 위메프는 부서별로 양식을 지정할 수 있다. (field_seq = null 은 공통양식)
String sfield_seq = "";
if (!auth.getString("_DEFAULT_YN").equals("Y")) {
//	sfield_seq = " and ( field_seq is null or '^'|| replace(replace(field_seq,' ',''),',','^')||'^' like '%^'||" + auth.getString("_FIELD_SEQ") + "||'^%' )";
	if(!"9999".equals(auth.getString("_FIELD_SEQ"))){	//전산관리자(NDS)
		sfield_seq 	= " and template_cd in ("
					+ " select template_cd from tcb_cont_template_field"
					+ " where field_seq = '0000' or field_seq = "
					+ auth.getString("_FIELD_SEQ")
					+ ")";
	}
}

DataObject templateDao = new DataObject("tcb_cont_template");
DataSet ds = templateDao.find(
		  " status > 0 and template_type in ('00', '10') and member_no like '%" + _member_no + "%' and use_yn = 'Y' and (doc_type is null or doc_type = 2) " + sfield_seq
		, " template_cd, nvl(display_name,template_name) template_name "
		, " display_seq asc, template_cd desc");

f.addElement("template_cd", null, "hname:'계약서종류', required:'Y'");

if (u.isPost() && f.validate()) {
/* 구비서류 영구 등록 삭제
	DB db = new DB();
	db.setCommand("delete from tcb_rfile_template where template_cd = '" + f.get("template_cd") + "' and member_no = '" + _member_no + "' and reg_type = '20' ", null);

	String[] attch_yn = f.getArr("attch_yn");
	String[] doc_name = f.getArr("doc_name");
	String[] reg_type = f.getArr("reg_type");
	int doc_cnt = doc_name == null ? 0 : doc_name.length;
	for (int i=0; i<doc_cnt; i++) {
		if (reg_type[i].equals("10")) continue;
		DataObject rfile = new DataObject("tcb_rfile_template");
		rfile.item("template_cd", f.get("template_cd"));
		rfile.item("member_no", _member_no);
		rfile.item("rfile_seq", i + 1);
		rfile.item("doc_name", doc_name[i]);
		rfile.item("attch_yn", attch_yn[i].equals("Y") ? "Y" : "N");
		rfile.item("reg_type", "20");
		db.setCommand(rfile.getInsertQuery(), rfile.record);
	}

	if (!db.executeArray()) {
		u.jsError("처리에 실패 하였습니다.\\n\\n 고객센터로 문의해 주세요.");
		return;
	}
*/
	String sign_types = templateDao.getOne("select sign_types from tcb_cont_template where template_cd = '" + f.get("template_cd") + "' ");
    if (sign_types.equals("")) {
		u.redirect("contract_insert.jsp?template_cd=" + f.get("template_cd"));
    } else {
		u.redirect("contract_msign_insert.jsp?template_cd=" + f.get("template_cd"));
    }
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_select_template");
p.setVar("menu_cd", "000053");
p.setVar("auth_select", _authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), "000053", "btn_auth").equals("10"));
p.setLoop("template", ds);
p.setVar("form_script", f.getScript());
p.display(out);
%>