<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_noti_status = {"10=>모집중","20=>모집완료"};
String[] code_cust_status = {"10=>임시저장","20=>신청중","30=>수정요청","31=>수정신청","40=>심사완료","50=>완료"};
String noti_seq = u.request("noti_seq");
if(noti_seq.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}


DataObject notiDao = new DataObject("tcb_recruit_noti");
DataSet noti = notiDao.find("member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"' ");
if(!noti.next()){
	u.jsError("공고 정보가 없습니다.");
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
	cust.put("succ_tag", cust.getString("succ_yn").equals("Y")?"<font color='red'><b>ν</b></font>":"");
	
}

if(u.isPost()&&f.validate()){
	
	if(!noti.getString("status").equals("10")){
		u.jsError("모집중인 공고만 처리 가능 합니다.");
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
	
	
	if(f.get("status").equals("20")){//선정완료시
		
		//db.setCommand("update tcb_recruit_cust set status = '50' where  member_no = '"+_member_no+"' and noti_seq = '"+noti_seq+"'", null);
		
		for(int i = 0 ; i < arr_client.length; i++){
			clientDao = new DataObject("tcb_client");
			clientDao.item("client_reg_cd", "1"); // 0:가등록업체, 1:정식등록업체
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
		u.jsError("저장 처리에 실패 하였습니다.");
		return;
	}
	
	u.jsAlertReplace("처리 하였습니다.", "nhqv_recruit_modify.jsp?"+u.getQueryString());
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