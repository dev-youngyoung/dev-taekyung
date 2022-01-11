<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String client_no = u.request("client_no");
String person_seq = u.request("person_seq");
String cust_person_seq = u.request("cust_person_seq");
String client_detail_seq = u.request("client_detail_seq");
if(client_no.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

CodeDao code = new CodeDao("tcb_comcode");
String[] code_member_gubun = code.getCodeArray("M001");

String member_slno1= "";
String member_slno2= "";

String client_seq = "";


DataObject mdao = new DataObject("tcb_member");
//mdao.setDebug(out);
DataSet member = mdao.query(
		"select a.* "
				+" , b.status client_status"
				+" , b.reason "
				+" , b.temp_yn "
				+" , b.client_seq "
				+" from tcb_member a, tcb_client b "
				+"  where a.member_no = b.client_no"
				+"    and b.member_no = '"+_member_no+"'"
				+"    and b.client_no = '"+client_no+"'"
);
if(!member.next()){
	u.jsError("회원정보가 없습니다.");
	return;
}
member.put("vendcd", u.getBizNo(member.getString("vendcd")));
member.put("member_gubun_name", u.getItem(member.getString("member_gubun"),code_member_gubun));
if(member.getString("member_slno").length()==13){
	member_slno1= member.getString("member_slno").substring(0,6);
	member_slno2= member.getString("member_slno").substring(6);
	member.put("member_slno", member_slno1+" - "+member_slno2);
}
if(member.getString("post_code").trim().length() == 6){
	String post_code1 = member.getString("post_code").substring(0,3);
	String post_code2 = member.getString("post_code").substring(3);
	member.put("post_code", post_code1+" - "+ post_code2);
}else{
	member.put("post_code", member.getString("post_code").trim());
}

client_seq = member.getString("client_seq");

// 을 업체 담당자
DataObject personDao = new DataObject();
//personDao.setDebug(out);
String sQuery = "select member_no, person_seq, user_name, hp1, hp2, hp3, division, position, tel_num, email, fax_num"
		+" from tcb_person"
		+" where member_no = '"+client_no+"'";
if( !cust_person_seq.equals("") )
	sQuery += " and person_seq = " + cust_person_seq;
DataSet person = personDao.query(sQuery);

// 갑 업체 담당자
DataObject orgpersonDao = new DataObject();
DataSet orgperson = orgpersonDao.query(
		" select td.*, tp.user_name, tf.field_name"
				+" from tcb_client_detail td "
				+"       inner join tcb_client tc on td.member_no=tc.member_no and td.client_seq=tc.client_seq"
				+"       inner join tcb_person tp on td.member_no=tp.member_no and td.person_seq=tp.person_seq"
				+"       inner join tcb_field tf on tf.member_no=tp.member_no and tf.field_seq=tp.field_seq"
				+" where td.member_no = '"+_member_no+"'"
				+"   and tc.client_no = '"+client_no+"'"
				+"   and td.person_seq = '"+person_seq+"'"
				+"   and td.client_detail_seq = '"+client_detail_seq+"'"
);
while(orgperson.next()) {
	orgperson.put("orguserinfo", orgperson.getString("field_name") + " / " + orgperson.getString("user_name"));
}

f.addElement("client_status", orgperson.getString("status"), "hname:'거래정지'");
f.addElement("reason", orgperson.getString("reason"), "hname:'거래정지사유'");
f.addElement("temp_yn", orgperson.getString("temp_yn"), "hname:'일회성업체'");
f.addElement("cust_detail_name", orgperson.getString("cust_detail_name"), "hname:'계약처명'");
f.addElement("cust_detail_code", orgperson.getString("cust_detail_code"), "hname:'계약처코드'");
f.addElement("update_person_seq", orgperson.getString("person_seq"), "hname:'계약처코드'");

if(u.isPost()&& f.validate()){

	DB db = new DB();
	boolean bInsert = false;
	DataObject clientDao = new DataObject("tcb_client_detail");

	if(client_detail_seq.equals(""))  // 담당자가 지정되지 않은 경우
	{
		client_detail_seq = clientDao.getOne(
				"  select nvl(max(client_detail_seq),0)+1 client_detail_seq "
						+"    from tcb_client_detail "
						+" where member_no = '"+_member_no+"'"
						+"   and client_seq = '"+client_seq+"'"
						+"   and person_seq = '"+person_seq+"'"
		);
		bInsert = true;

	}

	//clientDao.setDebug(out);
	clientDao.item("person_seq", f.get("update_person_seq"));
	clientDao.item("cust_detail_code", f.get("cust_detail_code"));
	clientDao.item("cust_detail_name", f.get("cust_detail_name"));
	clientDao.item("status", f.get("client_status").equals("90")?"90":"10");
	clientDao.item("reason", f.get("reason"));
	clientDao.item("reason_date", f.get("reason").equals("")?"":u.getTimeString());
	clientDao.item("reason_id",  f.get("reason").equals("")?"":auth.getString("_USER_ID"));
	clientDao.item("temp_yn", f.get("temp_yn").equals("Y")?"Y":"");
	if(bInsert)
	{
		clientDao.item("member_no", _member_no);
		clientDao.item("client_seq", client_seq);
		clientDao.item("cust_person_seq", f.get("s_cust_person_seq"));
		clientDao.item("client_detail_seq", client_detail_seq);
		db.setCommand(clientDao.getInsertQuery(), clientDao.record);
	} else {
		db.setCommand(clientDao.getUpdateQuery(" member_no = '"+_member_no+"' and client_seq = '"+client_seq+"' and client_detail_seq = " + client_detail_seq + " and person_seq = " + orgperson.getString("person_seq") + " and cust_person_seq = " + f.get("s_cust_person_seq") ), clientDao.record);

		DataObject uPersonDao = new DataObject("tcb_person");
		uPersonDao.item("user_name", f.get("user_name"));
		uPersonDao.item("division", f.get("division"));
		uPersonDao.item("position", f.get("position"));
		uPersonDao.item("tel_num", f.get("tel_num"));
		uPersonDao.item("email", f.get("email"));
		uPersonDao.item("hp1", f.get("hp1"));
		uPersonDao.item("hp2", f.get("hp2"));
		uPersonDao.item("hp3", f.get("hp3"));

		db.setCommand(uPersonDao.getUpdateQuery(" member_no = '"+client_no+"' and person_seq = " + f.get("s_cust_person_seq")), uPersonDao.record);
	}

	// 담당자가 설정 되었으므로 기존 계약서가 있으면 정보도 같이 변경한다.
	DataObject contDao = new DataObject("tcb_contmaster");
	DataObject custDao = new DataObject("tcb_cust");
	DataObject person2Dao = new DataObject("tcb_person");
	//person2Dao.setDebug(out);
	//custDao.setDebug(out);
	//String sField_seq = person2Dao.getOne("select field_seq from tcb_person where member_no='"+ _member_no +"' and person_seq=" + f.get("update_person_seq"));
	DataSet dsPerson2 = person2Dao.find("member_no='"+ _member_no +"' and person_seq=" + f.get("update_person_seq"));
	dsPerson2.next();

	DataSet dsCust = custDao.find("member_no = '"+client_no+"' and cust_detail_code='" +f.get("cust_detail_code") + "'");
	while(dsCust.next())
	{
		if(!dsPerson2.getString("field_seq").equals("")){
			contDao.item("field_seq", dsPerson2.getString("field_seq"));
			db.setCommand(contDao.getUpdateQuery("cont_no='"+dsCust.getString("cont_no")+"' and cont_chasu=" + dsCust.getString("cont_chasu")), contDao.record); // 계약 마스터

			custDao.item("user_name", dsPerson2.getString("user_name"));
			custDao.item("tel_num", dsPerson2.getString("tel_num"));
			custDao.item("hp1", dsPerson2.getString("hp1"));
			custDao.item("hp2", dsPerson2.getString("hp2"));
			custDao.item("hp3", dsPerson2.getString("hp3"));
			custDao.item("email", dsPerson2.getString("email"));
			db.setCommand(custDao.getUpdateQuery("cont_no='"+dsCust.getString("cont_no")+"' and cont_chasu=" + dsCust.getString("cont_chasu") + " and member_no='"+_member_no+"'"), custDao.record); // 계약담당자
		}
	}

	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}

	u.jsAlertReplace("저장 하였습니다.", "./person_my_cust_list.jsp?"+u.getQueryString("client_no,client_detail_seq,person_seq,cust_person_seq"));
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.person_cust_view");
p.setVar("menu_cd","000085");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000085", "btn_auth").equals("10"));
p.setVar("member",member);
p.setLoop("person", person);
p.setVar("orgperson", orgperson);
p.setVar("sys_date", u.getTimeString());
p.setVar("person_modify", client_detail_seq.equals("") ? false : true );  // 담당자가 지정된 경우 (회원가입직후가 아닌 경우에만) 수정가능
p.setVar("comment", person.size() > 1 ? true : false);  // 담당자가 1명 이상인 경우 선택하라는 코멘트 보여줌..
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.display(out);
%>