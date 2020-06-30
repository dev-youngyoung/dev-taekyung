<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_noti_status = {"10=>������","20=>�����Ϸ�"};
String[] code_cust_status = {"10=>�ӽ�����","20=>��û��","30=>������û","31=>������û","40=>�ɻ�Ϸ�","50=>�Ϸ�"};
String noti_seq = u.request("noti_seq");
if(noti_seq.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}


DataObject notiDao = new DataObject("tcb_recruit_noti");
DataSet noti = notiDao.find("member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"' ");
if(!noti.next()){
	u.jsError("���� ������ �����ϴ�.");
	return;
}
noti.put("req_sdate", u.getTimeString("yyyy-MM-dd", noti.getString("req_sdate")));
noti.put("req_edate", u.getTimeString("yyyy-MM-dd", noti.getString("req_edate")));
noti.put("noti_date", u.getTimeString("yyyy-MM-dd", noti.getString("noti_date")));
noti.put("status_nm", u.getItem(noti.getString("status"), code_noti_status ) );
noti.put("noti_end", noti.getString("status").equals("20"));


DataObject custDao =  new DataObject("tcb_recruit_cust");
DataSet cust = custDao.find("member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"' ","*","src_cd asc, tot_point desc");
while(cust.next()){
	cust.put("vendcd", u.getBizNo(cust.getString("vendcd")));
	cust.put("status_nm", u.getItem(cust.getString("status"), code_cust_status));
	if(cust.getString("status").equals("30")){
		cust.put("status_nm", "<span style='color:blue'>"+cust.getString("status_nm")+"</span>");
	}
	if(cust.getString("status").equals("31")){
		cust.put("status_nm", "<span style='color:red;font-weight:bold'>"+cust.getString("status_nm")+"</span>");
	}
	
	cust.put("tot_point", u.numberFormat(cust.getString("tot_point")));
	cust.put("checked", cust.getString("succ_yn").equals("Y")?"checked":"");
	cust.put("succ_tag", cust.getString("succ_yn").equals("Y")?"<font color='red'><b>��</b></font>":"");
	
}

if(u.isPost()&&f.validate()){
	
	if(!noti.getString("status").equals("10")){
		u.jsError("�������� ���� ó�� ���� �մϴ�.");
		return;
	}
	
	String[] arr_client = f.get("client_nos").split(",");
	
	DB db = new DB();
	
	DataObject clientDao = null;
	db.setCommand("update tcb_recruit_cust set succ_yn = '' where  member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"'", null);
	for(int i = 0 ; i < arr_client.length; i++){
		custDao = new DataObject("tcb_recruit_cust");
		custDao.item("succ_yn", "Y");
		db.setCommand(custDao.getUpdateQuery("member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"' and client_no= '"+arr_client[i]+"'  "), custDao.record);
	}
	
	
	if(f.get("status").equals("20")){//�����Ϸ��
		
		//db.setCommand("update tcb_recruit_cust set status = '50' where  member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"'", null);
		
		for(int i = 0 ; i < arr_client.length; i++){
			clientDao = new DataObject("tcb_client");
			clientDao.item("client_reg_cd", "1"); // 0:����Ͼ�ü, 1:���ĵ�Ͼ�ü
			db.setCommand(clientDao.getUpdateQuery(" member_no = '"+_member_no+"' and client_no = '"+arr_client[i]+"' "), clientDao.record);
		}
		
		String query = 
				 " INSERT INTO tcb_src_member (member_no, src_member_no, src_cd)                            "
				+"  select member_no , client_no src_member_no, src_cd                                      "
				+"    from tcb_recruit_cust                                                                 "
				+"   where member_no = '"+_member_no+"'                                                     "
				+"     and noti_seq = '"+noti_seq+"'                                                        "
				+"     and succ_yn = 'Y'                                                                    "
				+"     and client_no ||src_cd not in (                                                      "
				+"     	 select src_member_no || src_cd from tcb_src_member where member_no = '"+_member_no+"'  "
				+"      )                                                                                   ";
		db.setCommand(query, null);
		
		notiDao = new DataObject("tcb_recruit_noti");
		notiDao.item("status","20");
		db.setCommand(notiDao.getUpdateQuery("member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"' "), notiDao.record);
	}
	
	if(!db.executeArray()){
		u.jsError("���� ó���� ���� �Ͽ����ϴ�.");
		return;
	}
	
	u.jsAlertReplace("ó�� �Ͽ����ϴ�.", "nhqv_recruit_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.nhqv_recruit_modify");
p.setVar("menu_cd","000098");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000098", "btn_auth").equals("10"));
p.setVar("noti", noti);
p.setLoop("cust", cust);
p.setVar("btn_auth", noti.getString("status").equals("10"));
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("noti_seq"));
p.setVar("form_script",f.getScript());
p.display(out);

%>