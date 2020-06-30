<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String main_member_no = u.request("main_member_no");
String bid_no = u.request("bid_no");
String bid_deg = u.request("bid_deg");
if(main_member_no.equals("")||bid_no.equals("")||bid_deg.equals("")){
	u.jsErrClose("정상적인 경로 접근하세요.");
	return;
}

if(main_member_no.equals("20120500023")){//동희 오토는 수작업 해야 함.
	u.jsErrClose("동희 오토는 수작업 하세요.업체 추가 안되요..~~!");
	return;
}

String[] code_supp_status = {"10=>미투찰","30=>투찰","91=>현설불참","92=>입찰포기","93=>미투찰"};

String where = "main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"'";

DataObject bidDao = new DataObject("tcb_bid_master");
//bidDao.setDebug(out);
DataSet bid = bidDao.find(where);
if(!bid.next()){
	u.jsError("입찰정보가 없습니다.");
	return;
}

DataObject suppDao = new DataObject("tcb_bid_supp");
DataSet supp = suppDao.find(where,"*"," display_seq asc");
while(supp.next()){
	supp.put("vendcd", u.getBizNo(supp.getString("vendcd")));
	if(u.inArray( bid.getString("status"), new String[]{"04","05","06","07","91","92","94"})){
		if(bid.getString("field_yn").equals("Y")){//현설이 있을 경우
			if(!supp.getString("field_conf_yn").equals("Y")){
				supp.put("status_nm", "현설불참");
			}else{
				supp.put("status_nm", u.getItem(supp.getString("status"),code_supp_status));
			}
		}else{
			supp.put("status_nm", u.getItem(supp.getString("status"),code_supp_status));
		}
	}else{
		supp.put("status_nm", u.getItem(supp.getString("status"),code_supp_status));
	}
	supp.put("btn_pay", bid.getString("public_bid_yn").equals("Y")&&bid.getString("status").equals("05")&&!supp.getString("pay_yn").equals("Y"));
}



if(u.isPost()&&f.validate()){
	int cnt = suppDao.getOneInt(" select count(member_no) from tcb_bid_supp where main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"' and member_no='"+f.get("member_no")+"' ");
	if(cnt > 0){
		u.jsError("이미 추가된 업체입니다.");
		return;
	}
	String display_seq = suppDao.getOne(" select nvl(max(display_seq),0)+1 from tcb_bid_supp where main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"' ");
	if(display_seq.equals("")){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	suppDao = new DataObject("tcb_bid_supp");
	suppDao.item("main_member_no", main_member_no);
	suppDao.item("bid_no", bid_no);
	suppDao.item("bid_deg", bid_deg);
	suppDao.item("member_no", f.get("member_no"));
	suppDao.item("vendcd", f.get("vendcd").replaceAll("-", ""));
	suppDao.item("member_name", f.get("member_name"));
	suppDao.item("boss_name", f.get("boss_name"));
	suppDao.item("user_name", f.get("user_name"));
	suppDao.item("hp1", f.get("hp1"));
	suppDao.item("hp2", f.get("hp2"));
	suppDao.item("hp3", f.get("hp3"));
	suppDao.item("email", f.get("email"));
	suppDao.item("display_seq", display_seq);
	suppDao.item("status", "10");	//미투찰 상태
	if(bid.getString("field_yn").equals("Y")){
		suppDao.item("field_conf_yn","Y");
	}

	if(!suppDao.insert()){
		u.jsError("처리중 오류가 발생 하였습니다.");
		return;
	}
	
	u.jsAlertReplace("업체 추가 처리 되었습니다.", "pop_bid_supp.jsp?"+u.getQueryString());
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("buyer.pop_bid_supp");
p.setVar("popup_title","참여업체조회");
p.setVar("bid",bid);
p.setLoop("supp", supp);
p.setVar("btn_add", u.inArray(bid.getString("status"), new String[]{"03","05"}) );
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>