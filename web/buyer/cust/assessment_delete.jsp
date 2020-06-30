<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String asse_no = u.request("asse_no", "");
String div_cd = u.request("div_cd");  // 평가부서 코드 : S 구매팀, Q:QC팀, E: ENC
String mode = u.request("mode", "00"); // 00 : 완전삭제, 10 : 상태 변경
String mstatus = u.request("mstatus");
String ret = u.request("ret");


if(asse_no.equals("") || mode.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}
	
DB db = new DB();

if(mode.equals("00"))  // 완전삭제
{
	db.setCommand("delete from tcb_assedetail where asse_no = '"+asse_no+"'", null);
	db.setCommand("delete from tcb_assemaster where asse_no = '"+asse_no+"'", null);
}
else if(mode.equals("10"))  
{
	if(mstatus.equals("20")) // 평가중 -> 평가 대상 등록 : 해당 기록 모두 삭제 
	{
		db.setCommand("delete from tcb_assedetail where asse_no = '"+asse_no+"'", null);
		db.setCommand("update tcb_assemaster set status='10' where asse_no = '"+asse_no+"'", null);
	}
	else if(mstatus.equals("50")) // 평가완료 -> 평가중
	{
		db.setCommand("update tcb_assedetail set status='20' where asse_no = '"+asse_no+"' and div_cd='"+div_cd+"'", null);
		db.setCommand("update tcb_assemaster set status='20' where asse_no = '"+asse_no+"'", null);
	}
}

if(!db.executeArray()){
	u.jsError("처리중 오류가 발생 하였습니다.");
	return;
}

if(mode.equals("00"))  // 완전삭제
	u.jsAlertReplace("삭제 하였습니다.","assessment_list.jsp?"+u.getQueryString());
else if(mode.equals("10"))  // 상태변경
	u.jsAlertReplace("이전 상태로 변경 하였습니다.", ret + "?"+u.getQueryString());

%>