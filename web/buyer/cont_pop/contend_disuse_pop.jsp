<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="nicednb.Client" %>
<%
String vcd = u.request("vcd");
String key = u.request("key");
String cert = u.request("cert");
System.out.println("vcd : " + vcd);
System.out.println("key : " + key);
System.out.println("cert : " + cert);
if(vcd.length()!=10){
	out.print("No Permission!!");
	return;
}

String contstr = u.aseDec(key);  // 디코딩
if(contstr.length() != 12){
	out.print("No Permission!!");
	return;
}

String sClientKey = "";

String member_no = "";

Client cs = new Client();
if(vcd.equals("1168150973")){  // 아이디지털홈쇼핑
	sClientKey = cs.getClientKey("www.idigitalhomeshopping.com");
	member_no = "20150600110";
}else if(vcd.equals("1208755227")){  // 위메프
	sClientKey = cs.getClientKey("www.wemakeprice.com");
	member_no = "20130500619";
}else if(vcd.equals("2118819183")){  // 더블유컨셉코리아
	sClientKey = cs.getClientKey("www.wconcept.co.kr");
	member_no = "20140100706";
}else if(vcd.equals("4928700855")){  // 에스케이브로드밴드
	sClientKey = cs.getClientKey("www.skbroadband.com");
	member_no = "20171101813";
}else if(vcd.equals("1068123810")){  // 소니코리아
	sClientKey = cs.getClientKey("www.sonykorea.com");
	member_no = "20160900378";
	//out.print(sClientKey);
}else if(vcd.equals("1168115020")){  // 나이스평가정보
	sClientKey = cs.getClientKey("www.niceinfo.co.kr");
	member_no = "20120300010";
	//out.print(sClientKey);
}else if(vcd.equals("2208708311")){  // 더블유쇼핑
	sClientKey = cs.getClientKey("w-shopping.co.kr");
	member_no = "20150500312";
} else if(vcd.equals("1078176324")){  // 아워홈
	System.out.println("아워홈");
	sClientKey = cs.getClientKey("www.ourhome.co.kr");
	member_no = "20170501348";
} else if(vcd.equals("4438700566")){  // 카카오메이커스
	sClientKey = cs.getClientKey("makers.kakao.com");
	member_no = "20181101476";
}else if(vcd.equals("1348106363")){  // 대덕전자
	sClientKey = cs.getClientKey("www.daeduck.com");
	member_no = "20150500269";
}else{
	out.print("No Permission!!");
	return;
}

System.out.println("cert : "+cert);
System.out.println("sClientKey : "+sClientKey);

if(!cert.equals(sClientKey))
{
	out.print("Certfication Key Error!!");
	return;
}


String cont_no = contstr.substring(0,11);
String cont_chasu = contstr.substring(11);

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

String where = "cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";

DataObject contDao = new DataObject("tcb_contmaster");
contDao.setDebug(out);
DataSet cont  = contDao.find(where+" and member_no= '"+_member_no+"' ");
if(!cont.next()){
	//u.jsError(" 계약정보가 존재 하지 않습니다.");
	return;
}

if(!cont.getString("status").equals("50")){
	u.jsError("계약완료 상태에서만 폐기 처리 가능 합니다.");
	return;
}


DB db = new DB();
contDao.item("status","99");
contDao.item("mod_req_date",u.getTimeString());
db.setCommand(contDao.getUpdateQuery(where), contDao.record);

/* 계약로그 START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 폐기",  "", "92","10");
/* 계약로그 END*/

if(!db.executeArray()){
	u.jsError("처리에 실패 하였습니다.");
	return;
}
String callback = "contend_sendview_pop.jsp";
if(!cont.getString("sign_types").equals("")){
	callback = "contend_msign_sendview_pop.jsp";
}

u.jsAlertReplace("계약서 폐기처리 하였습니다.", "./"+callback+"?"+u.getQueryString());

%>