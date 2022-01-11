<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
f.addElement("vendcd1", null, "hname:'사업자등록번호', required:'Y', option:'number', fixbyte:'3'");
f.addElement("vendcd2", null, "hname:'사업자등록번호', required:'Y', option:'number', fixbyte:'2'");
f.addElement("vendcd3", null, "hname:'사업자등록번호', required:'Y', option:'number', fixbyte:'5'");
f.addElement("member_gubun", null, null);
f.addElement("member_slno1", null, "hnme:'법인번호', option:'number', minbyte:'6'");
f.addElement("member_slno2", null, "hnme:'법인번호', option:'number', minbyte:'7'");
f.addElement("member_name", null, "hname:'업체명', required:'Y'");
f.addElement("boss_name", null, "hname:'대표자명', required:'Y'");
f.addElement("condition", null, "hname:'업태', required:'Y'");
f.addElement("category", null, "hname:'종목', required:'Y'");
f.addElement("post_code", null, "hname:'우편번호', required:'Y', option:'number'");
f.addElement("address", null, "hname:'주소', required:'Y'");

f.addElement("user_id", null, "hname:'아이디', required:'Y', func:'validChkId'");
f.addElement("passwd", null, "hname:'비밀번호', required:'Y', option:'userpw', match:'passwd2', minbyte:'4', mixbyte:'20'");
f.addElement("user_name", null, "hname:'담당자명', required:'Y'");
f.addElement("position", null, "hname:'직위'");
f.addElement("email", null, "hname:'이메일', required:'Y', option:'email'");
f.addElement("tel_num", null, "hname:'전화번호'");
f.addElement("division", null, "hname:'부서'");
f.addElement("fax_num", null, "hname:'팩스'");
f.addElement("hp1", null, "hname:'휴대전화', required:'Y'");
f.addElement("hp2", null, "hname:'휴대전화', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", null, "hname:'휴대전화', required:'Y', minbyte:'4', maxbyte:'4'");

boolean isSuccess = false;
String memberNo = "";
String vendCd = "";

