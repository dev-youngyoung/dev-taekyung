<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_status = {"10=>�ӽ�����","20=>��û��","30=>������û","31=>������û","40=>�ɻ�Ϸ�","50=>�Ϸ�"};

//NH���� ���� ���� ��Ͼ�ü ��û ���� ������
String noti_seq = u.request("noti_seq");
if(noti_seq.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

DataObject notiDao = new DataObject("tcb_recruit_noti");
DataSet noti = notiDao.find("member_no = '20160901598' and noti_seq = '"+noti_seq+"' ");
if(!noti.next()){
	u.jsError("���� ������ �����ϴ�.");
	return;
}
noti.put("req_sdate", u.getTimeString("yyyy-MM-dd", noti.getString("req_sdate")));
noti.put("req_edate", u.getTimeString("yyyy-MM-dd", noti.getString("req_edate")));
noti.put("noti_date", u.getTimeString("yyyy-MM-dd", noti.getString("noti_date")));


DataObject custDao = new DataObject("tcb_recruit_cust");
DataSet cust = custDao.find(" member_no = '20160901598' and noti_seq = '"+noti_seq+"'  and client_no = '"+_member_no+"' ");
if(cust.next()){
	String[] vendcds = u.getBizNo(cust.getString("vendcd")).split("-"); 
	cust.put("vendcd1", vendcds[0]);
	cust.put("vendcd2", vendcds[1]);
	cust.put("vendcd3", vendcds[2]);
	cust.put("status_nm", u.getItem(cust.getString("status"), code_status));
	
	cust.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm", cust.getString("mod_req_date")));
	if(!cust.getString("mod_req_id").equals("")){
		cust.put("mod_req_name", new DataObject("tcb_person").getOne("select user_name from tcb_person where member_no = '20160901598' and user_id = '"+cust.getString("mod_req_id")+"' "));
	}
	cust.put("mod_req_reason", u.nl2br(cust.getString("mod_req_reason")));
	
}else{
	cust = new DataSet();
	cust.addRow();
	DataObject memberDao = new DataObject("tcb_member");
	DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
	if(member.next()){
		cust.put("client_no", member.getString("member_no"));
		cust.put("member_name", member.getString("member_name"));
		cust.put("vendcd", member.getString("vendcd"));
		String[] vendcds = u.getBizNo(member.getString("vendcd")).split("-"); 
		cust.put("vendcd1", vendcds[0]);
		cust.put("vendcd2", vendcds[1]);
		cust.put("vendcd3", vendcds[2]);
		cust.put("post_code", member.getString("post_code").trim());
		cust.put("address", member.getString("address"));
		cust.put("boss_name", member.getString("boss_name"));
	}
	DataObject personDao = new DataObject("tcb_person");
	DataSet person = personDao.find("member_no = '"+_member_no+"' and person_seq = '"+auth.getString("_PERSON_SEQ")+"' ");
	if(person.next()){
		cust.put("user_name", person.getString("user_name"));
		cust.put("tel_num", person.getString("tel_num"));		
		cust.put("fax_num", person.getString("fax_num"));
		cust.put("hp1", person.getString("hp1"));		
		cust.put("hp2", person.getString("hp2"));		
		cust.put("hp3", person.getString("hp3"));		
		cust.put("email", person.getString("email"));		
	}
}



if(u.isPost()&&f.validate()){
	
	custDao = new DataObject("tcb_recruit_cust");
	
	boolean isUpdate= cust.getString("cust_seq").equals("")?false:true;
	boolean openerReload = false;
	
	String cust_seq = cust.getString("cust_seq");
	if(cust_seq.equals("")){
		cust_seq = custDao.getOne("select nvl(max(cust_seq),0)+1 from tcb_recruit_cust where member_no = '"+noti.getString("member_no")+"' and noti_seq = '"+noti.getString("noti_seq")+"' ");
		if(cust_seq.equals("")){
			u.jsError("ó���� ���� �Ͽ����ϴ�.");
			return;
		}
	}
	
	String[] req_html = f.getArr("req_html");
	for(int i = 0 ; i < req_html.length; i ++){
		req_html[i] = new String(Base64Coder.decode(req_html[i]),"UTF-8");
	}
	
	DB db = new DB();
	
	// ���� ��ü�� ���
	DataObject clientDao = new DataObject("tcb_client");
	DataSet client = clientDao.find(" member_no = '"+noti.getString("member_no")+"' and client_no = '"+_member_no+"' ");
	if(client.next()){
		clientDao.item("client_type", "1");   // 1:��Ͼ�ü, 2:���¾�ü
		clientDao.item("client_reg_cd", "0"); // 0:����Ͼ�ü, 1:���ĵ�Ͼ�ü
		clientDao.item("client_reg_date", u.getTimeString());
		db.setCommand(clientDao.getUpdateQuery("member_no ='"+noti.getString("member_no")+"' and client_no = '"+_member_no+"' and client_seq = '"+client.getString("client_seq")+"'"), clientDao.record);
	}else{
		openerReload = true;
		int client_seq = clientDao.getOneInt(
			"  select nvl(max(client_seq),0)+1 client_seq "+
			"    from tcb_client "+
			"   where member_no = '"+noti.getString("member_no")+"'"
		);
		clientDao.item("member_no", noti.getString("member_no"));
		clientDao.item("client_seq", client_seq);
		clientDao.item("client_no", _member_no);
		clientDao.item("client_type", "1");   // 1:��Ͼ�ü, 2:���¾�ü
		clientDao.item("client_reg_cd", "0"); // 0:����Ͼ�ü, 1:���ĵ�Ͼ�ü
		clientDao.item("client_reg_date", u.getTimeString());
		db.setCommand(clientDao.getInsertQuery(), clientDao.record);
	}
	
	if(!isUpdate){
		custDao.item("member_no", noti.getString("member_no"));
		custDao.item("noti_seq", noti.getString("noti_seq"));
		custDao.item("cust_seq", cust_seq);
	}
	custDao.item("client_no", cust.getString("client_no"));
	custDao.item("vendcd", cust.getString("vendcd"));
	custDao.item("member_name", cust.getString("member_name"));
	custDao.item("boss_name", cust.getString("boss_name"));
	custDao.item("user_name", f.get("user_name"));
	custDao.item("hp1", f.get("hp1"));
	custDao.item("hp2", f.get("hp2"));
	custDao.item("hp3", f.get("hp3"));
	custDao.item("email", f.get("email"));
	custDao.item("src_cd", f.get("src_cd"));
	custDao.item("src_nm", f.get("src_cd_nm"));
	custDao.item("req_html", req_html[0]);
	custDao.item("evaluate_html", req_html[1]);
	custDao.item("tot_point", f.get("tot_point"));
	if(!isUpdate){
		custDao.item("reg_date", u.getTimeString());
		custDao.item("reg_id", auth.getString("_USER_ID"));
	}else{
		custDao.item("mod_date", u.getTimeString());
		custDao.item("mod_id", auth.getString("_USER_ID"));
	}
	
	String status = "10";
	String msg = "�ӽ����� �Ͽ����ϴ�.\\n\\n��û������ ��ư�� Ŭ���Ͽ� ��û �� ���� ��û �˴ϴ�.";
	if(f.get("status").equals("20")){
		msg = "��û�� ���� ó�� �Ͽ����ϴ�.";
		openerReload = true;
		if(cust.getString("status").equals("30")){
			status = "31";
		}
		if(cust.getString("status").equals("10")){
			status = "20";
		}
	}else{
		if(cust.getString("status").equals("30")){
			status = "30";
		}
		if(cust.getString("status").equals("")){
			status = "10";
		}
	}
	custDao.item("status", status);
	
	if(!isUpdate){
		db.setCommand(custDao.getInsertQuery(), custDao.record);
	}else{
		db.setCommand(custDao.getUpdateQuery(" member_no = '"+noti.getString("member_no")+"' and noti_seq = '"+noti.getString("noti_seq")+"' and cust_seq = '"+cust_seq+"' "), custDao.record);
	}
	
	
	if(!db.executeArray()){
		u.jsError("����ó���� ���� �Ͽ����ϴ�.");
		return;
	}
	out.println("<script>");
	if(openerReload){
		out.println("opener.location.reload();");
	}
	out.println("alert('"+msg+"');");
	out.println("location.href='pop_nhqv_recruit_req.jsp?"+u.getQueryString()+"';");
	out.println("</script>");
	return;
}


p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_nhqv_recruit_req");
p.setVar("popup_title","NH�������� ��Ͼ�ü ��û");
p.setVar("modify", !cust.getString("cust_seq").equals(""));
p.setVar("noti", noti);
p.setVar("cust", cust);
p.setVar("btn_save", u.inArray(cust.getString("status"), new String[]{"10","30"})||cust.getString("status").equals(""));
p.setVar("btn_req", u.inArray(cust.getString("status"), new String[]{"10","30"}));
p.setVar("print_url","pop_nhqv_pdf_viewer.jsp?gubun="+u.aseEnc("req")+"&noti_seq="+u.aseEnc(noti_seq)+"&member_no="+u.aseEnc(_member_no));
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>