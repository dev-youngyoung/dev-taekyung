<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String client_no = u.request("client_no");
String person_seq = u.request("person_seq");
String cust_person_seq = u.request("cust_person_seq");
String client_detail_seq = u.request("client_detail_seq");
if(client_no.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

CodeDao code = new CodeDao("tcb_comcode");
String[] code_member_gubun = code.getCodeArray("M001");

boolean src_view = false;

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
	u.jsError("ȸ�������� �����ϴ�.");
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

// �� ��ü �����
DataObject personDao = new DataObject();
//personDao.setDebug(out);
String sQuery = "select member_no, person_seq, user_name, hp1, hp2, hp3, division, position, tel_num, email, fax_num"
		+" from tcb_person"
		+" where member_no = '"+client_no+"'";
if( !cust_person_seq.equals("") )
	sQuery += " and person_seq = " + cust_person_seq;
DataSet person = personDao.query(sQuery);

// �� ��ü �����
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

DataSet src = new DataSet();
if( u.inArray(auth.getString("_MEMBER_TYPE"), new String[]{"01","03"})){
	DataSet login_member = mdao.find(" member_no = '"+_member_no+"' ");
	if(!login_member.next()){
	}
	if(!login_member.getString("src_depth").equals("")){
		src_view = true;
		src = mdao.query(
				"  select                                                                                                                        "
						+"         (select src_nm from tcb_src_adm where member_no = a.member_no and src_cd = substr(a.src_cd ,0,3)||'000000') l_src_nm   "
						+"       , (select src_nm from tcb_src_adm where member_no = a.member_no and src_cd = substr(a.src_cd ,0,6)||'000') m_src_nm      "
						+"       , (select src_nm from tcb_src_adm where member_no = a.member_no and src_cd = a.src_cd ) s_src_nm                         "
						+"  from tcb_src_member a                                                                                                         "
						+" where member_no = '"+_member_no+"'                                                                                             "
						+"   and src_member_no = '"+client_no+"'                                                                                          "
		);
	}
	while(src.next()){
		if(login_member.getString("src_depth").equals("01")){
			src.put("src_nm", src.getString("l_src_nm"));
		}
		if(login_member.getString("src_depth").equals("02")){
			src.put("src_nm", src.getString("l_src_nm")+">"+src.getString("m_src_nm"));
		}
		if(login_member.getString("src_depth").equals("03")){
			src.put("src_nm", src.getString("l_src_nm")+" > "+src.getString("m_src_nm")+" > "+src.getString("s_src_nm"));
		}
	}
}


f.addElement("client_status", orgperson.getString("status"), "hname:'�ŷ�����'");
f.addElement("reason", orgperson.getString("reason"), "hname:'�ŷ���������'");
f.addElement("temp_yn", orgperson.getString("temp_yn"), "hname:'��ȸ����ü'");
f.addElement("cust_detail_name", orgperson.getString("cust_detail_name"), "hname:'���ó��'");
f.addElement("cust_detail_code", orgperson.getString("cust_detail_code"), "hname:'���ó�ڵ�'");
f.addElement("update_person_seq", orgperson.getString("person_seq"), "hname:'���ó�ڵ�'");

if(u.isPost()&& f.validate()){

	DB db = new DB();
	boolean bInsert = false;
	DataObject clientDao = new DataObject("tcb_client_detail");

	if(client_detail_seq.equals(""))  // ����ڰ� �������� ���� ���
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

	// ����ڰ� ���� �Ǿ����Ƿ� ���� ��༭�� ������ ������ ���� �����Ѵ�.
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
			db.setCommand(contDao.getUpdateQuery("cont_no='"+dsCust.getString("cont_no")+"' and cont_chasu=" + dsCust.getString("cont_chasu")), contDao.record); // ��� ������

			custDao.item("user_name", dsPerson2.getString("user_name"));
			custDao.item("tel_num", dsPerson2.getString("tel_num"));
			custDao.item("hp1", dsPerson2.getString("hp1"));
			custDao.item("hp2", dsPerson2.getString("hp2"));
			custDao.item("hp3", dsPerson2.getString("hp3"));
			custDao.item("email", dsPerson2.getString("email"));
			db.setCommand(custDao.getUpdateQuery("cont_no='"+dsCust.getString("cont_no")+"' and cont_chasu=" + dsCust.getString("cont_chasu") + " and member_no='"+_member_no+"'"), custDao.record); // �������
		}
	}

	if(!db.executeArray()){
		u.jsError("���忡 ���� �Ͽ����ϴ�.");
		return;
	}

	u.jsAlertReplace("���� �Ͽ����ϴ�.", "./person_my_cust_list.jsp?"+u.getQueryString("client_no,client_detail_seq,person_seq,cust_person_seq"));
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
p.setVar("src_view", src_view);
p.setLoop("src", src);
p.setVar("sys_date", u.getTimeString());
p.setVar("person_modify", client_detail_seq.equals("") ? false : true );  // ����ڰ� ������ ��� (ȸ���������İ� �ƴ� ��쿡��) ��������
p.setVar("comment", person.size() > 1 ? true : false);  // ����ڰ� 1�� �̻��� ��� �����϶�� �ڸ�Ʈ ������..
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.display(out);
%>