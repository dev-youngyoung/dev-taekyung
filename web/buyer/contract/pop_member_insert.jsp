<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String sign_seq = u.request("sign_seq");

f.addElement("vendcd1", null, "hname:'����ڵ�Ϲ�ȣ', required:'Y'");
f.addElement("vendcd2", null, "hname:'����ڵ�Ϲ�ȣ', required:'Y'");
f.addElement("vendcd3", null, "hname:'����ڵ�Ϲ�ȣ', required:'Y'");
f.addElement("member_name", null, "hname:'��ȣ', required:'Y'");
f.addElement("boss_name", null, "hname:'��ǥ�ڸ�', required:'Y'");
f.addElement("post_code", null, "hname:'�����ȣ',required:'Y'");
f.addElement("address", null, "hname:'�ּ�', required:'Y'");
f.addElement("user_name", null, "hname:'����ڸ�', required:'Y'");
f.addElement("tel_num", null, "hname:'��ȭ��ȣ', required:'Y'");
f.addElement("hp1", null, "hname:'�޴���ȭ', required:'Y'");
f.addElement("hp2", null, "hname:'�޴���ȭ', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", null, "hname:'�޴���ȭ', required:'Y', minbyte:'4', maxbyte:'4'");
f.addElement("email", null, "hname:'�̸���', required:'Y',option:'email'");

if(u.isPost()&& f.validate()){

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

	String vendcd = f.get("vendcd1")+f.get("vendcd2")+f.get("vendcd3");
	DataObject memberDao = new DataObject("tcb_member");

/*
	if(memberDao.findCount("vendcd = '"+vendcd+"' ")>0){
		u.jsError("�̹� ��ϵǾ� �ִ� ��ü �Դϴ�. �ŷ� ��ü ����� ��û �ϼ���.");
		return;
	}
*/
	//memberDao.setDebug(out);
	// ȸ����ȣ ���ϱ�
	String member_no = f.get("chk_member_no");

	if(f.get("chk_vendcd").equals("1")){  // 1:�ű� ��ȸ��, 2:���� ��ȸ��, 3:���� ��ȸ��

		if(memberDao.findCount("vendcd='"+vendcd+"' ")>0){
			u.jsError("�̹� ��ϵǾ� �ִ� ��ü�Դϴ�. ��ü ����ڿ��� �ŷ�ó ����� ��û�ϼ���.");
			return;
		}

		member_no= memberDao.getOne(
		"SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(TO_NUMBER(SUBSTR(member_no, 7))), 0) + 1),5,'0' ) member_no"+
	    "  FROM tcb_member WHERE  member_no like '"+u.getTimeString("yyyyMM")+"%'"
	    );
	}

	if(member_no.equals("")){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �����ͷ� ���� �Ͽ� �ֽʽÿ�.");
		return;
	}
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

	DataObject personDao = new DataObject("tcb_person");
	personDao.item("member_no",member_no);
	personDao.item("person_seq", "1");
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



	DataObject clientDao = new DataObject("tcb_client");
	//clientDao.setDebug(out);
	int client_seq = clientDao.getOneInt(" select nvl(max(client_seq),0)+1 from tcb_client where member_no='"+_member_no+"' ");
	clientDao.item("member_no", _member_no);
	clientDao.item("client_seq", client_seq);
	clientDao.item("client_no",  member_no);
	clientDao.item("client_reg_cd", "1");
	clientDao.item("client_reg_date", u.getTimeString());

	DB db = new DB();
	//db.setDebug(out);
	if(f.get("chk_vendcd").equals("1")){  // 1:�ű� ��ȸ��, 2:���� ��ȸ��, 3:���� ��ȸ��
		db.setCommand(memberDao.getInsertQuery(), memberDao.record);
		db.setCommand(personDao.getInsertQuery(), personDao.record);
	}else if(f.get("chk_vendcd").equals("2")){  // ���� ��ȸ��
		db.setCommand(memberDao.getUpdateQuery("member_no='"+member_no+"'"), memberDao.record);
		db.setCommand(personDao.getUpdateQuery("member_no='"+member_no+"' and default_yn='Y'"), personDao.record);
	}

	if(clientDao.findCount(" member_no = '"+_member_no+"' and client_no ='"+member_no+"' ")<1){
		db.setCommand(clientDao.getInsertQuery(),clientDao.record);
	}

	if(!db.executeArray()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �����ͷ� ���� �Ͽ� �ֽʽÿ�.");
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
	out.println(" ,'sign_seq':'"+sign_seq+"'");
	out.println("                  }; ");
	out.println("opener.addClientInfo(data); ");
	out.println(" self.close(); ");
	out.println("</script>");
	return;
}
p.setLayout("popup");
p.setDebug(out);
p.setBody("contract.pop_member_insert");
p.setVar("popup_title","��ȸ����ü���");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>