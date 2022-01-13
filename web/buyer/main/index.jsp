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



int noti_cnt = 9;


DataObject boardDao = new DataObject("tcb_board");
boardDao.setDebug(out);
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
p.setVar("user_id", user_id);
p.setVar("loginurl", sLoginUrl);
p.setVar("isMobile", isMobile);
p.display(out);
%>