// 입력수정
if (u.isPost() && f.validate()) {
	String join_gubn = f.get("hdn_mode");
	String	sMemberNo = f.get("hdn_member_no");
	boolean	bMember = false;
	if (sMemberNo != null && sMemberNo.length() > 0) bMember = true;

	DataObject memberDao = new DataObject("tcb_member");
	/* if (!bMember) {
		if (memberDao.findCount("vendcd = '" + f.get("vendcd1") + f.get("vendcd2") + f.get("vendcd3") + "'") > 0) {
			u.jsError("이미 가입된 사업자 등록 번호 입니다.");
			return;
		}
		sMemberNo = memberDao.getOne(
				" SELECT MAX(MEMBER_NO) AS MEMBER_NO FROM( "
			   +	" SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(SUBSTR(member_no, 7)), 0) + 1),5,'0' ) member_no "
			   +	" FROM TCB_MEMBER WHERE  member_no like '" + u.getTimeString("yyyyMM") + "%' "
			   +	" UNION "
			   +	" SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(SUBSTR(member_no, 7)), 0) + 1),5,'0' ) member_no "
			   +	" FROM IF_MMBAT100 WHERE  member_no like '" + u.getTimeString("yyyyMM") + "%' "
			   +")"
			   );
		if (sMemberNo.equals("")) {
			u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
	    	return;
		}
	} */

	memberDao.item("member_no", sMemberNo);
	memberDao.item("vendcd", f.get("vendcd1") + f.get("vendcd2") + f.get("vendcd3"));
	memberDao.item("member_name", f.get("member_name"));
	memberDao.item("member_gubun", f.get("member_gubun"));
	if (f.get("member_gubun") == null || f.get("member_gubun").equals("")) {
		if (f.get("vendcd2").equals("81")
			|| f.get("vendcd2").equals("82")
			|| f.get("vendcd2").equals("83")
			|| f.get("vendcd2").equals("84")
			|| f.get("vendcd2").equals("86")
			|| f.get("vendcd2").equals("87")
			|| f.get("vendcd2").equals("88")) { // 법인사업자(본사)
			memberDao.item("member_gubun", "01");
		} else if (f.get("vendcd2").equals("85")) { // 법인사업자(지사)
			memberDao.item("member_gubun", "02");
		} else { // 개인사업자
			memberDao.item("member_gubun", "03");
		}
	}
	memberDao.item("member_type", "02");
	memberDao.item("boss_name", f.get("boss_name"));
	memberDao.item("post_code", f.get("post_code"));
	memberDao.item("address", f.get("address"));
	memberDao.item("member_slno", f.get("member_slno1") + f.get("member_slno2"));
	memberDao.item("condition", f.get("condition"));
	memberDao.item("category", f.get("category"));
	memberDao.item("join_date", u.getTimeString());
	memberDao.item("reg_date", u.getTimeString());
	memberDao.item("reg_id", f.get("user_id"));
	memberDao.item("status", "01");

	/*String sPersonSeq = f.get("hdn_person_seq");
	boolean	bPerson = false;
	if (sPersonSeq != null && sPersonSeq.length() > 0) bPerson	=	true;*/

	DataObject personDao = new DataObject("tcb_person");
	
	String sPersonSeq = personDao.getOne(
			  "select nvl(max(person_seq),0)+1 person_seq "
			+ "  from tcb_person where member_no = '" + sMemberNo + "'");
	
	
	if (sPersonSeq.equals("")) {
	  	u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
	    return;
  	}
	
	// 존재하는 아이디인지 확인 ()
	DataObject dao = new DataObject("tcb_person");
	DataSet ds =  dao.find("lower(user_id) = lower('" + f.get("user_id") + "') AND PASSWD IS NULL ");
	String person_update_seq = "";
	if (ds.next()) {
		if(sMemberNo.equals(ds.getString("member_no"))){
			person_update_seq = ds.getString("person_seq");
			sPersonSeq = ds.getString("person_seq");
		}else{
			u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
		    return;
		}
	}
	
	personDao.item("member_no", sMemberNo);
	personDao.item("person_seq", sPersonSeq);
	personDao.item("user_id", f.get("user_id"));
	if (!f.get("passwd").equals("")) personDao.item("passwd", u.sha256(f.get("passwd")));
	personDao.item("user_name", f.get("user_name"));
	personDao.item("position", f.get("position"));
	personDao.item("division", f.get("division"));
	personDao.item("tel_num", f.get("tel_num"));
	personDao.item("fax_num", f.get("fax_num"));
	personDao.item("hp1", f.get("hp1"));
	personDao.item("hp2", f.get("hp2"));
	personDao.item("hp3", f.get("hp3"));
	personDao.item("email", f.get("email"));
	personDao.item("default_yn", "Y");
	personDao.item("use_yn", "Y");
	personDao.item("reg_date", u.getTimeString());
	personDao.item("reg_id", f.get("user_id"));
	personDao.item("user_gubun", "10");
	personDao.item("status", "1");
	personDao.item("user_level", "10");//10:관리자 , 20:부서관리자 , 30:일반사용자
	personDao.item("event_agree_date", u.getCookie("event_agree_yn").equals("Y") ? u.getTimeString() : "");
	
	//농심 거래처 check(tcb_client)
	DataObject clientsDao = new DataObject("tcb_client");
	// TODO : 농심 member_no 하드코딩
	String nongshim_no = "20201000001"; //농심 member_no
	int client_cnt = clientsDao.findCount("member_no = '" + nongshim_no + "' and client_no = '" + sMemberNo + "'");
	
	DB db = new DB();
	// TCB_MEMBER
	if("NEW_M".equals(join_gubn)){
		db.setCommand(memberDao.getInsertQuery(), memberDao.record);
	}/* else{
		db.setCommand(memberDao.getUpdateQuery(" member_no = '" + sMemberNo + "' "), memberDao.record);
	} */
	
	// TCB_PERSON
	if("".equals(person_update_seq) || person_update_seq == null){
		db.setCommand(personDao.getInsertQuery(), personDao.record);
	}else{
		db.setCommand(personDao.getUpdateQuery(" member_no = '" + sMemberNo + "' and person_seq = '" + sPersonSeq + "' "), personDao.record);
	}
	
	/* if (!bMember || "NEW".equals(hdn_mode)) {
		db.setCommand(memberDao.getInsertQuery(), memberDao.record);
	} else {
		db.setCommand(memberDao.getUpdateQuery(" member_no = '" + sMemberNo + "' "), memberDao.record);
	}

	if (!bPerson) {
		db.setCommand(personDao.getInsertQuery(), personDao.record);
	} else {
		db.setCommand(personDao.getUpdateQuery(" member_no = '" + sMemberNo + "' and person_seq = '" + sPersonSeq + "' and default_yn = 'Y' "), personDao.record);
	} */
	
	if(client_cnt == 0){
		int client_seq = clientsDao.getOneInt(
				  "select nvl(max(client_seq),0)+1 client_seq "
				+ "  from tcb_client "
				+ " where member_no = '" + nongshim_no + "'");
		clientsDao.item("member_no", nongshim_no);
		clientsDao.item("client_seq", client_seq);
		clientsDao.item("client_no", sMemberNo);
		clientsDao.item("client_reg_cd", "1");
		clientsDao.item("client_reg_Date", u.getTimeString());
		
		db.setCommand(clientsDao.getInsertQuery(), clientsDao.record);
	}
	
	if (!db.executeArray()) {
		u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
		return;
	} else {
		// u.jsAlert("정상적으로 회원 가입 되었습니다.\\n\\n★★로그인 후 상단 [거래업체관리] 메뉴에서 상대방 업체를 추가하세요!!★★");
		memberNo = sMemberNo;
		vendCd = f.get("vendcd1") + f.get("vendcd2") + f.get("vendcd3");
		isSuccess = true;
	}
	
	// u.jsReplace("../");
	// return;
}

p.setLayout("default");
//p.setDebug(out);
p.setVar("menu_cd", "000127");
p.setBody("member.join");
p.setVar("title_img", "join");
p.setVar("isSuccess", isSuccess);
p.setVar("memberNo", memberNo);
p.setVar("vendCd", vendCd);
p.setVar("form_script", f.getScript());
p.display(out);
%>