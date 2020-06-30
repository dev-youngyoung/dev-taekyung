<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
// ���� �̿� �Ⱓ üũ
DataObject useinfoDao = new DataObject("tcb_useinfo");
DataSet useinfo = useinfoDao.find("member_no='"+_member_no+"' and usestartday <='"+u.getTimeString("yyyyMMdd")+"' and useendday>='"+u.getTimeString("yyyyMMdd")+"' ");
if( !useinfo.next() )
{
	u.jsError("���� �̿�Ⱓ�� ���� �Ǿ����ϴ�.\\n\\n���̽���ť ������[02-788-9097]�� �����ϼ���.");
	return;
}

if(auth.getString("_FIELD_SEQ")== null || auth.getString("_FIELD_SEQ").equals("")){
	if(auth.getString("_DEFAULT_YN").equals("Y")){
		u.jsError("���μ� ������ �����ϴ�.\\n\\n����� ȸ���������� -> ����� ���� �޴����� �μ� ������ �Է� �Ͽ� �ּ���.");
		return;
	}else{
		u.jsError("���μ� ������ �����ϴ�.\\n\\n�⺻ �����ڿ��� �μ� ���� �Է��� ��û �ϼ���.");
		return;
	}
}

// ����� ���� ��ȸ
DataObject memberDao = new DataObject("tcb_member");
DataSet cust = memberDao.query(
 "	select a.member_no, a.vendcd, a.post_code, a.member_slno, a.address, a.member_name, a.boss_name, "
+"	        b.user_name, b.email ,b.tel_num, b.hp1, b.hp2,b.hp3, b.field_seq "
+"	  from tcb_member a, tcb_person b "
+"	 where a.member_no = b.member_no "
+"	  and a.member_no = '"+_member_no+"' "
+"	  and b.person_seq = '"+auth.getString("_PERSON_SEQ")+"'	 "
);
if(!cust.next()){
	u.jsError("����� ������ ���� ���� �ʽ��ϴ�.");
	return;
}


if(u.isPost()&&f.validate()){

	DB db = new DB();
	db.setDebug(out);
	DataObject custDao = new DataObject("tcb_cust_temp");
	//custDao.setDebug(out);
	//temp���� ä��
	int temp_seq = custDao.getOneInt(" select nvl(max(temp_seq),0)+1 from tcb_cust_temp where main_member_no = '"+_member_no+"'");

// ��ü ����
	String[] member_no = f.getArr("member_no");
	String[] signer_name = f.getArr("signer_name");
	String[] cust_sign_seq = f.getArr("cust_sign_seq");
	String[] vendcd = f.getArr("vendcd");
	String[] member_name = f.getArr("member_name");
	String[] boss_name = f.getArr("boss_name");
	String[] post_code = f.getArr("post_code");
	String[] address = f.getArr("address");
	String[] tel_num = f.getArr("tel_num");
	String[] member_slno = f.getArr("member_slno");
	String[] user_name = f.getArr("user_name");
	String[] hp1 = f.getArr("hp1");
	String[] hp2 = f.getArr("hp2");
	String[] hp3 = f.getArr("hp3");
	String[] email = f.getArr("email");
	int member_cnt = member_no == null? 0: member_no.length;
	for(int i = 0 ; i < member_cnt; i ++){
		custDao = new DataObject("tcb_cust_temp");
		custDao.item("main_member_no", _member_no);
		custDao.item("member_no",member_no[i]);
		custDao.item("temp_seq", temp_seq);
		custDao.item("sign_seq", cust_sign_seq[i]);
		custDao.item("signer_name", signer_name[i]);
		custDao.item("cust_gubun", "01");//01:����� 02:����
		custDao.item("vendcd", vendcd[i].replaceAll("-",""));
		custDao.item("member_name", member_name[i]);
		custDao.item("boss_name", boss_name[i]);
		custDao.item("post_code", post_code[i].replaceAll("-",""));
		custDao.item("address", address[i]);
		custDao.item("tel_num", tel_num[i]);
		custDao.item("member_slno", member_slno[i]);
		custDao.item("user_name", user_name[i]);
		custDao.item("hp1", hp1[i]);
		custDao.item("hp2", hp2[i]);
		custDao.item("hp3", hp3[i]);
		custDao.item("email", email[i]);
		custDao.item("display_seq", i);
		db.setCommand(custDao.getInsertQuery(), custDao.record);
	}

	if(!db.executeArray()){
		u.jsError("�ۼ��� ������ �߻� �Ͽ����ϴ�.");
		return;
	}
	u.redirect("offcont_insert.jsp?temp_seq="+temp_seq);
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.offcont_template");
p.setVar("menu_cd","000057");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000057", "btn_auth").equals("10"));
p.setLoop("code_signer", u.arr2loop(code_signer));
p.setLoop("cust", cust);
p.setVar("form_script", f.getScript());
p.display(out);
%>