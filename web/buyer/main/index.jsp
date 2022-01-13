<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

if(auth.getString("_MEMBER_NO")!=null&&!auth.getString("_MEMBER_NO").equals("")){
	u.redirect("index2.jsp");
	return;
}

// co.kr 도메인으로 들어오면 .com 도메인으로 보낸다. 이유는 ssl 인증서가 .com 밖에 없다.
String sServerName = request.getServerName();
 
if(sServerName.indexOf("nicedocu.co.kr")>0){
	u.redirect("https://www.nicedocu.com/web/buyer/index.jsp");
}else if(sServerName.indexOf("www.nicedocu.co.kr")>0){
	u.redirect("https://www.nicedocu.com/web/buyer/index.jsp");
}else if(sServerName.indexOf("https://www.nicedocu.co.kr")>0){
	u.redirect("https://www.nicedocu.com/web/buyer/index.jsp");
}else if(sServerName.indexOf("http://www.nicedocu.co.kr")>0){
	u.redirect("https://www.nicedocu.com/web/buyer/index.jsp");
}else if(sServerName.indexOf("http://www.nicedocu.com")>0){
	u.redirect("https://www.nicedocu.com/web/buyer/index.jsp");
}else if(sServerName.equals("https://www.nicedocu.co.kr/web/buyer/main/index.jsp")){ 	
	u.redirect("https://www.nicedocu.com/web/buyer/index.jsp");
}else if(sServerName.equals("http://www.nicedocu.co.kr/web/buyer/main/index.jsp")){
	u.redirect("https://www.nicedocu.com/web/buyer/index.jsp");
}
 
String sLoginUrl = "./login.jsp";

String user_id = "";
String pin = u.getCookie("pin");
if(pin!=null&&!pin.equals("")){
	user_id =  Security.AESdecrypt(pin);
}


DataObject bidDao = new DataObject("tcb_bid_master tb inner join tcb_member tm on tb.main_member_no=tm.member_no");
//bidDao.setDebug(out);
DataSet bid = bidDao.find(
		  "bid_method in ('20', '21')"
		+ " and public_bid_yn = 'Y'"
		+ " and ( (field_yn = 'Y' and tb.status in ('03') and field_date > to_char(sysdate, 'yyyymmddhh24miss')) or (tb.status in ('05','06') and bid_date <= TO_CHAR(SYSDATE, 'yyyymmdd') and submit_edate > TO_CHAR(SYSDATE, 'yyyymmddhh24miss') ) )"
		, "bid_no, bid_deg, bid_name, main_member_no, bid_kind_cd, adj_date,rev_date , tb.bid_date, tb.status, tm.member_name", "bid_date desc"
		,9);

while(bid.next()){
	String detail_url = "";//상세화면 url
	
	boolean isBid = u.inArray(bid.getString("bid_kind_cd"), new String[]{"10","20","30"});
	
	bid.put("bid_kind_nm", isBid?"입찰":"견적");
	if(bid.getString("status").equals("05")){//견적,입찰
		bid.put("bid_date", u.getTimeString("yyyy-MM-dd", bid.getString("bid_date")));
	}else{//현설
		bid.put("bid_date", u.getTimeString("yyyy-MM-dd", bid.getString("field_date")));
	}
		
	if(isBid){//입찰
		if(u.inArray(bid.getString("status"), new String[]{"03","04"})){//현설
			detail_url = "pop_ofield_view.jsp";//케이스 없음. ㅠ.ㅠ
		}else if(u.inArray(bid.getString("status"), new String[]{"05","06"})){//입찰
			detail_url = "pop_obid_view.jsp";
		}
		
		if(!bid.getString("adj_date").equals("")){
			bid.put("bid_name", "<font style='color:#0000FF;'>[연기]</font>"+bid.getString("bid_name"));
		}
		if(!bid.getString("rev_date").equals("")){
			bid.put("bid_name", "<font style='color:#0000FF;'>[정정]</font>"+bid.getString("bid_name"));
		}
		 
		if(bid.getInt("bid_deg") > 0){
			bid.put("bid_name", "<font style='color:#FF0000;'>[재입찰]</font>"+bid.getString("bid_name"));
		}else{
			bid.put("bid_name", bid.getString("bid_name"));
		}
		 
		bid.put("link", "../bid/" + detail_url);
	}else{//견적요청
		if(bid.getString("status").equals("05")){
			
			if(!bid.getString("adj_date").equals(""))
				bid.put("bid_name", "<font style='color:#0000FF;'>[연기]</font>"+bid.getString("bid_name"));
			if(!bid.getString("rev_date").equals(""))
				bid.put("bid_name", "<font style='color:#0000FF;'>[정정]</font>"+bid.getString("bid_name"));
		}
		bid.put("link", "../esti/pop_oesti_view.jsp");
	}
}

int noti_cnt = 9;
if(bid.size() > 0){
	noti_cnt = 9-(bid.size()+3);
}


DataObject boardDao = new DataObject("tcb_board");
//boardDao.setDebug(out);
DataSet noti = boardDao.find("category = 'noti' and open_yn = 'Y' and open_date <= '"+u.getTimeString("yyyyMMdd")+"' ","*","open_date desc",noti_cnt);
while(noti.next()){
	noti.put("open_date", u.getTimeString("yyyy-MM-dd",noti.getString("open_date")));
}

//모바일로 접근시 모듈설치 안함
boolean isMobile = false;
String agent = request.getHeader("USER-AGENT");
String[] mobileos = {"iPhone","iPod","Android","BlackBerry","Windows CE","Nokia","Webos","Opera Mini","SonyEricsson","Opera Mobi","IEMobile"};
int j = -1;
for(int i=0 ; i<mobileos.length ; i++) {
	j=agent.indexOf(mobileos[i]);
	if(j > -1 )	{
		isMobile = true;
		break;
	}
}

p.setLayout("main");
p.setDebug(out);
p.setBody("main.index");
p.setLoop("noti", noti);
p.setLoop("bid", bid);
p.setVar("user_id", user_id);
p.setVar("loginurl", sLoginUrl);
p.setVar("isMobile", isMobile);
p.display(out);
%>