<%@ page contentType="text/html; charset=UTF-8"%><%@ include file="init.jsp" %>
<%@ page import="
				 kr.co.nicepay.module.lite.NicePayWebConnector,
				 nicelib.util.*
                 " %>
<%
request.setCharacterEncoding("UTF-8");

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String insteadyn = u.request("insteadyn");
String member_no = u.request("member_no");
if(cont_no.equals("")||cont_chasu.equals("")||insteadyn.equals("")||member_no.equals("")){
	u.jsErrClose("정상적인 경로로 접근하세요.");
	return;
}

if(!_member_no.equals(member_no)){
	u.jsErrClose("로그인사용자가 변경 되었습니다.\\n\\n결제를 다시 진행 하세요.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' ";

//계약정보 확인 
ContractDao contDao = new ContractDao("tcb_contmaster");
DataSet cont = contDao.find(where);
if(!cont.next()){
	u.jsAlert("계약정보가 없습니다");
	return;
}

////////////////////////////소켓 통신 시작///////////////////////////////////////////////

String nicePayHome = "/user2/tax/WEB-INF";
//String nicePayHome = "D:/nicedata_git/git-repository/nicedocu/WEB-INF";

NicePayWebConnector connector = new NicePayWebConnector();

// 1. 로그 디렉토리 생성
connector.setNicePayHome(nicePayHome);

// 2. 요청 페이지 파라메터 셋팅
connector.setRequestData(request);

// 3. 추가 파라메터 셋팅
connector.addRequestData("MID", "docu00002m");	// 상점아이디
connector.addRequestData("actionType", "PY0");  // actionType : CL0 취소, PY0 승인
connector.addRequestData("MallIP", request.getRemoteAddr());	// 상점 고유 ip
connector.addRequestData("CancelPwd", "0140");


// 4. NICEPAY Lite 서버 접속하여 처리
connector.requestAction();

// 5. 결과 처리
String resultCode = connector.getResultData("ResultCode");	// 결과코드 (정상 :3001 , 그 외 에러)
String resultMsg = connector.getResultData("ResultMsg");	// 결과메시지
String authDate = connector.getResultData("AuthDate");		// 승인일시 YYMMDDHH24mmss
String authCode = connector.getResultData("AuthCode");		// 승인번호
String buyerName = connector.getResultData("BuyerName");	// 구매자명
String mallUserID = connector.getResultData("MallUserID");	// 회원사고객ID
String payMethod = connector.getResultData("PayMethod");	// 결제수단  ('CARD':신용카드, 'BANK':계좌이체)
String mid = connector.getResultData("MID");				// 상점ID
String tid = connector.getResultData("TID");				// 거래ID
String moid = connector.getResultData("Moid");				// 주문번호
String amt = connector.getResultData("Amt");				// 금액

// 카드 결제
String cardCode = connector.getResultData("CardCode");		// 카드사 코드
String cardName = connector.getResultData("CardName");		// 결제카드사명
String cardQuota = connector.getResultData("CardQuota");	//00:일시불,02:2개월

// 실시간 계좌이체
String bankCode = connector.getResultData("BankCode");		// 은행 코드
String bankName = connector.getResultData("BankName");		// 은행명
String rcptType = connector.getResultData("RcptType");		// 현금 영수증 타입 (0:발행되지않음,1:소득공제,2:지출증빙)
String rcptAuthCode = connector.getResultData("RcptAuthCode");	//현금영수증 승인 번호
String rcptTID = connector.getResultData("RcptTID");		//현금 영수증 TID

// 휴대폰 결제
String carrier = connector.getResultData("Carrier");		// 이통사구분
String dstAddr = connector.getResultData("DstAddr");		// 휴대폰번호

// 가상계좌 결제
String vbankBankCode = connector.getResultData("VbankBankCode");	// 가상계좌은행코드
String vbankBankName = connector.getResultData("VbankBankName");	// 가상계좌은행명
String vbankNum = connector.getResultData("VbankNum");				// 가상계좌번호
String vbankExpDate = connector.getResultData("VbankExpDate");		// 가상계좌입금예정일


boolean paySuccess = false;		// 결제 성공 여부

/** 위의 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능 */
if(payMethod.equals("CARD"))	//신용카드
{
	if(resultCode.equals("3001")) paySuccess = true;	// 결과코드 (정상 :3001 , 그 외 에러)
}
else if(payMethod.equals("BANK"))	//계좌이체
{
	if(resultCode.equals("4000")) paySuccess = true;	// 결과코드 (정상 :4000 , 그 외 에러)
}
else if(payMethod.equals("CELLPHONE"))	//휴대폰
{
	if(resultCode.equals("A000")) paySuccess = true;	//결과코드 (정상 : A000, 그 외 비정상)
}
else if(payMethod.equals("VBANK"))	//가상계좌
{
	if(resultCode.equals("4100")) paySuccess = true;	// 결과코드 (정상 :4100 , 그 외 에러)
}

//-------------------------  여기서부터 DB 저장을 위한 부분 ---------------------------------

if(!paySuccess){
	u.jsErrClose(resultMsg);
	return;
}

String pay_type = "";  // 결제 타입 코드

if(payMethod.equals("CARD"))
	pay_type = "01";
else if(payMethod.equals("BANK"))
	pay_type = "02";


DB db = new DB();
//결제 여부 컬럼  update
DataObject custDao = new DataObject("tcb_cust");
custDao.item("pay_yn", "Y");
db.setCommand(custDao.getUpdateQuery(where+" and member_no = '"+_member_no+"' "), custDao.record);

//tcb_pay Data입력
DataObject payDao = new DataObject("tcb_pay");
payDao.item("cont_no",cont_no);
payDao.item("cont_chasu",cont_chasu);
payDao.item("member_no",_member_no);
if(insteadyn.equals("Y")){
	payDao.item("cont_name","(대납포함)"+cont.getString("cont_name"));
}else{
	payDao.item("cont_name",cont.getString("cont_name"));
}
payDao.item("pay_amount",amt);
payDao.item("pay_type",pay_type);
payDao.item("accept_date","20"+authDate);
payDao.item("pay_number",moid);
if(!rcptTID.equals("")){
	payDao.item("tid",rcptTID);
}else{
	payDao.item("tid",tid);
}
payDao.item("receit_type",rcptType);
db.setCommand(payDao.getInsertQuery(), payDao.record);

if(!db.executeArray()){
	u.jsErrClose("DB 작업중에 오류가 발생하였습니다. \\n\\n나이스다큐 고객센터(02-788-9097)로 문의하세요.");
	return;
}

out.println("<script>");
out.println("alert('결제되었습니다.\\n\\n계약서에 서명해 주세요.');");
out.println("opener.focus();");
out.println("opener.fSign();");
out.println("self.close();");
out.println("</script>");
%>