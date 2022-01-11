<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%

String sign_seq = u.request("sign_seq");

f.addElement("vendcd1", null, "hname:'사업자등록번호', required:'Y'");
f.addElement("vendcd2", null, "hname:'사업자등록번호', required:'Y'");
f.addElement("vendcd3", null, "hname:'사업자등록번호', required:'Y'");
f.addElement("member_name", null, "hname:'상호', required:'Y'");
f.addElement("boss_name", null, "hname:'대표자명', required:'Y'");
f.addElement("post_code", null, "hname:'우편번호',required:'Y', option:'number'");
f.addElement("address", null, "hname:'주소', required:'Y'");
f.addElement("user_name", null, "hname:'담당자명', required:'Y'");
f.addElement("tel_num", null, "hname:'전화번호', required:'Y'");
f.addElement("hp1", null, "hname:'휴대전화', required:'Y'");
f.addElement("hp2", null, "hname:'휴대전화', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", null, "hname:'휴대전화', required:'Y', minbyte:'4', maxbyte:'4'");
f.addElement("email", null, "hname:'이메일', required:'Y',option:'email'");
f.addElement("cust_detail_code", null, null);
f.addElement("cust_detail_name", null, "hname:'계약처명', required:'Y'");

if(u.isPost()&& f.validate()){
	boolean bNewMember = false;
	boolean bNewPerson = false;
	boolean bNewClient = false;
	boolean bNewClientDetail = false;

	int person_seq = 0;
	String member_gubun = "";
	String[] arr = {"81","82","83","84","86","87","88"};
	if( u.inArray(f.get("vendcd2"),arr)){
		member_gubun = "01";
	}else
	if(f.get("vendcd2").equals("85")){
		member_gubun = "02";
	}else{
		member_gubun = "03";
	}

	String member_no = f.get("chk_member_no");
	String vendcd = f.get("vendcd1")+f.get("vendcd2")+f.get("vendcd3");
	DataObject memberDao = new DataObject("tcb_member");
	DataSet member= memberDao.find("vendcd = '"+vendcd+"' ");
	if(!member.next()){
		// 회원번호 구하기
		member_no= memberDao.getOne(
				" SELECT MAX(MEMBER_NO) AS MEMBER_NO FROM( "
			   +	" SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(SUBSTR(member_no, 7)), 0) + 1),5,'0' ) member_no "
			   +	" FROM TCB_MEMBER WHERE  member_no like '" + u.getTimeString("yyyyMM") + "%' "
			   +	" UNION "
			   +	" SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(SUBSTR(member_no, 7)), 0) + 1),5,'0' ) member_no "
			   +	" FROM IF_MMBAT100 WHERE  member_no like '" + u.getTimeString("yyyyMM") + "%' "
			   +")"
	    );

		if(member_no.equals("")){
			u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
			return;
		}
		bNewMember = true;
		
		memberDao.item("member_no",member_no);
		memberDao.item("vendcd", vendcd);
		memberDao.item("member_name", f.get("member_name"));
		memberDao.item("member_gubun", member_gubun);
		memberDao.item("member_type","02");//
		memberDao.item("boss_name", f.get("boss_name"));
		memberDao.item("post_code", f.get("post_code"));
		memberDao.item("address",f.get("address"));
		memberDao.item("reg_date", u.getTimeString());
		memberDao.item("reg_id", f.get("user_id"));
		memberDao.item("status","02");
	}else{
		
		if(member.getString("status").equals("01")){
			memberDao.item("member_name", f.get("member_name"));
			memberDao.item("boss_name", f.get("boss_name"));
			memberDao.item("post_code", f.get("post_code"));
			memberDao.item("address",f.get("address"));
			memberDao.item("reg_date", u.getTimeString());
			memberDao.item("reg_id", f.get("user_id"));
		}else if(member.getString("status").equals("02")){
			memberDao.item("member_no",member_no);
			memberDao.item("vendcd", vendcd);
			memberDao.item("member_name", f.get("member_name"));
			memberDao.item("member_gubun", member_gubun);
			memberDao.item("member_type","02");//
			memberDao.item("boss_name", f.get("boss_name"));
			memberDao.item("post_code", f.get("post_code"));
			memberDao.item("address",f.get("address"));
			memberDao.item("reg_date", u.getTimeString());
			memberDao.item("reg_id", f.get("user_id"));
		}
	}

	DataObject personDao = new DataObject("tcb_person");
	if(bNewMember)
	{
		person_seq = 1;
		personDao.item("member_no",member_no);
		personDao.item("person_seq", person_seq);
		personDao.item("user_name",f.get("user_name"));
		personDao.item("tel_num",f.get("tel_num"));
		personDao.item("hp1",f.get("hp1"));
		personDao.item("hp2",f.get("hp2"));
		personDao.item("hp3",f.get("hp3"));
		personDao.item("email",f.get("email"));
		personDao.item("default_yn", "Y");
		personDao.item("user_level", "10");
		personDao.item("use_yn","N");
		personDao.item("reg_date", u.getTimeString());
		personDao.item("reg_id", f.get("user_id"));
		personDao.item("user_gubun", "10");
		personDao.item("status", "1");

		bNewPerson = true;
	} else {
		// 같은 이름의 사용자 조사
		person_seq= personDao.getOneInt("SELECT person_seq FROM tcb_person WHERE member_no = '" +member_no+ "' and user_name = '"+ f.get("user_name")+"'");

		if(person_seq == 0) // 같은 사용자가 없으면 추가
		{
			person_seq = personDao.getOneInt(" select nvl(max(person_seq),0)+1 from tcb_person where member_no='"+member_no+"' ");
			bNewPerson = true;
		}

		personDao.item("member_no",member_no);
		personDao.item("person_seq", person_seq);
		personDao.item("user_name",f.get("user_name"));
		personDao.item("tel_num",f.get("tel_num"));
		personDao.item("hp1",f.get("hp1"));
		personDao.item("hp2",f.get("hp2"));
		personDao.item("hp3",f.get("hp3"));
		personDao.item("email",f.get("email"));
		if(bNewPerson)
			personDao.item("default_yn", "N");
		personDao.item("use_yn","Y");
		personDao.item("reg_date", u.getTimeString());
		personDao.item("reg_id", f.get("user_id"));
		personDao.item("user_gubun", "10");
		personDao.item("status", "1");

	}

	DataObject clientDao = new DataObject("tcb_client");
	//clientDao.setDebug(out);
	int client_seq = 0;
	client_seq= clientDao.getOneInt("SELECT client_seq FROM tcb_client WHERE member_no = '" +_member_no+ "' and client_no = '"+ member_no+"'");
	if(client_seq == 0) // 거래처로 등록되어 있지 않다면
	{
		client_seq = clientDao.getOneInt(" select nvl(max(client_seq),0)+1 from tcb_client where member_no='"+_member_no+"' ");
		clientDao.item("member_no", _member_no);
		clientDao.item("client_seq", client_seq);
		clientDao.item("client_no",  member_no);
		clientDao.item("client_reg_cd", "1");
		clientDao.item("client_reg_date", u.getTimeString());

		bNewClient = true;
	}

	DataObject clientDetailDao = new DataObject("tcb_client_detail");
	//clientDetailDao.setDebug(out);
	int client_Detail_seq = 0;
	client_Detail_seq= clientDetailDao.getOneInt("SELECT client_detail_seq FROM tcb_client_detail WHERE member_no = '" +_member_no+ "' and client_seq = '"+ client_seq+"' and cust_detail_code = '"+f.get("cust_detail_code")+"'");
	if(client_Detail_seq == 0) // 거래처 코드가 등록되어 있지 않다면
	{
		client_Detail_seq = clientDao.getOneInt(" select nvl(max(client_detail_seq),0)+1 from tcb_client_detail where member_no = '" +_member_no+ "' and client_seq = '"+ client_seq+"' and person_seq = " + auth.getString("_PERSON_SEQ") );
		bNewClientDetail = true;
	} else {
		u.jsError("이미 등록된 계약처 코드입니다. 다시 한번 확인하시기 바랍니다.");
		return;
	}
	clientDetailDao.item("member_no", _member_no);
	clientDetailDao.item("client_seq", client_seq);
	clientDetailDao.item("person_seq", auth.getString("_PERSON_SEQ"));
	clientDetailDao.item("client_detail_seq", client_Detail_seq);
	clientDetailDao.item("cust_detail_name", f.get("cust_detail_name"));
	clientDetailDao.item("cust_detail_code", f.get("cust_detail_code"));
	clientDetailDao.item("cust_person_seq", person_seq);

	DB db = new DB();
	//db.setDebug(out);
	if(bNewMember){
		db.setCommand(memberDao.getInsertQuery(), memberDao.record);
	} else {
		db.setCommand(memberDao.getUpdateQuery("member_no='"+member_no+"'"), memberDao.record);
	}

	if(bNewPerson){
		db.setCommand(personDao.getInsertQuery(), personDao.record);
	} else {
		db.setCommand(personDao.getUpdateQuery("member_no='"+member_no+"' and person_seq=" + person_seq), personDao.record);
	}

	if(bNewClient){
		db.setCommand(clientDao.getInsertQuery(),clientDao.record);
	}

	if(bNewClientDetail){
		db.setCommand(clientDetailDao.getInsertQuery(),clientDetailDao.record);
	}

	if(!db.executeArray()){
		u.jsError("처리중 오류가 발생 하였습니다. 고객센터로 문의 하여 주십시오.");
		return;
	}
	
	out.println("<script>");
	out.println("var data = { ");
	out.println("  'member_no':'"+member_no+"' "); 
	out.println(" ,'vendcd':'"+vendcd+"' ");
	out.println(" ,'member_slno':'' ");
	out.println(" ,'member_name':'"+f.get("member_name")+"'");
	out.println(" ,'post_code':'"+f.get("post_code")+"'");
	out.println(" ,'address':'"+f.get("address")+"'");
	out.println(" ,'boss_name':'"+f.get("boss_name")+"'");
	out.println(" ,'member_gubun':'"+member_gubun+"'");
	out.println(" ,'user_name':'"+f.get("user_name")+"'");
	out.println(" ,'tel_num':'"+f.get("tel_num")+"'");
	out.println(" ,'hp1':'"+f.get("hp1")+"'");
	out.println(" ,'hp2':'"+f.get("hp2")+"'");
	out.println(" ,'hp3':'"+f.get("hp3")+"'");
	out.println(" ,'email':'"+f.get("email")+"'");
	out.println(" ,'cust_detail_code':'"+f.get("cust_detail_code")+"'");
	out.println(" ,'sign_seq':'"+sign_seq+"'");
	out.println("                  }; ");
	out.println("opener.addClientInfo(data); ");
	out.println(" self.close(); ");
	out.println("</script>");
	return;
}
p.setLayout("popup");
p.setDebug(out);
p.setBody("contract.pop_member_insert2");
p.setVar("popup_title","신규계약처등록");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>