<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%

String member_no = u.request("member_no");
String client_type = u.request("client_type");
String member_slno1 = u.request("member_slno1");
String member_slno2 = u.request("member_slno2");
if(member_no.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

if(u.isPost()){
	DB db = new DB();

	// 상대방 업체에 등록
	DataObject dao = new DataObject("tcb_client");
	//dao.setDebug(out);
	int client_seq = dao.getOneInt(
		"  select nvl(max(client_seq),0)+1 client_seq "+
		"    from tcb_client "+
		"   where member_no = '"+member_no+"'"
	);
	dao.item("member_no", member_no);
	dao.item("client_seq", client_seq);
	dao.item("client_no", _member_no);
	if(!client_type.equals("")){
		dao.item("client_type", client_type);
	}
	// 가등록이 필요한 업체의 거래처인 경우 (대보정보통신, 한국제지, 신세계, 테스트, NH투자증권,대림C&S, 하이엔텍 , 경기테크노파크, 농협네트웍스,메트로9호선)
	if( u.inArray(member_no, new String[]{"20130400091", "20121200116", "20140101025", "20120200001","20160901598","20170101031","20121204063","20170602171","20180203437","20181002679","20151101243","20191200612"}) ) {
		dao.item("client_reg_cd", "0");   // 0:가등록업체, 1:정식등록업체
	} else {
		dao.item("client_reg_cd", "1");
	}
	dao.item("client_reg_date", u.getTimeString());
	db.setCommand(dao.getInsertQuery(), dao.record);
	

	if( !member_slno1.equals("") && !member_slno2.equals("") && auth.getString("_MEMBER_GUBUN").equals("03") ){//CJ대한통운 개인 사업자 생년월일정보를 법인등록번호에 저장해둠
		DataObject member = new DataObject("tcb_member");
		
		if( Integer.parseInt(member_slno1.substring(0,2)) < 20 ){
			member_slno1 = member_slno1.replaceAll("-","");
			member_slno1 = member_slno1.substring(2);
		}else{
			member_slno1 = member_slno1.replaceAll("-","");
			member_slno1 = member_slno1.substring(2);
			member_slno2 = member_slno2.equals("1") ? "3" : "4";
		}
		member.item("member_slno", member_slno1+member_slno2);
		db.setCommand(member.getUpdateQuery("member_no= '"+_member_no+"'"), member.record); // 주민번호
		
	}
	
	if(!db.executeArray()){
		u.jsError("처리중 오류가 발생 하였습니다. 고객 센터로 문의해 주세요.");
		return;
	}
}

// 업체가 추가로 첨부해야할 파일이 있는 경우 바로 이동
DataObject rfileDao = new DataObject("tcb_client_rfile_template");
DataSet rf = rfileDao.find("member_no='"+member_no+"'");
if(rf.next()) {
	u.jsAlertReplace("기본 정보등록 완료되었습니다.\\n\\n추가 구비서류 파일을 첨부해 주시기 바랍니다.", "company_view.jsp?member_no="+member_no);
}

if(member_no.equals("20130400333")&&client_type.indexOf("0")>-1){ // CJ대한통운은 기업현황을 추가로 입력하도록 한다.
	u.jsAlertReplace("거래처로 등록 되었습니다. \\n\\n입찰에 참여하시는 업체는 추가 정보를 입력해주시기 바랍니다.", "../info/company_add_info.jsp");
}else if(u.inArray(member_no, new String[]{"20130400091", "20121200116", "20140101025", "20120200001","20160901598"}) ){//가등록 메세지 변경
	u.jsAlertReplace("가등록 거래처로 등록 되었습니다.","cust_list.jsp?"+u.getQueryString("member_no"));
}else{
	u.jsAlertReplace("거래처로 등록 되었습니다.","cust_list.jsp?"+u.getQueryString("member_no"));
}
return;
%>