<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
f.addElement("member_name", null, "hname:'이름',required:'Y'");
f.addElement("birth_date", null, "hname:'생년월일', required:'Y', minbyte:'10', mixbyte:'10'");
f.addElement("gender", null, "hname:'성별', required:'Y'");
f.addElement("user_id", null, "hname:'아이디', required:'Y', option:'userid', func:'validChkId'");
f.addElement("passwd", null, "hname:'비밀번호',required:'Y', option:'userpw', match:'passwd2', minbyte:'4', mixbyte:'20'");
f.addElement("post_code", null, "hname:'우편번호',required:'Y', option:'number'");
f.addElement("address", null, "hname:'주소', required:'Y'");
f.addElement("hp1", null, "hname:'휴대전화', required:'Y'");
f.addElement("hp2", null, "hname:'휴대전화', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", null, "hname:'휴대전화', required:'Y', minbyte:'4', maxbyte:'4'");
f.addElement("org_member_no", null, "hname:'거래처', required:'Y'");
f.addElement("email", null, "hname:'이메일', required:'Y',option:'email'");
f.addElement("tel_num", null, "hname:'전화번호'");
f.addElement("fax_num", null, "hname:'팩스번호'");

// 입력수정
if(u.isPost() && f.validate()){
	
	Security security = new	Security();
	
	String member_no = f.get("member_no");
	String birth_date = f.get("birth_date").replaceAll("-", "");
	String gender = f.get("gender");
	
	if(Integer.parseInt(f.get("birth_date").substring(0,4)) >= 2000){
		gender = f.get("gender").equals("1") ? "3" : "4";
	} else {
		gender = f.get("gender");
	}
	String jumin_no = birth_date.substring(2)+gender;
	
	DataObject personDao = new DataObject("tcb_person");
	DataSet person = personDao.query(
			  "select a.member_no, a.status, c.boss_ci                 "
			 +"  from tcb_member a, tcb_person b, tcb_member_boss c    "
			 +" where a.member_no = b.member_no                        "
			 +"   and a.member_no = c.member_no(+)                     "
			 +"   and a.member_gubun = '04'                            "
			 +"   and b.jumin_no = '"+security.AESencrypt(jumin_no)+"' "
			 +"   and a.member_name = '"+f.get("member_name")+"'       "
			 +"   and b.hp1 = '"+f.get("hp1")+"'                       "
			 +"   and b.hp2 = '"+f.get("hp2")+"'                       "
			 +"   and b.hp3 = '"+f.get("hp3")+"'                       "
			);
	if(person.next()){
		if(!person.getString("status").equals("02")){
			u.jsError("회원 정보가 있습니다. \n\n중복된 정보고 회원 가입 될 수 없습니다.");
			return;
		}
	}
	
	
	DB db = new DB();
	if(member_no.equals("")){
		DataObject memberDao = new DataObject("tcb_member");
		member_no = memberDao.getOne(
				"SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(SUBSTR(member_no, 7)), 0) + 1),5,'0' ) member_no"
				+"  FROM tcb_member WHERE  member_no like '"+u.getTimeString("yyyyMM")+"%'"
				);
		
		memberDao = new DataObject("tcb_member");
		memberDao.item("member_no", member_no);
		memberDao.item("vendcd", "");
		memberDao.item("member_name", f.get("member_name"));
		memberDao.item("member_gubun", "04");
		memberDao.item("member_type", "02");
		memberDao.item("boss_name", f.get("member_name"));
		memberDao.item("post_code", f.get("post_code"));
		memberDao.item("address", f.get("address"));
		memberDao.item("member_slno", "");
		memberDao.item("condition", "");
		memberDao.item("category", "");
		memberDao.item("join_date", u.getTimeString());
		memberDao.item("reg_date", u.getTimeString());
		memberDao.item("reg_id", f.get("user_id"));
		memberDao.item("status", "01");
		memberDao.item("market_yn", u.getCookie("event_agree_yn").equals("Y")?"Y":"N");
		db.setCommand(memberDao.getInsertQuery(), memberDao.record);

		personDao = new DataObject("tcb_person");
		personDao.item("member_no", member_no);
		personDao.item("person_seq", "1");
		personDao.item("user_id", f.get("user_id"));
		personDao.item("passwd", u.sha256(f.get("passwd")));
		personDao.item("user_name", f.get("member_name"));
		personDao.item("position", "");
		personDao.item("division", "");
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
		personDao.item("jumin_no",	security.AESencrypt(jumin_no));
		personDao.item("status", "1");
		personDao.item("event_agree_date", u.getCookie("event_agree_yn").equals("Y")?u.getTimeString():"");
		db.setCommand(personDao.getInsertQuery(), personDao.record);
		
		//상대방 업체에 등록
		DataObject clientDao = new DataObject("tcb_client");
		//dao.setDebug(out);
		int client_seq = clientDao.getOneInt(
			"  select nvl(max(client_seq),0)+1 client_seq "+
			"    from tcb_client "+
			"   where member_no = '"+f.get("org_member_no")+"'"
		);
		clientDao.item("member_no", f.get("org_member_no"));
		clientDao.item("client_seq", client_seq);
		clientDao.item("client_no", member_no);
		clientDao.item("client_reg_cd", "1");
		clientDao.item("client_reg_date", u.getTimeString());
		db.setCommand(clientDao.getInsertQuery(), clientDao.record);
		
	}else{
		DataObject memberDao = new DataObject("tcb_member");
		memberDao.item("member_name", f.get("member_name"));
		memberDao.item("post_code", f.get("post_code"));
		memberDao.item("address", f.get("address"));
		memberDao.item("join_date", u.getTimeString());
		memberDao.item("status", "01");
		memberDao.item("market_yn", u.getCookie("event_agree_yn").equals("Y")?"Y":"N");
		db.setCommand(memberDao.getUpdateQuery("member_no = '"+member_no+"'"), memberDao.record);

		personDao = new DataObject("tcb_person");
		personDao.item("user_id", f.get("user_id"));
		personDao.item("passwd", u.sha256(f.get("passwd")));
		personDao.item("hp1", f.get("hp1"));
		personDao.item("hp2", f.get("hp2"));
		personDao.item("hp3", f.get("hp3"));
		personDao.item("email", f.get("email"));
		personDao.item("tel_num", f.get("tel_num"));
		personDao.item("fax_num", f.get("fax_num"));
		personDao.item("default_yn", "Y");
		personDao.item("use_yn", "Y");
		personDao.item("reg_date", u.getTimeString());
		personDao.item("reg_id", f.get("user_id"));
		personDao.item("user_gubun", "10");
		personDao.item("jumin_no",	security.AESencrypt(jumin_no));
		personDao.item("status", "1");
		personDao.item("event_agree_date", u.getCookie("event_agree_yn").equals("Y")?u.getTimeString():"");
		db.setCommand(personDao.getUpdateQuery("member_no = '"+member_no+"' and person_seq = '1'"), personDao.record);
		
		DataObject memberBossDao = new DataObject("tcb_member_boss");
		if(memberBossDao.findCount(" member_no = '"+member_no+"' ")<1){//공인인증서 메일 서명 회원의 경우 인증정보 수집
			memberBossDao.item("member_no", member_no);
			memberBossDao.item("seq","1");
			memberBossDao.item("boss_name",f.get("member_name"));
			memberBossDao.item("boss_birth_date",f.get("birth_date"));
			memberBossDao.item("boss_gender", u.inArray(f.get("gender"), new String[]{"1","3"})?"남":"여" );
			memberBossDao.item("boss_hp1", f.get("hp1"));
			memberBossDao.item("boss_hp2", f.get("hp2"));
			memberBossDao.item("boss_hp3", f.get("hp3"));
			memberBossDao.item("boss_email", f.get("email"));
			memberBossDao.item("boss_ci", f.get("boss_ci"));
			memberBossDao.item("ci_date", u.getTimeString());
			memberBossDao.item("status", "10");
			db.setCommand(memberBossDao.getInsertQuery() , memberBossDao.record);
		}else{
			//있는 경우 기존 계약과 메칭이 자동으로 될껄?
		}
	}


	if(!db.executeArray()){
		u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
		return;
	}
	u.jsAlert("정상적으로 회원 가입되었습니다. 로그인후 사용 하여 주십시오.");
	u.jsReplace("../");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("member.join_person");
p.setVar("menu_cd","000127");
p.setVar("form_script", f.getScript());
p.display(out);
%>